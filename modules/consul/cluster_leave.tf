data "template_file" "cluster_leave" {
  count = "${ var.cluster_size }"

  template = <<EOF
sudo docker run consul:$${ consul_version } consul leave -http-addr=$${host_addr}:8500 }
EOF

  vars {
    consul_version = "${ var.consul_version }"
    cluster_size = "${ var.cluster_size }"
    host_addr = "${ module.consul_network.all_fixed_ips[count.index] }"
  }
}
