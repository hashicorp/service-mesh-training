# Lab 03, Exercise 03: Downstream Requests

**Objective:** Create a visualization of downstream requests.

As with the previous exercise, you'll use the **lab03 - API** dashboard.

Open the **Envoy Inbound Requests (downstream)** panel.

## Step 1

In the query with legend `{{envoy_response_code_class}}xx-{{name}}` put the following:

```
sum(increase(envoy_http_downstream_rq_xx{envoy_http_conn_manager_prefix="ingress_api", name=~"^$pod_name$"}[30s])) by (envoy_response_code_class,name)
```
