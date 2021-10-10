resource "aci_rest" "infraSHPortS" {
  dn         = "uni/infra/spaccportprof-${var.interface_profile}/shports-${var.name}-typ-range"
  class_name = "infraSHPortS"
  content = {
    name = var.name
    type = "range"
  }
}

resource "aci_rest" "infraRsSpAccGrp" {
  count      = var.policy_group != null ? 1 : 0
  dn         = "${aci_rest.infraSHPortS.dn}/rsspAccGrp"
  class_name = "infraRsSpAccGrp"
  content = {
    tDn = "uni/infra/funcprof/spaccportgrp-${var.policy_group}"
  }
}

resource "aci_rest" "infraPortBlk" {
  for_each   = { for block in var.port_blocks : block.name => block }
  dn         = "${aci_rest.infraSHPortS.dn}/portblk-${each.value.name}"
  class_name = "infraPortBlk"
  content = {
    name     = each.value.name
    descr    = each.value.description != null ? each.value.description : ""
    fromCard = each.value.from_module != null ? each.value.from_module : "1"
    fromPort = each.value.from_port
    toCard   = each.value.to_module != null ? each.value.to_module : (each.value.from_module != null ? each.value.from_module : "1")
    toPort   = each.value.to_port != null ? each.value.to_port : each.value.from_port
  }
}
