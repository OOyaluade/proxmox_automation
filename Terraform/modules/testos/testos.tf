resource "proxmox_lxc" "testos" {
  hostname        = var.name
  target_node     = var.target_node
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  password        = var.proxmox_resource_pass
  unprivileged    = true
  start           = var.start
  tags            = "ComputeUserL"
  ssh_public_keys = var.public_ssh_key
  onboot          = true


  cores  = 2
  memory = 2048
  swap   = 512

  rootfs {
    storage = "slow-ceph"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = var.ip
    gw     = "10.1.10.1"
  }

  features {
    nesting = true
  }
  provisioner "local-exec" {
    command = <<EOT
echo "[testos]" >> ../Ansible/machine_loader.int

echo "${split("/",var.ip)[0]} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'" >> ../Ansible/machine_loader.int

EOT
}

}



resource "null_resource" "PermitRootLogin" {
  provisioner "remote-exec" {
    inline = [

      "pct exec ${proxmox_lxc.testos.vmid} -- bash -c 'curl \"0.0.0.0\"'",
      "pct exec ${proxmox_lxc.testos.vmid} -- bash -c 'apt -y update'",
      "pct exec ${proxmox_lxc.testos.vmid} -- bash -c 'apt install -y openssh-server'",
      "pct exec ${proxmox_lxc.testos.vmid} -- bash -c \"sed -i '/^#PermitRootLogin/c\\PermitRootLogin yes' /etc/ssh/sshd_config\"",
      "pct exec ${proxmox_lxc.testos.vmid} -- systemctl enable --now ssh",
      "pct exec ${proxmox_lxc.testos.vmid} -- systemctl restart ssh",

    ]

    connection {
      type     = "ssh"
      user     = "root"
      host     = var.host
      password = var.proxmox_resource_pass
    }
  }

}


resource "null_resource" "ansible_trigger" {
  depends_on = [proxmox_lxc.testos,null_resource.PermitRootLogin]
  provisioner "local-exec" {
    command = <<EOT
    ansible-playbook -i ../Ansible/machine_loader.int ../Ansible/${var.name}.yml
    EOT
   
  }
  
}
