# Data for compute module
data "linode_images" "talos_image" {
  filter {
    name   = "id"
    values = [var.cluster_node_img]
  }
}

data "linode_instance_type" "cluster_node_instance_type" {
  id = var.k8s_node_type_id
}