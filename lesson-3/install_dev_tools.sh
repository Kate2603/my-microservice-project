#!/usr/bin/env bash
set -euo pipefail

# -------- helpers ----------
log()  { echo -e "\n[INFO] $*"; }
warn() { echo -e "\n[WARN] $*" >&2; }
die()  { echo -e "\n[ERROR] $*" >&2; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1; }

require_sudo() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    if ! need_cmd sudo; then
      die "sudo не знайдено. Встановіть sudo або запускайте скрипт від root."
    fi
    sudo -v || die "Немає доступу sudo."
  fi
}

run_root() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

# One-shot apt update flag (int only; no resetting)
APT_UPDATED=0

apt_update_once() {
  if [[ "$APT_UPDATED" -eq 0 ]]; then
    log "Оновлюю списки пакетів (apt update)..."
    run_root apt-get update -y
    APT_UPDATED=1
  fi
}

install_packages() {
  apt_update_once
  run_root apt-get install -y --no-install-recommends "$@"
}

# -------- checks ----------
is_debian_like() {
  [[ -f /etc/os-release ]] || return 1
  . /etc/os-release
  [[ "${ID_LIKE:-}" == *debian* ]] || [[ "${ID:-}" == "debian" ]] || [[ "${ID:-}" == "ubuntu" ]]
}

python_ok() {
  if need_cmd python3; then
    python3 - <<'PY'
import sys
sys.exit(0 if sys.version_info >= (3,9) else 1)
PY
  else
    return 1
  fi
}

docker_ok() {
  need_cmd docker && docker --version >/dev/null 2>&1
}

docker_compose_ok() {
  docker_ok && docker compose version >/dev/null 2>&1
}

# -------- installs ----------
install_prereqs() {
  log "Перевіряю базові залежності (ca-certificates, curl, gnupg, lsb-release)..."
  install_packages ca-certificates curl gnupg lsb-release
}

install_docker() {
  # Важливо: у WSL може бути "docker" в PATH, але він не працює.
  # Тому перевіряємо саме docker --version.
  if docker_ok; then
    log "Docker вже встановлений: $(docker --version)"
    if docker_compose_ok; then
      log "Docker Compose (plugin) вже встановлений: $(docker compose version | head -n 1)"
    else
      warn "Docker є, але docker compose недоступний (можливо вимкнена інтеграція Docker Desktop або не встановлений plugin)."
    fi
    return 0
  fi

  log "Встановлюю Docker Engine (офіційний репозиторій Docker)..."
  install_prereqs

  . /etc/os-release

  local codename=""
  if need_cmd lsb_release; then
    codename="$(lsb_release -cs)"
  else
    codename="${VERSION_CODENAME:-}"
  fi
  [[ -n "$codename" ]] || die "Не вдалося визначити codename (VERSION_CODENAME)."

  run_root install -m 0755 -d /etc/apt/keyrings
  if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
    curl -fsSL "https://download.docker.com/linux/${ID}/gpg" | run_root gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    run_root chmod a+r /etc/apt/keyrings/docker.gpg
  fi

  local arch
  arch="$(dpkg --print-architecture)"

  local repo_file="/etc/apt/sources.list.d/docker.list"
  if [[ ! -f "$repo_file" ]]; then
    echo "deb [arch=${arch} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${ID} ${codename} stable" \
      | run_root tee "$repo_file" >/dev/null
  fi

  # Не скидаємо APT_UPDATED: якщо apt update вже був — ок.
  # Але після додавання нового repo бажано один раз оновити індекси.
  # Тому тут викликаємо apt-get update прямо, без прапорця, щоб точно підтягнути новий repo.
  log "Оновлюю списки пакетів після додавання Docker repo..."
  run_root apt-get update -y

  install_packages docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  if need_cmd systemctl; then
    log "Пробую увімкнути та запустити docker.service..."
    run_root systemctl enable --now docker || true
  else
    warn "systemctl не знайдено (можливо WSL без systemd) — пропускаю запуск сервісу."
  fi

  if docker_ok; then
    log "Docker встановлено: $(docker --version)"
  else
    warn "Docker пакети встановлені, але команда docker не працює. Для WSL перевір інтеграцію Docker Desktop."
  fi

  if docker_compose_ok; then
    log "Docker Compose (plugin) доступний: $(docker compose version | head -n 1)"
  else
    warn "Docker Compose (docker compose) недоступний після установки."
  fi
}

install_python() {
  if python_ok; then
    log "Python вже підходить (>=3.9): $(python3 --version)"
    return 0
  fi

  log "Встановлюю Python 3.9+ (python3, pip, venv)..."
  install_packages python3 python3-pip python3-venv

  if python_ok; then
    log "Python встановлено/оновлено: $(python3 --version)"
  else
    warn "python3 встановлено, але версія може бути нижча за 3.9: $(python3 --version)"
  fi
}

install_django() {
  install_python

  # Якщо Django вже є у venv — покажемо версію і вийдемо
  if [[ -f ".venv/bin/python" ]]; then
    if .venv/bin/python -c "import django; print(django.get_version())" >/dev/null 2>&1; then
      local ver
      ver="$(.venv/bin/python -c "import django; print(django.get_version())")"
      log "Django вже встановлений у venv (.venv): ${ver}"
      return 0
    fi
  fi

  log "Встановлюю Django у virtualenv (.venv), щоб обійти PEP 668 (externally-managed-environment)..."

  if ! python3 -m venv --help >/dev/null 2>&1; then
    log "Встановлюю python3-venv..."
    install_packages python3-venv
  fi

  if [[ ! -d ".venv" ]]; then
    log "Створюю .venv..."
    python3 -m venv .venv
  else
    log ".venv вже існує — використовую."
  fi

  # shellcheck disable=SC1091
  source .venv/bin/activate

  log "Оновлюю pip у venv..."
  python -m pip install --upgrade pip

  log "Встановлюю Django у venv..."
  python -m pip install django

  local ver
  ver="$(python -c "import django; print(django.get_version())" 2>/dev/null || true)"
  [[ -n "$ver" ]] || die "Django не встановився у venv. Перевір помилки вище."
  log "Django встановлено у venv: ${ver}"

  deactivate

  log "Підказка: активувати venv: source .venv/bin/activate"
}

post_setup() {
  if docker_ok; then
    local user="${SUDO_USER:-$USER}"
    if id -nG "$user" | grep -qw docker; then
      log "Користувач '${user}' вже у групі docker."
    else
      log "Додаю користувача '${user}' у групу docker (щоб запускати docker без sudo)..."
      run_root usermod -aG docker "$user" || true
      warn "Потрібен logout/login (або перезавантаження), щоб група docker застосувалась для '${user}'."
    fi
  fi
}

# -------- main ----------
main() {
  is_debian_like || die "Цей скрипт підтримує Ubuntu/Debian (debian-like)."
  require_sudo

  log "Старт встановлення DevOps-інструментів: Docker, Docker Compose, Python 3.9+, Django"
  install_docker
  install_python
  install_django
  post_setup

  log "Готово ✅"
  echo "Перевірка:"
  echo "  docker:          $(docker --version 2>/dev/null || echo 'not found')"
  echo "  docker compose:  $(docker compose version 2>/dev/null | head -n 1 || echo 'not found')"
  echo "  python3:         $(python3 --version 2>/dev/null || echo 'not found')"
  echo "  django (system): $(python3 -c 'import django; print(django.get_version())' 2>/dev/null || echo 'not found')"
  echo "  django (venv):   $(.venv/bin/python -c 'import django; print(django.get_version())' 2>/dev/null || echo 'not found')"
}

main "$@"
