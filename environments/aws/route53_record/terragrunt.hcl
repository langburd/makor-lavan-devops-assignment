terraform {
  source = "${include.root.locals.resource_vars["tf_source"]}"
}

include "root" {
  path   = "${find_in_parent_folders()}"
  expose = true
}

inputs = merge(
  include.root.locals.resource_vars["inputs"],
  {
    app_name       = dependency.helm.outputs.app_name
    hosted_zone_id = dependency.route53_zone.outputs.hosted_zone_id
  },
  {
    tags = merge(
      include.root.locals.env_vars["tags"],
      include.root.locals.common_vars["tags"]
    )
  },
)

dependencies {
  paths = [
    "../app",
    "../route53_zone",
  ]
}

dependency "route53_zone" {
  config_path = "../route53_zone"
  mock_outputs = {
    hosted_zone_id = "Z1234567890"
  }
}

dependency "helm" {
  config_path = "../app"
  mock_outputs = {
    app_name = "makor-lavan"
  }
}
