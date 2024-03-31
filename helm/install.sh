#!/bin/bash

# install helm repos
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add aqua https://aquasecurity.github.io/helm-charts/
helm repo update

# install webhooki server
pushd ./chart
helm upgrade wh --install --create-namespace --namespace kube-security . 
popd

# install prometheus
helm upgrade prometheus prometheus-community/kube-prometheus-stack --install --create-namespace --namespace kube-monitoring --values prometheus_values.yaml 


kubectl create ing prometheus -n kube-monitoring --class=nginx --annotation=nginx.ingress.kubernetes.io/rewrite-target="/" --rule=prometheus.celso.home/*=prometheus-operated:9090

kubectl create ing grafana -n kube-monitoring --class=nginx --annotation=nginx.ingress.kubernetes.io/rewrite-target="/" --rule=grafana.celso.home/*=prometheus-grafana:80

# Create prometheus ingress
kubectl create ingress prometheus --class=nginx --rule=celso.home/*=prometheus-operated:9090

# install trivy
helm upgrade trivy aqua/trivy-operator --install --create-namespace --namespace kube-security --values trivy_values.yaml
