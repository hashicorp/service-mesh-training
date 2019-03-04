---
{layout="01 Main Title - Consul"}

# Service Mesh, QCon London 2019
## Nic Jackson, Christie Koehler, Erik Veld

---
{layout="14 Title at Top"}

## Introductions

* Nic Jackson (@sheriffjackson)
* Christie Koehler (@christi3k)
* Erik Veld (erikveld)

We're all Developer Advocates at HashiCorp!

<!--
TODO: Figure out if there is a straight-forward way to add our photos to this slide.
-->

---
{layout="14 Title at Top"}

## Housekeeping & Schedule

<!--
TODO: Determine what we want to include here, if anything.
- Where to find workshop content.
- Our contact info.
- How to ask questions.
- Schedule (or should this be on it's own slide?
-->


---
{layout="14 Title at Top"}

## Technologies this workshop

* Envoy (data plane)
* Consul Connect (control plane)
* Prometheus (metrics database)
* Grafana (metrics dashboard)
* Kubernetes (scheduler)

<!--
Today we'll be using the following to teach the principles of service mesh.

Regardless if you are using Consul Connect or Istio as your control plane most of the features such as the reliability patterns, security, and observability happen with Envoy. The control plane is responsible for configuring the data plane and providing service to service authorization and TLS certificates but the bulk of this course will concentrate on your understanding of Envoy. Understanding the underlying concepts of Envoy and its raw configuration will help greatly when you attempt to successfully deploy and operate your service mesh. Regarding the control plane, we have chosen Consul as we believe it is the easiest to install and understand. It is also the Control Plane that we understand the most.
-->

---
{layout="14 Title at Top"}

## Workshop goal

Excellent general understanding of service mesh concepts you can apply regardless of specific technology choices.

<!--
There will be some specifics but we hope that you will be able to walk away from this course with an excellent general understanding of concepts which you will later be able to apply regardless of your technological choice.
-->

---
{layout="01 Main Title - Consul"}

# Part 1: What is a Service Mesh

---
{layout="09 Section Title - Consul"}

# What is a Service Mesh

<!--
TODO: Determine which layout to use, this one or the previous one.
-->

---
{layout="09 Section Title - Consul"}

# Dynamic Environments

<!--
What really makes a service mesh necessary are dynamic environments, which are becominging increasingly common, whether your organization's infrastructure is primarily on-prem, in the cloud, or some mix of each. 

What do we mean by "dynamic environments"?
-->

---
{layout="14 Title at Top"}

## Definition of a dynamic environment

* Applications and infrastructure subject to frequent changes
* Subject to auto scaling or automated instance replacement
* Applications running in a scheduler like Kubernetes


<!--
In the simplest terms, a dynamic environment is one where applications and infrastructure are subject to frequent changes, either manually through regular deployments and infrastructure changes, or without operator intervention triggered by auto scaling or automated instance replacement. Operating a scheduler like HashiCorp Nomad or Kubernetes exhibits this behaviour, as does leveraging the automated redundancy of autoscaling groups provided by many cloud providers. The effect, however, is not limited to cloud environments, any platform such as vSphere configured in a highly available mode can also be classified as a dynamic environment.
-->

---
{layout="14 Title at Top"}

## Service mesh solutions

* Istio
* Consul
* Linkerd/2
* AWS App Mesh
* nginx
* Tigera
* and more...

<!--

So "service mesh" is the infrastructure layer that addresses these new challenges of dynamic environments. Examples of service meshes are Istio, Consul, AWS App Mesh, Linkerd, nginx, Tigera, etc. 

In this workshop we'll be using Consul as the service mesh for our lab exercises. The theory we'll be teaching is applicable to any service mesh (or all service meshes in general?).

-->

---
{layout="14 Title at Top"}

## Components of a service mesh

* service _discovery_
* service _segmentation_
* service _configuration_

<!--

Generally speaking, service meshes have three main components: Service discovery, service segmentation, service configuration. Let's take a quick look at each one of these.

-->


---
{layout="14 Title at Top"}

## Service discovery

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/what_is/images/service_registry.png){pad=100}

<!--
Service discovery is the detection of services available within a given network (infrastructure?). In environments where application deployments are dynamic, services need a way to both discover other needed services and to make themselves discoverable. 

One of the ways this is accomplished is with a service **registry**. Services register themselves with the registry when then become available and query the registry when they need to access a given service. The registry stores information about services including where on the network they are running. (TODO: anything else key about registries to mention here?)

Service registries often also implement health checks for cataloged services.
-->

---
{layout="14 Title at Top"}

## Service segmentation

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/security/images/service_segmentation.png){pad=100}

<!--
Where network segmentation is concerned with securing traffic between zones, service segmentation secures traffic between services in the same zone. Service segmentation is a more granular approach and is particularly relevant to multi-tenanted environments such as schedulers where multiple applications are running on a single node.

Implementing service segmentation depends on your operating environment and application infrastructure. Service segments are often applied through the configuration of software firewalls, software defined networks such as the overlay networks used by application schedulers, and more recently by leveraging a service mesh.

Like network segmentation, the principle of least privilege is applied and service to service communication is only permitted where there is an explicit intention to allow this traffic.
-->

---
{layout="14 Title at Top"}

## Service configuration

<!--

Centralized configuration management, usually through a key/value store.

Those of you using Kubernetes will be using etcd for this. Those of you not using Kubernetes, may still need a service configuration solution, which Consul provides.

-->


---
{layout="14 Title at Top"}

## Service Mesh Architecture

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/what_is/images/architecture_1.png){pad=100}

<!--
A service mesh is traditionally built from two main components:
Control plane, Consul, Linkerd2 (Conduit), Itsio


Data plane, Envoy, Consul Connect Proxy, Linkerd-Proxy
-->


---
{layout="14 Title at Top"}

## Service Mesh Architecture - Control Plane

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/what_is/images/architecture_2.png){pad=100}

<!--
-->


---
{layout="14 Title at Top"}

## Service Mesh Architecture - Data Plane

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/what_is/images/architecture_3.png){pad=100}

<!--
The data plane is typically a local proxy which runs as a sidecar to your application. The data plane terminates all TLS connections and managed Authorisation for requests against the policy and service graph in the Control Plane. In addition to this the Data plane often will replace the fat client which you would traditionally implement via a library such as Netflix’s Hystrix client.
-->


---
{layout="14 Title at Top"}

## Service Mesh Architecture - Data Plane

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/what_is/images/architecture_4.png){pad=100}


---
{layout="14 Title at Top"}

## Consul Architecture - Service -> Consul Communication

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/what_is/images/architecture_5.png){pad=100}

<!--
Communication to the server is carried out through the local client, typically there is one of these running for each virtual machine or node in kubernetes. The agent manages service registration, query of the service catalog, DNS interface, access to the key value and interaction with the Connect feature. It understands the topology of the cluster including the state of the server and location of server nodes. There is no need to manually load balance requests to the Consul server the local agent manages all this for you.
-->

---
{layout="14 Title at Top"}

## Service mesh benefits

* security
* observability
* reliability

<!--
TODO: Add clear definitions for each of the three terms.
-->

---
{layout="14 Title at Top"}

## Workshop infrastructure overview

<!--
TODO: Create and include a snazzy diagram explaining workshop infrastructure. Possibly use multiple slides to show infrastructure at each stage of lab to demonstrate how we'll use it to demonstrate 3 main benefits of service mesh.
-->

---
{layout="14 Title at Top"}

## Lab 0: Get started

- 1. Login to Instruqt and get familiar with environment
- 2. Install Consul with helm chart
- 3. Install emojify app.
- 4. Install Prometheus and Grafana
- 5. Configure Grafana

<!--
-->

