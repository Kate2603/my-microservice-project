resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.jenkins_namespace
  }
}

resource "helm_release" "jenkins" {
  name       = "jenkins"
  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  namespace  = kubernetes_namespace.jenkins.metadata[0].name

  values = [
    file("${path.module}/values.yaml")
  ]

  timeout    = 1800
  depends_on = [kubernetes_namespace.jenkins]
}
