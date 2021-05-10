### Need to download libvirt provider? 
# go to https://github.com/dmacvicar/terraform-provider-libvirt
terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source = "multani/libvirt"
      version = "0.6.3-1+4"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

# A pool for all cluster volumes
resource "libvirt_pool" "cluster" {
  name = "${var.project_id}-volume"
  type = "dir"
  path = var.storage_pool_dir
}
# Base OS image to use to create a cluster of different
# nodes
resource "libvirt_volume" "base_image" {
  name   = "centos7"
  pool   = libvirt_pool.name
  source = var.centos_iso
}

# volumes to attach to the "workers" domains as main disk
resource "libvirt_volume" "worker" {
  name           = "worker_${count.index}-os.qcow2"
  base_volume_id = libvirt_volume.base_image.id
  count          = var.workers_count
}
