resource "proxmox_lxc" "prom-graph" {
  hostname    = var.name
  target_node = var.target_node
  ostemplate  = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  password    = var.proxmox_resource_pass
  unprivileged = true
    start = var.start
    tags = "ComputeUserL"
    ssh_public_keys = var.public_ssh_key


  cores  = 2
  memory = 2048
  swap   = 512

  rootfs {
    storage = "LVM-THIN"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.1.10.11/24"
    gw = "10.1.10.1"
  }

  features {
    nesting = true
  }


}

resource "null_resource" "PermitRootLogin" {
  provisioner "remote-exec" {
    inline = [
      # 1. Install SSH, Docker prerequisites
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- bash -c 'apt-get update && apt-get install -y openssh-server sudo apt-transport-https ca-certificates curl software-properties-common'",

      # 2. Set PermitRootLogin yes in sshd_config
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- bash -c \"sed -i '/^PermitRootLogin/c\\PermitRootLogin yes' /etc/ssh/sshd_config || echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config\"",
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- systemctl restart ssh",

    ]

    connection {
      type        = "ssh"
      user        = "root"
      host        = var.host
      password = var.proxmox_resource_pass
    }
  }
  depends_on = [proxmox_lxc.prom-graph]
}


resource "null_resource" "bootstrap_promgraph" {
  provisioner "remote-exec" {
    inline = [

      "pct exec ${proxmox_lxc.prom-graph.vmid} -- bash -c 'curl \"0.0.0.0\"'", 
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- bash -c 'apt -y update'",
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- bash -c 'apt install -y openssh-server'", 
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- bash -c \"sed -i '/^PermitRootLogin/c\\PermitRootLogin yes' /etc/ssh/sshd_config\"",
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- systemctl enable --now sshd",
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- systemctl restart ssh",
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common",
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- apt-get install -y docker.io",

      "pct exec ${proxmox_lxc.prom-graph.vmid} -- systemctl enable docker",
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- systemctl start docker",
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- docker run -d --name prometheus -p 9090:9090 prom/prometheus",
      "pct exec ${proxmox_lxc.prom-graph.vmid} -- docker run -d --name grafana -p 3000:3000 grafana/grafana"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      host        = var.host
      password    = var.proxmox_resource_pass
    }
  }
  depends_on = [null_resource.PermitRootLogin]
}
