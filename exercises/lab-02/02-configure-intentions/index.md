# Lab 02, Exercise 02: Configure Intentions

**Objective:**

## Background

Intentions define access control for services via Connect and are used
to control which services may establish connections. Intentions can be
managed via the API, CLI, or UI.

Intentions are enforced by the [proxy](/docs/connect/proxies.html)
or [natively integrated application](/docs/connect/native.html) on
inbound connections. After verifying the TLS client certificate, the
[authorize API endpoint](#) is called which verifies the connection
is allowed by testing the intentions. If authorize returns false the
connection must be terminated.

The default intention behavior is defined by the default
[ACL policy](/docs/guides/acl.html). If the default ACL policy is "allow all",
then all Connect connections are allowed by default. If the default ACL policy
is "deny all", then all Connect connections are denied by default.


## Step 1 Add deny all rule

## Step 2: Add individual intentions

