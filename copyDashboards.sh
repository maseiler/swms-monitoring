kubectl cp ./dashboards $(kubectl get pod -l app.kubernetes.io/name=grafana -n prometheus-grafana -o jsonpath="{.items[0].metadata.name}"):/tmp/dashboards -n prometheus-grafana
