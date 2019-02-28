# Lab 01, Exercise 04: Install Prometheus and Grafana

**Objective:** Install [Prometheus](https://prometheus.io) and [Grafana](https://grafana.com) into Kubernetes cluster.

Prometheus and Grafana:

```
$ kubectl apply -f service-mesh-training/k8s-config/monitoring/
configmap/prometheus-server-conf created
clusterrole.rbac.authorization.k8s.io/prometheus created
clusterrolebinding.rbac.authorization.k8s.io/prometheus created
service/prometheus created
service/grafana created
statefulset.apps/prometheus-statefulset created
daemonset.apps/prometheus-statsd created
```

Verify

```
$ kubectl get pods
NAME                                        READY   STATUS    RESTARTS   AGE
emojify-api-external-cache-788c9964-vs688   3/3     Running   0          10m
emojify-cache-879fdccb7-4464c               3/3     Running   1          10m
emojify-facebox-7b4fdc8b5b-j4b46            3/3     Running   0          10m
emojify-ingress-7b697c574b-zhj76            3/3     Running   0          10m
emojify-loadtest-bf6d754d-8rdvn             1/1     Running   0          71s
emojify-website-5dd8ff4b55-jfn8z            3/3     Running   0          10m
jaunty-cheetah-consul-klfdj                 1/1     Running   0          16m
jaunty-cheetah-consul-server-0              1/1     Running   0          16m
prometheus-statefulset-0                    2/2     Running   0          2m29s
prometheus-statsd-h4hg2                     1/1     Running   0          2m29s
```

Load testing data:

```
$ kubectl apply -f service-mesh-training/k8s-config/load-test.yml
configmap/emojify-loadtest-configmap created
deployment.apps/emojify-loadtest created
```

