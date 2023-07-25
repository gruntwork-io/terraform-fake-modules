########################################################################
#                                                                      #
# 'data' calls to get information on where we're authenticated in AWS. #
#                                                                      #
#   e.g., "What region are we in?", "What account are we in?"          #
#                                                                      #
########################################################################

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_default_tags" "these" {}

########################################################################
#                                                                      #
# 'locals' blocks are where most the action happens to create strings  #
# that will be used as 'outputs' in your plan and apply that look      #
# semi-realistic.                                                      #
#                                                                      #
########################################################################

locals {
  aws_region_shortname = replace(data.aws_region.current.name, "/(\\w\\w).*-(\\w).*-(\\d).*$/", "$1$2$3")
  aws_account_id       = data.aws_caller_identity.current.account_id

  namespace   = try(data.aws_default_tags.these.tags["Namespace"], var.namespace)
  environment = try(data.aws_default_tags.these.tags["Namespace"], var.environment)

  # This generates a random value that will change when any of these other variables will change.
  # Trying playing with the sha256 function in the `terraform console`.
  string_used_for_fake_ids = sha256(join("", [local.namespace, local.environment, local.aws_region_shortname, local.vpc_id]))

  aurora_cluster_name = join("-", [local.namespace, local.environment, local.aws_region_shortname, "aurora", local.engine_name])

  aurora_cluster_arn = join(":", [
    "arn:aws:rds",
    data.aws_region.current.name,
    local.aws_account_id,
    "cluster:${local.aurora_cluster_name}"
  ])

  # This has no impact on the creation or destruction of the null_resource.
  # It might be useful in future uses of this fake module.
  port = "5432"

  ########################################################################
  //                                                                    \\
  // Generate realistic looking Aurora reader and writer endpoints      \\
  // that would be used for authenticating to the actual database.      \\
  //                                                                    \\
  ########################################################################

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

  tags = merge(var.tags, data.aws_default_tags.these.tags)
}

########################################################################
#                                                                      #
# 'null_resource's are a tricky topic to understand that can be very   #
# powerful but should be used rarely in production. The `triggers`     #
# block is there to destroy this resource when values change to mimic  #
# AWS behavior.                                                        #
#                                                                      #
#   e.g., if the AWS region changes, we will destroy the Aurora        #
#   cluster and "recreate" the Aurora cluster in the new region.       #
#                                                                      #
#  See this line below which causes this behavior:                     #
#   'destroy_aurora_if_region_changed = data.aws_region.current.name'  #
#                                                                      #
########################################################################

resource "null_resource" "aurora_cluster" {
  triggers = {
    destroy_aurora_if_region_changed = data.aws_region.current.name
    destroy_aurora_if_name_changed   = local.aurora_cluster_name
    destroy_aurora_if_vpc_changed    = var.vpc_id
  }
}
