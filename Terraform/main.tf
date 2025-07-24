module "vyos_router" {

  vm_state    = "stopped"
  name        = "VYOSPVE1"
  target_node = "pve1"
  pool        = "dev-pool"
  storage     = "slow-ceph"
  source      = "./modules/vyos"
  providers = {
    proxmox = proxmox
  }
}

# module "NODE1a" {

#   host                  = "10.1.10.31"
#   pool                  = "dev-pool"
#   name                  = "NODE1a"
#   target_node           = "pve1"
#   source                = "./modules/ontap"
#   proxmox_resource_pass = var.proxmox_resource_pass
#   providers = {
#     proxmox = proxmox
#   }
# }


module "NODE1b" {

  host                  = "10.1.10.31"
  pool                  = "dev-pool"
  name                  = "NODE1bC"
  target_node           = "pve1"
  source                = "./modules/ontap"
  proxmox_resource_pass = var.proxmox_resource_pass
  providers = {
    proxmox = proxmox
  }
}


# module "esxi" {
#   source = "./modules/esxi"
#   providers = {
#     proxmox = proxmox
#   }
# }

module "win22" {
  source      = "./modules/win22"
  target_node = "pve2"
  name        = "Win22"
  storage     = "slow-ceph"
  pool        = "dev-pool"
  vm_state    = "stopped"
  providers = {
    proxmox = proxmox

  }
}


module "winA" {
  source      = "./modules/win11"
  target_node = "pve3"
  name        = "WinA"
  pool        = "dev-pool"
  storage     = "slow-ceph"
  vm_state    = "stopped"
  providers = {
    proxmox = proxmox

  }
}

# module "winB" {
#   source      = "./modules/win11"
#   target_node = "pve2"
#   name        = "WinB"
#   pool        = "dev-pool"
#   storage     = "slow-ceph"
#   providers = {
#     proxmox = proxmox

#   }
# }






####################################################################3


####################################################################3


module "target_ubuntu0" {

  name        = "WebUbuntuTarget0"
  target_node = "pve1"
  storage     = "slow-ceph"
  vm_state    = "stopped"

  pool   = "dev-pool"
  ip     = "10.1.10.20"
  source = "./modules/target_ubuntu"
  providers = {
    proxmox = proxmox
  }
}



# module "target_redhat" {
#   vm_state    = "running"
#   name        = "RedHatTarget"
#   target_node = "pve2"
#   ip = "10.1.10.22"
#   source = "./modules/target_redhat"
#   providers = {
#     proxmox = proxmox
#   }
# }

# module "target_susu" {
#   vm_state    = "running"
#   name        = "SUSUTarget"
#   target_node = "pve2"
#   ip = "10.1.10.23"
#   source = "./modules/target_susu"
#   providers = {
#     proxmox = proxmox
#   }
# }


# module "testos17" {
#   source                = "./modules/testos"
#   host                  = "10.1.10.32"
#   ip                    = var.testos17_ip
#   start                 = true
#   target_node           = "pve2"
#   name                  = "testos17"
#   storage               = "slow-ceph"
#   public_ssh_key        = var.public_ssh_key
#   proxmox_resource_pass = var.proxmox_resource_pass
#   providers = {
#     proxmox = proxmox
#   }
# }



# module "testos16" {
#   source                = "./modules/testos"
#   host                  = "10.1.10.3"
#   ip                    = var.testos16_ip
#   start                 = true
#   target_node           = "pve2"
#   name                  = "testos16"
#   storage               = "slow-ceph"
#   public_ssh_key        = var.public_ssh_key
#   proxmox_resource_pass = var.proxmox_resource_pass
#   providers = {
#     proxmox = proxmox
#   }
# }


module "testos15" {
  source                = "./modules/testos"
  host                  = "10.1.10.32"
  ip                    = var.testos15_ip
  start                 = true
  target_node           = "pve2"
  name                  = "testos15"
  storage               = "slow-ceph"
  public_ssh_key        = var.public_ssh_key
  proxmox_resource_pass = var.proxmox_resource_pass
  providers = {
    proxmox = proxmox
  }
}



module "jenkins" {
  source                = "./modules/jenkins"
  host                  = "10.1.10.33"
  ip                    = var.jenkins_ip
  start                 = true
  target_node           = "pve2"
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
  ip             = var.graf_ip
  start          = true
  target_node    = "pve2"
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
  ip             = var.prom_ip
  start          = true
  target_node    = "pve2"
  name           = "Prom12"
  source         = "./modules/prom"
  providers = {
    proxmox = proxmox
  }
  proxmox_resource_pass = var.proxmox_resource_pass
}


module "centos" {

  public_ssh_key = var.public_ssh_key
  host           = "10.1.10.32"
  ip             = var.centos_ip
  start          = true
  target_node    = "pve2"
  name           = "CentOS11"
  unprivileged   = true
  source         = "./modules/centos"
  providers = {
    proxmox = proxmox
  }
  proxmox_resource_pass = var.proxmox_resource_pass
}


# module "centtwo" {

#   public_ssh_key = var.public_ssh_key
#   host           = "10.1.10.31"
#   ip             = "10.1.10.21/24"
#   start          = true
#   target_node    = "pve2"
#   name           = "CentOSanother"
#   unprivileged   = true
#   source         = "./modules/centos"
#   providers = {
#     proxmox = proxmox
#   }
#   proxmox_resource_pass = var.proxmox_resource_pass
# }









