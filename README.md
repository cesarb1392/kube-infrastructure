# kube-terraforming

## todo

- set helm charts versions!!! 
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
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 3.7 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |
| <a name="requirement_pihole"></a> [pihole](#requirement\_pihole) | >= 0.0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_container_registry"></a> [container\_registry](#module\_container\_registry) | ./container_registry | n/a |
| <a name="module_continuous_deployment"></a> [continuous\_deployment](#module\_continuous\_deployment) | ./continuous_deployment | n/a |
| <a name="module_dns"></a> [dns](#module\_dns) | ./dns | n/a |
| <a name="module_file_manager"></a> [file\_manager](#module\_file\_manager) | ./file_manager | n/a |
| <a name="module_github_runner"></a> [github\_runner](#module\_github\_runner) | ./github_runner | n/a |
| <a name="module_house_searching_notifier"></a> [house\_searching\_notifier](#module\_house\_searching\_notifier) | ./house_searching_notifier | n/a |
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
| <a name="input_ACCESS_TOKEN"></a> [ACCESS\_TOKEN](#input\_ACCESS\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_CLIENT_ID"></a> [CLIENT\_ID](#input\_CLIENT\_ID) | n/a | `string` | n/a | yes |
| <a name="input_CLIENT_SECRET"></a> [CLIENT\_SECRET](#input\_CLIENT\_SECRET) | n/a | `string` | n/a | yes |
| <a name="input_EMAIL_FROM"></a> [EMAIL\_FROM](#input\_EMAIL\_FROM) | n/a | `string` | n/a | yes |
| <a name="input_EMAIL_TO"></a> [EMAIL\_TO](#input\_EMAIL\_TO) | n/a | `string` | n/a | yes |
| <a name="input_CF_API_TOKEN"></a> [K3S\_CF\_API\_TOKEN](#input\_K3S\_CF\_API\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_CF_DOMAIN"></a> [K3S\_CF\_DOMAIN](#input\_K3S\_CF\_DOMAIN) | n/a | `string` | `""` | no |
| <a name="input_CF_EMAIL"></a> [K3S\_CF\_EMAIL](#input\_K3S\_CF\_EMAIL) | n/a | `string` | n/a | yes |
| <a name="input_GRAFANA_PASSWORD"></a> [K3S\_GRAFANA\_PASSWORD](#input\_K3S\_GRAFANA\_PASSWORD) | The password to connect to Grafana UI. | `string` | `""` | no |
| <a name="input_GRAFANA_USER"></a> [K3S\_GRAFANA\_USER](#input\_K3S\_GRAFANA\_USER) | The username to connect to Grafana UI. | `string` | `""` | no |
| <a name="input_OPENVPN_PASSWORD"></a> [K3S\_OPENVPN\_PASSWORD](#input\_K3S\_OPENVPN\_PASSWORD) | The username to connect to Grafana UI. | `string` | `""` | no |
| <a name="input_OPENVPN_USERNAME"></a> [K3S\_OPENVPN\_USERNAME](#input\_K3S\_OPENVPN\_USERNAME) | The username to connect to Grafana UI. | `string` | `""` | no |
| <a name="input_PIHOLE_PASSWORD"></a> [K3S\_PIHOLE\_PASSWORD](#input\_K3S\_PIHOLE\_PASSWORD) | n/a | `string` | `""` | no |
| <a name="input_TRAEFIK_DASHBOARD"></a> [K3S\_TRAEFIK\_DASHBOARD](#input\_K3S\_TRAEFIK\_DASHBOARD) | n/a | `string` | `""` | no |
| <a name="input_REFRESH_TOKEN"></a> [REFRESH\_TOKEN](#input\_REFRESH\_TOKEN) | n/a | `string` | n/a | yes |
| <a name="input_REPO_URL"></a> [REPO\_URL](#input\_REPO\_URL) | n/a | `string` | n/a | yes |
| <a name="input_RUNNER_NAME"></a> [RUNNER\_NAME](#input\_RUNNER\_NAME) | n/a | `string` | n/a | yes |
| <a name="input_RUNNER_WORKDIR"></a> [RUNNER\_WORKDIR](#input\_RUNNER\_WORKDIR) | n/a | `string` | n/a | yes |
| <a name="input_SCRAPE_URL_BUY"></a> [SCRAPE\_URL\_BUY](#input\_SCRAPE\_URL\_BUY) | n/a | `string` | n/a | yes |
| <a name="input_SCRAPE_URL_RENT"></a> [SCRAPE\_URL\_RENT](#input\_SCRAPE\_URL\_RENT) | n/a | `string` | n/a | yes |
| <a name="input_k3s_config"></a> [k3s\_config](#input\_k3s\_config) | The config file used to connect to Kubectl | `string` | `"~/.kube/config_k3s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_modules_enabled"></a> [modules\_enabled](#output\_modules\_enabled) | n/a |
<!-- END_TF_DOCS -->

## ufw rules

- [master node](https://kubernetes.io/docs/reference/ports-and-protocols/#node) 
- [worker node](https://kubernetes.io/docs/reference/ports-and-protocols/#node)  



