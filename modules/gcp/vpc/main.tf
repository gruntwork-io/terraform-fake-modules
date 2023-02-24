data "google_compute_regions" "available" {}

data "google_project" "this" {}

data "google_client_config" "current" {}

data "google_client_openid_userinfo" "this" {}

locals {
  project                  = data.google_project.this.name
  string_used_for_fake_ids = sha256(join("", [var.namespace, var.environment, local.project, local.gcp_region_shortname]))

  region_map = zipmap(data.google_compute_regions.available.names, local.available_region_shortnames)

  #TODO this is a hack, South America and North America regions don't look great.
  available_region_shortnames = [for k in data.google_compute_regions.available.names : replace(k, "/(\\w\\w{0,2}).*-(\\w).{0,4}(.?)\\w*(\\d).*$/", "$1$2$3$4")]

  #TODO this is a hack, South America and North America regions don't look great.
  gcp_region_shortname = replace(data.google_client_config.current.region, "/(\\w\\w{0,2}).*-(\\w).{0,4}(.?)\\w*(\\d).*$/", "$1$2$3$4")

  vpc_name = join("-", [var.namespace, var.environment, "vpc"])
  vpc = {
    name    = local.vpc_name
    id      = "projects/${local.project}/global/networks/${local.vpc_name}"
    project = local.project
  }

  #TODO this is really just winging it - could be cleaned up, will produce /24's, could be done a number of ways
  indexes_used_to_select_fake_subnets = distinct(split("", substr(replace(local.string_used_for_fake_ids, "/[abcdefg]/", ""), 0, 14)))
  subnet_regions                      = [for i in local.indexes_used_to_select_fake_subnets : element(data.google_compute_regions.available.names, i * i + 7)]
  subnet_cidr_blocks                  = [for s in range(length(local.subnet_regions)) : cidrsubnet("10.0.0.0/8", 16, s)]

  subnets = [for i, k in local.subnet_regions : {
    region          = k,
    cidr_block      = local.subnet_cidr_blocks[i],
    gateway_address = cidrhost(local.subnet_cidr_blocks[i], 1),
    network         = "https://www.googleapis.com/compute/v1/projects/${local.project}/global/networks/${local.vpc.name}"
    project         = local.project
    id              = "projects/${local.project}/regions/${k}/subnetworks/${join("-", [var.namespace, var.environment, local.region_map[k], "subnet"])}"

  }]
}

resource "null_resource" "vpc" {
  triggers = {
    destroy_vpc_if_name_changed = local.vpc.name
  }
}

resource "null_resource" "subnets" {
  count = length(local.subnet_regions)
  triggers = {
    destroy_vpc_if_name_changed = local.vpc.name
  }
}
