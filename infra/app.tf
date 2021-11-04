resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app.name
  }
}

resource "kubernetes_deployment" "app" {
  depends_on = [ovh_cloud_project_kube_nodepool.node_pool]
  wait_for_rollout = true
  timeouts {
    create = "300s"
    update = "300s"
    delete = "60s"
  }
  metadata {
    name      = var.app.name
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = {
      app = var.app.name
    }
  }
  spec {
    selector {
      match_labels = {
        app = var.app.name
      }
    }
    replicas = var.app_replicas.min
    template {
      metadata {
        labels = {
          app = var.app.name
        }
      }
      spec {
        termination_grace_period_seconds = 20
        container {
          name              = "app"
          image             = "${var.app.image}:${var.app.tag}"
          image_pull_policy = "Always"
          port {
            container_port = 5000
            name           = "http"
          }
          port {
            container_port = 9000
            name           = "metrics"
          }
          liveness_probe {
            tcp_socket {
              port = "5000"
            }
          }
          readiness_probe {
            tcp_socket {
              port = "5000"
            }
          }
          resources {
            limits   = {
              cpu    = "4"
              memory = "4G"
            }
            requests = {
              cpu    = "4"
              memory = "4G"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = var.app.name
    namespace = kubernetes_namespace.app.metadata[0].name
    labels    = {
      app = var.app.name
    }
  }
  spec {
    port {
      port        = 80
      name        = "http"
      target_port = "http"
    }
    selector = {
      app : var.app.name
    }
    type     = "ClusterIP"
  }
}

resource "kubernetes_ingress" "app" {
  metadata {
    name        = var.app.name
    namespace   = kubernetes_namespace.app.metadata[0].name
    labels      = {
      app = var.app.name
    }
    annotations = {
      "kubernetes.io/ingress.class" : "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" : false
      "nginx.ingress.kubernetes.io/proxy-body-size" : "0"
      "nginx.ingress.kubernetes.io/proxy-read-timeout" : "600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" : "600"
    }
  }

  spec {
    rule {
      host = var.app.host
      http {
        path {
          backend {
            service_name = var.app.name
            service_port = "http"
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "app" {
  metadata {
    name      = var.app.name
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = var.app.name
    }
  }
  spec {
    min_replicas = var.app_replicas.min
    max_replicas = var.app_replicas.max
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = var.app.name
    }
    target_cpu_utilization_percentage = 50
  }
}