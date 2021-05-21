terraform {
  required_version = ">= 0.12"

  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = ">= 1.2.0"
    }
  }
}
