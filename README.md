# K3s Monitoring Stack with Prometheus & Grafana

This guide sets up a lightweight Kubernetes cluster using K3s on a virtual machine, deploys a Prometheus monitoring stack via Helm, and exposes both Grafana and Prometheus dashboards using NodePort.
![image](https://github.com/user-attachments/assets/6d180dab-3142-40aa-92d8-7e3ade483b8b)


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
![k3s 1](https://github.com/user-attachments/assets/682ef88d-44e6-463c-9836-16cd61e79a71)


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

#Alternatively you can put all the dependables into a yaml file and apply during the install

![k3s namespace x depl](https://github.com/user-attachments/assets/f8dde502-9374-4135-880e-f6ec08f3cfc4)

![k3s all](https://github.com/user-attachments/assets/18f41b8c-d1e6-434f-9121-e76eed7fcb27)




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
![grafana ui](https://github.com/user-attachments/assets/55af1099-250d-42d9-802b-51e21a7d4cd7)

![ui 2](https://github.com/user-attachments/assets/68683c95-d478-45a4-bece-ca6fcac2d605)


# Grafana credentials:
* Username: admin
* Password: prom_operator

![Screenshot_4-7-2025_141559_100 91 78 70](https://github.com/user-attachments/assets/5fad6a3f-0699-4a9c-964e-d25c2cfad50e)


# Expose Prometheus using NodePort
```bash
kubectl patch svc prometheus-kube-prometheus-prometheus -p '{"spec": {"type": "NodePort"}}'
kubectl get svc prometheus-kube-prometheus-prometheus
# Note the NodePort (e.g. 32290)
```

# Access Prometheus in browser
URL format: http://<VM_IP>:<NodePort>   
Example: http://100.91.78.70:32290

![prom ui](https://github.com/user-attachments/assets/eff57c14-bcfb-47cb-bc56-ad75b4c33c91)

![Screenshot_4-7-2025_142425_100 91 78 70](https://github.com/user-attachments/assets/096fc0c9-ba66-4ffd-a47b-b486d2aa8754)
