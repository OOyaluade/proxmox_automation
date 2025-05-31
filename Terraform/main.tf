module "vyos_router" {
  source    = "./modules/vyos"
  providers = {
    proxmox = proxmox
  }
}

module "esxi" {
  source = "./modules/esxi"
  providers = {
    proxmox = proxmox
  }
}

module "ontap" {
  source = "./modules/ontap"
  providers = {
    proxmox = proxmox
  }
}

