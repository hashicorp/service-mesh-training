# Lab 03, Exercise 04: Build Grafana Dashboard

**Objective:** Create a visualization of Envoy authorizations.

As with the previous exercise, you'll use the **lab03 - API** dashboard.

Open the **Envoy authz** panel.

## Step 1

In the query with legend `ok`:

```
sum(increase(envoy_ext_authz_connect_authz_ok{label_app="emojify-api", name=~"^$pod_name$"}[1m]))
```

In the query with legend `error`:

```
sum(increase(envoy_ext_authz_connect_authz_error{label_app="emojify-api", name=~"^$pod_name$"}[1m]))
```
