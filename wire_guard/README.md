<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| helm | n/a |
| template | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.wireguard](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [template_file.wireguard_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| namespace | The namespace where is installed | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->