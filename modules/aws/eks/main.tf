data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  aws_region_shortname = replace(data.aws_region.current.name, "/(\\w\\w).*-(\\w).*-(\\d).*$/", "$1$2$3")
  aws_account_id       = data.aws_caller_identity.current.account_id

  string_used_for_fake_ids = sha256(join("", [var.namespace, var.environment, local.aws_region_shortname, var.vpc_id]))

  eks_api_server_endpoint = join(".", [
    "https://${upper(substr(local.string_used_for_fake_ids, 0, 32))}",
    lower(substr(local.string_used_for_fake_ids, 33, 3)),
    data.aws_region.current.name,
    "eks.amazonaws.com"
  ])

  eks_cluster_name = join("-", [var.namespace, var.environment, local.aws_region_shortname, "eks"])

  eks_cluster_arn = join(":", [
    "arn:aws:eks",
    data.aws_region.current.name,
    local.aws_account_id,
    "cluster/${local.eks_cluster_name}"
  ])
}

resource "null_resource" "eks_cluster" {
  triggers = {
    destroy_eks_if_region_changed = data.aws_region.current.name
    destroy_eks_if_name_changed   = local.eks_cluster_name
    destroy_eks_if_vpc_changed    = var.vpc_id
  }
}

#resource "null_resource" "v2_resource" {
#  triggers = {
#    destroy_eks_if_region_changed = data.aws_region.current.name
#    destroy_eks_if_name_changed   = local.eks_cluster_name
#    destroy_eks_if_vpc_changed    = var.vpc_id
#  }
#}
