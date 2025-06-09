# resource "proxmox_vm_qemu" "isilon_node1" {
#   name        = "ISILON-NODE1"
#   target_node = "pve1"
#   memory      = 6144
#   onboot      = true
#   vm_state    = "stopped"
#   scsihw      = "virtio-scsi-pci"
#   boot = "order=ide0;scsi0"


#   cpu {
#     cores = 2
#   }

#   disks {                     # placeholder CD-ROM disk
#     ide {
#       ide0 {
#         cdrom {
#           iso = "ISO file"
#         }
#       }
#     }
#   }
#   serial {
#   id     = 0
#   type   = "socket"
# }


#   network {
#     id        = 0
#     bridge    = "vmbr1"
#     firewall  = false
#     link_down = false
#     model     = "e1000"
#   }

#   network {
#     id        = 1
#     bridge    = "vmbr1"
#     firewall  = false
#     link_down = false
#     model     = "e1000"
#   }

#   lifecycle {
#     ignore_changes = [disk]
#   }
# }


# resource "null_resource" "import_isilon_disks" {
#   depends_on = [proxmox_vm_qemu.isilon_node1]

#   connection {
#     type     = "ssh"
#     user     = "root"
#     host     = "10.1.10.31"
#     password = var.proxmox_resource_pass
#   }

#   provisioner "file" {
#     source      = "import_disks.sh"
#     destination = "/tmp/import_disks.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/import_disks.sh",
#       "/tmp/import_disks.sh ${proxmox_vm_qemu.isilon_node1.vmid} LVM-THIN"
#     ]
#   }
# }
