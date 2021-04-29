data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}

data "nutanix_cluster" "cluster" {
  name = var.nutanix_cluster_name
}

data "nutanix_image" "image_data" {
  image_name = var.image_name
}

resource "nutanix_virtual_machine" "vm" {
  count        = length(var.vm_name)
  name         = var.vm_name[count.index]
  cluster_uuid = data.nutanix_cluster.cluster.metadata.uuid

  num_vcpus_per_socket = var.cpu["num_vcpus_per_socket"]
  num_sockets          = var.cpu["num_sockets"]
  memory_size_mib      = var.vm_memory

  project_reference = {
    kind = "project"
    uuid = var.project_id
  }
  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = data.nutanix_image.image_data.metadata.uuid
    }
    device_properties {
      device_type = "DISK"
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }
    }
  }
  dynamic "disk_list" {
    for_each = var.additional_disk_enabled ? var.additional_disk_list : {}
    content {
      disk_size_mib = disk_list.value
    }
  }
  nic_list {
    subnet_uuid = data.nutanix_subnet.subnet.metadata.uuid
    dynamic "ip_endpoint_list" {
      for_each = var.static_ip_enabled ? [var.ip_address[count.index]] : []
      content {
        ip   = var.ip_address[count.index]
        type = "ASSIGNED"
      }
    }
  }
  provisioner "remote-exec" {
    inline = [
      "echo '${var.ssh_password}' | sudo -S sed -i '1 s_$_ ${var.vm_name[count.index]}_' /etc/hosts 2>/dev/null",
      "echo '${var.ssh_password}' | sudo -S hostnamectl set-hostname ${var.vm_name[count.index]}",
    ]
    connection {
      type     = "ssh"
      user     = var.ssh_user
      password = var.ssh_password
      host     = self.nic_list_status.0["ip_endpoint_list"].0["ip"]
    }
  }
}
