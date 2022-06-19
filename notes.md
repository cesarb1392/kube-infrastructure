# notes


- `<serviceName>.<namespaceName>.svc.cluster.local`
```
 kubectl logs monitoring-prometheus-server-66b6b5897f-jt56w -c prometheus-server -n monitoring --follow
 kubectl patch pvc monitoring-prometheus-volume-claim -n monitoring -p '{"metadata":{"finalizers": []}}' --type=merge
 kubectl delete pods <pod_name> --grace-period=0 --force -n <namespace>
```
