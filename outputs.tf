output "nic_list" {
  description = "List of nic statuses"
  value       = nutanix_virtual_machine.vm[*].nic_list_status
}
