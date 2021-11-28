![Platforms](https://img.shields.io/badge/%20Platforms-Windows%20/%20Linux-blue.svg?style=flat-square")
[![License](https://img.shields.io/badge/%20Licence-MIT-green.svg?style=flat-square)](LICENSE.md)
[![Code Of Conduct](https://img.shields.io/badge/Community-Code%20of%20Conduct-orange.svg?style=flat-squre)](CODE_OF_CONDUCT.md)
[![Support](https://img.shields.io/badge/Community-Support-red.svg?style=flat-square)](SUPPORT.md)
[![Contributing](https://img.shields.io/badge/%20Community-Contribution-yellow.svg?style=flat-square)](CONTRIBUTING.md)

<hr>

# Terraform Hetzner Cloud Kubernetes Module

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v1.4%20adopted-ff69b4.svg)](CODE_OF_CONDUCT.md)

Provisioning Kubernetes Stack On Hetzner Cloud.

## Requirements

| Name | Version |
| ---- | ------- |
| [Terraform](https://www.terraform.io/downloads.html) |  > = 1.0.11 |

Machine at least 3 with minum as kubernetes requirements refer to
kubernetes [docs](https://kubernetes.io/docs/setup/production-environment)

## Getting Started

There are `demo` for current provisioning kubernetes cluster on Hetzner Cloud [here](https://github.com/bayudwiyansatria/terraform-hcloud)

### Usage

```shell
module "kubernetes" {
  source                    = "bayudwiyansatria/kubernetes/hcloud"
  cluster_admin_ssh_keys    = file("~/.ssh/id_rsa.pub")
  cluster_name              = "bayudwiyansatria"
  hcloud_token              = var.hcloud_token
  cluster_admin_ssh_access  = file("~/.ssh/id_rsa")
}
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

Looking to contribute to our code but need some help? There's a few ways to get information:

* Connect with us on [Twitter](https://twitter.com/bayudsatria)
* Like us on [Facebook](https://facebook.com/PBayuDSatria)
* Follow us on [LinkedIn](https://linkedin.com/in/bayudwiyansatria)
* Subscribe us on [Youtube](https://youtube.com/channel/UCihxWj1rtheK73mGdrf0OiA)
* Log an issue here on github

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see
the [tags on this repository](https://github.com/bayudwiyansatria/Development-And-Operations/tags).

## Authors

- [Bayu Dwiyan Satria](https://github.com/bayudwiyansatria)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

<p> Copyright &copy; 2021. All Rights Reserved.

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
