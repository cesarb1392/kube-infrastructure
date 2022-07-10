# https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-20-04
# https://www.phillipsj.net/posts/k3s-enable-nfs-storage/
resource "helm_release" "helm_nfs_provisioner" {
  chart      = "nfs-subdir-external-provisioner"
  name       = "nfs-provisioner"
  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner"
  namespace  = var.namespace

  set {
    name  = "nfs.server"
    value = var.nfs_host
  }
  set {
    name  = "nfs.path"
    value = var.nfs_path
  }
  set {
    name  = "storageClass.name"
    value = "nfs"
  }
  set {
    name  = "storageClass.onDelete"
    value = "delete"
  }
}
