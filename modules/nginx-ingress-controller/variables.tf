variable "enabled" {
  type        = bool
  description = "Enabled Nginx Ingress Controller"
  default     = false
}

variable "load_balancer_name" {
  type        = string
  description = "Kubernetes Load Balance IPs"
  default     = "nginx-ingress-controller"
}