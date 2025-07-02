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

module "win22" {
  source = "./modules/win22"
  target_node = "pve1"
  name = "Win22"
  providers = {
    proxmox = proxmox
    
  }
}






####################################################################3


####################################################################3




module "testos16" {
  source                = "./modules/testos"
  host                  = "10.1.10.33"
  ip                    = var.testos16_ip
  start                 = true
  target_node           = "pve3"
  name                  = "testos16"
  public_ssh_key        = var.public_ssh_key
  proxmox_resource_pass = var.proxmox_resource_pass
  providers = {
    proxmox = proxmox
  }
}

resource "null_resource" "testos16" {


  provisioner "local-exec" {
    command = <<EOT


echo "[testos16]" >> ../Ansible/machine_loader.int
echo "$(terraform output -raw testos16_ip | cut -d'/' -f1) ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'" >> ../Ansible/machine_loader.int
ansible-playbook -i ../Ansible/machine_loader.int ../Ansible/testos16.yml 
EOT
  }
}

module "testos15" {
  source                = "./modules/testos"
  host                  = "10.1.10.33"
  ip                    = var.testos15_ip
  start                 = true
  target_node           = "pve3"
  name                  = "testos15"
  public_ssh_key        = var.public_ssh_key
  proxmox_resource_pass = var.proxmox_resource_pass
  providers = {
    proxmox = proxmox
  }
}
resource "null_resource" "testos15" {


  provisioner "local-exec" {
    command = <<EOT

echo "[testos15]" >> ../Ansible/machine_loader.int
echo "$(terraform output -raw testos15_ip | cut -d'/' -f1) ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'" >> ../Ansible/machine_loader.int
ansible-playbook -i ../Ansible/machine_loader.int ../Ansible/testos15.yml 
EOT
  }
}


module "jenkins" {
  source                = "./modules/jenkins"
  host                  = "10.1.10.33"
  ip                    = var.jenkins_ip
  start                 = true
  target_node           = "pve3"
  name                  = "Jenkins14"
  public_ssh_key        = var.public_ssh_key
  proxmox_resource_pass = var.proxmox_resource_pass
  providers = {
    proxmox = proxmox
  }
}
resource "null_resource" "jenkins" {


  provisioner "local-exec" {
    command = <<EOT
echo "[jenkins]" >> ../Ansible/machine_loader.int
echo "$(terraform output -raw jenkins_ip | cut -d'/' -f1) ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'" >> ../Ansible/machine_loader.int
ansible-playbook -i ../Ansible/machine_loader.int ../Ansible/jenkins.yml 
EOT
  }
}

module "graf" {

  public_ssh_key = var.public_ssh_key
  host           = "10.1.10.33"
  ip             = var.graf_ip
  start          = true
  target_node    = "pve3"
  name           = "Graf13"
  source         = "./modules/graf"
  providers = {
    proxmox = proxmox
  }
  proxmox_resource_pass = var.proxmox_resource_pass
}

resource "null_resource" "graf" {


  provisioner "local-exec" {
    command = <<EOT
echo "[graf]" >> ../Ansible/machine_loader.int
echo "$(terraform output -raw grafana_ip | cut -d'/' -f1) ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'" >> ../Ansible/machine_loader.int
ansible-playbook -i ../Ansible/machine_loader.int ../Ansible/graf.yml 
EOT
  }
}


module "prom" {

  public_ssh_key = var.public_ssh_key
  host           = "10.1.10.33"
  ip             = var.prom_ip
  start          = true
  target_node    = "pve3"
  name           = "Prom12"
  source         = "./modules/prom"
  providers = {
    proxmox = proxmox
  }
  proxmox_resource_pass = var.proxmox_resource_pass
}


resource "null_resource" "prom" {


  provisioner "local-exec" {
    command = <<EOT
echo "[prom]" >> ../Ansible/machine_loader.int
echo "$(terraform output -raw prometheus_ip | cut -d'/' -f1) ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'" >> ../Ansible/machine_loader.int
ansible-playbook -i ../Ansible/machine_loader.int ../Ansible/prom.yml 
EOT
  }
}



module "centos" {

  public_ssh_key = var.public_ssh_key
  host           = "10.1.10.31"
  ip             = var.centos_ip
  start          = true
  target_node    = "pve1"
  name           = "CentOS11"
  unprivileged  = true
  source         = "./modules/centos"
  providers = {
    proxmox = proxmox
  }
  proxmox_resource_pass = var.proxmox_resource_pass
}






# module "docker17" {
#   source                = "./modules/docker"
#   host                  = "10.1.10.33"
#   ip                    = var.docker_ip
#   start                 = true
#   target_node           = "pve3"
#   name                  = "docker17"
#   public_ssh_key        = var.public_ssh_key
#   proxmox_resource_pass = var.proxmox_resource_pass
#   providers = {
#     proxmox = proxmox
#   }
# }
# resource "null_resource" "docker17" {
#   depends_on = [module.docker17]

#   provisioner "local-exec" {
#     command = <<EOT

# echo "[docker17]" >> ../Ansible/machine_loader.int
# echo "$(terraform output -raw docker_ip | cut -d'/' -f1) ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'" >> ../Ansible/machine_loader.int
# ansible-playbook -i ../Ansible/machine_loader.int ../Ansible/docker17.yml 

# EOT
#   }
# }







