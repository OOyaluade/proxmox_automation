resource "proxmox_lxc" "centos" {
  hostname        = var.name
  target_node     = var.target_node
  ostemplate      = "local:vztmpl/centos-9-stream-default_20240828_amd64.tar.xz"
  password        = var.proxmox_resource_pass
  unprivileged    = var.unprivileged  
  start           = var.start
  tags            = "ComputeUserL"
  ssh_public_keys = var.public_ssh_key
  onboot          = true


  cores  = 4
  memory = 16384
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
echo "[centos]" >> ../Ansible/centos.int

echo "${split("/",var.ip)[0]} ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_ed25519 ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'" >> ../Ansible/centos.int

EOT
  }
}


resource "null_resource" "PermitRootLogin" {
  provisioner "remote-exec" {
    inline = [
      # 1. Update packages and install SSH + essentials
      "pct exec ${proxmox_lxc.centos.vmid} -- bash -c 'curl \"0.0.0.0\"'",
      "pct exec ${proxmox_lxc.centos.vmid} -- bash -c 'dnf -y update'",
      "pct exec ${proxmox_lxc.centos.vmid} -- bash -c 'dnf install -y openssh-server'",
      "pct exec ${proxmox_lxc.centos.vmid} -- bash -c \"sed -i '/^#PermitRootLogin/c\\PermitRootLogin yes' /etc/ssh/sshd_config\"",
      "pct exec ${proxmox_lxc.centos.vmid} -- systemctl enable --now sshd",
      "pct exec ${proxmox_lxc.centos.vmid} -- systemctl restart sshd",
    ]

    connection {
      type     = "ssh"
      user     = "root"
      host     = var.host
      password = var.proxmox_resource_pass
    }
  }
  depends_on = [proxmox_lxc.centos]
}

resource "null_resource" "ansible_trigger" {
  depends_on = [proxmox_lxc.centos,null_resource.PermitRootLogin ]
  provisioner "local-exec" {
    command = <<EOT
    ansible-playbook -i ../Ansible/centos.int ../Ansible/centos.yml
    EOT
   
  }
  
}
