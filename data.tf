data "local_file" "kube_config" {
  filename   = "${path.root}/kube_config"
  depends_on = [
    local_file.kube_config
  ]
}

data "null_data_source" "kube_config" {
  inputs     = {
    endpoint           = module.kubernetes.cluster_endpoint
    ca                 = base64decode(module.kubernetes.cluster_ca_certificate)
    client_certificate = base64decode(module.kubernetes.cluster_client_certificate)
    client_key         = base64decode(module.kubernetes.cluster_client_key)
  }
  depends_on = [
    module.kubernetes
  ]
}