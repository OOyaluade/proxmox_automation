resource "proxmox_vm_qemu" "win22" {
  name        = var.name
  target_node = var.target_node

  os_type     = "win10" # "win10" is fine for Server 2016/2019/2022
  memory      = 8192
  scsihw      = "virtio-scsi-pci"
  onboot      = true
  boot        = "order=ide0"
  vm_state    = "stopped"
  tags = "ComputeServer"

  disks {
    ide {
      ide0 {
        cdrom {
          iso = "local:iso/win22.iso" # Your Server ISO
        }
      }
      ide1 {
        disk {
          size    = "100G"
          storage = "LVM-THIN"
        }
      }
      ide2 {
        cdrom {
          iso = "local:iso/vitro.iso" # Your Server ISO
        }
      }

    }
  }

  network {
    id       = 0
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = false
  }

  cpu {
    type    = "host"
    cores   = 4
    sockets = 1
  }

  machine = "q35"

}
