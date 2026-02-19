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

apt_update_once() {
  # щоб не робити update по 10 разів
  if [[ -z "${APT_UPDATED:-}" ]]; then
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
    # повертає 0 якщо >= 3.9
    python3 - <<'PY'
import sys
sys.exit(0 if sys.version_info >= (3,9) else 1)
PY
  else
    return 1
  fi
}

# -------- installs ----------
install_prereqs() {
  log "Перевіряю базові залежності (ca-certificates, curl, gnupg, lsb-release)..."
  install_packages ca-certificates curl gnupg lsb-release
}

install_docker() {
  if need_cmd docker; then
    log "Docker вже встановлений: $(docker --version || true)"
    return 0
  fi

  log "Встановлюю Docker Engine (офіційний репозиторій Docker)..."
  install_prereqs

  # Визначення Ubuntu/Debian codename
  . /etc/os-release
  local codename=""
  if need_cmd lsb_release; then
    codename="$(lsb_release -cs)"
  else
    codename="${VERSION_CODENAME:-}"
  fi
  [[ -n "$codename" ]] || die "Не вдалося визначити codename (VERSION_CODENAME)."

  # Додати GPG key + repo
  run_root install -m 0755 -d /etc/apt/keyrings
  if [[ ! -f /etc/apt/keyrings/docker.gpg ]]; then
    curl -fsSL https://download.docker.com/linux/"$ID"/gpg | run_root gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    run_root chmod a+r /etc/apt/keyrings/docker.gpg
  fi

  local arch
  arch="$(dpkg --print-architecture)"

  local repo_file="/etc/apt/sources.list.d/docker.list"
  if [[ ! -f "$repo_file" ]]; then
    echo "deb [arch=${arch} signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/${ID} ${codename} stable" \
      | run_root tee "$repo_file" >/dev/null
  fi

  APT_UPDATED=""
  apt_update_once

  install_packages docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  log "Вмикаю та запускаю docker.service..."
  run_root systemctl enable --now docker || true

  log "Docker встановлено: $(docker --version || true)"
}

install_docker_compose() {
  # У сучасних Ubuntu/Debian після встановлення docker-compose-plugin команда "docker compose" має бути доступна.
  if need_cmd docker; then
    if docker compose version >/dev/null 2>&1; then
      log "Docker Compose (plugin) вже встановлений: $(docker compose version | head -n 1)"
      return 0
    fi
  fi

  # Якщо Docker ще не стоїть — поставимо Docker (він принесе compose plugin)
  warn "Docker Compose (docker compose) не знайдено — встановлюю через docker-compose-plugin."
  install_docker

  if docker compose version >/dev/null 2>&1; then
    log "Docker Compose встановлено: $(docker compose version | head -n 1)"
  else
    die "Не вдалося встановити Docker Compose. Перевірте помилки вище."
  fi
}

install_python() {
  if python_ok; then
    log "Python вже підходить (>=3.9): $(python3 --version || true)"
    return 0
  fi

  log "Встановлюю Python 3.9+ (python3, pip, venv)..."
  # На Ubuntu/Debian зазвичай python3 вже є, але може бути <3.9 на старих релізах.
  # Для ДЗ приймаємо установку з репозиторію дистрибутива.
  install_packages python3 python3-pip python3-venv

  if python_ok; then
    log "Python встановлено/оновлено: $(python3 --version || true)"
  else
    warn "python3 встановлено, але версія може бути нижча за 3.9: $(python3 --version || true)"
    warn "Якщо ментор вимагає строго 3.9+, використайте новішу Ubuntu/Debian або встановіть Python через deadsnakes/pyenv."
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

  # гарантуємо наявність venv
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
  if need_cmd docker; then
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
  install_docker_compose
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
