output "kube_config" {
  sensitive   = true
  description = "Cluster Config Files"
  value       = data.local_file.kube_config
  depends_on  = [
    data.local_file.kube_config
  ]
}

output "master" {
  sensitive   = false
  description = "Cluster Master Hosts"
  value       = module.master.ips
  depends_on  = [
    module.master
  ]
}

output "worker" {
  sensitive   = false
  description = "Cluster Worker Hosts"
  value       = local.worker_ips
  depends_on  = [
    module.worker
  ]
}

output "cluster_name" {
  sensitive   = false
  description = "Kubernetes Cluster Name"
  value       = var.cluster_name
}

output "cluster_endpoint" {
  sensitive   = false
  description = "Cluster Endpoint"
  value       = module.kubernetes.cluster_endpoint
  depends_on  = [
    module.kubernetes
  ]
}

output "cluster_ca_certificate" {
  sensitive   = true
  description = "Cluster CA Certificate"
  value       = module.kubernetes.cluster_ca_certificate
  depends_on  = [
    module.kubernetes
  ]
}

output "cluster_client_certificate" {
  sensitive   = true
  description = "Cluster Client Certificate"
  value       = module.kubernetes.cluster_client_certificate
  depends_on  = [
    module.kubernetes
  ]
}

output "cluster_client_key" {
  sensitive   = true
  description = "Cluster Client Key"
  value       = module.kubernetes.cluster_client_key
  depends_on  = [
    module.kubernetes
  ]
}