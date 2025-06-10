resource "proxmox_lxc" "graf" {
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



resource "null_resource" "bootstrap_promgraph" {
  provisioner "remote-exec" {
    inline = [

      "pct exec ${proxmox_lxc.graf.vmid} -- bash -c 'curl \"0.0.0.0\"'",
      "pct exec ${proxmox_lxc.graf.vmid} -- bash -c 'apt -y update'",
      "pct exec ${proxmox_lxc.graf.vmid} -- bash -c 'apt install -y openssh-server'",
      "pct exec ${proxmox_lxc.graf.vmid} -- bash -c \"sed -i '/^#PermitRootLogin/c\\PermitRootLogin yes' /etc/ssh/sshd_config\"",
      "pct exec ${proxmox_lxc.graf.vmid} -- systemctl enable --now ssh",
      "pct exec ${proxmox_lxc.graf.vmid} -- systemctl restart ssh",
    ]

    connection {
      type     = "ssh"
      user     = "root"
      host     = var.host
      password = var.proxmox_resource_pass
    }
  }

}
