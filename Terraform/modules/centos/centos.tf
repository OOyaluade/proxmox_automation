resource "proxmox_lxc" "centos" {
  hostname        = var.name
  target_node     = var.target_node
  ostemplate      = "local:vztmpl/centos-9-stream-default_20240828_amd64.tar.xz"
  password        = var.proxmox_resource_pass
  unprivileged    = true
  start           = var.start
  tags            = "ComputeUserL"
  ssh_public_keys = var.public_ssh_key
  onboot          = true


  cores  = 4
  memory = 16384
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
