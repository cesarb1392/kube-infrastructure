resource "kubectl_manifest" "this" {

  override_namespace = var.namespace
  yaml_body = file("${path.module}/install.yaml")
}
