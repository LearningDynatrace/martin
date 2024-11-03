/* terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.65.0"
    }
     ansible = {
      version = "1.3.0"
      source  = "ansible/ansible"
    }
  }
}
 */


variable "numhosts" {
  default = 2
}

variable "instances" {
  default = [
    {
      position = "1"
      name     = "rousseltm-prod-1"
      ip       = "192.168.3.3"
    },
    {
      position = "2"
      name     = "rousseltm-prod-2"
      ip       = "192.168.3.4"
    }
  ]
}

resource "proxmox_virtual_environment_vm" "vm" {
  count = var.numhosts

  name      = var.instances[count.index].name
  node_name = "your-node-name"
  memory    = 2048
  cores     = 2
  sockets   = 1
  onboot    = true
  tags      = ["tag1", "tag2"]

  network {
    model  = "virtio"
    bridge = "vmbr0"
    ip     = var.instances[count.index].ip
  }

  provisioner "remote-exec" {
    inline = [
      "sed -i 's/#DNS=/DNS=8.8.8.8/g' /etc/systemd/resolved.conf",
      "systemctl restart systemd-resolved",
      "apt -y update",
      "apt -y install git"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://get.docker.com -o get-docker.sh",
      "sh get-docker.sh"
    ]
  }

  provisioner "file" {
    source      = "scripts/app-${var.instances[count.index].position}.sh"
    destination = "/tmp/app-${var.instances[count.index].position}.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/app-${var.instances[count.index].position}.sh",
      "/tmp/app-${var.instances[count.index].position}.sh"
    ]
  }
}