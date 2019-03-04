# Lab 02, Exercise 1: Enable Connect Sidecar Injection

**Objective:** Enable Connect sidecar injector by applying updated helm chart.

## Background

[Connect](/docs/connect/index.html) is a feature built into to Consul that
enables automatic service-to-service authorization and connection encryption
across your Consul services. Connect can be used with Kubernetes to secure pod
communication with other pods and external Kubernetes services.

The Connect sidecar running Envoy can be automatically injected into pods in
your cluster, making configuration for Kubernetes automatic.  This
functionality is provided by the [consul-k8s
project](https://github.com/hashicorp/consul-k8s) and can be automatically
installed and configured using the [Consul Helm
chart](/docs/platform/k8s/helm.html).

## Step 1: Inspect updated configs

TODO: Complete this section.

## Step 2: Apply updated chart / configs

```
helm upgrade path/chart
```

(if there are also kube configs to apply)

```
kubectl apply -f
```

## Step 3: Verify connect sidecars injected and running

TODO: add how they do this
