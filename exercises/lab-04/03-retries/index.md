# Lab 04, Exercise 03: Retries

**Objective:** Learn how to implement retry pattern in Envoy and how that pattern visualizes in Grafana.

## Step 1: Implement retries for Envoy

First, navigate to this exercise's directory:

```
cd ~/service-mesh-training/exercises/lab-04/03-retries/
```

Take a look at the updated Kubernetes config files in `files/app` and see where we are implementing the retry pattern.

Now apply the updated config files:

```
kubectl apply -f files/app
```

## Step 2: Use Grafana to see what affect retries has

Look at the dashboard see that the end user is no longer affected by the problem but the service response is still slower due to the retry.
