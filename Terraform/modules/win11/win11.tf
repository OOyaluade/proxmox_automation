resource "proxmox_vm_qemu" "win11" {
  name        = var.name
  target_node = var.target_node
  pool = var.pool
  vm_state = var.vm_state

  desc     = "Windows 11 VM"
  tags     = "ComputeUserW"
  onboot   = true

  memory   = 8192
  scsihw   = "virtio-scsi-pci"


  boot     = "order=ide1;ide0;ide2"


  os_type = "win10" # Use win10 — no win11 support in Proxmox terraform provider yet

  bios = "ovmf"  # UEFI required for Windows 11



  disks {
    ide {
      ide0 {
        cdrom {
          iso = "local:iso/win11.iso" # Your Server ISO
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
