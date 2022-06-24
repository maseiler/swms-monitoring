#!/bin/bash
###
# Note: all port forwarding happens in the background. You have to kill the process to stop it.
###

printf "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Creating k8s cluster and connecting...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
gcloud config set project resonant-forge-350508

# when conducting final benchmarks, we may want to use better machines
gcloud container clusters create cluster-1 \
  --machine-type e2-medium \
  --image-type "ubuntu_containerd" \
  --num-nodes 3 \
  --region "europe-west3-b" \
  --disk-size 20

gcloud container clusters get-credentials cluster-1 --zone europe-west3-b --project resonant-forge-350508

# deploy Airflow
printf "\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Deploying Airflow...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
helm install airflow apache-airflow/airflow \
  --namespace airflow --create-namespace \
  -f airflow-values.yaml \
  --set executor=KubernetesExecutor

nohup kubectl port-forward service/airflow-webserver 8080:8080 -n airflow &>/dev/null &
printf "\nAirflow UI accessible via http://localhost:8080\n  User: pjds\n  Pass: pjds\n"

# deploy eBPF Exporter
printf "\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Deploying eBPF Exporter...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
helm install ebpf ebpf-exporter-swms \
  --namespace kube-system \
  -f ebpf-exporter-swms/values.yaml

# deploy Prometheus and Grafana
printf "\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Deploying Prometheus and Grafana...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
helm install prometheus-grafana prometheus-community/kube-prometheus-stack \
  -n prometheus-grafana --create-namespace \
  -f prometheus-grafana-values.yaml

nohup kubectl port-forward service/prometheus-grafana 3000:80 -n prometheus-grafana &>/dev/null &
printf "\nGrafana dashboard accessible via http://localhost:3000\n  User: pjds\n  Pass: pjds\n"
sleep 3s
kubectl cp ./dashboards $(kubectl get pod -l app.kubernetes.io/name=grafana -n prometheus-grafana -o jsonpath="{.items[0].metadata.name}"):/tmp -n prometheus-grafana
# nohup kubectl port-forward service/prometheus-grafana-kube-pr-prometheus 9090:9090 -n prometheus-grafana &>/dev/null &
# printf "\nPrometheus dashboard accessible via http://localhost:9090\n"
