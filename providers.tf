terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.65.0"
      }
     ansible = {
      version = "1.3.0"
      source  = "ansible/ansible"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.1.20:8006/"
  api_token = var.api_token
  insecure  = true
  ssh {
    agent    = true
    username = "root"
  }
}

provider "ansible" {
  # Optionnel : spécifiez un chemin d'inventaire statique si vous utilisez un fichier d'inventaire fixe
  # inventory_file = "${path.module}/ansible/hosts.ini"
}