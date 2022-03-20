# kube-terraforming

## todo
- add tags / labels

#### Table of Contents
1. [Usage](#usage)
2. [Requirements](#requirements)
3. [Providers](#Providers)
4. [Inputs](#inputs)
5. [Outputs](#outputs)

## Usage

- Main node
```shell
export K3S_KUBECONFIG_MODE="644" && export INSTALL_K3S_EXEC=" --no-deploy servicelb --no-deploy traefik" && curl -sfL https://get.k3s.io | sh -
sudo cat /var/lib/rancher/k3s/server/node-token
```

- Assistant node
```shell
export K3S_KUBECONFIG_MODE="644" && export K3S_URL="https://192.168.x.x:6443" && export K3S_TOKEN="" && curl -sfL https://get.k3s.io | sh -
```

- Grab the config file from the main node

```shell
kubectl label nodes <name> kubernetes.io/role=worker
kubectl label nodes <name> kubernetes.io/role=worker
```

```dotenv
TF_VAR_K3S_CF_EMAIL=""
TF_VAR_K3S_CF_API_KEY=""
TF_VAR_K3S_GRAFANA_USER=""
TF_VAR_K3S_GRAFANA_PASSWORD=""
TF_VAR_K3S_CF_DOMAIN=""
```



<!-- BEGIN_TF_DOCS -->
 ## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ./ingress | n/a |
| <a name="module_loadbalancer"></a> [loadbalancer](#module\_loadbalancer) | ./loadbalancer | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./monitoring | n/a |
| <a name="module_nginx"></a> [nginx](#module\_nginx) | ./nginx | n/a |
| <a name="module_portfolio"></a> [portfolio](#module\_portfolio) | ./portfolio | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_K3S_CF_API_KEY"></a> [K3S\_CF\_API\_KEY](#input\_K3S\_CF\_API\_KEY) | n/a | `string` | n/a | yes |
| <a name="input_K3S_CF_DOMAIN"></a> [K3S\_CF\_DOMAIN](#input\_K3S\_CF\_DOMAIN) | n/a | `string` | n/a | yes |
| <a name="input_K3S_CF_EMAIL"></a> [K3S\_CF\_EMAIL](#input\_K3S\_CF\_EMAIL) | n/a | `string` | n/a | yes |
| <a name="input_K3S_GRAFANA_PASSWORD"></a> [K3S\_GRAFANA\_PASSWORD](#input\_K3S\_GRAFANA\_PASSWORD) | The password to connect to Grafana UI. | `string` | n/a | yes |
| <a name="input_K3S_GRAFANA_USER"></a> [K3S\_GRAFANA\_USER](#input\_K3S\_GRAFANA\_USER) | The username to connect to Grafana UI. | `string` | n/a | yes |
| <a name="input_K3S_TRAEFIK_DASHBOARD"></a> [K3S\_TRAEFIK\_DASHBOARD](#input\_K3S\_TRAEFIK\_DASHBOARD) | n/a | `string` | n/a | yes |
| <a name="input_k3s_config"></a> [k3s\_config](#input\_k3s\_config) | The config file used to connect to Kubectl | `string` | `"~/.kube/config_k3s"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->  
