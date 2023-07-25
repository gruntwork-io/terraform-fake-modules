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

  eks_cluster_name = join("-", [local.namespace, local.environment, local.aws_region_shortname, "eks"])

  eks_cluster_arn = join(":", [
    "arn:aws:eks",
    data.aws_region.current.name,
    local.aws_account_id,
    "cluster/${local.eks_cluster_name}"
  ])

  ########################################################################
  //                                                                    \\
  // Generate a realistic looking EKS endpoint that would be used for   \\
  // authenticating to the Kubernetes API for actions like Helm chart   \\
  // deployments and on-cluster debugging.                              \\
  //                                                                    \\
  ########################################################################

  eks_api_server_endpoint = join(".", [
    "https://${upper(substr(local.string_used_for_fake_ids, 0, 32))}",
    lower(substr(local.string_used_for_fake_ids, 33, 3)),
    data.aws_region.current.name,
    "eks.amazonaws.com"
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
#   e.g., if the AWS region changes, we will destroy the EKS cluster,  #
#   and "recreate" the EKS cluster in the new region.                  #
#                                                                      #
#  See this line below which causes this behavior:                     #
#   'destroy_eks_if_region_changed = data.aws_region.current.name'     #
#                                                                      #
########################################################################

resource "null_resource" "eks_cluster" {
  triggers = {
    destroy_eks_if_region_changed = data.aws_region.current.name
    destroy_eks_if_name_changed   = local.eks_cluster_name
    destroy_eks_if_vpc_changed    = var.vpc_id
  }
}
