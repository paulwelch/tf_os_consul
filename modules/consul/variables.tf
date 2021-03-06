variable "os_auth_url" {
  type = "string"

  description = <<EOF
OpenStack authentication URL for the API. NOTE: Some OS environments require /v3 in the URL to correctly identify API version.
EOF
}

variable "public_key_file" {
  type = "string"

  description = <<EOF
Path to public key file to use on VM instances for SSH access.
EOF
}

variable "private_key_file" {
  type = "string"

  description = <<EOF
Path to private SSH key file to use for provisioning VM instances.
EOF
}

variable "do_bootstrap" {
  type = "string"

  description = <<EOF
Set to 1 to bootstrap a new cluster or 0 to join to existing cluster.
EOF
}

variable "cluster_size" {
  type = "string"

  description = <<EOF
Number of consul instances for cluster.  Should be an odd number for quorum.
EOF
}

variable "region" {
  type = "string"

  description = <<EOF
OS Region ID.
EOF
}

variable "image_name" {
  type = "string"

  description = <<EOF
OS Image Name for VM instances.
EOF
}

variable "flavor_name" {
  type = "string"

  description = <<EOF
OS Flavor Name for VM instances.
EOF
}

variable "ssh_key_pair_name" {
  type = "string"

  description = <<EOF
Name of keypair to create in OS.
EOF
}

variable "security_group_ids" {
  type = "list"

  description = <<EOF
OS Security Groups ID's.
EOF
}

variable "network_id" {
  type = "string"

  description = <<EOF
OS Network ID.
EOF
}

variable "consul_version" {
  type = "string"

  description = <<EOF
consul Container version to pull.
See versions here: https://quay.io/repository/coreos/consul?tab=tags
EOF
}

variable "env_name_prefix" {
  type = "string"

  description = <<EOF
Prefix for environment to use on OS names.  This allows you to create
more than one cluster with unique naming.
EOF
}
