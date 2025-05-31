# vyos.tf

resource "proxmox_vm_qemu" "vyos" {
  name        = "vyos-router"
  target_node = "pve1"             # Change to your Proxmox node name
  vmid        = 105                # Pick a unique VMID
  os_type     = "l26"              # Generic Linux 2.6/3.x/4.x/5.x (VyOS runs on Linux)
  memory      = 1024
  scsihw      = "virtio-scsi-pci"
  onboot      = true
  boot        = "order=ide0"
  agent       = 0

  disks {
    ide {
      ide0 {
        cdrom {
          iso = "local:iso/vyos.iso"
        }
      }
    }
  }


  # Minimum one NIC (modify as needed)
  network {
    id        = 1
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"
  }
}
