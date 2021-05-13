output "nic_list" {
  description = "List of nic statuses"
  value       = coalescelist(nutanix_virtual_machine.vm-linux[*].nic_list_status, nutanix_virtual_machine.vm-windows[*].nic_list_status)
}
