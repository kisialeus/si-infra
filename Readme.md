# Steps for Deploying and Managing Infrastructure with Terraform and ArgoCD

## 1. Apply Terraform Configuration

To deploy the specific modules using Terraform, run the following commands:

```bash
terraform apply -target=module.vpc
terraform apply -target=module.ecr
terraform apply -target=module.eks
terraform apply -target=module.cluster_addons
terraform apply -target=module.argocd-app
```
Get kubeconfig
```bash
aws eks --region eu-central-1 update-kubeconfig --name si-hometask-cluster  
```





after updating we need to patch argocd cm to enable ssl termination on LB

```bash
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  annotations: {}
  labels:
    app.kubernetes.io/name: argocd-cmd-params-cm
    app.kubernetes.io/part-of: argocd
  name: argocd-cmd-params-cm
  namespace: argocd
data:
  server.insecure: "true"
EOF
```
... and restart argocd app
```bash
kubectl rollout restart all -n argocd 
```


#get initial pass for argo admin 
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Delete infra 
```
terraform destroy -target=module.argocd-app
terraform destroy -target=module.cluster_addons
terraform destroy -target=module.eks
terraform destroy -target=module.ecr
terraform destroy -target=module.vpc
```
