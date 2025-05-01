kind create cluster
sudo apt install make

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install prometheus prometheus-community/prometheus -f prometheus-values.yaml --namespace monitoring
helm install grafana bitnami/grafana --namespace monitoring --set persistence.enabled=false

kubectl apply -R -f .

nohup kubectl port-forward -n monitoring svc/prometheus-server 9090:80 &

