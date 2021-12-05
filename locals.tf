locals {
  worker_ids = flatten(module.worker.*.ids)
  worker_ips = flatten(module.worker.*.ips)
  depends_on = [
    module.worker
  ]
}
