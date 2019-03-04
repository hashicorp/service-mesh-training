# Lab 04, Exercise 01: Load Balancing

**Objective:** Delpoy 2nd API service, enable round-robin load balancing with updated Envoy config, and use Grafana to verify visually traffic is being balanced between the new services.

## Background

## Step 1: Deploy second API service to the cluster

Look at `path/to/config` files and see where we are adding second service.

```
kubectl apply -f path/to/config
```

## Step 2: Verify round robin load balancing

Look at dashboards.

