output "consul_endpoints" {
  value = [ "${ module.consul_network.all_fixed_ips }" ]
}
