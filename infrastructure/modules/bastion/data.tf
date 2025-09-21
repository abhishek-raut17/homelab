# Data for bastion module
data "linode_images" "linux_image" {
  filter {
    name   = "id"
    values = [var.bastion_node_img]
  }
  filter {
    name   = "is_public"
    values = ["true"]
  }
  filter {
    name   = "deprecated"
    values = ["false"]
  }
}