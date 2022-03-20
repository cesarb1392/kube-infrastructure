# kube-terraforming


export K3S_KUBECONFIG_MODE="644" && export INSTALL_K3S_EXEC=" --no-deploy servicelb --no-deploy traefik" && curl -sfL https://get.k3s.io | sh -

sudo cat /var/lib/rancher/k3s/server/node-token

export K3S_KUBECONFIG_MODE="644" && export K3S_URL="https://192.168.2.10:6443" && export K3S_TOKEN="K1064808b1b312c41b71014729cf99d3a86e6d85e273fc55b36087dc7e85473f22b::server:8545ab94af2a1292424416407e946689" && curl -sfL https://get.k3s.io | sh -

kubectl label nodes slowbanana kubernetes.io/role=worker
kubectl label nodes fastbanana2 kubernetes.io/role=worker
kubectl label nodes fastbanana1 kubernetes.io/role=master


