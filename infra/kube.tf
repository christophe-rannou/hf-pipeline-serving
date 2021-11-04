resource "ovh_cloud_project_kube" "serving_cluster" {
  service_name = var.service_name
  name         = "hf_serving_cluster"
  region       = "SBG5"
  version      = "1.19"
}

resource "ovh_cloud_project_kube_nodepool" "node_pool" {
  service_name  = var.service_name
  kube_id       = ovh_cloud_project_kube.serving_cluster.id
  name          = "base-pool"
  flavor_name   = "b2-30"
  desired_nodes = 4
  max_nodes     = 4
  min_nodes     = 4
}

resource "local_file" "kubeconfig" {
  content = ovh_cloud_project_kube.serving_cluster.kubeconfig
  filename = "${path.module}/kubeconfig.yaml"
}
