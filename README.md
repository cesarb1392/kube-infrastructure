# kube-terraforming

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


