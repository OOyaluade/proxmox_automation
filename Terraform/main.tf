# resource "proxmox_lxc" "basic" {
#   for_each = toset(["pve1", "pve2", "pve3"])


#   target_node  = each.value
#   hostname     = "lxc-basic"
#   ostemplate   = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
#   password     = "${2723damyXX.}"
#   unprivileged = true
#   onboot       = true
#   start        = true
#   cores        = 4
#   memory       = 16000


#   // Terraform will crash without rootfs defined
#   rootfs {
#     storage = "LVM-THIN"
#     size    = "8G"
#   }


#   network {
#     name   = "eth0"
#     bridge = "vmbr0"
#     ip     = "10.1.10.181/24"
#   }
# }

