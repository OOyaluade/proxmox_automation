# vyos.tf


resource "proxmox_vm_qemu" "vyos" {
  name        = var.name
  target_node = var.target_node # Change to your Proxmox node name
  os_type     = "l26"           # Generic Linux 2.6/3.x/4.x/5.x (VyOS runs on Linux)
  memory      = 1024
  scsihw      = "virtio-scsi-pci"
  onboot      = true
  boot        = "order=ide1;ide0"
  agent       = 0
  vm_state    = var.vm_state
  tags        = "router"
  serial {
    id   = 0
    type = "socket"
  }
  disks {
    ide {
      ide0 {
        cdrom {
          iso = "local:iso/vyos.iso"
        }
      }
      ide1 {
        disk {
          size    = "2G"
          storage = "LVM-THIN"
        }
      }
    }
  }


  # Minimum one NIC (modify as needed)
  network {
    id        = 0
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"
    tag       = 0

  }
  network {
    id        = 1
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 2
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 3
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 4
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 5
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 6
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 7
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 8
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 9
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 10
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 11
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 12
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  network {
    id        = 13
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"

  }
  # lifecycle {
  #   prevent_destroy = true
  # }
}
