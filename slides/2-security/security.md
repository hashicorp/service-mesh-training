---
{layout="01 Main Title - Consul"}

# Service Mesh - Security

## Nic Jackson & Christie Koehler & Erik Veld


---
{layout="09 Section Title - Consul"}

# Why?

<!--
Before we dive into the how I think it is really important to understand why, why do we need to secure our Kubernetes networking.  I mean we already have a perimeter firewall right, and we have a decent authentication layer which is protecting us from external threats.
-->


---
{layout="14 Title at Top"}

## Easy to bypass the perimeter by attacking code

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/bypass.png){pad=100 offset-y=100}

<!--
What if I told you that an attacker could quite possibly by pass that external defence, that they had the possibility to gain access to the internal network without even trying to touch external firewall but by looking for application code level vulnerabilities which allows them direct access to your internal systems?

You might believe me, you might say no chance, you might say I have heard about this approach but it would never happen to me we patch our systems regularly and take a secure code review of the application code we write. 
-->


---
{layout="09 Section Title - Consul"}

# "One of the key phases in most targeted attacks is what’s known as lateral movement. Attackers rarely luck out and manage to immediately compromise the computer"{style="font-size: 72"}
## Symantec Internet Threat Report 2018

<!--
This lateral movement is the key thing here, I love this quote from the Symantec security report.

“SHOW QUOTE, blah blah, most attackers do not luck out and get what they need first time, most attacks are due to lateral movement in a system.”
-->


---
{layout="14 Title at Top"}

## Example attack on vulnerable service

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/vulnerable_service_1.png){pad=100}



---
{layout="06-1 (C)SR Case Study Challenge"}

# Two factors which allowed lateral movement

* Open network access
* Traffic between services are not encrypted

<!--
We have two real problems here:
open network access 


traffic sent between services not encrypted
-->

---
{layout="09 Section Title - Consul"}

# Problem 1:  Open network access

<!--
Let’s address the first problem with open network access, we have already discussed that an attacker is going to attempt to move laterally inside your system.
-->


---
{layout="14 Title at Top"}

## Traditional approach to security was a perimeter firewall

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/firewall.png){pad=100}

<!--
The traditional approach to restrict access to services was to use a perimeter firewall, the fundamental problem with a perimeter firewall is that it assumes that it can not be bypassed and as we have already seen it, it can and potentially by someone with a low level of skill.  I.e. me.
-->


---
{layout="14 Title at Top"}

## We need internal network isolation

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/network_isolation.png){pad=100}

<!--
What we need to do is to assume that the perimeter has been breached and control access to services in a fine grained way behind the firewall.  What we are attempting to achieve is to reduce the blast radius of an attack and to limit the attackers ability to move laterally.  The first thing an attacker is going to do is to scan for other applications or services.

They are looking for an easy target, is there a service with no authentication, can I attack the authentication of another accessible service to move deeper into the system.  Does the service I currently have access to have too high privilege to an upstream service, i.e access is not segregated based on role or read or write.  A service mesh can indeed help with these issues but first we need to understand the traditional approach and why it just does not work in modern environments
-->


---
{layout="14 Title at Top"}

## Network segmentation 

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/network_segmentation.png){pad=100}

<!--
With fine-grained network segmentation a network is partitioned into many smaller networks with the intention of reducing the blast radius should an intrusion occur. This approach involves developing and enforcing a ruleset to control the communications between specific hosts and services.

Each host and network should be segmented and segregated at the lowest level which can be practically managed. Routers or layer 3 switches divide a network into separate smaller networks using measures such as Virtual LAN (VLAN) or Access Control Lists (ACLs). Network firewalls are implemented to filter network traffic between segments, and host-based firewalls filter traffic from the local network adding additional security.

If you are operating in a cloud-based environment, network segmentation is achieved through the use of Virtual Private Clouds (VPC) and Security Groups. While the switches are virtualized the approach of configuring ingress rules and ACLs to segment networks is mostly the same as physical infrastructure.
-->


---
{layout="14 Title at Top"}

## Service segmentation 

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/service_segmentation.png){pad=100}

<!--
Where network segmentation is concerned with securing traffic between zones, service segmentation secures traffic between services in the same zone. Service segmentation is a more granular approach and is particularly relevant to multi-tenanted environments such as schedulers where multiple applications are running on a single node.

Implementing service segmentation depends on your operating environment and application infrastructure. Service segments are often applied through the configuration of software firewalls, software defined networks such as the overlay networks used by application schedulers, and more recently by leveraging a service mesh.

Like network segmentation, the principle of least privilege is applied and service to service communication is only permitted where there is an explicit intention to allow this traffic.
-->


---
{layout="14 Title at Top"}

## Problem: Dynamic environments result in constantly changing ip addresses and ingress ports

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/dynamic_environments.png){pad=100}

<!--
As long as there have been networks this problem has existed, the concepts of Network Segmentation and Segregation have been around for a long time.

Network segmentation is a highly effective strategy to limit the impact of network intrusion. However, in modern environments such as a cluster scheduler, applications are started and restarted often without operator intervention. This dynamic provisioning results in constantly changing IP addresses, and application ingress ports. Segmenting these dynamic environments using traditional methods of firewalls and routing can be very technically challenging.
-->


---
{layout="14 Title at Top"}

## Definition of a dynamic environment

* Applications and infrastructure subject to frequent changes
* Subject to auto scaling or automated instance replacement
* Applications running in a scheduler like Kubernetes

<!--
In the simplest terms, a dynamic environment is one where applications and infrastructure are subject to frequent changes, either manually through regular deployments and infrastructure changes, or without operator intervention triggered by auto scaling or automated instance replacement. Operating a scheduler like HashiCorp Nomad or Kubernetes exhibits this behaviour, as does leveraging the automated redundancy of autoscaling groups provided by many cloud providers. The effect, however, is not limited to cloud environments, any platform such as vSphere configured in a highly available mode can also be classified as a dynamic environment.

It is dynamic environments which cause us the greatest problem from a network security perspective.
-->


---
{layout="14 Title at Top"}

## Problems with network and service segmentation in dynamic environments

* Application deployment is disconnected from the network configuration
* Applications are scheduled in a modern scheduler

<!--
Dynamic networks pose a number of problems when attempting to implement network and service level segmentation
-->


---
{layout="14 Title at Top"}

## Application deployment is disconnected from the network configuration

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/application_deployment_1.png){pad=100}

<!--
When applications are deployed using an autoscaling group, and a new instance is created, it is generally dynamically assigned an IP address from a pre-configured block. This particular application is rarely going to be running in isolation and needs to access services running inside the same network segment, and potentially another network segment. If we had taken a hardened approach to our network security, then there would be strict routing rules between the two segments which only allow traffic on a predefined list. In addition to this, we would have host level firewalls configured on the upstream service which again would only allow specific traffic.

In a static world, this was simpler to solve as the application is deployed to a known location. The routing and firewalls rules could be updated at deploy time to enable the required access.
-->


---
{layout="14 Title at Top"}

## Application deployment is disconnected from the network configuration

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/application_deployment_2.png){pad=100}

<!--
In a dynamic world, there is a disconnect, the application is deployed independently to configuring network security and the allocated IP address, and potentially even ports are dynamic. Typically there is a manual process of updating the network security rules, which can slow down deployments.
-->


---
{layout="14 Title at Top"}

## Applications are scheduled in a modern scheduler

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/application_deployment_3.png){pad=100}

<!--
In this case, we also need to consider how applications inside the scheduler communicate with other network services. For example, you have a one hundred node cluster and one of your application instances needs to talk to a service in another network segment. The application running in the scheduler could be running on any of the one hundred nodes. This makes it challenging to determine which IP should be whitelisted. A scheduler often moves applications between nodes dynamically, and this causes a constant requirement for routing and firewall rules to be updated.

One of the unfortunate side effects of this complexity can be that security is relaxed, network segmentation is reduced to blocks of routing rules rather than absolute addresses. Entire clusters are allowed routing rather than just the nodes which are running specific applications. And from a service perspective, too much trust is applied to a local network segment. From a security perspective this is suboptimal and increases the applications attack surface, there needs a consistent and centralized way to manage and understand network and service segmentation.
-->


---
{layout="14 Title at Top"}

## Network / Service segmentation with intention based security

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/application_deployment_4.png){pad=100}

<!--
The solution to the complexity and to increase our network security is to remove the need to configure location based security rules and move to an Intention-based model. Intention-based security builds rules on identity rather than location. For example, we can define an intention which states that the front-end service needs to communicate with the payment service.

Defining network segmentation through Intentions alleviates the complexity of traditional network segmentation and allows tighter control of network security rules. With Intentions, you describe security at an application level, not a network location level.
-->


---
{layout="99-2 Title Clean"}

# Exercise 1

<!-- -->


---
{layout="09 Section Title - Consul"}

# Problem 2: Traffic between services is not encrypted

<!--
The reason we encrypt traffic between the client and the server is so that nobody can read this data if it is intercepted it in transit.  This is a known problem there are e number of ways to do this from simply snooping insecure hotel wifi and networks, fake wifi hotspots, and even more advanced techniques such as intercepting traffic inside the datacenter.

Where TLS keeps that traffic safe is that the data is encrypted between the client and the termination point.
-->


---
{layout="14 Title at Top"}

## Example attack on vulnerable service

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/vulnerable_service_2.png){pad=100}

<!--
Where things start to fall down is that data is encrypted from the client to the termination point.  In many systems this is not the destination service but an external router or load balancer.  Traffic is often forwarded on in an unencrypted form to the destination service.  We have already seen that it is possible to bypass the firewall and gain access to the system.  If I can read your systems traffic from the wire in an unencrypted form then potentially I do not need to to go any deeper into your system.  Consider this flow, I have a front end application where I submit payment information, actually the payment system and the database which it uses is incredibly well protected, the passwords are strong the data is encrypted at rest and the system has access correctly configured in terms of read and write.  The data contained within this system is incredibly lucrative for me as an attacker, I can get names addresses, credit card numbers, expiry and CVC numbers.  It is the holy grail.  And you as developers and operators have done an incredible job at securing it, in fact such a great job I can not break the system.

Except, I don’t need to, if you are not securing the data between your edge and your internal services then I can read this data straight off the wire before it even hits the payment system.  Yes this is slower than exporting a mother load of information from the database but it all depends on how long I am in your system before I get detected.
-->


---
{layout="09 Section Title - Consul"}

# "it takes on average 180 days, to detect a breach"

<!--
Owasp states that it takes on average 180 days, yes 180 days for an attack to be detected.  If you consider a recent attack on a major airline which used a harvesting approach rather than an attack on a database over half a million credit card details were exposed.  Ok this particular attack injected a vulnerability client side but what I am trying to get across is that that there is potentially a huge amount of sensitive data which flows through your systems.  A huge amount of data which I am sitting quietly collecting.
-->


---
{layout="14 Title at Top"}

## Implementing and managing certificates is hard. Reality, a service mesh can do all this for you

* You need to manage a Certificate Authority (CA)
* Have to distribute, and rotate certificates and keys
* Application code needs to be changed to handle TLS termination

<!--
The second point I will however concede is not so easy, you need to manage a certificate authority distribute keys and certificates to applications, change application code so that your servers terminate with TLS.  You need to rotate certificates and keys, understand how you are going to manage the lifecycle of your application when this rotation takes place.  Not impossible but not easy.  This is where the service mesh excels, the mesh managed the certificates, delivery, rotation and termination, you just add an additional sidecar.
-->


---
{layout="14 Title at Top - 2 Col"}

## Data plane - How Connect Secures Traffic

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/data_plane_1.png){pad=100}

{.column}

1. Envoy contacts the local Consul client to obtain certificates and keys required to enable Mutual TLS, this is through a bi-directional gRPC connection using Envoys xDS admin API

<!--
-->


---
{layout="14 Title at Top - 2 Col"}

## Data plane - How Connect Secures Traffic

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/data_plane_2.png){pad=100}

{.column}

2. The Consul client creates the x509 certificate containing the SPIFFE id for the proxy
3. It requests this certificate to be signed by the Consul server

<!--
-->


---
{layout="14 Title at Top - 2 Col"}

## Data plane - How Connect Secures Traffic

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/data_plane_3.png){pad=100}

{.column}

4. The certificate and key bundle is sent back to the proxy which it uses to secure the inbound connection and identify itself for outbound connections

<!--
-->


---
{layout="14 Title at Top - 2 Col"}

## Data plane - How Connect Secures Traffic

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/data_plane_4.png){pad=100}

{.column}

5. The client starts a blocking connection to the server and waits for any updates to intentions or certificates
6. Envoy listens for changes using the xDS API implemented in Consul

<!--
-->


---
{layout="14 Title at Top - 2 Col"}

## Data plane - How Connect Secures Traffic

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/data_plane_5.png){pad=100}

{.column}

7. Client initiates request and performs TLS Handshake
8. Upstream service requests client certificate as part of mTLS request, validating cert is signed by valid source

<!--
-->


---
{layout="14 Title at Top - 2 Col"}

## Data plane - How Connect Secures Traffic

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/data_plane_6.png){pad=100}

{.column}

9. Envoy validates that the connections is allowed by calling the ext_authz filters api (once per new connection)
10. If allowed the request is passed to the upstream service
11. Send the response to the caller

<!--
-->


---
{layout="14 Title at Top"}

## How do we segment the network?

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/segment_1.png){pad=100}

<!--
We discussed this problem before that we had limited capability to lock down our network to a particular node due to the dynamic way the scheduler operates, so how do we solve this problem with Consul Connect?

The truth is we don't have to
-->


---
{layout="14 Title at Top"}

## How do we segment the network?

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/2-security/images/segment_2.png){pad=100}

<!--
Yes we have open network access to our service running in segment b but since we are securing things with connect this is OK, the ports for service B are accessible and open but they are secured automatically with service intentions and the connect proxy.  Let's take a deeper dive at how connect works to understand how things are secure.
-->


---
{layout="99-2 Title Clean"}

# Exercise 2

<!-- -->


---
{layout="09 Section Title - Consul"}

# Summary

<!--
-->


---
{layout="14 Title at Top"}

## Implementing and managing certificates is hard - Reality, Consul Connect can do all this for you

* You need to manage a Certificate Authority (CA)
* Have to distribute, and rotate certificates and keys
* Application code needs to be change to handle TLS termination
* Consul Connect has a built in CA, capable of leveraging HashiCorp Vault
* Consul Connect manages key and certificate rotation
* Sidecar proxy terminates TLS and implements Authz, no code changes

<!--
-->


---
{layout="14 Title at Top"}

## Service and Network segmentation in Dynamic environments is hard - Reality, Consul Connect can do all this for you

* Managing routing and firewall rules when application locations keep changing
* Maintaining millions of rules in a large environment
* Open networks due to complexity
* Manage service policy through intentions
* Leverage mTLS to service to service authorization

<!--
-->
