#!/bin/bash

###
# Note: all port forwarding happens in the background. You have to kill the process to stop it.
###

set -u

create_vms() {
  ZONE=${ZONE:-europe-west3-b}
  MACHINE_TYPE=${MACHINE_TYPE:-e2-medium}
  IMAGE_PROJECT=${IMAGE_PROJECT:-ubuntu-os-cloud}
  IMAGE_FAMILY=${IMAGE_FAMILY:-ubuntu-2204-lts}
  BOOT_DISK_SIZE=${BOOT_DISK_SIZE:-50GB}
  (
    set -x
    gcloud compute instances create k3s-1 \
      --zone "$ZONE" \
      --machine-type "$MACHINE_TYPE" \
      --image-project "$IMAGE_PROJECT" \
      --image-family "$IMAGE_FAMILY" \
      --boot-disk-size "$BOOT_DISK_SIZE" \
      --tags k3s,k3s-master

    gcloud compute instances create k3s-2 k3s-3 \
      --zone "$ZONE" \
      --machine-type "$MACHINE_TYPE" \
      --image-project "$IMAGE_PROJECT" \
      --image-family "$IMAGE_FAMILY" \
      --boot-disk-size "$BOOT_DISK_SIZE" \
      --tags k3s,k3s-worker

    gcloud compute config-ssh
  )
}

create_k3s_cluster() {
  primary_server_ip=$(gcloud compute instances list \
    --filter=tags.items=k3s-master \
    --format="get(networkInterfaces[0].accessConfigs.natIP)")

  # Instal k3s with k3sup
  (
    set -x
    k3sup install --ip "${primary_server_ip}" --context k3s --ssh-key ~/.ssh/google_compute_engine --user $(whoami)

    gcloud compute firewall-rules create k3s --allow=tcp:6443 --target-tags=k3s

gcloud container clusters get-credentials cluster-1 --zone europe-west3-b --project resonant-forge-350508

deploy_airflow() {
  helm install airflow apache-airflow/airflow \
    --namespace airflow --create-namespace \
    -f airflow-values.yaml \
    --set executor=KubernetesExecutor

  nohup kubectl port-forward service/airflow-webserver 8080:8080 -n airflow &>/dev/null &
  printf "\nAirflow UI accessible via http://localhost:8080\n  User: pjds\n  Pass: pjds\n"
}

deploy_ebpf() {
  helm install ebpf ebpf-exporter-swms \
    --namespace kube-system \
    -f ebpf-exporter-swms/values.yaml

  kubectl apply -f ebpf-exporter-swms/clusterrolebinding.yaml
  
  printf "\neBPF Exporter installed.\n"
}

deploy_prometheus_grafana() {
  helm install prometheus-grafana prometheus-community/kube-prometheus-stack \
    -n prometheus-grafana --create-namespace \
    -f prometheus-grafana-values.yaml

  sleep 3s
  kubectl cp ./dashboards $(kubectl get pod -l app.kubernetes.io/name=grafana -n prometheus-grafana -o jsonpath="{.items[0].metadata.name}"):/tmp -n prometheus-grafana
  nohup kubectl port-forward service/prometheus-grafana 3000:80 -n prometheus-grafana &>/dev/null &
  printf "\nGrafana dashboard accessible via http://localhost:3000\n  User: pjds\n  Pass: pjds\n"
  # nohup kubectl port-forward service/prometheus-grafana-kube-pr-prometheus 9090:9090 -n prometheus-grafana &>/dev/null &
  # printf "\nPrometheus dashboard accessible via http://localhost:9090\n"
}

########################
# Main
########################

printf "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Creating VMs...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
create_vms
sleep 15s # give machines some more time
printf "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Installing k3s...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
create_k3s_cluster
sleep 5s
export KUBECONFIG=$(pwd)/kubeconfig
printf "\nKubernetes Nodes:\n"
kubectl get nodes

printf "\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Deploying Airflow...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
deploy_airflow
printf "\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Deploying eBPF Exporter...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
deploy_ebpf
printf "\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n\t Deploying Prometheus and Grafana...\n▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒\n"
deploy_prometheus_grafana
