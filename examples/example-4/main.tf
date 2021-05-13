module "vm_create" {

  source  = "Aristocrat-B2B/virtualmachine/nutanix"
  version = "1.0.1"

  os_type          = "linux"
  auto_sethostname = false

  subnet_name          = "Lenovo_VM-Network"
  nutanix_cluster_name = "chi-hx3520-cl01"
  vm_name              = ["paul-vm-module-test"]
  vm_memory            = 1024
  cpu = {
    "num_vcpus_per_socket" : 1,
    "num_sockets" : 1
  }
  image_name = "debian-elasticsearch-7.12.0.qcow2"

  static_ip_enabled = false
  ip_address        = []

  ssh_user = "nutanix"

  ssh_password = "nutanix"

  project_id = "abc-paul-test"

  cfn_init_user_data = <<-EOT
  #cloud-config
  ssh_pwauth: 1
  chpasswd:
    list: |
      admin_user:admin_password
    expire: false
  users:
    - name: another_user
      gecos: CEE another_user Account
      sudo: ALL=(ALL) NOPASSWD:ALL
      primary_group: another_user_group
      primary_group: another_user_group
      groups: another_user
      ssh-authorized-keys:
        - abcd-1234
  final_message: "The system is finally up, after $UPTIME seconds"
  EOT
}

output "vm_details" {
  value = module.vm_create.nic_list
}

