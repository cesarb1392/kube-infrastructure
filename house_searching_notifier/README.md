<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| kubernetes | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_deployment.house_searching_notifier](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_secret.env_vars](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| CLIENT\_ID | n/a | `string` | n/a | yes |
| CLIENT\_SECRET | n/a | `string` | n/a | yes |
| EMAIL\_FROM | n/a | `string` | n/a | yes |
| EMAIL\_TO | n/a | `string` | n/a | yes |
| REFRESH\_TOKEN | n/a | `string` | n/a | yes |
| SCRAPE\_URL\_BUY | n/a | `string` | n/a | yes |
| SCRAPE\_URL\_RENT | n/a | `string` | n/a | yes |
| namespace | The namespace where is installed | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->