resource "proxmox_lxc" "jenkins" {
  hostname        = var.name
  target_node     = var.target_node
  ostemplate      = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
  password        = var.proxmox_resource_pass
  unprivileged    = true
  start           = var.start
  tags            = "ComputeUserL"
  ssh_public_keys = var.public_ssh_key
  onboot          = true

  cores  = 2
  memory = 2048
  swap   = 512

  rootfs {
    storage = "LVM-THIN"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.1.10.10/24"
    gw     = "10.1.10.1"
  }

  features {
    nesting = true
  }
}



resource "null_resource" "bootstrap_jenkins" {
  provisioner "remote-exec" {
    inline = [

      "pct exec ${proxmox_lxc.jenkins.vmid} -- bash -c 'curl \"0.0.0.0\"'",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- bash -c 'apt -y update'",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- bash -c 'apt install -y openssh-server'",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- bash -c \"sed -i '/^PermitRootLogin/c\\PermitRootLogin yes' /etc/ssh/sshd_config\"",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- systemctl enable --now sshd",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- systemctl restart sshd",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- apt-get install -y docker.io",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- systemctl enable docker",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- systemctl start docker",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- bash -c 'mkdir -p /var/jenkins_home && chown 1000:1000 /var/jenkins_home'",

      "pct exec ${proxmox_lxc.jenkins.vmid} -- docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home jenkins/jenkins:lts",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword",

      "pct exec ${proxmox_lxc.jenkins.vmid} -- bash -c \"docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v /var/jenkins_home:/var/jenkins_home jenkins/jenkins:lts\"",
      "pct exec ${proxmox_lxc.jenkins.vmid} -- bash -c 'for i in {1..30}; do if docker exec jenkins test -f /var/jenkins_home/secrets/initialAdminPassword; then docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword; exit 0; fi; sleep 2; done; echo \"Jenkins admin password file not found!\"; exit 1'"

    ]
    connection {
      type     = "ssh"
      user     = "root"
      host     = var.host # Proxmox host IP
      password = var.proxmox_resource_pass
    }
  }

}
