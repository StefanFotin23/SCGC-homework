kind create cluster
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus -f prometheus-values.yaml --namespace monitoring

kubectl apply -f nginx-configmap.yaml
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml

nohup kubectl port-forward -n monitoring svc/prometheus-server 9090:80 &

