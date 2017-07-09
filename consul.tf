variable "os_auth_url" { }
variable "public_key_file" { }
variable "private_key_file" { }
variable "do_bootstrap" { }
variable "cluster_size" { }
variable "region" { }
variable "image_name" { }
variable "flavor_name" { }
variable "ssh_key_pair_name" { }
variable "security_group_ids" { type="list" }
variable "network_id" { }
variable "consul_version" { }
variable "env_name_prefix" { }

#####################################################################

module "consul" {
  source = "./modules/consul"

  public_key_file = "${ var.public_key_file }"
  private_key_file = "${ var.private_key_file }"
  os_auth_url = "${ var.os_auth_url }"
  do_bootstrap = "${ var.do_bootstrap }"
  cluster_size = "${ var.cluster_size }"
  region = "${ var.region }"
  image_name = "${ var.image_name }"
  flavor_name = "${ var.flavor_name }"
  ssh_key_pair_name = "${ var.ssh_key_pair_name }"
  security_group_ids = "${ var.security_group_ids }"
  network_id = "${ var.network_id }"
  consul_version = "${ var.consul_version }"
  env_name_prefix = "${ var.env_name_prefix }"
}

module "consul_client_config" {
  source = "./modules/consul_client_config"

  consul_version = "${ var.consul_version }"
  data_dir = "/tmp/consul/data"
  server_ips = "${ module.consul.consul_endpoints }"
  client_ip = "[INSERT CLIENT IP HERE]"
}

#####################################################################

output "consul_endpoints" {
  value = [ "${ module.consul.consul_endpoints }" ]
}

output "consul_client_config" {
  value = [ "${ module.consul_client_config.consul_client_config }" ]
}
