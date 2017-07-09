data "template_file" "cloud-config" {
  count = "${ var.cluster_size }"

  template = <<EOF
#cloud-config

---
coreos:
  units:
    - name: docker.service
      command: start

    - name: consul.service
      content: |
        [Unit]
        Description=consul
        Requires=docker.service

        [Service]
        Restart=always
        ExecStartPre=-/usr/bin/docker stop consul
        ExecStartPre=-/usr/bin/docker rm -f consul
        ExecStart=/usr/bin/docker run --net=host -v /$${env_name_prefix}-consul-${count.index+1}/data:/consul/data --name consul consul:$${consul_version} consul agent -server -ui -data-dir=/consul/data -bind=$${host_addr} -client=$${host_addr}
        ExecStop=/usr/bin/docker rm -f consul
EOF

  vars {
    consul_version = "${ var.consul_version }"
    env_name_prefix = "${ var.env_name_prefix }"
    cluster_size = "${ var.cluster_size }"
    host_addr = "${ module.consul_network.all_fixed_ips[count.index] }"
  }
}
