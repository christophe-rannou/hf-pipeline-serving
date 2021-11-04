terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "0.15.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.2.0"
    }
  }
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.ovhcloud_credentials.application_key
  application_secret = var.ovhcloud_credentials.application_secret
  consumer_key       = var.ovhcloud_credentials.consumer_key
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}