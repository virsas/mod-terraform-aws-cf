output "id" {
  value = aws_cloudfront_distribution.vss.id
}
output "arn" {
  value = aws_cloudfront_distribution.vss.arn
}
output "caller_reference" {
  value = aws_cloudfront_distribution.vss.caller_reference
}
output "status" {
  value = aws_cloudfront_distribution.vss.status
}
output "domain_name" {
  value = aws_cloudfront_distribution.vss.domain_name
}
output "last_modified_time" {
  value = aws_cloudfront_distribution.vss.last_modified_time
}
output "etag" {
  value = aws_cloudfront_distribution.vss.etag
}
output "hosted_zone_id" {
  value = aws_cloudfront_distribution.vss.hosted_zone_id
}

output "oai_id" {
  value = try(aws_cloudfront_origin_access_identity.vss.id, "")
}
output "oai_etag" {
  value = try(aws_cloudfront_origin_access_identity.vss.etag, "")
}
output "oac_id" {
  value = try(aws_cloudfront_origin_access_control.vss.id, "")
}
output "oac_etag" {
  value = try(aws_cloudfront_origin_access_control.vss.etag, "")
}