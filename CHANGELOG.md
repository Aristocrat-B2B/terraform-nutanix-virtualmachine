# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

<a name="v2.0.0"></a>
## [v2.0.0] - 2023-05-19
Changed
- Deleted outputs:
  - `creation_time` - moved these data to `host_inventory`
  - `vms` - it is meaningless as it contained `var.vm_name`
  - `nic_list` - its content can be obtained from `host_inventory`
- Changed outputs:
  - `host_inventory` - changed structure to
```
{
  host_name = {
    ip = 1.2.3.4
    id = "vm id"
  }
  ...
}
```

<a name="v1.0.9"></a>
## [v1.0.9] - 2021-09-06

Changed
- Added trigger to force hostname re-run

<a name="v1.0.8"></a>
## [v1.0.8] - 2021-09-20

Added

- Now supports additional optional network interfaces

<a name="v1.0.7"></a>
## [v1.0.7] - 2021-09-06

Added
- Now supports additional optional network interfaces


<a name="v1.0.6"></a>
## [v1.0.6] - 2021-06-17

Fixed
-  Output "host_inventory" caters windows resources too

<a name="v1.0.5"></a>
## [v1.0.5] - 2021-05-29

Added
-  Support for vm_name output

<a name="v1.0.4"></a>
## [v1.0.4] - 2021-05-28

Added
-  Output to create a map of hostnames(keys) and IPs(values)

<a name="v1.0.3"></a>
## [v1.0.3] - 2021-05-25

Changed
- can now pass in 'project_name' and it will automatically lookup 'project_id' for you

<a name="v1.0.2"></a>
## [v1.0.2] - 2021-05-24

Changed
- product_reference map is now optional.

<a name="v1.0.1"></a>
## [v1.0.1] - 2021-05-13

Added
- Support for cloud_init
- Support for sysprep
- Added additional example showing cloud_init


<a name="v1.0.0"></a>
## [v1.0.0] - 2021-04-28

Added
- Initial version of virtualmachine module

[Unreleased]: https://github.com/Aristocrat-B2B/terraform-nutanix-virtualmachine/compare/v1.0.0...HEAD
