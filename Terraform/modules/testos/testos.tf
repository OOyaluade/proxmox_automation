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
  memory = 2048*4
  swap   = 512

  rootfs {
    storage = "LVM-THIN"
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
echo "[testos]" > ../Ansible/${var.name}.int

echo "${split("/",var.ip)[0]} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'" >> ../Ansible/${var.name}.int

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
      "pct exec ${proxmox_lxc.testos.vmid} -- bash -c \"useradd -m -s /bin/bash -G sudo dami\"",
      "pct exec ${proxmox_lxc.testos.vmid} -- bash -c \"echo 'dami:${var.proxmox_resource_pass}' | chpasswd\"",
      "pct exec ${proxmox_lxc.testos.vmid} -- bash -c 'echo \"dami ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/dami'",
      "pct exec ${proxmox_lxc.testos.vmid} -- bash -c \"chmod 0440 /etc/sudoers.d/dami\"",
      "pct exec ${proxmox_lxc.testos.vmid} -- bash -c \"mkdir -p /home/dami/.ssh && echo '${var.public_ssh_key}' > /home/dami/.ssh/authorized_keys && chown -R dami:dami /home/dami/.ssh && chmod 700 /home/dami/.ssh && chmod 600 /home/dami/.ssh/authorized_keys\"",
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
    ansible-playbook -i ../Ansible/${var.name}.int ../Ansible/${var.name}.yml
    EOT
   
  }
  
}
