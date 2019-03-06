# Lab 04, Exercise 01: Load Balancing

**Objective:** Delpoy 2nd API service, enable round-robin load balancing with updated Envoy config, and use Grafana to verify visually traffic is being balanced between the new services.

## Step 1: Deploy second API service to the cluster

First, navigate to this exercise's directory:

```
cd ~/service-mesh-training/exercises/lab-04/01-load-balancing/
```

Take a look at the updated Kubernetes config files in `files/app` and see where we are adding second service.

Now apply the updated config files:

```
kubectl apply -f files/app

deployment.apps/emojify-api-2 created
configmap/emojify-api-configmap unchanged
deployment.apps/emojify-api configured
configmap/emojify-cache-configmap unchanged
deployment.apps/emojify-cache configured
configmap/emojify-facebox-configmap unchanged
deployment.apps/emojify-facebox configured
service/emojify-ingress unchanged
configmap/emojify-ingress-configmap unchanged
deployment.apps/emojify-ingress configured
secret/emojify unchanged
configmap/emojify-website-configmap unchanged
deployment.apps/emojify-website configured
```

## Step 2: Verify round robin load balancing

Look at dashboards.

