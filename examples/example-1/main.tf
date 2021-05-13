module "vm_create" {
  source  = "Aristocrat-B2B/virtualmachine/nutanix"
  version = "1.0.1"

  subnet_name          = "Primary"
  nutanix_cluster_name = "PHX-POC236"
  vm_name              = ["terraform-vm-module-test"]
  vm_memory            = 4096
  cpu = {
    "num_vcpus_per_socket" : 2,
    "num_sockets" : 2
  }
  additional_disk_enabled = true
  additional_disk_list = {
    disk1 = 10240,
    disk2 = 16000
  }
  image_name = "debian-elasticsearch-7.12.qcow2"

  static_ip_enabled = false
  ip_address        = []

  ssh_user = var.ssh_user

  ssh_password = var.ssh_password

  project_id = var.project_id
}

output "vm_details" {
  value = module.vm_create.nic_list
}

