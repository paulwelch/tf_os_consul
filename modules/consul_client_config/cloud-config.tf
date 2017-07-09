###
# A sample cloud-init to run the consul agent in client mode preconfigured to
# connect to the cluster. NOTE: depending on your network interface and OS, you
# may need to add/change parameter: -advertise=[IP ADDRESS]
###

data "template_file" "consul-client-cloud-config" {

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
        ExecStart=/usr/bin/docker run --net=host -v $${data_dir}:/consul/data --name consul consul:$${consul_version} consul agent -data-dir=/consul/data -bind=0.0.0.0 -client=0.0.0.0 -advertise=$${client_ip} $${retry_join_params}
        ExecStop=/usr/bin/docker rm -f consul
EOF

  vars {
    consul_version = "${ var.consul_version }"
    data_dir = "${ var.data_dir }"
    client_ip = "${ var.client_ip }"
    retry_join_params = "${ data.template_file.retry_join_params.*.rendered[0] }"
  }
}

data "template_file" "retry_join_params" {

  template = "$${list_of_params}"

  vars {
    list_of_params = "${ join(" ", data.template_file.param.*.rendered) }"
  }
}

data "template_file" "param" {
  count = "${ length(var.server_ips) }"

  template = "-retry-join=$${server_addr}"

  vars {
    server_addr = "${ var.server_ips[count.index] }"
  }
}
