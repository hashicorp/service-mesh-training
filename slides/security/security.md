---
{layout="01 Main Title - Consul"}

# Service Mesh - Security

## Nic Jackson & Christie Koehler


---
{layout="09 Section Title - Consul"}

# Why?

<!--
Before we dive into the how I think it is really important to understand why, why do we need to secure our Kubernetes networking.  I mean we already have a perimeter firewall right, and we have a decent authentication layer which is protecting us from external threats.
-->


---
{layout="14 Title at Top"}

## Easy to bypass the perimeter by attacking code

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/security/images/bypass.png){pad=100 offset-y=100}

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

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/security/images/vulnerable_service.png){pad=100}



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

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/security/images/firewall.png){pad=100}

<!--
The traditional approach to restrict access to services was to use a perimeter firewall, the fundamental problem with a perimeter firewall is that it assumes that it can not be bypassed and as we have already seen it, it can and potentially by someone with a low level of skill.  I.e. me.
-->


---
{layout="14 Title at Top"}

## We need internal network isolation

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/security/images/network_isolation.png){pad=100}

<!--
What we need to do is to assume that the perimeter has been breached and control access to services in a fine grained way behind the firewall.  What we are attempting to achieve is to reduce the blast radius of an attack and to limit the attackers ability to move laterally.  The first thing an attacker is going to do is to scan for other applications or services.

They are looking for an easy target, is there a service with no authentication, can I attack the authentication of another accessible service to move deeper into the system.  Does the service I currently have access to have too high privilege to an upstream service, i.e access is not segregated based on role or read or write.  A service mesh can indeed help with these issues but first we need to understand the traditional approach and why it just does not work in modern environments
-->


---
{layout="14 Title at Top"}

## Network segmentation 

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/security/images/network_segmentation.png){pad=100}

<!--
With fine-grained network segmentation a network is partitioned into many smaller networks with the intention of reducing the blast radius should an intrusion occur. This approach involves developing and enforcing a ruleset to control the communications between specific hosts and services.

Each host and network should be segmented and segregated at the lowest level which can be practically managed. Routers or layer 3 switches divide a network into separate smaller networks using measures such as Virtual LAN (VLAN) or Access Control Lists (ACLs). Network firewalls are implemented to filter network traffic between segments, and host-based firewalls filter traffic from the local network adding additional security.

If you are operating in a cloud-based environment, network segmentation is achieved through the use of Virtual Private Clouds (VPC) and Security Groups. While the switches are virtualized the approach of configuring ingress rules and ACLs to segment networks is mostly the same as physical infrastructure.
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

## Problem: Dynamic environments result in constantly changing ip addresses and ingress ports

![](https://raw.githubusercontent.com/hashicorp/service-mesh-training/master/slides/security/images/dynamic_environments.png){pad=100}

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
{layout="Thank You"}


