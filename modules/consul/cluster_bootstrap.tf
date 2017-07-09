data "template_file" "cluster_bootstrap" {
  count = "${ var.cluster_size }"

  template = <<EOF
sudo docker run \
  -d \
  --net=host \
  -v /$${env_name_prefix}-consul-${count.index+1}/data:/consul/data \
  --name consul consul:$${consul_version} \
  consul agent -server $${bootstrap_params}\
    -ui \
    -data-dir=/consul/data \
    -bind=0.0.0.0 \
    -client=0.0.0.0 \
    -advertise=$${host_addr} \
    -retry-join=$${seed_addr}
EOF

  vars {
    consul_version = "${ var.consul_version }"
    env_name_prefix = "${ var.env_name_prefix }"
    cluster_size = "${ var.cluster_size }"
    host_addr = "${ module.consul_network.all_fixed_ips[count.index] }"
    seed_addr = "${ module.consul_network.all_fixed_ips[0] }"
    bootstrap_params = "${ data.template_file.bootstrap_params.*.rendered[count.index] }"
  }
}

### The do_bootstrap=0 param should work for scale-out once issue 14548 is resolved
### https://github.com/hashicorp/terraform/issues/14548
data "template_file" "bootstrap_params" {
  count = "${ var.do_bootstrap * var.cluster_size }"

  template = "-bootstrap-expect=$${cluster_size} "

  vars {
    bootstrap_count = "${ var.do_bootstrap * var.cluster_size }"
    cluster_size = "${ var.cluster_size }"
  }
}
