terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "infraSpAccPortP" {
  dn         = "uni/infra/spaccportprof-SPINE1001"
  class_name = "infraSpAccPortP"
}

module "main" {
  source = "../.."

  interface_profile = aci_rest.infraSpAccPortP.content.name
  name              = "1-1"
}

data "aci_rest" "infraSHPortS" {
  dn = "uni/infra/spaccportprof-SPINE1001/shports-${module.main.name}-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "infraSHPortS" {
  component = "infraSHPortS"

  equal "name" {
    description = "name"
    got         = data.aci_rest.infraSHPortS.content.name
    want        = module.main.name
  }
}
