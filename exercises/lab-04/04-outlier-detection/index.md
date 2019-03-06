# Lab 04, Exercise 04: Outlier Detection

**Objective:** Learn how to configure outlier detection in Envoy and how to visualize this pattern and its affects in Grafana.

## Step 1: Configure outlier ejection for Envoy

First, navigate to this exercise's directory:

```
cd ~/service-mesh-training/exercises/lab-04/04-outlier-detection/
```

Take a look at the updated Kubernetes config files in `files/app` and see where we are implementing outlier detection.

Now apply the updated config files:

```
kubectl apply -f files/app
```

## Step 2: Verify in Grafana

Look at the dashboard, now you can see that Envoy is ejecting the broken service from the load balancing.

The service time has also reduced as the retry is not as spammy.
