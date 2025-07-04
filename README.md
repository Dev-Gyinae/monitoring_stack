# K3s Monitoring Stack with Prometheus & Grafana

This guide sets up a lightweight Kubernetes cluster using K3s on a virtual machine, deploys a Prometheus monitoring stack via Helm, and exposes both Grafana and Prometheus dashboards using NodePort.

```bash
# Create environment script
cat <<EOF > k3s-env.sh
#!/bin/bash
export INSTALL_K3S_CHANNEL=stable
export INSTALL_K3S_EXEC="--disable=traefik --disable=servicelb --disable=metrics-server"
export K3S_KUBECONFIG_MODE="644"
export INSTALL_K3S_NAME="k3s"
EOF
```

```bash
chmod +x k3s-env.sh
source ./k3s-env.sh
```

# Install K3s
```bash
curl -sfL https://get.k3s.io | sh -
kubectl get nodes
```

# Configure kubectl access
```bash
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
```

# Install Helm
```bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version
```

# Add Prometheus Helm repository
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

# Install Prometheus monitoring stack
```bash
helm install prometheus prometheus-community/kube-prometheus-stack \
  --set grafana.persistence.enabled=true \
  --set grafana.persistence.size=2Gi \
  --set grafana.adminUser="admin" \
  --set grafana.adminPassword="prom_operator" \
  --set grafana.grafana.ini.database.wal=true
```

# Expose Grafana using NodePort
```bash
kubectl patch svc prometheus-grafana -p '{"spec": {"type": "NodePort"}}'
kubectl get svc prometheus-grafana
# Note the NodePort (e.g. 32185)
```

# Access Grafana in browser
```bash
# URL format: http://<VM_IP>:<NodePort>
# Example: http://100.91.78.70:32185
```
# Grafana credentials:
* Username: admin
* Password: prom_operator

# Expose Prometheus using NodePort
```bash
kubectl patch svc prometheus-kube-prometheus-prometheus -p '{"spec": {"type": "NodePort"}}'
kubectl get svc prometheus-kube-prometheus-prometheus
# Note the NodePort (e.g. 32290)
```

# Access Prometheus in browser
URL format: http://<VM_IP>:<NodePort>   
Example: http://100.91.78.70:32290
