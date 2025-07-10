resource "proxmox_vm_qemu" "Target_Ubuntu" {
  name        = var.name
  target_node = var.target_node # Change to your Proxmox node name
  os_type     = "ubuntu"          # Generic Linux 2.6/3.x/4.x/5.x (Target_Ubuntu runs on Linux)
  memory      = 2048
  scsihw      = "virtio-scsi-single"
  onboot      = true
  boot        = "order=ide1;ide0"
  agent       = 1
  vm_state    = var.vm_state
  tags        = "TestMachines"
  bios = "ovmf"



  cpu {
    cores=4
    
  }

  efidisk {
  efitype = "4m"           # 4m is standard for most UEFI setups
  storage = "LVM-THIN"     # Use your actual storage pool here
}
  serial {
    id   = 0
    type = "socket"
  }
  disks {
    ide {
      ide0 {
        cdrom {
          iso = "local:iso/ubuntu-25.04-desktop-amd64.iso"
        }
      }
      ide1 {
        disk {
          size    = "25000M"
          storage = "LVM-THIN"
          emulatessd=true
          # iothread=true
          discard=true
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
    model     = "virtio"
    tag       = 0

}
}