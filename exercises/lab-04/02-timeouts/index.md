# Lab 04, Exercise 02: Timeouts

**Objective:** Configure timeouts in Envoy and verify affect upon response time and users in Grafana.

## Step 1: Deploy a faulty API service

First, navigate to this exercise's directory:

```
cd ~/service-mesh-training/exercises/lab-04/02-timeouts/
```

Now apply the updated config files:

```
kubectl apply -f part1/files/app

deployment.apps/emojify-api-2 configured
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

## Step 2: Use Grafana to verify affect upon response times and users

## Step 3: Configure timeouts in Envoy (set to 1s)

Now apply the updated config files:

```
kubectl apply -f part2/files/app

deployment.apps/emojify-api-2 configured
configmap/emojify-api-configmap unchanged
deployment.apps/emojify-api configured
configmap/emojify-cache-configmap unchanged
deployment.apps/emojify-cache configured
configmap/emojify-facebox-configmap unchanged
deployment.apps/emojify-facebox configured
service/emojify-ingress unchanged
configmap/emojify-ingress-configmap configured
deployment.apps/emojify-ingress configured
secret/emojify unchanged
configmap/emojify-website-configmap unchanged
deployment.apps/emojify-website configured
```

## Step 4: Use Grafana to verify affect timeouts are having on response times and users
