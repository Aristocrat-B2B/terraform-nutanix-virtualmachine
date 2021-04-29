/*resource "nutanix_image" "image" {
  name        = "debian-services.qcow2"
  description = "Services Debian Image"
  source_uri  = "https://storage.googleapis.com/vm_qemu_images/debian_services_image/debian-services.qcow2"
}*/

module "vm_create" {
#  depends_on = [nutanix_image.image]
  source = "git::https://github.com/Aristocrat-B2B/devops-terraform_infra_services.git//modules/virtual_machine"

  subnet_name = "VLAN274iPAM"
  nutanix_cluster_name = "indc-nutanix-01"
  vm_name = ["terraform-vm-module-test-4", "terraform-vm-test-55"]
  vm_memory = 4096
  cpu = {
      "num_vcpus_per_socket": 2,
      "num_sockets" : 2
  }
  additional_disk_enabled = true
  additional_disk_list = {
        disk1 = 10240,
        disk2 = 16000
}

  image_name = "debian-services.qcow2"

  static_ip_enabled = true
  ip_address = ["172.26.74.110", "172.26.74.111"]

  ssh_user = var.ssh_user

  ssh_password = var.ssh_password

  project_id = var.project_id

}
