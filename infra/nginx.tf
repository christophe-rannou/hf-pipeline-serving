resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    name = "nginx-ingress"
  }
}

resource "helm_release" "nginx_ingress" {
  depends_on = [ovh_cloud_project_kube_nodepool.node_pool]
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  namespace  = kubernetes_namespace.nginx_ingress.metadata[0].name
  timeout    = 120
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "metrics.enabled"
    value = "true"
  }
  set {
    name = "metrics.serviceMonitor.enabled"
    value = "true"
  }
  set {
    name = "metrics.serviceMonitor.namespace"
    value = "monitoring"
  }
  set {
    name = "metrics.serviceMonitor.additionalLabels.release"
    value = "prometheus-stack"
  }
}
