### Setup

K3s cluster is base on [k3s-ansible](https://github.com/k3s-io/k3s-ansible) 

- Install ansible
  `brew install ansible`
- Check servers connectivity
  `ansible all -m ping`
- Set up node dependencies
  `ansible-playbook node_setup.yaml`
  `ansible-playbook node_ufw_rules.yaml`
- Set up K3S cluster
  `ansible-playbook cluster_setup.yaml`
- Delete K3S cluster
  `ansible-playbook cluster_destroy.yaml`