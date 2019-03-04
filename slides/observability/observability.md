---
{layout="01 Main Title - Consul"}

# Service Mesh - Observability

## Nic Jackson & Christie Koehler & Erik Veld


---
{layout="09 Section Title - Consul"}

# Observability is it just buzz word?

<!--
Observability is a buzzword which has been floating round the industry recently, but what does it actually mean.  Is it just re-branded monitoring, or does observability mean something completely different?

Before we dive into this let’s re-visit a concept which should be familiar, monitoring.
-->

---
{layout="09 Section Title - Consul"}

# Monitoring

<!--
-->


---
{layout="14 Title at Top"}

## Monitoring is something we perform against our applications and systems to determine their state 

- is a service up or down?
- detecting problems and anomalies
- gain insight to capacity problems
- performance trends over time 


<!--
-->

---
{layout="14 Title at Top"}

## Internal and external instrumentation

* IMAGE HERE

<!--
We use instrumentation both internal an external to achieve this, for example, we may have an external health check which probes an application’s state or determines the current resource consumption.  We may have internal statistics which report the performance of a particular block of code or the time taken to perform a database transaction.
-->

---
{layout="14 Title at Top"}

## Internal instumentation

- StatsD
- Prometheus metrics endpoints

<!--
With regard to internal metrics which are explicitly emitted by your application there two primary methods for executing this.  
-->


---
{layout="14 Title at Top"}

## StatsD

- Originally created by Etsy
- Push based metrics
- Lightweight UDP protocol
- No support for meta data

<!--
I could tell you a joke about UDP but you might not get it
-->



## StatsD - Metric Types
---
{layout="11-3 Code Editor"}

## StatsD 

```
# metric.name:value|type|sample_rate
myservice.mymethod.called:123|c
```

<!--
StatsD is a project originally created by Etsy, it defines a light weight protocol for sending metrics to a collection server using UDP which makes it fast and scale able.  Some of the criticisms of StatsD have been that the metric format does not have a concept of associating meta data to a statistic.  For example, you have a simple metric which shows the number of times a particular method was called
-->


---
{layout="14 Title at Top"}

## StatsD - Metric Types

- Counter - Increment value, e.g. number of method calls 
- Gauge - Value over time, e.g. CPU consumption, memory usage
- Timing - Time taken to perform a task, e.g. time take to perform a method call
- Set - Set of unique values over collection period

<!--

-->


---
{layout="11-3 Code Editor"}

## StatsD - Problem with basic metric labels

```
myservice.service1.mymethod.called
myservice.service2.mymethod.called
myservice.service3.mymethod.called
```

<!--
While we not have granularity which allows us to infer differences between our service instances we have introduced a new problem which is how we aggregate the data.  Many data reporting systems prefer an explicit metric name for performance reasons.  
-->


## StatsD - DogStatsD

- Created by DataDog based on StatsD protocol
- Push based metrics
- Lightweight UDP protocol
- Support for meta data through tags
  

---
{layout="11-3 Code Editor"}

## StatsD - DogStatsD 

```
myservice.mymethod.called tags[serviceid:service1]
myservice.mymethod.called tags[serviceid:service2]
myservice.mymethod.called tags[serviceid:service3]
```

<!--
For this reason DataDog a company providing a Software as a Service platform for metrics introduced an extension of the StatsD format called DogStatsD.  This extension introduced tags in addition to the simple metric name and value.  Now we can define our metrics like so:

This gives us the best of both worlds, we can have aggregated data but if necessary we can drill down into this using tags.
-->


---
{layout="14 Title at Top"}

## Prometheus 

- Pull based approach from central server
- Service implements HTTP enpoint exposing metrics
- Supports meta data by default

<!--
Prometheus takes a slightly different approach, rather than a push based approach where your metrics are sent to a collector using UDP.  Prometheus requires you to implement a HTTP endpoint which exposed your metrics in the Prometheus format.  This is then scraped by the Prometheus server at predetermined intervals. Prometheus also supports tags by default.
-->


---
{layout="11-3 Code Editor"}

# Prometheus 
## statistic format

```
envoy_http_downstream_rq_completed{envoy_http_conn_manager_prefix="ingress_cache"} 23421
```


---
{layout="14 Title at Top"}

## Prometheus - Metrics types

- Counter - cumulative metric, representing a monotonically increasing counter, e.g. number of method calls
- Gauge - single numerical value that can arbitrarily go up and down, e.g. CPU consumption
- Histogram - samples observations and counts them in configurable buckets, e.g. request timings

<!--
-->


---
{layout="09 Section Title - Consul"}

# Observability - a measure of how well internal states of a system can be inferred from knowledge of external outputs

<!--
The term originates from the world of engineering and control theory, in summary the concept is a measure of how well internal states of a system can be inferred from knowledge of external outputs.
-->


---
{layout="14 Title at Top"}

# Observability 

- monitoring
- logs
- network traces
- business metrics such as sales figures
 
<!--
Some of these outputs will be from traditional monitoring however Observability encompasses:
-->

---
{layout="99-5 - Quote"}

# The service mesh is not a silver bullet

<!--
The service mesh is not a silver bullet when it comes to covering your observability needs, you will still need to add metrics to your application, however it can satisfy part of it.
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - statistics

- network connections (L4, L7)
- reliability patterns (timeouts, retries, etc)
- control plane statistics (authorization, service discovery, configuration)

<!--
We are specifically going to be looking at the data plane and Envoy.  Envoy is fast becoming the standard tool when it comes to a Service Mesh data plane.  Understanding the configurable elements and output statistics of Envoy is essential if you are going to successfully run a reliable system with a service mesh. 
-->


---
{layout="09 Section Title - Consul"}

# Envoy - Architecture

<!--
Before we start looking at these statistics, lets take a quick overview of Envoy’s architectural model.
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - architecture

NOTE: REPLACE WITH AN IMAGE

- Upstream
  - Cluster
    - Service Discovery
    - Load balancing
    - Outlier ejection
    - Circuit breaking
  - Listeners
    - Listener filters
      - HTTP Router
      - Retry
      - Timeouts
      - gRPC bridge filter
- Local app
  - Cluster
  - Listener
    - Listener filter
      - Authz
- Local agent - Control Plane (Aggregated Discovery Service)

<!--
Envoy is predominately composed of:
- Clusters which allow the connection to a local or remote resource.
- Listeners which allow a connection to a cluster
- Listener filters which are used to manage features such as HTTP routing, retries, timeouts and authentication.
-->

---
{layout="14 Title at Top"}

## Data plane (Envoy) - architecture

<!--
In terms of network reliability Listeners and Listener filters are things that you should think about monitoring as they expose metrics like connection status, HTTP/gRPC response and the status of various retry patterns.  There are also certain statistics which are output from a Cluster, these are reliability patterns such as rate limiting, circuit breaking and outlier ejection, and authentication.

We also need to consider administrative functions, it can be useful to monitor Envoy’s connection to the Control plane, generally this is a gRPC connection using the Aggregated Discovery Service.  The control plane is providing features such as TLS certificates and their rotation through the Secret Discovery Service (SDS), and Endpoint Discovery Service (EDS).  Failure of these services or the connection to the control plan will cause problems with your application especially for upstream connections.
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - terminology

Name   | Description
-------|--------------------------------
ADS    | Aggregated Discovery Service 
EDS    | Endpoint Discovery Service 
LDS    | Listener Discovery Service
RDS    | Router Discovery Service
CDS    | Cluster Discovery Service
SDS    | Secret Discovery Service (TLS Certificates)

<!--
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - terminology

Generally the statistics fall into three categories:

- **Downstream**: Downstream statistics relate to incoming connections/requests. They are emitted by listeners, the HTTP connection manager, the TCP proxy filter, etc.
- **Upstream**: Upstream statistics relate to outgoing connections/requests. They are emitted by connection pools, the router filter, the TCP proxy filter, etc.
- **Server**: Server statistics describe how the Envoy server instance is working. Statistics like server up-time or amount of allocated memory are categorized here.

<!--
Before we dive into Envoy’s statistics we need to understand some core terminology, Envoy emits a large number of statistics depending on how it is configured. Generally the statistics fall into three categories:

A single proxy scenario typically involves both downstream and upstream statistics. The two types can be used to get a detailed picture of that particular network hop. Statistics from the entire mesh give a very detailed picture of each hop and overall network health. The statistics emitted are documented in detail in the operations guide. 
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - connections and requests

- Connections are a point to point network connection between Envoy proxies
- Requests are a single request between a downstream (client) and an upstream (proxy)
- Connections and requests are **not** a 1-1 mapping

<!--
When we are looking at our metrics we need to differentiate between a connection and a request, Envoy metrics use the convention cx for a connection and rq for a request.  The important thing to remember when we are looking at this is that connections and requests are not a one to one mapping.  Where possible envoy will use HTTP keep-alive that means that a single connection will be used for multiple request and responses.  The benefit to this is that we do not need to waste time by renegotiating a connection and in the instance where TLS or mTLS is used we do not need to Handshake and validate certificates.  This can add significant performance benefits to your application.  Where monitoring comes in to this is that we need to monitor both of these, we monitor connections as a significant number of opening and closing connections can highlight an inefficient network transport and potentially a malfunctioning service.  We need to monitor requests as we give us an understanding of the time it takes to perform a request, the status (success or fail) and the data transferred.  
-->


---
{layout="11-3 Code Editor"}

# Data plane (Envoy)
## statistic format

```
http.<stat_prefix>.downstream_cx_total

# assuming prefix cache_service metric would be:

http.cache_service.downstream_cx_total

# would be displayed in prometheus as

http_cache_service_downstream_cx_total
```


---
{layout="11-3 Code Editor"}

# Data plane (Envoy)
## statistic problems

```
{__name__=~"http_.*_downstream_cx_total"}
```

<!--
This on it’s own is not terrible however we can often find ourselves in a situation where we need to use a hack in Prometheus to obtain the statistic name using a regex.
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - configuring statistics

* Envoy outputs prometheus metrics using the admin API at `/stats/prometheus`
* Admin API is not authenticated, allows access to config dump, configuration, etc
* Possible to configure other metric outputs (Stat Sinks)

<!--
Envoy has the capability of exposing Prometheus statistics directly through the administration endpoint at the path /stats/prometheus
However this endpoint is not secured and opening access not only allows the to the statistics but also the TLS certificates which are used to secure connections.  Exposing this endpoint can therefore pose a security risk so for now the easiest approach is to configure a stats sink which will push statistics to an upstream collector.
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - stats sinks

- envoy.statsd - standard statsd protocol
- envoy.dog_statsd - DataDog statsd protocol
- envoy.metrics_service - metrics service implementing Envoy gRPC metric service protocol (https://github.com/envoyproxy/envoy/blob/master/api/envoy/service/metrics/v2/metrics_service.proto)
- envoy.stat_sink_hystrix - for sending statistics to Hystrix dashboards

<!--
Configuring statistics for StatsD must be done through the Envoy bootstrap process, normally this is configured by your control plane however like many of the examples in this tutorial we are going to look at raw Envoy configuration as it will give you a greater appreciation of what is going on.
-->

---
{layout="11-3 Code Editor"}

# Data plane (Envoy)
## statistics config

```
stats_sinks:
- name: "envoy.dog_statsd"
  config:
    address: 
      socket_address:
        address: "127.0.0.1"
        port_value: 9125
    prefix: "envoy"
stats_config:
  use_all_default_tags: true
```

<!--
The following example is an except from our Envoy configuration, this is configuration is added to the root level of the bootstrap config.  Mostly this is pretty straight forward we can configure multiple sinks with Envoy the name, references the type of the sink from the 4 we looked at earlier.  The address takes the form of a standard Envoy socket address this is the IP address and port where the StatsD server is listening. Since we are have our StatsD exporter running in our pod we can reference this by using localhost port 9125 is the standard UDP port where the Prometheus StatsD server is listening.
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - configurable options

- stats_tags - enables us to manipulate the standard envoy metric name and extract parts of it to a tag.
- use_all_default_tags - use the default tag regex which are built into envoy, this automatically formats the metric names and extracts key components such as listener ip or cluster name as a tag
- stats_matcher - we can specify the specific metrics which we would like envoy to output, by default envoy outputs a huge number of metrics

<!--
There are a number or sinks available for Envoy, the DogStatsD sink allows tagging of metrics which is essential to be able to filter correctly in Grafana without resorting to the wild card hack for prom stats:
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - problems with StatsD sync

- No metadata related to pod name, ip address, etc
- Need to run a local sidecar so Prometheus can add metadata 

<!--
In addition to this we often need to get the instance id or IP address of the statistics origin,  Envoy by default does not add this to it’s statistics. Running a sidecar StatsD allows Prometheus scraping to add the details of the pod as labels which then allows us to filter our statistics to a more granular level.
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - L4 and L7

- Default is L4
- L4 only shows request success or fail at a connection level
- Need more information such as HTTP response codes (L7)
- Enabling L7 requires a Listener Filter

<!--
By default Envoy is only going to operate on L4 while that may be useful we will not see rich information which will enhance our awareness of our systems stability.

For example, with L4 we will see requests but only success or fail, a failure is only going to be reported if a connection is terminated unexpectedly.
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - L4 and L7

- Effective monitoring requires HTTP status codes
- Status codes give rich information about a request
    - 200 - OK
    - 404 - Not Found
    - 500 - Internal Service Error

<!--
For example, with L4 we will see requests but only success or fail, a failure is only going to be reported if a connection is terminated unexpectedly.  When your APIs or websites are reporting failures they will almost always terminate the request correctly. What they are actually doing is using L7 and the HTTP protocol, this carries with it HTTP status codes which indicate the real status of the request.  You will return a status 200 when a request is successful, a 404 if something is not found, and 5xx when the service has an unexpected error.  Monitoring these codes is essential to understanding your application however you need to enable some additional configuration in Envoy so that it understands that your app is talking L7.
-->


---
{layout="11-3 Code Editor"}

# Data plane (Envoy)
## configuring L7

```json
{
  "@type": "type.googleapis.com/envoy.api.v2.Listener",
  "name": "public_listener:${POD_IP}:20000",
  "address": {
    "socketAddress": {
      "address": "${POD_IP}",
      "portValue": 20000
    }
  },
  "filterChains": [
    {
      "filters": [
        {
          "name": "envoy.http_connection_manager",
          "config": {
            "stat_prefix": "ingress_http",
            "route_config": {
              "name": "local_route",
              "virtual_hosts": [
                {
                  "name": "backend",
                  "domains": ["*"],
                  "routes": [
                    {
                      "match": {
                        "prefix": "/"
                      },
                      "route": {
                        "cluster": "local_app"
                      }
                    }
                  ]
                }
              ]
            },
            "http_filters": [
              {
                "name": "envoy.router",
                "config": {}
              }
            ]
          }
        }
      ]
    }
  ]
}
```


---
{layout="14 Title at Top"}

## Data plane (Envoy) - gRPC

- Services communicate over a single HTTP2 connection
- Requests are multiplexed
- **Not** RESTFul
  - does not use HTTP status codes
  - uses Method not URI Path
- Status is sent as Error, part of message

<!--
By default when we are using Envoy’s observability features we are thinking in terms of HTTP.  HTTP uses status codes which are sent as part of the response for example.  Status 200 refers to a successful request, status 404 refers to something not found, and status 501 would relate to an internal error.  Envoy uses these response codes and can tag your request which allows you to filter the statistics to build dashboards of success and fail.

When you use a gRPC service things change slightly, gRPC while using HTTP2 as the transport does not leverage status codes in the same way that a RESTful API would, for example, should a request fail in gRPC with an internal status error then the gRPC server will still return a 200 HTTP code, this is because every gRPC response is augmented with an error which may or may not be nil depending on the success or fail of the operation.  These error codes loosely translate to HTTP status codes and in order for Envoy to output these correctly in it metrics we need to make a small configuration change to the way that we setup our listener.
-->


---
{layout="14 Title at Top"}

## Data plane (Envoy) - configuring gRPC services

- Require HTTP2 connection
- Enable envoy.grpc_http1_bridge to capture response codes and method name

<!--
To enable gRPC services we need to add a couple of features, firstly we need to enable the connection to use HTTP2, and secondly we need to configure the grpc_http1_bridge.  This does two things in envoy, it allows a HTTP request to be translated into a gRPC and it also decodes the response from the gRPC method and outputs this as statistics.
-->


---
{layout="11-3 Code Editor"}

# Data plane (Envoy)
## enabling HTTP2 for gRPC connections

```json
{
    "@type": "type.googleapis.com/envoy.api.v2.Cluster",
    "name": "local_app",
    "connect_timeout": "5s",
    "http2_protocol_options": {}
}
```

<!--
-->


---
{layout="11-3 Code Editor"}

# Data plane (Envoy)
## enabling gRPC statistics

```json
"http_filters": [                
    { 
      "name": "envoy.grpc_http1_bridge",
      "config": {}
    },
    {                              
      "name": "envoy.router",      
      "config": {}                 
    }
]                                
```

<!--
To enable statistics for gRPC services we need to enable the grpc_http1_bridge in the http filters, it is important to note that filters are executed in order, the bridge must come before the router or the request will be returned before it is processed by the bridge filter.
-->

---
{layout="14 Title at Top"}

## gRPC Statistics

<!--
-->