services {
  id   = "emojify-website-68b95bf46f-lqgcq-emojify-website-proxy"
  name = "emojify-website-proxy"
  kind = "connect-proxy"
  address = "${POD_IP}"
  port = 20000

  proxy {
    destination_service_name = "emojify-website"
    destination_service_id = "emojify-website"
    local_service_address = "127.0.0.1"
    local_service_port = 5000
  }

  checks {
    name = "Proxy Public Listener"
    tcp = "${POD_IP}:20000"
    interval = "10s"
    deregister_critical_service_after = "10m"
  }

  checks {
    name = "Destination Alias"
    alias_service = "emojify-website"
  }
}

