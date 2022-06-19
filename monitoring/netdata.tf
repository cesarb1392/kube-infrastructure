resource "helm_release" "netdata" {
  chart      = "netdata"
  name       = "netdata"
  repository = "https://netdata.github.io/helmchart"
  namespace  = var.namespace

}
