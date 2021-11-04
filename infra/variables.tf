variable "ovhcloud_credentials" {
  type = map(string)
  default = {
    application_key    = ""
    application_secret = ""
    consumer_key       = ""
  }
}

variable "service_name" {
  type    = string
  default = ""
}

variable "app" {
  type = map(string)
  default = {
    name  = "app"
    image = "fract4l/hf-pipeline-serving"
    tag   = "v0"
    host = "serving.ai.com"
  }
}

variable "app_replicas" {
  type = map(string)
  default = {
    min = 2
    max = 4
  }
}
