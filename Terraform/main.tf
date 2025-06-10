module "vyos_router" {
  for_each = tomap({
    VYOSPVE1 = {
      target_node = "pve1"
      vm_state    = "stopped"
    }
    VYOSPVE2 = {
      target_node = "pve2"
      vm_state    = "stopped"
    }
    VYOSPVE3 = {
      target_node = "pve3"
      vm_state    = "stopped"

  } })

  vm_state    = each.value.vm_state
  name        = each.key
  target_node = each.value.target_node

  source = "./modules/vyos"
  providers = {
    proxmox = proxmox
  }
}

# module "ontap" {
#   for_each = tomap({
#     NODE1a = {
#       target_node = "pve1"
#       host_ip     = "10.1.10.31"
#     }
#     NODE1b = {
#       target_node = "pve1"
#       host_ip     = "10.1.10.31"
#     }
#     NODE2 = {
#       target_node = "pve3"
#       host_ip     = "10.1.10.33"
#     }
#   })
#   host = each.value.host_ip
#   name = each.key
#   target_node = each.value.target_node
#   source                = "./modules/ontap"

#   proxmox_resource_pass = var.proxmox_resource_pass


#   providers = {
#     proxmox = proxmox
#   }
# }

# module "esxi" {
#   source = "./modules/esxi"
#   providers = {
#     proxmox = proxmox
#   }
# }

# module "win11" {
#   source = "./modules/win11"
#   providers = {
#     proxmox = proxmox
#   }
# }

# module "win22" {
#   for_each = tomap({
#     WINAPVE1 = {
#       target_node = "pve2"  
#     } 
#     WINBPVE1 = {
#       target_node = "pve2"
#     } 
#   })

# target_node = each.value.target_node
# name = each.key
#   source = "./modules/win22"
#   providers = {
#     proxmox = proxmox
#   }
# }


####################################################################3
module "testos16" {
  source                = "./modules/jenkins"
  host                  = "10.1.10.33"
  ip = "10.1.10.16/24"
  start                 = true
  target_node           = "pve3"
  name                  = "testos16"
  public_ssh_key        = var.public_ssh_key
  proxmox_resource_pass = var.proxmox_resource_pass
  providers = {
    proxmox = proxmox
  }
}
module "testos15" {
  source                = "./modules/jenkins"
  host                  = "10.1.10.33"
  ip = "10.1.10.15/24"
  start                 = true
  target_node           = "pve3"
  name                  = "testos15"
  public_ssh_key        = var.public_ssh_key
  proxmox_resource_pass = var.proxmox_resource_pass
  providers = {
    proxmox = proxmox
  }
}

module "jenkins" {
  source                = "./modules/jenkins"
  host                  = "10.1.10.33"
  ip = "10.1.10.14/24"
  start                 = true
  target_node           = "pve3"
  name                  = "Jenkins14"
  public_ssh_key        = var.public_ssh_key
  proxmox_resource_pass = var.proxmox_resource_pass
  providers = {
    proxmox = proxmox
  }
}


module "graf" {

  public_ssh_key = var.public_ssh_key
  host           = "10.1.10.33"
  ip = "10.1.10.13/24"
  start          = true
  target_node    = "pve3"
  name           = "Graf13"
  source         = "./modules/graf"
  providers = {
    proxmox = proxmox
  }
  proxmox_resource_pass = var.proxmox_resource_pass
}


module "prom" {

  public_ssh_key = var.public_ssh_key
  host           = "10.1.10.33"
    ip = "10.1.10.12/24"
  start          = true
  target_node    = "pve3"
  name           = "Prom12"
  source         = "./modules/prom"
  providers = {
    proxmox = proxmox
  }
  proxmox_resource_pass = var.proxmox_resource_pass
}



module "centos" {

  public_ssh_key = var.public_ssh_key
  host           = "10.1.10.31"
  ip = "10.1.10.11/24"
  start          = true
  target_node    = "pve1"
  name           = "CentOS11"
  source         = "./modules/centos"
  providers = {
    proxmox = proxmox
  }
  proxmox_resource_pass = var.proxmox_resource_pass
}
