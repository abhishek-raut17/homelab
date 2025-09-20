# Data for bastion module
data "linode_images" "linux_image" {
  filter {
    name   = "label"
    values = [var.bastion_node_img]
  }
}