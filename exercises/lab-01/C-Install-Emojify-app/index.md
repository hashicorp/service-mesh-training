# Lab 01-C: Install emojify app

**Objective:** Install sample emojify app into Kubernetes cluster.

```
$ kubectl apply -f service-mesh-training/k8s-config/app/
configmap/emojify-api-external-cache-configmap created
deployment.apps/emojify-api-external-cache created
configmap/emojify-cache-configmap created
deployment.apps/emojify-cache created
configmap/emojify-facebox-configmap created
deployment.apps/emojify-facebox created
service/emojify-ingress-service created
configmap/emojify-ingress-configmap created
deployment.apps/emojify-ingress created
secret/emojify created
configmap/emojify-website-configmap created
deployment.apps/emojify-website created
```

Verify:

```
$ kubectl get pods
NAME                                        READY   STATUS    RESTARTS   AGE
emojify-api-external-cache-788c9964-vs688   3/3     Running   0          65s
emojify-cache-879fdccb7-4464c               3/3     Running   1          65s
emojify-facebox-7b4fdc8b5b-j4b46            3/3     Running   0          65s
emojify-ingress-7b697c574b-zhj76            3/3     Running   0          65s
emojify-website-5dd8ff4b55-jfn8z            3/3     Running   0          65s
jaunty-cheetah-consul-klfdj                 1/1     Running   0          6m44s
jaunty-cheetah-consul-server-0              1/1     Running   0          6m44s
```

Check emojify app tab:

Check Consul:

