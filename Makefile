.PHONY: all setup create-namespaces install-prometheus install-grafana apply create-cluster add-repos install-dependencies get-pods get-svc status

status: get-pods get-svc

get-pods:
	@echo "Getting all pods from all namespaces..."
	kubectl get pods --all-namespaces

get-svc:
	@echo "Getting all services from all namespaces..."
	kubectl get svc --all-namespaces

# The 'all' target: creates the cluster, sets up the environment, and applies resources
all: install-dependencies create-cluster create-namespaces setup apply

# Setup command: installs dependencies, creates the cluster, and sets up the environment
setup: add-repos install-prometheus install-grafana

# Create the namespaces
create-namespaces:
	kubectl apply -f k8s/namespaces/

# Install dependencies: make, helm, and kind
install-dependencies:
	sudo apt update && sudo apt install -y make curl
	curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
	curl -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.18.0/kind-linux-amd64
	chmod +x ./kind
	sudo mv ./kind /usr/local/bin/kind

# Create the Kubernetes cluster with kind
create-cluster:
	kind create cluster --name monitoring-cluster

# Add Prometheus and Bitnami repositories to Helm
add-repos:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo update

# Install Prometheus using Helm with the custom values file
install-prometheus:
	helm install prometheus prometheus-community/prometheus -f prometheus-values.yaml --namespace monitoring

# Install Grafana using Helm with no persistence
install-grafana:
	helm install grafana bitnami/grafana --namespace monitoring --set persistence.enabled=false

# Apply all resources recursively in the current directory
apply:
	kubectl apply -R -f k8s/

delete-cluster:
	kind delete cluster --name monitoring-cluster
