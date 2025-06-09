resource "proxmox_lxc" "centos" {
  hostname    = var.name
  target_node = var.target_node
  ostemplate  = "local:vztmpl/centos-9-stream-default_20240828_amd64.tar.xz"
  password    = var.proxmox_resource_pass
  unprivileged = true
    start = var.start
    tags = "ComputeUserL"
    ssh_public_keys = var.public_ssh_key


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
    ip     = "10.1.10.60/24"
    gw = "10.1.10.1"
  }

  features {
    nesting = true
  }


}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [proxmox_lxc.centos] # or whatever resource you want to wait for
  create_duration = "15s"
}

resource "null_resource" "PermitRootLogin" {
  provisioner "remote-exec" {
    inline = [
      # 1. Update packages and install SSH + essentials
      "pct exec ${proxmox_lxc.centos.vmid} -- bash -c 'dnf -y update && dnf -y install openssh-server sudo curl ca-certificates gnupg2'",

      # 2. Ensure root login is permitted
      "pct exec ${proxmox_lxc.centos.vmid} -- bash -c \"sed -i '/^PermitRootLogin/c\\PermitRootLogin yes' /etc/ssh/sshd_config || echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config\"",

      # 3. Enable and restart SSHD
      "pct exec ${proxmox_lxc.centos.vmid} -- systemctl enable --now sshd",
      "pct exec ${proxmox_lxc.centos.vmid} -- systemctl restart sshd"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      host        = var.host
      password    = var.proxmox_resource_pass
    }
  }
  depends_on = [proxmox_lxc.centos]
}
