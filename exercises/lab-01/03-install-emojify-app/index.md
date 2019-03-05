# [Lab 01](../index.md), Exercise 03: Install emojify app

**Objective:** Install sample emojify app into Kubernetes cluster.

* [Step 1: Inspect emojify app configs](#step-1-inspect-emojify-app-configs)
* [Step 2: Apply emojify app configs](#step-2-apply-emojify-app-configs)
* [Step 3: Verify emojify app is running](#step-3-verify-emojify-app-is-running)
* [Step 4 (optional): Emojify an image of your choice](#step-4-optional-emojify-an-image-of-your-choice)

## Step 1: Inspect emojify app configs

First, navigate to this exercise's directory:

```
cd ~/service-mesh-training/exercises/lab-01/03-install-emojify-app/
```

Now take a look at the files in `files/apps`:

* **api-external-cache.yml**
* **cache.yml**
* **facebox.yml**
* **ingress.yml**
* **secret.yml**
* **templates**
* **website.yml**

TODO: Add brief explanation for each item above.
TODO: Add architecture diagram.

## Step 2: Apply emojify app configs

```
kubectl apply -f files/app/

service/emojify-api-service created
deployment.apps/emojify-api-external-cache created
service/emojify-cache-service created
deployment.apps/emojify-cache created
service/emojify-facebox-service created
deployment.apps/emojify-facebox created
service/emojify-ingress-service created
configmap/emojify-ingress-configmap created
deployment.apps/emojify-ingress created
secret/emojify created
configmap/emojify-website-configmap created
service/emojify-website-service created
deployment.apps/emojify-website created
```

## Step 3: Verify emojify app is running

With `kubectl`:

```
kubectl get pods

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

![Emojify app](/service-mesh-training/exercises/images/lab01-emojify-app.png "Emojify app")

## Step 4 (optional): Emojify an image of your choice

Use the application to generate an emojified image.
