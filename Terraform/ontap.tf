resource "proxmox_vm_qemu" "NODE1A" {
  name        = "NODE1A"
  target_node = "pve1"
  vm_state    = "stopped"
  os_type     = "ubuntu"
  scsihw      = "lsi53c810"
  

  cpu {
    cores = 2
    type  = "sandybridge"
  }
  memory = 6144
  network {
    id        = 0
    bridge    = "vmbr0"
    firewall  = false
    link_down = false
    model     = "e1000"
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

  disks {
    ide {
      ide1 {
        cdrom {
          iso = "ISO file"
        }
      }

    }
  }
}

resource "null_resource" "ontap_disk" {
    provisioner "local-exec" {
        command = <<EOT
          cd ../Ansible
          ansible-playbook -i inventory ontap-disk.yml
          EOT
      when = create
    }
  
}
