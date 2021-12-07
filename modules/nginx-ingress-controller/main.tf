resource "helm_release" "nginx-ingress-controller" {
  count      = var.enabled ? 1 : 0
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  version    = "9.0.9"
  namespace  = "kube-system"
  values     = [
    file("${path.module}/files/values.yaml")
  ]
  set {
    name  = "service.annotations"
    value = "load-balancer.hetzner.cloud/name: ${var.load_balancer_name}"
  }
}