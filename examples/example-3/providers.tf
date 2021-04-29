terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "1.2.0"
    }
  }
}

provider "nutanix" {
  username = "XXXX"
  password = "XXXX"
  endpoint = "XX.XX.XX.XX"
  insecure = true
}
