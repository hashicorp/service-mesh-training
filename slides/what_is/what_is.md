---
{layout="01 Main Title - Consul"}

# Service Mesh - What is a Service Mesh

## Nic Jackson & Christie Koehler


---
{layout="09 Section Title - Consul"}

# What is a Service Mesh

<!--
Stuff goes here, slides removed from my security deck
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
The data plane is typically a local proxy which runs as a sidecar to your application.  The data plane terminates all TLS connections and managed Authorisation for requests against the policy and service graph in the Control Plane.  In addition to this the Data plane often will replace the fat client which you would traditionally implement via a library such as Netflix’s Hystrix client.
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
Communication to the server is carried out through the local client, typically there is one of these running for each virtual machine or node in kubernetes.  The agent manages service registration, query of the service catalog, DNS interface, access to the key value and interaction with the Connect feature.  It understands the topology of the cluster including the state of the server and location of server nodes.  There is no need to manually load balance requests to the Consul server the local agent manages all this for you.
-->
