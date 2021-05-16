## Libvirt Domain

resource "libvirt_volume" "gtw_os_disk" {
  name           = "gtw-os-disk.qcow2"
  base_volume_id = libvirt_volume.os_image.id
  size           = 400 * var.BtoGB
}

resource "libvirt_domain" "gateway" {
  name   = "gateway"
  memory = var.gateway_memory
  vcpu   = var.gateway_cpu
  qemu_agent = true
  autostart = true

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_name = libvirt_network.hcp_network.name
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.gtw_os_disk.id
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }

  provisioner "remote-exec" {
    connection {
      host     = self.network_interface.0.addresses.0
      type     = "ssh"
      user     = "centos"
      private_key = file(pathexpand(var.ssh_prv_key_path))
    }
    inline = [
      "sudo hostnamectl set-hostname vm-${random_integer.host_id.1.result}.${libvirt_network.hcp_network.domain}"
    ]
  }
}