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

- Main node

```shell
export KUBECONFIG_MODE="644" && export INSTALL_EXEC=" --no-deploy servicelb --no-deploy traefik" && curl -sfL https://get.k3s.io | sh -
sudo cat /var/lib/rancher/k3s/server/node-token
```

- Assistant node

```shell
export KUBECONFIG_MODE="644" && export URL="https://192.168.x.x:6443" && export TOKEN="" && curl -sfL https://get.k3s.io | sh -
```

- Grab the config file from the main node

```shell
kubectl label nodes <name> kubernetes.io/role=worker
```

### Env vars
- Create and populate the file `terraform.tfvars` on the root project dir

### How to update the docs?
>  `for d in ./*/ ; do (cd "$d" && tcl); done`

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
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | 3.25.0 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.14.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ./ingress | n/a |
| <a name="module_loadbalancer"></a> [loadbalancer](#module\_loadbalancer) | ./loadbalancer | n/a |
| <a name="module_nginx"></a> [nginx](#module\_nginx) | ./nginx | n/a |

## Resources

| Name | Type |
|------|------|
| [cloudflare_argo_tunnel.access_tunnel](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/argo_tunnel) | resource |
| [cloudflare_record.access_tunnel](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/record) | resource |
| [kubectl_manifest.cloudflare_tunnel_config_traefik](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_config_map_v1.cloudflare_tunnel_config_traefik](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_deployment_v1.cloudflared_traefik](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment_v1) | resource |
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret_v1.tunnel_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [random_id.argo_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CF_ACCOUNT_ID"></a> [CF\_ACCOUNT\_ID](#input\_CF\_ACCOUNT\_ID) | n/a | `string` | n/a | yes |
| <a name="input_CF_API_TOKEN"></a> [CF\_API\_TOKEN](#input\_CF\_API\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_CF_ZONE_ID"></a> [CF\_ZONE\_ID](#input\_CF\_ZONE\_ID) | n/a | `string` | n/a | yes |
| <a name="input_KUBECONFIG"></a> [KUBECONFIG](#input\_KUBECONFIG) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_modules_enabled"></a> [modules\_enabled](#output\_modules\_enabled) | n/a |
<!-- END_TF_DOCS -->



