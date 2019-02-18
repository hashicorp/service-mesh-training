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
{layout="Thank You"}


