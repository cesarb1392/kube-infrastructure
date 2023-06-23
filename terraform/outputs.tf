output "modules_enabled" {
  value = keys(local.available_namespaces)
}
