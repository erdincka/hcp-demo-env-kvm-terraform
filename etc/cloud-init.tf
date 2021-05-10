# Use CloudInit to customize install

# resource "libvirt_cloudinit_disk" "commoninit" {
#   name      = "commoninit.iso"
#   user_data = data.template_file.user_data.rendered
# }
# data "template_file" "user_data" {
#   template = file("${path.module}/cloud_init.cfg")
# }

resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "cloudinit.iso"
  pool = "default"

  user_data = <<EOF
#cloud-config
#disable_root: 0
#ssh_pwauth: 1
users:
  - name: centos
    ssh-authorized-keys:
      - ${file("id_rsa.pub")}
growpart:
  mode: auto
  devices: ['/']

# Hostname management
# preserve_hostname: False
# hostname: ${var.hostname}
# fqdn: ${var.hostname}.${var.domain}

# Configure where output will go
output: 
  all: ">> /var/log/cloud-init.log"

# configure interaction with ssh server
ssh_svcname: ssh
ssh_deletekeys: True
ssh_genkeytypes: ['rsa', 'ecdsa']

# Remove cloud-init when finished with it
runcmd:
  - [ yum, -y, remove, cloud-init ]
  - echo "ip_resolve=4" >> /etc/yum.conf
  # - hostnamectl set-hostname ${var.hostname}.${var.domain}
  - timedatectl set-timezone "${var.timezone}"

EOF

}
