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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ./ingress | n/a |
| <a name="module_loadbalancer"></a> [loadbalancer](#module\_loadbalancer) | ./loadbalancer | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_CF_API_TOKEN"></a> [CF\_API\_TOKEN](#input\_CF\_API\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_CF_DOMAIN"></a> [CF\_DOMAIN](#input\_CF\_DOMAIN) | n/a | `string` | `""` | no |
| <a name="input_CF_EMAIL"></a> [CF\_EMAIL](#input\_CF\_EMAIL) | n/a | `string` | n/a | yes |
| <a name="input_k3s_config"></a> [k3s\_config](#input\_k3s\_config) | The config file used to connect to Kubectl | `string` | `"../ansible/kubeconfig"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_modules_enabled"></a> [modules\_enabled](#output\_modules\_enabled) | n/a |
<!-- END_TF_DOCS -->



