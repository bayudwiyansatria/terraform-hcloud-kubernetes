variable "hcloud_token" {
  sensitive   = true
  type        = string
  description = "Hcloud API Key"
}

variable "load_balancer_name" {
  type        = string
  description = "nginx-ingress-controller"
  default     = "default-load-balancer"
}

variable "network_subnet" {
  type        = string
  description = "Hcloud Network Subnet"
  default     = "10.0.0.0/24"
}

#-----------------------------------------------------------------------------------------------------------------------
# Clusters
#-----------------------------------------------------------------------------------------------------------------------
variable "cluster_name" {
  type        = string
  description = "Kubernetes Cluster Name"
}

variable "cluster_admin_ssh_keys" {
  type        = list(string)
  description = "List of Public Key"
}

variable "cluster_admin_ssh_access" {
  type        = string
  description = "SSH Private Key"
}

variable "master_count" {
  type        = number
  description = "Number of master nodes"
  default     = 1
}

variable "master_type" {
  type        = string
  description = "For more types have a look at https://www.hetzner.de/cloud"
  default     = "cx21"
}

variable "worker_type" {
  type        = list(object({
    count = number,
    type  = string
  }))
  description = "For more types have a look at https://www.hetzner.de/cloud"
  default     = [
    {
      count = 1
      type  = "cx21",
    },
    {
      count = 1
      type  = "cpx11",
    }
  ]
}


# Fix Needed
# https://github.com/hashicorp/terraform/issues/2430#issuecomment-188704400
variable "cluster_endpoint" {
  type        = string
  description = "Cluster Endpoint"
  default     = ""
}

variable "cluster_ca_certificate" {
  type        = string
  description = "Cluster CA Certificate PEM Format"
  default     = ""
}

variable "cluster_client_certificate" {
  type        = string
  description = "Cluster Client Certificate PEM Format"
  default     = ""
}

variable "cluster_client_key" {
  type        = string
  description = "Cluster Client Key PEM Format"
  default     = ""
}

#-----------------------------------------------------------------------------------------------------------------------
# Addons
#-----------------------------------------------------------------------------------------------------------------------
variable "enabled_nginx_ingress" {
  type        = bool
  description = "Enable Nginx Ingress Controller"
  default     = false
}