output "namespace" {
  value = kubernetes_namespace.jenkins.metadata[0].name
}