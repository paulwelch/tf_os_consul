provider "openstack" {
  # assumes OS environment variables
  auth_url = "${ var.os_auth_url }"
}

module "consul_network" {
  source = "../network"

  os_auth_url = "${ var.os_auth_url }"
  count = "${ var.cluster_size }"
  security_group_ids = "${ var.security_group_ids }"
  network_id = "${ var.network_id }"
  env_name_prefix = "${ var.env_name_prefix }"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name = "${ var.env_name_prefix}-${ var.ssh_key_pair_name }"
  public_key = "${ file(var.public_key_file) }"
}

resource "openstack_compute_instance_v2" "consul_cluster" {
  depends_on = [ "module.consul_network" ]
  count = "${ var.cluster_size }"
  name = "${ var.env_name_prefix }-consul-${ count.index + 1 }"
  region = "${ var.region }"
  image_name = "${ var.image_name }"
  flavor_name = "${ var.flavor_name }"
  key_pair = "${ var.env_name_prefix}-${ var.ssh_key_pair_name }"

  network {
    port = "${ module.consul_network.ports[count.index] }"
  }

  connection {
    agent = "true"
    type = "ssh"
    host = "${ module.consul_network.all_fixed_ips[count.index] }"
    user = "core"
    private_key = "${ file(var.private_key_file) }"
  }

provisioner "remote-exec" {
  inline = [
    "${ data.template_file.cluster_bootstrap.*.rendered[count.index] }",
    "${ data.template_file.cluster_health.*.rendered[count.index] }",
    "sudo systemctl start consul"
  ]
}

/*
### This should work for scale-in once issue 14548 is resolved
### https://github.com/hashicorp/terraform/issues/14548
  provisioner "remote-exec" {
    when = "destroy"
    inline = [
      "${ data.template_file.cluster_leave.*.rendered[count.index] }"
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
*/

  user_data = "${ data.template_file.cloud-config.*.rendered[count.index] }"
}
