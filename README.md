# DevOps Assignment – AWS EKS, Terraform, Kubernetes, ArgoCD

This project contains the Terraform configuration to create an EKS cluster,
Kubernetes manifests to deploy an NGINX application, and an ArgoCD
Application resource for GitOps-based deployment.

---

## 1. Steps to Provision the EKS Cluster (Terraform)

1. Navigate to the terraform folder:
   ```
   cd terraform
   ```

2. Initialize Terraform:
   ```
   terraform init
   ```

3. Review the execution plan:
   ```
   terraform plan
   ```

4. Create the EKS cluster:
   ```
   terraform apply -auto-approve
   ```

5. After the cluster is created, configure kubectl:
   ```
   aws eks update-kubeconfig --name devops-eks --region ap-south-1
   ```

6. Verify connection:
   ```
   kubectl get nodes
   ```

---

## 2. Deploy NGINX on Kubernetes

Apply the NGINX manifests:
```
kubectl apply -f manifests/
```

Check deployment:
```
kubectl get pods
kubectl get svc
```

---

## 3. Access the NGINX Application

### Option A: Port-forward
```
kubectl port-forward svc/nginx-service 8080:80
```
Visit:
```
http://localhost:8080
```

### Option B: NodePort (Public Access)
1. Get node public IP:
   ```
   kubectl get nodes -o wide
   ```
2. Access:
   ```
   http://<node-ip>:30080
   ```

---

## 4. ArgoCD Installation & Login Instructions

### Install ArgoCD:
```
kubectl create namespace argocd
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Get initial admin password:
```
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 --decode
```

### Port-forward the ArgoCD server:
```
kubectl port-forward -n argocd svc/argocd-server 8080:443
```

### Login:
- URL: https://localhost:8080  
- Username: `admin`  
- Password: (from above command)

---

## 5. ArgoCD GitOps Application

Apply the ArgoCD Application resource:
```
kubectl apply -f argocd/application.yaml
```

ArgoCD will automatically sync the NGINX manifests from this repository.

---

## 6. (Optional) Ingress + Domain Configuration

### Install NGINX Ingress Controller:
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace
```

### Apply ingress:
```
kubectl apply -f manifests/ingress.yaml
```

### Get LoadBalancer hostname:
```
kubectl -n ingress-nginx get svc
```

### DNS Mapping:
Create a CNAME or A record:
```
demo.yourdomain.com → <loadbalancer-hostname>
```

Access the app using:
```
http://demo.yourdomain.com
```

---
