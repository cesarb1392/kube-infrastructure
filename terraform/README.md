# kube-terraforming

## todo

- When installing from scratch Traefik CRD are not defined, therefore TF operations failed 
- improve variables
- improve tags / labels
- container registry
- pipelines (github self hosted runner)
- [CF Argo Tunnel](https://github.com/cloudflare/argo-tunnel-examples/tree/master/named-tunnel-k8s) 

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 3.24.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.5.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ./public_ingress | n/a |
| <a name="module_metallb"></a> [metallb](#module\_metallb) | ./metallb | n/a |
| <a name="module_minio"></a> [minio](#module\_minio) | ./minio | n/a |
| <a name="module_pihole"></a> [pihole](#module\_pihole) | ./pihole | n/a |
| <a name="module_private_ingress"></a> [private\_ingress](#module\_private\_ingress) | ./private_ingress | n/a |
| <a name="module_website"></a> [website](#module\_website) | ./website | n/a |
| <a name="module_wireguard"></a> [wireguard](#module\_wireguard) | ./wireguard | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CF_ACCOUNT_ID"></a> [CF\_ACCOUNT\_ID](#input\_CF\_ACCOUNT\_ID) | n/a | `string` | n/a | yes |
| <a name="input_CF_API_TOKEN"></a> [CF\_API\_TOKEN](#input\_CF\_API\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_CF_ZONE_ID"></a> [CF\_ZONE\_ID](#input\_CF\_ZONE\_ID) | n/a | `string` | n/a | yes |
| <a name="input_CF_ZONE_NAME"></a> [CF\_ZONE\_NAME](#input\_CF\_ZONE\_NAME) | n/a | `string` | n/a | yes |
| <a name="input_KUBECONFIG"></a> [KUBECONFIG](#input\_KUBECONFIG) | n/a | `string` | n/a | yes |
| <a name="input_MINIO_ROOT_PASSWORD"></a> [MINIO\_ROOT\_PASSWORD](#input\_MINIO\_ROOT\_PASSWORD) | n/a | `string` | n/a | yes |
| <a name="input_MINIO_ROOT_USER"></a> [MINIO\_ROOT\_USER](#input\_MINIO\_ROOT\_USER) | n/a | `string` | n/a | yes |
| <a name="input_MINIO_USERS"></a> [MINIO\_USERS](#input\_MINIO\_USERS) | n/a | <pre>list(<br>    object({<br>      accessKey = string<br>      secretKey = string<br>      policy    = string<br>  }))</pre> | n/a | yes |
| <a name="input_PI_HOLE_PASS"></a> [PI\_HOLE\_PASS](#input\_PI\_HOLE\_PASS) | n/a | `string` | n/a | yes |
| <a name="input_TZ"></a> [TZ](#input\_TZ) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_modules_enabled"></a> [modules\_enabled](#output\_modules\_enabled) | n/a |
<!-- END_TF_DOCS -->



