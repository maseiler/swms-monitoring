# SWMS Monitoring

Master Project Distributed Systems 2022: Monitoring of Scientific Workflows

## Deployment

### Prerequisites
- Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- Install [Helm](https://helm.sh/docs/intro/install/)
- Install and configure [gcloud CLI](https://cloud.google.com/sdk/gcloud/)

### Deploy
> IMPORTANT: Always shut down all instances when you are done working!
> Either using [https://console.cloud.google.com](https://console.cloud.google.com) or `gcloud container clusters delete cluster-1 --region=europe-west3-b`.

Run `./setup.sh`
