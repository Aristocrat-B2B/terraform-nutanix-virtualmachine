locals {
  projects   = zipmap(data.nutanix_projects.projects.entities.*.name, data.nutanix_projects.projects.entities.*.metadata.uuid)
  project_id = var.project_name != "" ? local.projects[var.project_name] : var.project_id
  project_reference = var.project_name != "" || local.project_id != "" ? {
    kind = "project"
    uuid = local.project_id
  } : {}
  additional_subnets = length(var.additional_nic_subnet_names) > 0 ? { for subnet in var.additional_nic_subnet_names :
    "subnet_${subnet}" => subnet
  } : {}
}

data "nutanix_projects" "projects" {
}

data "nutanix_subnet" "subnet" {
  subnet_name = var.subnet_name
}

data "nutanix_subnet" "additional_subnets" {
  count       = length(var.additional_nic_subnet_names)
  subnet_name = var.additional_nic_subnet_names[count.index]
}

data "nutanix_cluster" "cluster" {
  name = var.nutanix_cluster_name
}

data "nutanix_image" "image_data" {
  image_name = var.image_name
}

resource "nutanix_virtual_machine" "vm-linux" {
  count        = var.os_type == "linux" ? length(var.vm_name) : 0
  name         = var.vm_name[count.index]
  cluster_uuid = data.nutanix_cluster.cluster.metadata.uuid

  num_vcpus_per_socket = var.cpu["num_vcpus_per_socket"]
  num_sockets          = var.cpu["num_sockets"]
  memory_size_mib      = var.vm_memory

  project_reference = local.project_reference

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

  dynamic "nic_list" {
    for_each = length(var.additional_nic_subnet_names) > 0 ? local.additional_subnets : {}
    content {
      subnet_uuid = data.nutanix_subnet.additional_subnets[index(var.additional_nic_subnet_names, nic_list.value)].metadata.uuid
    }
  }

  guest_customization_cloud_init_user_data = base64encode(var.cfn_init_user_data)

  lifecycle {
    ignore_changes = [owner_reference, project_reference]
  }
}

resource "null_resource" "remote-exec-linux" {
  count = var.auto_sethostname && var.os_type == "linux" ? length(var.vm_name) : 0

  triggers = {
    vm = nutanix_virtual_machine.vm-linux[count.index].metadata.spec_hash
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
      host     = nutanix_virtual_machine.vm-linux[count.index].nic_list_status.0["ip_endpoint_list"].0["ip"]
    }
  }
}

resource "nutanix_virtual_machine" "vm-windows" {
  count        = var.os_type == "windows" ? length(var.vm_name) : 0
  name         = var.vm_name[count.index]
  cluster_uuid = data.nutanix_cluster.cluster.metadata.uuid

  num_vcpus_per_socket = var.cpu["num_vcpus_per_socket"]
  num_sockets          = var.cpu["num_sockets"]
  memory_size_mib      = var.vm_memory

  project_reference = {
    kind = "project"
    uuid = local.project_id
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

  dynamic "nic_list" {
    for_each = length(var.additional_nic_subnet_names) > 0 ? local.additional_subnets : {}
    content {
      subnet_uuid = data.nutanix_subnet.additional_subnets[index(var.additional_nic_subnet_names, nic_list.value)].metadata.uuid
    }
  }

  guest_customization_sysprep = var.sysprep_user_data
}
