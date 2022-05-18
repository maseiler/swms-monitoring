#!/usr/bin/bash
###
# Note: all port forwarding happens in the background. You have to kill the process to stop it.
###

printf "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Creating k8s cluster and connecting...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
gcloud config set project resonant-forge-350508

# when conducting final benchmarks, we may want to use better machines
gcloud container clusters create cluster-1 \
  --machine-type e2-medium \
  --num-nodes 3 \
  --region "europe-west3-b"

gcloud container clusters get-credentials cluster-1 --zone europe-west3-b --project resonant-forge-350508

# deploy Airflow
printf "\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Deploying Airflow...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
helm install airflow apache-airflow/airflow \
  -n airflow --create-namespace \
  -f airflow-values.yaml

nohup kubectl port-forward service/airflow-webserver 8080:8080 -n airflow &>/dev/null &
printf "\nAirflow UI accessible via http://localhost:8080\n  User: pjds\n  Pass: pjds\n"

# deploy Prometheus and Grafana
printf "\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Deploying Pronetheus and Grafana...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
helm install prometheus-grafana prometheus-community/kube-prometheus-stack \
  -n prometheus-grafana --create-namespace \
  -f prometheus-grafana-values.yaml

nohup kubectl port-forward service/prometheus-grafana 3000:80 -n prometheus-grafana &>/dev/null &
printf "\nGrafana dashboard accessible via http://localhost:3000\n  User: pjds\n  Pass: pjds\n"
