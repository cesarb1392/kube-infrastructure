# kube-terraforming

## todo

- Automate ansible with local-provisioner
- improve variables
- improve tags / labels
- container registry
- pipelines (github self hosted runner)
- [ssd issues](https://www.reddit.com/r/debian/comments/k2gzy4/ext4fs_failed_to_convert_unwritten_extents_to/)

#### Table of Contents

1. [Usage](#usage)
2. [Requirements](#requirements)
3. [Providers](#Providers)
4. [Inputs](#inputs)
5. [Outputs](#outputs)

## Usage

### Env vars
- Create and populate the file `terraform.tfvars` on the root project dir

To set up state, run:
```
terraform init -backend-config="access_key=$ACCESS_TOKEN" -backend-config="secret_key=$SECRET_KEY"
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.5.0, < 2.0.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 3.24.0 |
| <a name="requirement_curl"></a> [curl](#requirement\_curl) | >= 1.0.2 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.5.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.16.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.35.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_github_runner"></a> [github\_runner](#module\_github\_runner) | ./github_runner | n/a |
| <a name="module_loadtest"></a> [loadtest](#module\_loadtest) | ./load_test | n/a |
| <a name="module_metallb"></a> [metallb](#module\_metallb) | ./metallb | n/a |
| <a name="module_minio"></a> [minio](#module\_minio) | ./minio | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./monitoring | n/a |
| <a name="module_picamera"></a> [picamera](#module\_picamera) | ./picamera | n/a |
| <a name="module_pihole"></a> [pihole](#module\_pihole) | ./pihole | n/a |
| <a name="module_private_ingress"></a> [private\_ingress](#module\_private\_ingress) | ./private_ingress | n/a |
| <a name="module_public_ingress"></a> [public\_ingress](#module\_public\_ingress) | ./public_ingress | n/a |
| <a name="module_torrente"></a> [torrente](#module\_torrente) | ./torrente | n/a |
| <a name="module_vaultwarden"></a> [vaultwarden](#module\_vaultwarden) | ./vaultwarden | n/a |
| <a name="module_website"></a> [website](#module\_website) | ./website | n/a |
| <a name="module_wireguard"></a> [wireguard](#module\_wireguard) | ./wireguard | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_limit_range.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/limit_range) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_persistent_volume_claim.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CF_ACCESS_EMAIL_LIST"></a> [CF\_ACCESS\_EMAIL\_LIST](#input\_CF\_ACCESS\_EMAIL\_LIST) | n/a | `list(string)` | n/a | yes |
| <a name="input_CF_ACCOUNT_ID"></a> [CF\_ACCOUNT\_ID](#input\_CF\_ACCOUNT\_ID) | n/a | `string` | n/a | yes |
| <a name="input_CF_API_TOKEN"></a> [CF\_API\_TOKEN](#input\_CF\_API\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_CF_ZONE_ID"></a> [CF\_ZONE\_ID](#input\_CF\_ZONE\_ID) | n/a | `string` | n/a | yes |
| <a name="input_CF_ZONE_NAME"></a> [CF\_ZONE\_NAME](#input\_CF\_ZONE\_NAME) | n/a | `string` | n/a | yes |
| <a name="input_GH_ACCESS_TOKEN"></a> [GH\_ACCESS\_TOKEN](#input\_GH\_ACCESS\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_KUBECONFIG"></a> [KUBECONFIG](#input\_KUBECONFIG) | n/a | `string` | n/a | yes |
| <a name="input_MINIO_ROOT_PASSWORD"></a> [MINIO\_ROOT\_PASSWORD](#input\_MINIO\_ROOT\_PASSWORD) | n/a | `string` | n/a | yes |
| <a name="input_MINIO_ROOT_USER"></a> [MINIO\_ROOT\_USER](#input\_MINIO\_ROOT\_USER) | n/a | `string` | n/a | yes |
| <a name="input_MINIO_USERS"></a> [MINIO\_USERS](#input\_MINIO\_USERS) | n/a | <pre>list(<br/>    object({<br/>      accessKey = string<br/>      secretKey = string<br/>      policy    = string<br/>  }))</pre> | n/a | yes |
| <a name="input_NORD_TOKEN"></a> [NORD\_TOKEN](#input\_NORD\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_PASS"></a> [PASS](#input\_PASS) | n/a | `string` | n/a | yes |
| <a name="input_PGID"></a> [PGID](#input\_PGID) | n/a | `string` | n/a | yes |
| <a name="input_PI_HOLE_PASS"></a> [PI\_HOLE\_PASS](#input\_PI\_HOLE\_PASS) | n/a | `string` | n/a | yes |
| <a name="input_PUBLIC_IP"></a> [PUBLIC\_IP](#input\_PUBLIC\_IP) | n/a | `string` | n/a | yes |
| <a name="input_PUID"></a> [PUID](#input\_PUID) | n/a | `string` | n/a | yes |
| <a name="input_TZ"></a> [TZ](#input\_TZ) | n/a | `string` | n/a | yes |
| <a name="input_USER"></a> [USER](#input\_USER) | n/a | `string` | n/a | yes |
| <a name="input_VAULTWARDEN_ADMIN_TOKEN"></a> [VAULTWARDEN\_ADMIN\_TOKEN](#input\_VAULTWARDEN\_ADMIN\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_WG_PASSWORD"></a> [WG\_PASSWORD](#input\_WG\_PASSWORD) | n/a | `string` | n/a | yes |
| <a name="input_WG_PRIVATE_KEY"></a> [WG\_PRIVATE\_KEY](#input\_WG\_PRIVATE\_KEY) | n/a | `string` | n/a | yes |
| <a name="input_WG_USER"></a> [WG\_USER](#input\_WG\_USER) | n/a | `string` | n/a | yes |
| <a name="input_vpn_country"></a> [vpn\_country](#input\_vpn\_country) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_modules_enabled"></a> [modules\_enabled](#output\_modules\_enabled) | n/a |
<!-- END_TF_DOCS -->



