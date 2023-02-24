data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

locals {
  aws_region_shortname = replace(data.aws_region.current.name, "/(\\w\\w).*-(\\w).*-(\\d).*$/", "$1$2$3")
  aws_account_id       = data.aws_caller_identity.current.account_id

  string_used_for_fake_ids = sha256(join("", [var.namespace, var.environment, local.aws_region_shortname, var.vpc_id]))

  aurora_cluster_name = join("-", [var.namespace, var.environment, local.aws_region_shortname, "aurora", var.engine_name])

  aurora_cluster_arn = join(":", [
    "arn:aws:rds",
    data.aws_region.current.name,
    local.aws_account_id,
    "cluster:${local.aurora_cluster_name}"
  ])

  aurora_writer_endpoint = join(".", [
    local.aurora_cluster_name,
    "cluster-${lower(substr(local.string_used_for_fake_ids, 0, 12))}",
    data.aws_region.current.name,
    "rds.amazonaws.com"
  ])

  aurora_reader_endpoint = join(".", [
    local.aurora_cluster_name,
    "cluster-ro-${lower(substr(local.string_used_for_fake_ids, 0, 12))}",
    data.aws_region.current.name,
    "rds.amazonaws.com"
  ])

  port = "5432"
}

resource "null_resource" "aurora_cluster" {
  triggers = {
    destroy_aurora_if_region_changed = data.aws_region.current.name
    destroy_aurora_if_name_changed   = local.aurora_cluster_name
    destroy_aurora_if_vpc_changed    = var.vpc_id
  }
}

#resource "null_resource" "v2_resource" {
#  triggers = {
#    destroy_aurora_if_region_changed = data.aws_region.current.name
#    destroy_aurora_if_name_changed   = local.aurora_cluster_name
#    destroy_aurora_if_vpc_changed    = var.vpc_id
#  }
#}
