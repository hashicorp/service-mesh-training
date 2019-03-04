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

