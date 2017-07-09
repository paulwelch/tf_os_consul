variable "consul_version" {
  type = "string"

  description = <<EOF
consul Container version to pull.
See versions here: https://quay.io/repository/coreos/consul?tab=tags
EOF
}

variable "data_dir" {
  type = "string"

  description = <<EOF
Host OS path to store data. This will be mounted in the container as /consul/data
EOF
}

variable "client_ip" {
  type = "string"

  description = <<EOF
Client IP's for local host using this config to connect to the cluster.
EOF
}

variable "server_ips" {
  type = "list"

  description = <<EOF
List of cluster server IP's used for the client to connect to the cluster.
EOF
}
