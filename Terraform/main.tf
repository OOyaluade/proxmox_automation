module "vyos_router" {
  for_each = tomap({
    VYOSPVE1 = {
      target_node = "pve1"
      vm_state = "stopped"
    }
    VYOSPVE2 = {
      target_node = "pve2"
      vm_state = "stopped"
    }
    VYOSPVE3 = {
      target_node = "pve3"
      vm_state = "stopped"

  } })

  vm_state = each.value.vm_state
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

# module "centos" {
#     for_each = tomap({
#     LINUXAPVE2 = {
#       target_node = "pve2"  
#     } 
#     LINUXBPVE2 = {
#       target_node = "pve2"
#     } 
#   })

#   target_node = each.value.target_node
#   name = each.key
#   source = "./modules/centos"
#   providers = {
#     proxmox = proxmox
#   }

#   proxmox_resource_pass = var.proxmox_resource_pass
#   }
####################################################################3

module "jenkins" {
  source = "./modules/jenkins"
  host = "10.1.10.33"
  start = true
  target_node = "pve3"
  name = "Jenkins"
  public_ssh_key = var.public_ssh_key
  proxmox_resource_pass = var.proxmox_resource_pass
  providers = {
    proxmox = proxmox
  }
  }


module "prometheus_graphana" {

public_ssh_key = var.public_ssh_key
host = "10.1.10.33"
  start = true
  target_node = "pve3"
  name = "PromGraph"
  source = "./modules/prom-graph"
  providers = {
    proxmox = proxmox
  }

  proxmox_resource_pass = var.proxmox_resource_pass
  }



module "centos" {

  public_ssh_key = var.public_ssh_key
host = "10.1.10.31"
  start = true
  target_node = "pve1"
  name = "CentOS-REDHat"
  source = "./modules/cent-os"
  providers = {
    proxmox = proxmox
  }

  proxmox_resource_pass = var.proxmox_resource_pass
  }
