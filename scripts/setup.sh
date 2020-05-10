#!/bin/bash

kind create cluster

kubectl apply -f ./scripts/kind-ingress-nginx.yaml

helm repo add argo https://argoproj.github.io/argo-helm

helm repo add stable https://kubernetes-charts.storage.googleapis.com

helm repo update

helm install argocd argo/argo-cd -f ./scripts/argocd.values.yaml

helm install metrics-server stable/metrics-server --namespace kube-system

kubectl create namespace prometheus

kubectl create namespace helm-stable-only

kubectl --namespace prometheus create secret generic grafana-admin --from-literal=admin-user="admin" --from-literal=admin-password="password"

# Check NGINX is ready
port=""
while [ -z $port ]; do
  echo "Waiting for nodePort..."
  port=$(kubectl get service -n ingress-nginx ingress-nginx-controller -o=jsonpath="{.spec.ports[?(@.port == 80)].nodePort}")
  [ -z "$port" ] && sleep 10
done
echo "Nginx Ingress ready!"

# Start socat
for port in 80 443
do
    node_port=$(kubectl get service -n ingress-nginx ingress-nginx-controller -o=jsonpath="{.spec.ports[?(@.port == ${port})].nodePort}")

    docker run -d --name kind-proxy-${port} \
      --publish 127.0.0.1:${port}:${port} \
      --link kind-control-plane:target \
      alpine/socat -dd \
      tcp-listen:${port},fork,reuseaddr tcp-connect:target:${node_port}
done

echo "Waiting for argocd-server..."
POD=$(kubectl get pod -l app.kubernetes.io/name=argocd-server -o jsonpath='{.items[0].metadata.name}')
kubectl wait --timeout 300s --for=condition=ready pod/$POD

echo "Waiting for ingress-nginx-controller..."
POD=$(kubectl get pod -n ingress-nginx -l app.kubernetes.io/component=controller -o jsonpath='{.items[0].metadata.name}')
kubectl wait --timeout 300s -n ingress-nginx --for=condition=ready pod/$POD

kubectl -n default patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$10$rRyBsGSHK6.uc8fntPwVIuLVHgsAhAX7TcdrqW/RADU0uh7CaChLa",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

echo "You're ready to go!"