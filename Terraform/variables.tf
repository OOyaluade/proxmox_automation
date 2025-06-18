variable "pm_api_token_secret" {
  type = string
}
variable "pm_api_token_id" {
  type = string

}
variable "proxmox_resource_pass" {
  type = string
}
variable "public_ssh_key" {
  type = string
}

variable "prom_ip" {
  type    = string
  default = "10.1.10.12/24"

}

variable "graf_ip" {
  type    = string
  default = "10.1.10.13/24"

}

variable "testos16_ip" {
  type    = string
  default = "10.1.10.16/24"

}


variable "testos15_ip" {
  type    = string
  default = "10.1.10.15/24"

}


variable "jenkins_ip" {
  type    = string
  default = "10.1.10.14/24"

}


variable "centos_ip" {
  type    = string
  default = "10.1.10.11/24"

}

variable "docker_ip" {
  type    = string
  default = "10.1.10.17/24"

}