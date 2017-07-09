output "all_fixed_ips" {
  value = [ "${ openstack_networking_port_v2.consul_ips.*.all_fixed_ips.0 }" ]
}

output "ports" {
  value = [ "${ openstack_networking_port_v2.consul_ips.*.id }" ]
}
