resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus-stack" {
  depends_on = [ovh_cloud_project_kube_nodepool.node_pool]
  name       = "prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "17.0.3"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  timeout    = 600
  set {
    name  = "prometheus.enabled"
    value = "true"
  }
  set {
    name  = "prometheus.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "prometheus.service.port"
    value = 80
  }
  set {
    name  = "grafana.enabled"
    value = "true"
  }
  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "grafana.service.port"
    value = 80
  }
}
