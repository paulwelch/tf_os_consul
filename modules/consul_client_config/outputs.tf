output "consul_client_config" {
  value = [ "${ data.template_file.consul-client-cloud-config.*.rendered }" ]
}
