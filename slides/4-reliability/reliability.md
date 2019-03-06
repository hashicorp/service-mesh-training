---
{layout="01 Main Title - Consul"}

# Service Mesh - Reliability

## Nic Jackson, Christie Koehler, Erik Veld


---
{layout="14 Title at Top"}

## Monoliths communicate in process

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/monolith.png)

<!--
We explained in the first part of this course that with Microservices you break down what would be internal procedure call
-->


---
{layout="14 Title at Top"}

## Microservices communicate across the network

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/microservices.png)

<!--
and break them out into their own applications which are now connected via a network connections. 
-->

---
{layout="14 Title at Top"}

## Monoliths need reliability patterns too

- handle transient failures when:
  - connecting to database
  - queues
  - email server
  - etc
 
<!--
Even with the Monolith, reliability patterns were still partially applicable, often transient failures would be experienced when connecting to a database or communicating with an email server.  The key thing is that the problems were not as pronounced, network flakiness or service misbehavior can cause many problems for our applications.
-->


---
{layout="14 Title at Top"}

## Why we moved to microservices

- smaller application to manage and deploy
- cross team collaboration
- smaller domain model to understand
- increased availability through redundancy
- ease of scale particular components

<!--
We should not forget the reason for why we moved in this direction, smaller to manage and deploy applications are a huge bonus.  The ability to increase availability by distributing multiple copies of a service across different machines and even networks gave us scale and availability.  This does not come without a little additional complexity.
-->


---
{layout="14 Title at Top"}

## Common reliability patterns

- Service Discovery
- Load Balancing
- Retries
- Circuit Breaking
- Rate Limiting

<!--
The most common patterns we need to implement in our applications are:
-->


---
{layout="14 Title at Top"}

## Traditionally reliability patterns were implemented using a fat client

INSERT IMAGE

<!--
Traditionally these would be implemented at a code level using a Fat Client approach.  We mentioned Netflix and the Hystrix library, this was the start of the popularization of this approach, Hystrix is written in Java and therefore if you were working in this language you had an amazing library which you could rely on.  The problem is that Microservices enabled teams to choose a multitude of languages.  Front end teams would build services in NodeJS, Ruby could be used, Go became popular, the sadists would use closure, and everyone now seems to be moving to Rust.

-->


---
{layout="14 Title at Top"}

## Problems with fat client implementation

- different library for each language
- not all libraries implement the patterns in the same way
- configuration of patterns differs
- developers had to implement reliability at a code level

<!--
Where this raises a problem is that the different languages may not have a full implementation of all the patterns, or there may be differences in the way that the patterns were implemented.  Certainly you would have different methods to configure each of these reliability patterns and it was down to the developer to implement at a code level. 

-->

---
{layout="14 Title at Top"}

## Solution is to implement a service mesh

- companies like Lyft developed Envoy
- reliability was externalized to a sidecar
- Control Plane allows central configuration

<!--
Companies like Lyft started to look for a better option, the solution was to externalize these patterns into a separate application.  The next problem to solve configuration, this is where the Service Mesh really comes into its own, the Control Plane allows you that central and consistent configuration and the Data Plane allows you to externalize all that boiler plate code.

Lets take a quick overview of each of these patterns and then we can dive in and see how we can leverage them in our example application.
-->


---
{layout="09 Section Title - Consul"}

# Service Discovery

<!--
When we are working in a statically configured environment service discovery could be configured by a known catalog of endpoints, potentially these were also added as DNS entries storing them in a common and accessible location.
-->


---
{layout="14 Title at Top - 2 Col"}

## Service Discovery

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/service_discovery.png)

{.column}

* DNS TTL is too low
* Applications are constantly moving
* Need a dynamic service catalog with active health checking 

<!--
The problem comes when we start to work in the often changing and highly dynamic environments like Kubernetes. In this situation the network location for your application is both dynamically placed not manually configured and often changing.  If you scale you introduce changes, if an application dies and is re-scheduled then the location changes.

Working with manually configured catalogs of service locations, no longer works, even using tooling like DNS servers is no longer practical as often the TTL is far greater than the scheduling.  We needed another way to manage this and tools like Consul and etcd were developed to act as a dynamic service catalog.  Now when an application is started it is automatically registered with the service catalog, when an application needs to call an upstream service it can use this same service catalog to determine the network locations for the service instances.
-->


---
{layout="09 Section Title - Consul"}

# Load balancing

<!--
Load balancing is not a new problem and in fact has been around as long as the modern network.  Where things started to change was how these traditional load balancer could interact with the modern dynamic service catalog
-->


---
{layout="14 Title at Top"}

## Load balancing - Hardware load balancers

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/load_balancing_1.png)

<!--
We moved from this type of setup to...
-->


---
{layout="14 Title at Top"}

## Load balancing - Software load balancers

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/load_balancing_2.png)

<!--
As software architecture started to change so did trends started to change with load balancing teams started to move to software load balancing by leveraging a reverse proxy like NGinx or HAProxy in software.
-->


---
{layout="14 Title at Top"}

## Load balancing - Types of software load balancing

- Server side load balancing
- Client side load balancing

<!--
This approach generally follows two patterns:
-->

---
{layout="14 Title at Top - 2 Col"}

## Load balancing - Server side

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/load_balancing_2.png)

{.column}

- Load balancer configured using Service Catalog
- Standard convention for accessing services
  - [service_name].internal
  - api.internal
  - cache.internal

<!--
With server side load balancing you have a central system in your application which is responsible for routing traffic to the destination.  The load balancer is connected to the service catalog and is installed at a known location.  Often there is a standard convention used for accessing services following standard URI syntax.
-->


---
{layout="14 Title at Top"}

## Load balancing - Server side

**Problems:**
- Configuration is not configurable on a per service basis
- Centralized dependency, if the load balancer is unavailable no service to service communication is possible
- Introduces latency to requests 

<!--
While this approach gives a centralized approach to configuring your service catalog and removes the dependency from the client it does have certain problems.
-->

---
{layout="14 Title at Top - 2 Col"}

## Load balancing - Client side

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/load_balancing_3.png)

{.column}

- Requires developer to implement at a code level

<!--
To solve the problems introduced by the centralized dependency of a server side load balancer, client side load balancing became popular.  One of the initial problems with this was that it required the developer to add bespoke code to their application.
-->


---
{layout="14 Title at Top - 2 Col"}

## Load balancing - Data plane

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/load_balancing_4.png)

{.column}

- Load balancing integrated into the data plane
- Service communicates with data plane via localhost
- data plane automatically configured by the control plane

<!--
Since the introduction of the service mesh we can leverage the power of the data plane to handle all requests for us.
Envoy is configured to expose a local listener for each upstream service which you would like to communicate with.  Your application service then makes a request to localhost rather than directly communicating with the upstream service.
-->

---
{layout="14 Title at Top"}

## Load balancing - Data plane

- Weighted round robin
- Weighted least request
- Ring hash
- Maglev
- Random

<!--
By default Envoy will use round robin with equal weighting as its method of load balancing, there are other configurable options:
-->


---
{layout="14 Title at Top"}

## Load balancing - Weighted round robin

- hosts are selected in round robin order

`a -> b -> a`

- weighting allows endpoints to appear more often

`a -> a -> b -> a`

<!--
This is a simple policy in which each available upstream host is selected in round robin order. If weights are assigned to endpoints in a locality, then a weighted round robin schedule is used, where higher weighted endpoints will appear more often in the rotation to achieve the effective weighting.
-->


---
{layout="14 Title at Top"}

## Load balancing - Weighted least request

- with no weighting Envoy selects two random endpoints and selects one with least traffic
- with weighting, Envoy uses all endpoints and selects the one with highest weight based on an algorithm

<!--
This load balancing uses different algorithms depending on whether weights are assigned to endpoints:

- When no weighting is used then Envoy will select two random endpoints and pick the one which has the least traffic.
- When weighting is applied the Envoy will use all the endpoints in the cluster and selects the one which has the highest weight based on the following algorithm. 
-->


---
{layout="11-3 Code Editor"}

# Weighted least request
## algorithm

```
synthetic weight = (weight / active requests)

e.g.
endpoint 1
  weight: 1
  requests: 3
  synthetic weight: 0.33

endpoint 2
  weight: 2
  requests 7
  synthetic weight: 0.28

endpoint 1 has the highest weight and would be selected
```

<!-- -->


---
{layout="14 Title at Top"}

## Load balancing - Ring hash

- maps each endpoint to a ring by hashing it's address
- request is routed by hashing part of the request and finding nearest host
- useful for Redis with sharded data

<!--
This approach maps each of the endpoints to a ring by hashing its address, each request is then routed to the host by hashing some part of its request and then finding the nearest corresponding host.  Ring has requires that the request has a hashable property in order to correctly direct the request.  One use case for this approach could be sharding data across a Redis cluster, the ring hash would ensure that your request is potentially sent to the server containing the data reducing any forwarding by the destination server.
-->


---
{layout="14 Title at Top"}

## Load balancing - Maglev

- works similar to ring hash
- algorithm faster than ring hash
- as endpoints change double the keys need to move

<!--
Maglev works in a similar way to the Ring hash with the exception that the algorithm is generally faster to lookup endpoints.  The downside compared to ring hash is that when hosts are moved from the cluster double the number of keys move.
-->


---
{layout="14 Title at Top"}

## Load balancing - Random

- selects an endpoint at random
- performs better than round robin when no health checking as it avoids bias on endpoint following failed host

<!--
The random load balancer selects a endpoint at random.  When no health checking is configured the random load balancer generally performs better than round robin as it avoids the bias on the endpoint following a failed host.
-->


---
{layout="11-3 Code Editor"}

# Load balancing
## configuration

```json
{
  "@type": "type.googleapis.com/envoy.api.v2.Listener",
  "name": "public_listener:${POD_IP}:20000",
  "address": {
    "socketAddress": {
      "address": "${POD_IP}",
      "portValue": 20000
    },
  },
  "lb_policy": "ROUND_ROBIN", // default
}
```

<!--
We can configure the cluster for the upstream listener to specify a load balancing algorithm
-->


---
{layout="11-3 Code Editor"}

# Load balancing
## configuration

```json
"route": {
    "cluster": "local_app"
    "weighted_clusters": [
        {
          "clusters": [
            {
              "local_app",
              "weight": 2,
              "metadata_match": {"canary": false }
            },
            {
              "local_app",
              "weight": 1,
              "metadata_match": {"canary": true }
            }
          ],
          "total_weight": 3
        }
    ]
}
```

<!--
Then configure the routing section of the listener to use weighted load balancing 
-->


---
{layout="14 Title at Top"}

## Load balancing - configuration

**Note:**
The endpoint which is returned from the EDS must have the following metadata set in order for this feature to work. `envoy.lb` is a special key which is used by the load balancer.


```

"filter_metadata": {"envoy.lb": {"canary": <bool> }}

```

[https://www.envoyproxy.io/docs/envoy/latest/api-v2/api/v2/route/route.proto#route-weightedcluster](https://www.envoyproxy.io/docs/envoy/latest/api-v2/api/v2/route/route.proto#route-weightedcluster)

<!--
-->

---
{layout="14 Title at Top"}

## Load balancing - statistics

Name	| Type	| Description
--------|-------|----------------
lb_recalculate_zone_structures	| Counter	| The number of times locality aware routing structures are regenerated for fast decisions on upstream locality selection
lb_healthy_panic	| Counter	| Total requests load balanced with the load balancer in panic mode
lb_zone_cluster_too_small	| Counter	| No zone aware routing because of small upstream cluster size
lb_zone_routing_all_directly	| Counter	| Sending all requests directly to the same zone
lb_zone_routing_sampled	| Counter	| Sending some requests to the same zone
lb_zone_routing_cross_zone	| Counter	| Zone aware routing mode but have to send cross zone
lb_local_cluster_not_ok	| Counter	| Local host set is not set or it is panic mode for local cluster
lb_zone_number_differs	| Counter	| Number of zones in local and upstream cluster different
lb_zone_no_capacity_left	| Counter	| Total number of times ended with random zone selection due to rounding error
original_dst_host_invalid	| Counter	| Total number of invalid hosts passed to original destination load balancer

<!-- -->

---
{layout="99-2 Title Clean"}

# Exercise 1

<!-- -->


---
{layout="09 Section Title - Consul"}

# Timeouts

<!--
Timeouts are a really important safety mechanism, they protect your system from backing up requests when things are not working out as planned, we will also see a little later on that reliability patterns are often not used in isolation.  You layer patterns to create the best results.
-->


---
{layout="14 Title at Top"}

## Timeouts

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/timeouts.png)


<!-- 
Timeouts protect your downstream services from queued requests due to a slow running upstream service.  For example, if service b is failing to respond in a timely manner then the requests into service a will start to queue.  Eventually this service too can become overloaded and will fail.  This situation is know as cascading failure.  Correctly configured timeouts allow you to fail fast and potentially retry another instance
-->


---
{layout="11-3 Code Editor"}

# Timeouts 
## configuration

```json
"route": {
  "cluster": "service:emojify-api",
  "timeout": "60s",
}

```

<!--
Timeouts are configured on the http connection manager and apply at a cluster level, Envoy will terminate any connection which exceeds the configured amount.
-->


---
{layout="14 Title at Top"}

## Retries - statistics

| Name                  | Type    | Description                                                |
|-----------------------|---------|------------------------------------------------------------|
| downstream_rq_timeout | Counter | Total requests closed due to a timeout on the request path |

<!-- -->


---
{layout="99-2 Title Clean"}

# Exercise 2

<!-- -->


---
{layout="09 Section Title - Consul"}

# Retries

<!--
A retry is a mechanism which can be used to protect the downstream client from transient failures.  For example, should an upstream request return a 5xx error then the retry policy will attempt the next instance in the cluster.
-->


---
{layout="14 Title at Top"}

## Retries

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/retries.png)

<!--
Caution does need to taken when using retries as it is possible to DDOS your application.  If the application is misbehaving or just performing slow then constant retries can potentially make things worse.
-->


---
{layout="14 Title at Top"}

## Retries - configuration

- guess, check, modify, repeat
- use load testing to determine ideal settings
- retries may need modified as the system changes

<!--
Configuring retries like many reliability patterns should be one of “guess, check, modify, repeat”. That is you should look at your data and approximate what you think is a good retry setting, then you load test your application, validate your assumption and if necessary, modify and repeat the process.  This way you can tune for the best balance, one thing to note is that since system traffic does not stay constant, it is possible that you will need to modify these values.
-->


---
{layout="11-3 Code Editor"}

# Retries
## configuration

```json
"route": {
  "cluster": "service:emojify-api",
  "timeout": "6s", # Maximum time for all retries
  "retry_policy": {
    "retry_on": "5xx",
    "num_retries": 2,
    "per_try_timeout": "2s" # Timeout for each individual retry
  }
}
```

<!-- 
Retries are a cluster level configuration in envoy and are applied to all the endpoints in the cluster
-->


---
{layout="14 Title at Top"}

## Retries - statistics

| Name                       | Type    | Description                                        |
| -------------------------- | ------- | -------------------------------------------------- |
| upstream_rq_retry          | Counter | Total request retries                              |
| upstream_rq_retry_success  | Counter | Total request retry successes                      |
| upstream_rq_retry_overflow | Counter | Total requests not retried due to circuit breaking |

Envoy will output statistics when a retry is attempted, these are prefixed with the following syntax **cluster.[name]** If you are using the configurable parameter on our stats_sink use_default_tags then the name part of the statistic will be replaced with a tag called **envoy_cluster_name**.

[https://www.envoyproxy.io/docs/envoy/latest/api-v2/api/v2/route/route.proto#route-retrypolicy](https://www.envoyproxy.io/docs/envoy/latest/api-v2/api/v2/route/route.proto#route-retrypolicy)


---
{layout="99-2 Title Clean"}

# Exercise 3

<!-- -->


---
{layout="09 Section Title - Consul"}

# Circuit breaking

<!--
Circuit breaking is the process of stopping requests from reaching your endpoints and potentially overloading the system when errors occur. With the traditional Hystrix style pattern an endpoint would be removed from a load balanced set after the responses have exceeded a defined threshold.  
-->


---
{layout="14 Title at Top"}

## Circuit breaking

INSERT IMAGE

<!--
Envoy implements a slightly different pattern which instead opens a circuit when a number of retries to a cluster exceeds a configured value.  This will affect the entire cluster regardless on the number of healthy endpoints and is designed to protect large scale cascading failure.

When there are a number of outstanding retries the circuit will open and all future requests will be automatically rejected until the circuit returns to normal.  This is ideally configured with Outlier Detection.
-->


---
{layout="14 Title at Top"}

## Retries - statistics

| Name            | Type  | Description                                                            |
| --------------- | ----- | ---------------------------------------------------------------------- |
| cx_open         | Gauge | Whether the connection circuit breaker is closed (0) or open (1)       |
| rq_pending_open | Gauge | Whether the pending requests circuit breaker is closed (0) or open (1) |
| rq_open         | Gauge | Whether the requests circuit breaker is closed (0) or open (1)         |
| rq_retry_open   | Gauge | Whether the retry circuit breaker is closed (0) or open (1)            |

Whenever a circuit breaking condition occurs Envoy outputs statistics with the following format **cluster.[name].circuit_breakers.[priority]**

[https://www.envoyproxy.io/docs/envoy/v1.9.0/intro/arch_overview/circuit_breaking](https://www.envoyproxy.io/docs/envoy/v1.9.0/intro/arch_overview/circuit_breaking)

<!-- -->


---
{layout="09 Section Title - Consul"}

# Outlier detection

<!--
Outlier detection in Envoy operates closer to what many may understand as circuit breaking
-->


---
{layout="14 Title at Top"}

## Outlier detection

INSERT IMAGE

<!--
when an endpoint in a load balanced group exceeds a configured tolerance of errors it is temporarily removed from the group as it is assumed to be faulty.
-->


---
{layout="14 Title at Top"}

## Outlier detection

Envoy has two main configurable options for outlier detection, these are:

- consecutive errors 
- periodic success rate

<!--
With consecutive errors once a certain number of consecutive errors from a service has been received then Envoy will remove it from the cluster for a set period of time.  Should a single success be present in a set of errors then Envoy will not consider this as an outlier.
With periodic success then a tolerance rate is set, should the number of successful requests in a period drop beneath the limit then Envoy will remove the endpoint from the Cluster.  This allows for a situation where a service is mostly failing but might be flapping between success and fail.
-->

---
{layout="14 Title at Top"}

## Outlier detection

INSERT IMAGE

<!--
You can use outlier detection in combination with circuit breaking, and retries, the aim is to ensure that the outlier detection evicts the faulty endpoint before the circuit breaker opens.  The circuit breaker is then protecting downstream from cascading failure in case there is a wider problem with the cluster rather than few flapping endpoints.
-->


---
{layout="11-3 Code Editor"}

# Outlier detection
## configuration

```json
"outlier_detection": {
  "consecutive_5xx": 50,
  "base_ejection_time": "60s"
}
```

<!--
Outlier detection is configured on an cluster which is used by an upstream listener, the following example shows how outlier ejection can be configured after 50 consecutive errors with an ejection time of 60 seconds.
-->


---
{layout="14 Title at Top"}

## Outlier detection - statistics

| Name                                           | Type    | Description                                                                   |
| ---------------------------------------------- | ------- | ----------------------------------------------------------------------------- |
| ejections_enforced_total                       | Counter | Number of enforced ejections due to any outlier type                          |
| ejections_active                               | Gauge   | Number of currently ejected hosts                                             |
| ejections_overflow                             | Counter | Number of ejections aborted due to the max ejection %                         |
| ejections_enforced_consecutive_5xx             | Counter | Number of enforced consecutive 5xx ejections                                  |
| ejections_detected_consecutive_5xx             | Counter | Number of detected consecutive 5xx ejections (even if unenforced)             |
| ejections_enforced_success_rate                | Counter | Number of enforced success rate outlier ejections                             |
| ejections_detected_success_rate                | Counter | Number of detected success rate outlier ejections (even if unenforced)        |
| ejections_enforced_consecutive_gateway_failure | Counter | Number of enforced consecutive gateway failure ejections                      |
| ejections_detected_consecutive_gateway_failure | Counter | Number of detected consecutive gateway failure ejections (even if unenforced) |
| ejections_total                                | Counter | Deprecated. Number of ejections due to any outlier type (even if unenforced)  |
| ejections_consecutive_5xx                      | Counter | Deprecated. Number of consecutive 5xx ejections (even if unenforced)          |

When an outlier detection event occurs Envoy outputs the following statistics with the name **cluster.[name].outlier_detection**

[https://www.envoyproxy.io/docs/envoy/latest/configuration/cluster_manager/cluster_stats#outlier-detection-statistics](https://www.envoyproxy.io/docs/envoy/latest/configuration/cluster_manager/cluster_stats#outlier-detection-statistics)
[https://www.envoyproxy.io/docs/envoy/v1.9.0/intro/arch_overview/outlier](https://www.envoyproxy.io/docs/envoy/v1.9.0/intro/arch_overview/outlier)
[https://www.envoyproxy.io/docs/envoy/latest/api-v2/api/v2/cluster/outlier_detection.proto](https://www.envoyproxy.io/docs/envoy/latest/api-v2/api/v2/cluster/outlier_detection.proto)


---
{layout="99-2 Title Clean"}

# Exercise 4

<!-- -->


---
{layout="14 Title at Top"}

## Rate Limiting

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/4-reliability/images/rate_limit.png)


<!--
Rate limiting protects an upstream service from overload by limiting the number of connections or requests that it can receive.  For example given an understanding that the maximum threshold for a cluster is 100 requests/s, using the rate limiter it is possible to stop downstream requests once this limit is exceeded.
Envoy managing rate limiting on a global level across all service instances by leveraging an external rate limiting service.  Circuit breaking can be an extremely effective method of rate limiting a service in certain circumstances however 


https://www.envoyproxy.io/docs/envoy/v1.9.0/configuration/rate_limit
-->
