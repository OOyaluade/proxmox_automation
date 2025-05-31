resource "proxmox_vm_qemu" "NODE1A" {
  name        = "NODE1A"
  target_node = "pve1"
  vm_state    = "stopped"
  os_type     = "ubuntu"
  scsihw      = "lsi53c810"
  boot        = "order=ide0"

  disks {
    ide {
      ide0 {
        cdrom {
          iso = "ISO file"
        }
      }
    }
  }

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



  connection {
    type     = "ssh"
    user     = "root"
    password = var.proxmox_resource_pass
    host     = "10.1.10.31"

  }

  lifecycle {
    ignore_changes = [
      disk
    ]
  }

}

resource "null_resource" "import_netapp_disks" {
  depends_on = [proxmox_vm_qemu.NODE1A]

  connection {
    type     = "ssh"
    user     = "root"
    host     = "10.1.10.31" # Proxmox host IP
    password = var.proxmox_resource_pass
  }

  provisioner "remote-exec" {
    inline = [
      "cd /var/lib/vz/template/cache/",
      "tar -xvf /var/lib/vz/template/cache/vsim-netapp-DOT9.15.1-cm_nodar.ova",

      "qm disk import ${proxmox_vm_qemu.NODE1A.vmid} vsim-NetAppDOT-simulate-disk1.vmdk LVM-THIN -format qcow2",
      "qm disk import ${proxmox_vm_qemu.NODE1A.vmid} vsim-NetAppDOT-simulate-disk2.vmdk LVM-THIN -format qcow2",
      "qm disk import ${proxmox_vm_qemu.NODE1A.vmid} vsim-NetAppDOT-simulate-disk3.vmdk LVM-THIN -format qcow2",
      "qm disk import ${proxmox_vm_qemu.NODE1A.vmid} vsim-NetAppDOT-simulate-disk4.vmdk LVM-THIN -format qcow2",
      "qm set ${proxmox_vm_qemu.NODE1A.vmid} -delete ide0",
      "qm set ${proxmox_vm_qemu.NODE1A.vmid} -ide0 LVM-THIN:vm-${proxmox_vm_qemu.NODE1A.vmid}-disk-0",
      "qm set ${proxmox_vm_qemu.NODE1A.vmid} -ide1 LVM-THIN:vm-${proxmox_vm_qemu.NODE1A.vmid}-disk-1",
      "qm set ${proxmox_vm_qemu.NODE1A.vmid} -ide2 LVM-THIN:vm-${proxmox_vm_qemu.NODE1A.vmid}-disk-2",
      "qm set ${proxmox_vm_qemu.NODE1A.vmid} -ide3 LVM-THIN:vm-${proxmox_vm_qemu.NODE1A.vmid}-disk-3"


    ]
  }

}

