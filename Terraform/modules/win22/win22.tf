resource "proxmox_vm_qemu" "win22" {
  name        = var.name
  target_node = var.target_node
  vm_state   = var.vm_state

  desc     = "Windows Server 2022"
  tags     = "ComputeServer"
  onboot   = true
  pool = var.pool

  boot     = "order=ide1;ide0;ide2"
  os_type  = "win10"

  scsihw   = "virtio-scsi-pci"
  memory   = 8192


  # BIOS: UEFI (OVMF) for modern OSes
  bios = "ovmf"


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
          storage = var.storage
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
