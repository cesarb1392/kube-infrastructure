kube-infrastructure
kube-infrastructure is a set of Kubernetes manifests and configuration files that can be used to deploy and manage infrastructure services on a Kubernetes cluster.

Installation
To install kube-infrastructure on your Kubernetes cluster, you can use the following command:

bash
Copy code
kubectl apply -f https://raw.githubusercontent.com/cesarb1392/kube-infrastructure/main/kubernetes/infrastructure.yaml
This command will deploy all the infrastructure services defined in the infrastructure.yaml file to your cluster.

Configuration
kube-infrastructure includes several configuration files that can be used to customize the behavior of the different infrastructure services.

To configure a specific service, you can modify the corresponding configuration file and then apply the changes to your cluster using the following command:

php
Copy code
kubectl apply -f <service_config_file>
Services
kube-infrastructure includes the following infrastructure services:

nginx-ingress: a Kubernetes Ingress controller based on the NGINX open source project.
cert-manager: a Kubernetes add-on to automate the management and issuance of TLS certificates from various issuing sources.
external-dns: a Kubernetes add-on to manage external DNS records for Kubernetes services.
prometheus: a monitoring system and time series database.
grafana: a dashboard and visualization platform for data from various sources.
For more information about each service, refer to the corresponding documentation in the docs folder.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->