data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  aws_region_shortname     = replace(data.aws_region.current.name, "/(\\w\\w).*-(\\w).*-(\\d).*$/", "$1$2$3")
  string_used_for_fake_ids = sha256(join("", [var.namespace, var.environment, local.aws_region_shortname, var.cidr_block, local.available_az_count]))

  vpc_name = join("-", [var.namespace, var.environment, local.aws_region_shortname, "vpc"])
  vpc_id   = join("-", ["vpc", substr(local.string_used_for_fake_ids, 0, 7)])

  available_az_count = length(data.aws_availability_zones.available.names)
  az_count           = local.available_az_count > var.max_az_count ? var.max_az_count : local.available_az_count

  private_subnet_ids = [for i in range(local.az_count) :
    join("-", ["subnet", substr(local.string_used_for_fake_ids, i + 7, 7)])
  ]

  public_subnet_ids = [for i in range(local.az_count) :
    join("-", ["subnet", substr(local.string_used_for_fake_ids, i + 13, 7)])
  ]

  subnet_ids = concat(local.private_subnet_ids, local.public_subnet_ids)

  subnet_names = { for k in range(length(local.subnet_ids)) :
    local.subnet_ids[k] => join("-",
      [
        var.namespace,
        var.environment,
        local.aws_region_shortname,
        (contains(split("", tostring(k / 2)), ".") ? "public" : "private"),
        "subnet",
        k + 1
      ]
    )
  }

  subnet_cidr_blocks = { for m in range(length(local.subnet_ids)) :
    local.subnet_names[local.subnet_ids[m]] => cidrsubnet(var.cidr_block, var.cidrsubnet_newbits, m)
  }

  subnet_id_cidr_blocks = { for m in range(local.az_count) :
    local.subnet_ids[m] => cidrsubnet(var.cidr_block, local.az_count, m)
  }

  tags = merge({ namespace = var.namespace, environment = var.environment }, var.tags)
}

resource "null_resource" "vpc" {
  triggers = {
    destroy_vpc_if_region_changed = data.aws_region.current.name
    destroy_vpc_if_name_changed   = local.vpc_name
    destroy_vpc_if_cidr_changed   = var.cidr_block
  }
}

resource "null_resource" "private_subnets" {
  count = local.az_count

  triggers = {
    destroy_vpc_if_region_changed = data.aws_region.current.name

    destroy_subnets_if_subnet_ids_changed   = local.private_subnet_ids[count.index]
    destroy_subnets_if_subnet_names_changed = local.subnet_names[local.private_subnet_ids[count.index]]
    destroy_subnets_if_subnet_cidr_changed  = local.subnet_cidr_blocks[local.subnet_names[local.private_subnet_ids[count.index]]]
  }
}

resource "null_resource" "public_subnets" {
  count = local.az_count

  triggers = {
    destroy_vpc_if_region_changed = data.aws_region.current.name

    destroy_subnets_if_subnet_ids_changed   = local.public_subnet_ids[count.index]
    destroy_subnets_if_subnet_names_changed = local.subnet_names[local.public_subnet_ids[count.index]]
    destroy_subnets_if_subnet_cidr_changed  = local.subnet_cidr_blocks[local.subnet_names[local.public_subnet_ids[count.index]]]
  }
}

resource "null_resource" "internet_gateway" {
  triggers = {
    destroy_vpc_if_region_changed = data.aws_region.current.name
    destroy_vpc_if_name_changed   = local.vpc_name
    destroy_vpc_if_cidr_changed   = var.cidr_block
  }
}

resource "null_resource" "nat_gateway" {
  count = var.nat_gw_count

  triggers = {
    destroy_vpc_if_region_changed = data.aws_region.current.name
    destroy_vpc_if_name_changed   = local.vpc_name
    destroy_vpc_if_cidr_changed   = var.cidr_block
  }
}
