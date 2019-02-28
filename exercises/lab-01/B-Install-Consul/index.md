# Lab 01-B: Install Consul via Helm Chart

**Objective:** Install Consul into your Kubernetes cluster using Helm.

## Background

[Helm](https://helm.sh) is a package manager for Kubernetes. We'll use it to install and configure Consul in our workshop Kubernetes cluster.

If you're using the Instruqt environment, Helm is already installed. If you're using your own Kubernetes cluster, you may need to [install](https://github.com/helm/helm#install) it.

Helm charts come with default values for packages, but we need to override some of the default values. As with Kubernetes config, Helm charts are configured using yaml.

## Step 1: Examine values.yaml

Using a command line editor (e.g. vim, pico, emacs) or the visual Instruqt editor (Editor tab), take a look at the `values.yaml` file in this directory. You'll see several configuration values ([documentation](https://www.consul.io/docs/platform/k8s/helm.html#configuration-values-)).

Guiding questions:

- What Docker image will be used for the containers running Consul agents? ([hint](https://www.consul.io/docs/platform/k8s/helm.html#v-global-image))
- Are we enabling Consul Connect features at this time? ([hint](https://www.consul.io/docs/platform/k8s/helm.html#v-server-connect))
- Are we enabling the Consul UI at this time? ([hint](https://www.consul.io/docs/platform/k8s/helm.html#v-ui))
- Will GRPC be enabled for Consul clients? ([hint](https://www.consul.io/docs/platform/k8s/helm.html#v-client-grpc))

## Step 2: Install Consul

Once you are familar with the configuration options, go ahead and install Consul using `helm install -f <config> <chart>`:

```
helm install -f values.yaml k8s-config/consul/
```

You'll see output similar to:

```
NAME:   solitary-marmot
LAST DEPLOYED: Thu Feb 28 22:17:02 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/DaemonSet
NAME                    DESIRED  CURRENT  READY  UP-TO-DATE  AVAILABLE  NODE SELECTOR  AGE
solitary-marmot-consul  1        1        0      1           0          <none>         1s

==> v1/StatefulSet
NAME                           DESIRED  CURRENT  AGE
solitary-marmot-consul-server  1        1        1s

==> v1/Pod(related)
NAME                             READY  STATUS             RESTARTS  AGE
solitary-marmot-consul-m6ndn     0/1    ContainerCreating  0         1s
solitary-marmot-consul-server-0  0/1    ContainerCreating  0         1s

==> v1beta1/PodDisruptionBudget
NAME                           MIN AVAILABLE  MAX UNAVAILABLE  ALLOWED DISRUPTIONS  AGE
solitary-marmot-consul-server  N/A            0                0                    1s

==> v1/ConfigMap
NAME                                  DATA  AGE
solitary-marmot-consul-client-config  1     1s
solitary-marmot-consul-server-config  1     1s

==> v1/Service
NAME                           TYPE       CLUSTER-IP      EXTERNAL-IP  PORT(S)                          AGE
solitary-marmot-consul-dns     ClusterIP  10.107.127.61   <none>       53/TCP,53/UDP                          1s
solitary-marmot-consul-server  NodePort   10.109.158.40   <none>       8500:30010/TCP,8301:30011/TCP,8301:30011/UDP,8302:30012/TCP,8302:30012/UDP,8300:30013/TCP,8600:30014/TCP,8600:30014/UDP  1s
solitary-marmot-consul-ui      ClusterIP  10.111.114.137  <none>       80/TCP
```

## Step 3: Confirm Consul is running

Using `kubectl get services`:

```
kubectl get services

NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                               AGE
kubernetes                      ClusterIP   10.96.0.1        <none>        443/TCP                                                               37m
solitary-marmot-consul-dns      ClusterIP   10.107.127.61    <none>        53/TCP,53/UDP                                                               23m
solitary-marmot-consul-server   NodePort    10.109.158.40    <none>        8500:30010/TCP,8301:30011/TCP,8301:30011/UDP,8302:30012/TCP,8302:30012/UDP,8300:30013/TCP,8600:30014/TCP,8600:30014/UDP   23m
solitary-marmot-consul-ui       ClusterIP   10.111.114.137   <none>        80/TCP                                                               23m
```

If you're using the Instruqt environment, visit the **Consul** tab and you should see the Consul Web UI:

![Consul UI](/service-mesh-training/exercises/images/lab01-consul-ui.png "Consul Web UI")
