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

1. Connections (created / destroyed)
2. Authorizations e.g increase(envoy_ext_authz_connect_authz_ok{label_app="emojify-api"}[1m])
3. Requests (number and timings of individual upstream and downstream)
4. Make sure all dashboards are broken by pod instance
5. Update dashboard to show L7 information
6. (stretch) create grpc dashboard


