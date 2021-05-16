## Libvirt Domain

resource "libvirt_volume" "wrkr_os_disk" {
  count = var.worker_count
  name           = "wrkr${count.index}-os-disk.qcow2"
  base_volume_id = libvirt_volume.os_image.id
  size           = 400 * var.BtoGB
}

resource "libvirt_volume" "wrkr_data_disk1" {
  count = var.worker_count
  name = "wrkr${count.index}-disk1.qcow2"
  pool = libvirt_pool.pool.name
  format = "qcow2"
  size = 1024 * var.BtoGB
}
resource "libvirt_volume" "wrkr_data_disk2" {
  count = var.worker_count
  name = "wrkr${count.index}-disk2.qcow2"
  pool = libvirt_pool.pool.name
  format = "qcow2"
  size = 1024 * var.BtoGB
}

resource "libvirt_domain" "workers" {
  count = var.worker_count
  name   = "worker${count.index}"
  memory = var.worker_memory
  vcpu   = var.worker_cpu
  qemu_agent = true
  autostart = true

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_name = libvirt_network.hcp_network.name
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.wrkr_os_disk[count.index].id
  }

  disk {
    volume_id = libvirt_volume.wrkr_data_disk1[count.index].id
  }

  disk {
    volume_id = libvirt_volume.wrkr_data_disk2[count.index].id
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
      "sudo hostnamectl set-hostname vm-${random_integer.host_id[count.index+2].result}.${libvirt_network.hcp_network.domain}"
    ]
  }
}