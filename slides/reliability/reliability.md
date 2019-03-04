---
{layout="01 Main Title - Consul"}

# Service Mesh - Reliability

## Nic Jackson, Christie Koehler, Erik Veld


---
{layout="14 Title at Top"}

## Monoliths communicate in process

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/reliability/images/monolith.png)

<!--
We explained in the first part of this course that with Microservices you break down what would be internal procedure call
-->


---
{layout="14 Title at Top"}

## Microservices communicate across the network

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/reliability/images/microservices.png)

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

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/reliability/images/service_discovery.png)

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

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/reliability/images/load_balancing_1.png)

<!--
We moved from this type of setup to...
-->


---
{layout="14 Title at Top"}

## Load balancing - Software load balancers

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/reliability/images/load_balancing_2.png)

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

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/reliability/images/load_balancing_2.png)

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

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/reliability/images/load_balancing_3.png)

{.column}

- Requires developer to implement at a code level

<!--
To solve the problems introduced by the centralized dependency of a server side load balancer, client side load balancing became popular.  One of the initial problems with this was that it required the developer to add bespoke code to their application.
-->


---
{layout="14 Title at Top - 2 Col"}

## Load balancing - Data plane

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/reliability/images/load_balancing_4.png)

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
{layout="99-2 Title Clean"}

# Exercise 1

<!-- -->
