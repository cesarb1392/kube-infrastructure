### Setup

K3s cluster is base on [k3s-ansible](https://github.com/k3s-io/k3s-ansible) 

- Install ansible
  `brew install ansible`
- Check servers connectivity
  `ansible all -m ping`
- Set up dependencies
  `ansible-playbook instance_setup.yaml`
- Set up K3S cluster
  `ansible-playbook k3s_cluster_setup.yaml`