output "controller_ip" {
  value = libvirt_domain.controller.*.network_interface.0.addresses
}
output "gateway_ip" {
  value = libvirt_domain.gateway.*.network_interface.0.addresses
}
output "worker_ips" {
  value = libvirt_domain.workers.*.network_interface.0.addresses
}