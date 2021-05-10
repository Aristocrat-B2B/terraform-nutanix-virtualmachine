# required variables
variable "os_type" {
  type = string
}

variable "admin_ssh_publickey" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "local_admin_secret" {
  type = string
}

variable "local_admin_username" {
  type = string
}

variable "nutanix_cluster_name" {
  type        = string
  description = "The name of the nutanix cluster"
}

variable "subnet_name" {
  type        = string
  description = "The name of the nutanix subnet to deploy into"
}

variable "project_id" {
  type        = string
  description = "Project UUID"
}

variable "image_name" {
  type        = string
  description = "Name of the uploaded image to use for the VM"
}


# Optional Variables
variable "vm_name" {
  type        = list(string)
  description = "List of virtual machine names"
  default     = ["example-vm"]
}

variable "ssh_user" {
  type        = string
  default     = "nutanix"
  description = "ssh user"
}

variable "ssh_password" {
  type        = string
  description = "ssh password"
  default     = "WeakPassword"
}

variable "vm_memory" {
  type        = number
  description = "Memory in Mb to allocate to VM"
  default     = 512
}

variable "cpu" {
  type        = map(any)
  description = "Map detailing num vcpu and num sockets"
  default = {
    "num_vcpus_per_socket" : 2,
    "num_sockets" : 2
  }
}

variable "additional_disk_enabled" {
  type        = bool
  description = "Controls if virtual machine resource should be created"
  default     = false
}

variable "additional_disk_list" {
  type        = map(any)
  description = "map of additional disks to add in MiB"
  default = {
    disk1 = 10,
    disk2 = 20
  }
}

variable "ip_address" {
  type        = list(any)
  description = "list of IP addresses"
  default     = []
}

variable "static_ip_enabled" {
  type        = bool
  description = "Assign static IP or DHCP assigned IP"
  default     = false
}
