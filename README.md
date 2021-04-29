# terraform-nutanix-virtualmachine

A terraform module to create a managed Kubernetes cluster on Nutanix. Available
through the [Terraform registry](https://registry.terraform.io/modules/terraform-nutanix-virtualmachine).

## Usage example

A full example leveraging other community modules is contained in the [examples/](https://github.com/Aristocrat-B2B/terraform-nutanix-virtualmachine/tree/master/examples/).

```hcl

terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "1.2.0"
    }
  }
}

provider "nutanix" {
  username = "admin"
  password = "ItsASecret!"
  endpoint = "10.0.0.10" # prism endpoint
  insecure = true
}

module "vm_create" {
  source  = "terraform-nutanix-virtualmachine"
  version = "1.0.0"

  subnet_name          = "Primary"
  nutanix_cluster_name = "PHX-POC236"
  vm_name              = ["terraform-vm-module-test"]
  vm_memory            = 4096
  cpu = {
    "num_vcpus_per_socket" : 2,
    "num_sockets" : 2
  }
  additinal_disk_enabled = true
  additional_disk_list = {
    disk1 = 10240,
    disk2 = 16000
  }
  image_name = "debian-elasticsearch-7.12.qcow2"

  static_ip_enabled = false
  ip_address        = []
  project_id        = "abcde-12345"
  ssh_user = "admin"
  ssh_password = "ItsASecret!"
}

```
## Conditional creation

Sometimes you need to have a way to create resources conditionally but Terraform does not allow to use `count` inside `module` block, so the solution is to specify an empty list to the argument `vm_name`.


```hcl

# This cluster will not be created
module "vm_create" {
  source  = "terraform-nutanix-virtualmachine"
  version = "1.0.0"

create_virtualmachine = false
  subnet_name          = "Primary"
  nutanix_cluster_name = "PHX-POC236"
  vm_name              = []
  vm_memory            = 4096
  cpu = {
    "num_vcpus_per_socket" : 2,
    "num_sockets" : 2
  }
  additinal_disk_enabled = true
  additional_disk_list = {
    disk1 = 10240,
    disk2 = 16000
  }
  image_name = "debian-elasticsearch-7.12.qcow2"

  static_ip_enabled = false
  ip_address        = []
  project_id        = "abcde-12345"
  ssh_user = "admin"
  ssh_password = "ItsASecret!"
}

```

## Contributing

Report issues/questions/feature requests on in the [issues](https://github.com/Aristocrat-B2B/terraform-nutanix-virtualmachine/issues/new) section.

Full contributing [guidelines are covered here](https://github.com/Aristocrat-B2B/terraform-nutanix-virtualmachine/blob/master/.github/CONTRIBUTING.md).

## Change log

- The [changelog](https://github.com/Aristocrat-B2B/terraform-nutanix-virtualmachine/tree/master/CHANGELOG.md) captures all important release notes from v1.0.0

## Authors

- Created by [B2B Devops - Aristocrat](https://github.com/Aristocrat-B2B)
- Maintained by [B2B Devops - Aristocrat](https://github.com/Aristocrat-B2B)

## License

MIT Licensed. See [LICENSE](https://github.com/Aristocrat-B2B/terraform-nutanix-virtualmachine/tree/master/LICENSE) for full details.
