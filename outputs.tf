output "dn" {
  value       = aci_rest.infraSHPortS.id
  description = "Distinguished name of `infraSHPortS` object."
}

output "name" {
  value       = aci_rest.infraSHPortS.content.name
  description = "Spine interface selector name."
}
