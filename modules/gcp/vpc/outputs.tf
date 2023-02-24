output "gcp_vpc" {
  value = {

    ## DEBUG outputs, mostly for us GCP newbies.
    #    region                      = data.google_client_config.current.region
    #    project_info                = data.google_project.this
    #    region_shortname            = local.gcp_region_shortname
    #    openid                      = data.google_client_openid_userinfo.this
    #    region_map                  = local.region_map
    #    available_regions           = data.google_compute_regions.available.names
    #    available_region_shortnames = local.available_region_shortnames
    #    subnets            = local.subnets

    vpc                = local.vpc
    subnet_regions     = local.subnet_regions
    subnet_cidr_blocks = local.subnet_cidr_blocks
    tags               = var.tags
  }
}

