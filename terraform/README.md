# kube-terraforming

## todo

- When installing from scratch Traefik CRD are not defined, therefore TF operations failed 
- improve variables
- improve tags / labels
- container registry
- pipelines (github self hosted runner)

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
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager"></a> [cert\_manager](#module\_cert\_manager) | ./cert_manager | n/a |
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ./ingress | n/a |
| <a name="module_loadbalancer"></a> [loadbalancer](#module\_loadbalancer) | ./loadbalancer | n/a |
| <a name="module_nginx"></a> [nginx](#module\_nginx) | ./nginx | n/a |
| <a name="module_portfolio"></a> [portfolio](#module\_portfolio) | ./portfolio | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CF_API_TOKEN"></a> [CF\_API\_TOKEN](#input\_CF\_API\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_KUBECONFIG"></a> [KUBECONFIG](#input\_KUBECONFIG) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_modules_enabled"></a> [modules\_enabled](#output\_modules\_enabled) | n/a |
<!-- END_TF_DOCS -->



