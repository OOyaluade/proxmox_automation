resource "proxmox_vm_qemu" "esxi" {
  name        = "esxi"
  target_node = "pve1"

  os_type     = "other"
  memory      = 16384
  scsihw      = "virtio-scsi-pci"
  onboot      = true
  boot        = "order=ide0"
  hotplug     = ""
  vm_state    = "stopped"
  tags = "Hypervisor"

  disks {

    ide {
      ide0 {
        cdrom {
          iso = "local:iso/esxi.iso" # Use your VCSA ISO here
        }
      }


      ide1 {
        disk {
          size    = "350G"
          storage = "LVM-THIN" # Adjust storage as needed

        }
      }

    }
  }

  network {
    id       = 0
    bridge   = "vmbr0"
    model    = "vmxnet3"
    firewall = false
  }

  network {
    id       = 1
    bridge   = "vmbr0"
    model    = "vmxnet3"
    firewall = false
  }

  cpu {
    type    = "host"
    cores   = 8
    sockets = 2
  }

  machine = "q35"

}
