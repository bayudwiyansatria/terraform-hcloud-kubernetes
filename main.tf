#-----------------------------------------------------------------------------------------------------------------------
# Operations
#-----------------------------------------------------------------------------------------------------------------------
resource "hcloud_ssh_key" "admin" {
  count      = length(var.cluster_admin_ssh_keys)
  name       = "admin-${count.index + 1}"
  public_key = var.cluster_admin_ssh_keys[count.index]
}

#-----------------------------------------------------------------------------------------------------------------------
# Master
#-----------------------------------------------------------------------------------------------------------------------

module "master" {
  source       = "bayudwiyansatria/server/hcloud"
  version      = "1.0.0"
  hcloud_token = var.hcloud_token
  server_keys  = hcloud_ssh_key.admin.*.id
  server_name  = "${var.cluster_name}-master"
  server_count = var.master_count
  server_type  = var.master_type
}

#-----------------------------------------------------------------------------------------------------------------------
# Worker
#-----------------------------------------------------------------------------------------------------------------------

module "worker" {
  count        = length(var.worker_type)
  source       = "bayudwiyansatria/server/hcloud"
  version      = "1.0.0"
  hcloud_token = var.hcloud_token
  server_keys  = hcloud_ssh_key.admin.*.id
  server_name  = "${var.cluster_name}-worker-${var.worker_type[count.index].type}"
  server_count = var.worker_type[count.index].count
  server_type  = var.worker_type[count.index].type
}

#-----------------------------------------------------------------------------------------------------------------------
# Network
#-----------------------------------------------------------------------------------------------------------------------

module "network" {
  source       = "bayudwiyansatria/network/hcloud"
  hcloud_token = var.hcloud_token
}

module "load_balancer" {
  source             = "bayudwiyansatria/load-balancer/hcloud"
  version            = "1.0.0"
  load_balancer_name = var.load_balancer_name
  hcloud_token       = var.hcloud_token
  network_zone       = "eu-central"
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  count            = var.master_count
  type             = "server"
  server_id        = module.master.ids[0]
  load_balancer_id = module.load_balancer.ids
  depends_on       = [
    module.master
  ]
}

resource "hcloud_server_network" "master_network" {
  count      = var.master_count
  server_id  = module.master.ids[count.index]
  network_id = module.network.ids
  depends_on = [
    module.master,
    module.network
  ]
}

resource "hcloud_server_network" "worker_network" {
  count      = length(local.worker_ids)
  server_id  = local.worker_ids[count.index]
  network_id = module.network.ids
  depends_on = [
    module.worker,
    module.network
  ]
}

#-----------------------------------------------------------------------------------------------------------------------
# Kubernetes
#-----------------------------------------------------------------------------------------------------------------------

module "kubernetes" {
  source          = "bayudwiyansatria/cloud-bootstrap/kubernetes"
  version         = "1.0.1"
  docker_enabled  = true
  master_host     = module.master.ips
  worker_host     = local.worker_ips
  ssh_private_key = var.cluster_admin_ssh_access
  depends_on      = [
    module.master,
    module.worker
  ]
}

#-----------------------------------------------------------------------------------------------------------------------
# Controller Manager
#-----------------------------------------------------------------------------------------------------------------------

resource "null_resource" "cloud-controller-manager" {
  connection {
    host        = module.master.ips[0]
    private_key = var.cluster_admin_ssh_access
  }

  provisioner "file" {
    source      = "${path.module}/scripts/cloud-controller-manager.sh"
    destination = "/root/cloud-controller-manager.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "HCLOUD_TOKEN=${var.hcloud_token} CLUSTER_NETWORK=${module.network.ids} bash /root/cloud-controller-manager.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "rm -rf /root/cloud-controller-manager.sh"
    ]
  }

  depends_on = [
    module.kubernetes
  ]
}

#-----------------------------------------------------------------------------------------------------------------------
# CSI
#-----------------------------------------------------------------------------------------------------------------------
# This is a Container Storage Interface driver for Hetzner Cloud enabling you to use ReadWriteOnce Volumes within Kubernetes.
# Please note that this driver requires Kubernetes 1.13 or newer.
# https://github.com/hetznercloud/csi-driver

resource "null_resource" "csi" {
  connection {
    host        = module.master.ips[0]
    private_key = var.cluster_admin_ssh_access
  }

  provisioner "file" {
    source      = "${path.module}/scripts/cloud-csi.sh"
    destination = "/root/cloud-csi.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "HCLOUD_TOKEN=${var.hcloud_token} bash /root/cloud-csi.sh"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "rm -rf /root/cloud-csi.sh"
    ]
  }

  depends_on = [
    null_resource.cloud-controller-manager
  ]
}

#-----------------------------------------------------------------------------------------------------------------------
# Addons
#-----------------------------------------------------------------------------------------------------------------------
# Nginx Ingress Resource Will Be Created On Kubernetes Cluster
# Load Balancer Is Expected To Be Available
# Notes:
# Delete Nginx Ingress Resource After It's Created Will Cause Old Load Balancer Deleted
# Known Issues https://github.com/hetznercloud/hcloud-cloud-controller-manager/issues/249

module "nginx-ingress-controller" {
  source                     = "./modules/nginx-ingress-controller"
  enabled                    = var.enabled_nginx_ingress
  load_balancer_name         = var.load_balancer_name
  depends_on = [
    null_resource.cloud-controller-manager,
    null_resource.csi
  ]
}
