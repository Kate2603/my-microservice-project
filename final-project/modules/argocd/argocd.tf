resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  values = [
    file("${path.module}/values.yaml")
  ]

  timeout    = 1200
  depends_on = [kubernetes_namespace.argocd]
}

resource "helm_release" "argocd_apps" {
  name      = "argocd-apps"
  chart     = "${path.module}/charts/argocd-apps"
  namespace = kubernetes_namespace.argocd.metadata[0].name

  values = [
    templatefile("${path.module}/charts/argocd-apps/values.yaml", {
      gitops_repo_url    = var.gitops_repo_url
      gitops_repo_branch = var.gitops_repo_branch
      gitops_repo_path   = var.gitops_repo_path
    })
  ]

  depends_on = [helm_release.argocd]
}
