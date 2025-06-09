resource "proxmox_lxc" "centos9" {
  hostname    = var.name
  target_node = var.target_node
  ostemplate  = "local:vztmpl/centos-9-stream-default_20240828_amd64.tar.xz"
  password    = var.proxmox_resource_pass
  unprivileged = true
    start = false
    tags = "ComputeUserL"


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
    ip     = "dhcp"
  }

  features {
    nesting = true
  }


}
