# kube-terraforming

## todo

- set helm charts versions!!! 
- install cert manager
- move secrets and policies from type resource to data
- improve variables
- move to input vars traefik.ymal config
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.2 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 3.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_container_registry"></a> [container\_registry](#module\_container\_registry) | ./container_registry | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | ./dns | n/a |
| <a name="module_file_manager"></a> [file\_manager](#module\_file\_manager) | ./file_manager | n/a |
| <a name="module_ingress"></a> [ingress](#module\_ingress) | ./ingress | n/a |
| <a name="module_loadbalancer"></a> [loadbalancer](#module\_loadbalancer) | ./loadbalancer | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./monitoring | n/a |
| <a name="module_nfs"></a> [nfs](#module\_nfs) | ./nfs | n/a |
| <a name="module_nginx"></a> [nginx](#module\_nginx) | ./nginx | n/a |
| <a name="module_pi_hole"></a> [pi\_hole](#module\_pi\_hole) | ./pi_hole | n/a |
| <a name="module_portfolio"></a> [portfolio](#module\_portfolio) | ./portfolio | n/a |
| <a name="module_torrente"></a> [torrente](#module\_torrente) | ./torrente | n/a |
| <a name="module_wireguard"></a> [wireguard](#module\_wireguard) | ./wire_guard | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.this](https://registry.terraform.io/providers/hashicorp/kubernetes/2.8.0/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_K3S_CF_ACCOUNT_ID"></a> [K3S\_CF\_ACCOUNT\_ID](#input\_K3S\_CF\_ACCOUNT\_ID) | n/a | `string` | n/a | yes |
| <a name="input_K3S_CF_API_KEY"></a> [K3S\_CF\_API\_KEY](#input\_K3S\_CF\_API\_KEY) | n/a | `string` | n/a | yes |
| <a name="input_K3S_CF_DOMAIN"></a> [K3S\_CF\_DOMAIN](#input\_K3S\_CF\_DOMAIN) | n/a | `string` | `""` | no |
| <a name="input_K3S_CF_EMAIL"></a> [K3S\_CF\_EMAIL](#input\_K3S\_CF\_EMAIL) | n/a | `string` | n/a | yes |
| <a name="input_K3S_CF_ZONE_ID"></a> [K3S\_CF\_ZONE\_ID](#input\_K3S\_CF\_ZONE\_ID) | n/a | `string` | n/a | yes |
| <a name="input_K3S_GRAFANA_PASSWORD"></a> [K3S\_GRAFANA\_PASSWORD](#input\_K3S\_GRAFANA\_PASSWORD) | The password to connect to Grafana UI. | `string` | `""` | no |
| <a name="input_K3S_GRAFANA_USER"></a> [K3S\_GRAFANA\_USER](#input\_K3S\_GRAFANA\_USER) | The username to connect to Grafana UI. | `string` | `""` | no |
| <a name="input_K3S_OPENVPN_PASSWORD"></a> [K3S\_OPENVPN\_PASSWORD](#input\_K3S\_OPENVPN\_PASSWORD) | The username to connect to Grafana UI. | `string` | `""` | no |
| <a name="input_K3S_OPENVPN_USERNAME"></a> [K3S\_OPENVPN\_USERNAME](#input\_K3S\_OPENVPN\_USERNAME) | The username to connect to Grafana UI. | `string` | `""` | no |
| <a name="input_K3S_PIHOLE_PASSWORD"></a> [K3S\_PIHOLE\_PASSWORD](#input\_K3S\_PIHOLE\_PASSWORD) | n/a | `string` | `""` | no |
| <a name="input_K3S_TRAEFIK_DASHBOARD"></a> [K3S\_TRAEFIK\_DASHBOARD](#input\_K3S\_TRAEFIK\_DASHBOARD) | n/a | `string` | `""` | no |
| <a name="input_k3s_config"></a> [k3s\_config](#input\_k3s\_config) | The config file used to connect to Kubectl | `string` | `"~/.kube/config_k3s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_modules_enabled"></a> [modules\_enabled](#output\_modules\_enabled) | n/a |
<!-- END_TF_DOCS -->

## ufw rules

- [master node](https://kubernetes.io/docs/reference/ports-and-protocols/#node) 
- [worker node](https://kubernetes.io/docs/reference/ports-and-protocols/#node)  



