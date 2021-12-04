variable "hcloud_token" {
  sensitive   = true
  type        = string
  description = "Hcloud API Key"
}

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