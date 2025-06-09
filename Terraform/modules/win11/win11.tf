resource "proxmox_vm_qemu" "win11" {
  name        = "win11"
  target_node = "pve2"

  os_type     = "win11"
  memory      = 8192            # 8 GB RAM
  scsihw      = "virtio-scsi-pci"
  onboot      = true
  boot        = "order=ide0"
    vm_state    = "stopped"
    tags = "ComputeUserW"


  disks {
    ide {
      ide0 {
        cdrom {
          iso = "local:iso/win11.iso" # Your Server ISO
        }
      }
      ide1 {
        disk {
          size    = "8G"
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
    id        = 0
    bridge    = "vmbr0"
    model     = "virtio"
    firewall  = false
  }

  cpu {
    type    = "host"
    cores   = 4
    sockets = 1
  }

  machine = "q35"

}
