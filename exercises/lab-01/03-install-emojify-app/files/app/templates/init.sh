#!/bin/sh

# Process the config
envsubst < /init/envoy_bootstrap.yaml | tee /consul-init/bootstrap.yaml
envsubst < /init/envoy_consul_config.hcl | tee /consul-init/envoy_consul_config.hcl

# Add the consul binary to the shared volume to allow deregistration
cp /bin/consul /consul-init

# Register the service with consul
/bin/consul services register -http-addr=http://${HOST_IP}:8500 /consul-init/envoy_consul_config.hcl
