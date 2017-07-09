data "template_file" "cluster_health" {
  count = "${ var.cluster_size }"

  template = <<EOF
until [[ $(curl -q http://$${host_addr}:8500/v1/status/leader 2> /dev/null ) =~ ^\"(([0-9]*)\.){3}[0-9]*:8300\"$ ]]; do \
  sleep 1; \
done; \
EOF

  vars {
    consul_version = "${ var.consul_version }"
    env_name_prefix = "${ var.env_name_prefix }"
    cluster_size = "${ var.cluster_size }"
    host_addr = "${ module.consul_network.all_fixed_ips[count.index] }"
    seed_addr = "${ module.consul_network.all_fixed_ips[0] }"
  }
}
