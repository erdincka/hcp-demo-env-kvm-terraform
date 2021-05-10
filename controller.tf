## Controller

resource "libvirt_volume" "ctrl_os_disk" {
  name           = "ctrl_os.qcow2"
  base_volume_id = libvirt_volume.base_image.id
}

resource "libvirt_domain" "controller" {
  name   = "controller"
  memory = var.controller_memory
  vcpu   = var.controller_cpu

  network_interface {
    network_name = "default"
  }

  disk {
    volume_id = libvirt_volume.ctrl_os_disk.id
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}