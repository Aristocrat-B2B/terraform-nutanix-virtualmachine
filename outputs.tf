output "nic_list" {
  description = "List of nic statuses"
  value       = coalescelist(nutanix_virtual_machine.vm-linux[*].nic_list_status, nutanix_virtual_machine.vm-windows[*].nic_list_status)
}

output "project_id" {
  description = "project_id generated by looking up var.project_name"
  value       = local.project_id
}

output "host_inventory" {
  description = "Map of host and IPs"
  value       = zipmap(var.vm_name, coalescelist([for ip in nutanix_virtual_machine.vm-linux[*].nic_list_status : ip.0["ip_endpoint_list"].0["ip"]], [for ip in nutanix_virtual_machine.vm-windows[*].nic_list_status : ip.0["ip_endpoint_list"].0["ip"]]))
}

output "vms" {
  description = "List of VMs"
  value       = var.vm_name
}

output "creation_time" {
  description = "Creation time of VM"
  value       = join(",", coalescelist(nutanix_virtual_machine.vm-linux[*].metadata.creation_time, nutanix_virtual_machine.vm-windows[*].metadata.creation_time))
}
