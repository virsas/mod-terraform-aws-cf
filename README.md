# mod-terraform-aws-cf

Terraform module to create CloudFront instance

## Variables

- **profile** - The profile from ~/.aws/credentials file used for authentication. By default it is the default profile.
- **accountID** - ID of your AWS account. It is a required variable normally used in JSON files or while assuming a role.
- **region** - The region for the resources. By default it is eu-west-1.
- **assumeRole** - Enable / Disable role assume. This is disabled by default and normally used for sub organization configuration.
- **assumableRole** - The role the user will assume if assumeRole is enabled. By default, it is OrganizationAccountAccessRole.
- **oai** - If you want to create a distribution with Origin Access Identity you have already created. Configure this value with its ID
- **oac** - If you want to create a distribution with Origin Access Control you have already created. Configure this value with its ID
- **enabled** - You can change this variable to false if you want to disable distribution temporarily.
- **source_domain** - Main CNAME record this cloudfront distribution will be serving. Required value.
- **source_domain_aliases** - List of alternative domains.
- **s3_config_enabled** - S3 config prefered in case S3 REST API Endpoint is used. Defaults to true.
- **custom_config_enabled** - Custom config prefered in case S3 Website Endpoint is used. Defaults to false.
- **endpoint** - S3 API or Website endpoint. Required value
- **default_root_object** - Object that you want CloudFront to return. Eg. index.html. For website endpoint, leave it empty and let the endpoint to make the call. Defaults to index.html
- **origin_connection_attempts** - Number of times that CloudFront attempts to connect to the origin. Must be between 1-3. Defaults to 3.
- **origin_connection_timeout** - Number of seconds that CloudFront waits when trying to establish a connection to the origin. Must be between 1-10. Defaults to 10.
- **origin_custom_header** - Add extra headers to traffic between CF and Endpoint. Eg. [{name: \"Referer\", value: \"ref-01\"}]
- **custom_endpoint_http_port** - Endpoint http port. Defaults to 80.
- **custom_endpoint_https_port** - Endpoint https port. Defaults to 443.
- **custom_endpoint_protocol_policy** - Origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer. Fow S3 website endpoint, it must be http-only. Default value.
- **custom_endpoint_ssl_protocols** - SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. Allowed one to many values. By default TLSv1.2. Full list [\"SSLv3\", \"TLSv1\", \"TLSv1.1\", \"TLSv1.2\"]
- **ipv6_enabled** - Enable/Disable IPv6 for Cloudfront distribution. Enabled by default.
- **custom_errors** - List of errors you would want to server customized page for. Eg.: [{error_code = 404, response_code = 200, response_page = \"/index.html\" }]
- **allowed_methods** - Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. Allowed value GET | HEAD | POST | PUT | PATCH | OPTIONS | DELETE. Defaults to [\"GET\", \"HEAD\", \"OPTIONS\"]
- **cache_policy_id** - Unique identifier of the cache policy that is attached to the cache behavior. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html Defaults to 4135ea2d-6df8-44a3-9df3-4b5a84be39ad.
- **compress** - Whether you want CloudFront to automatically compress content for web requests. Defaults to true
- **protocol_policy** - Use this element to specify the protocol that users can use to access the files in the origin. allow-all, https-only or redirect-to-https. Defaults to the redirect.
- **function_associations** - List of up to 2 cf functions. Eg.: [{event_type = \"viewer-request\", function_arn = \"function_arn\" }]. Allowed event types: viewer-request or viewer-response
- **lambda_functions** - List of up to 4 lambda functions. Eg.: [{event_type = \"viewer-request\", lambda_arn = \"lambda_arn\", include_body = false }]. Allowed event types: viewer-request, origin-request, viewer-response, origin-response
- **http_version** - Maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3 and http3. The default is http2
- **geo_restriction_locations** - ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content. Defaults to empty array.
- **geo_restriction_type** - Method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist. Defaults to none
- **ssl_acm_certificate_arn** - ACM ARN used for SSL access. Required value.
- **ssl_minimum_protocol_version** - Minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Defaults to TLSv1.2_2019
- **default_ttl** - Default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request. Defaults to 3600.
- **min_ttl** - Minimum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request. Defaults to 0.
- **max_ttl** - Maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request. Defaults to 86400.

## Example

### Static website with header Referer

```terraform
variable accountID { default = "123456789012"}

module "s3_bucket_example" {
  source   = "git::https://github.com/virsas/mod-terraform-aws-cf.git?ref=v1.0.0"

  profile = "default"
  accountID = var.accountID
  region = "eu-west-1"

  source_domain         = "example.com"
  source_domain_aliases = ["www.example.com"]

  endpoint              = module.s3_example_spa_app.bucket_regional_domain_name
  default_root_object   = "index.html"
  custom_errors         = [
    { error_code = 404, response_code = 200, response_page = "/index.html" },
    { error_code = 403, response_code = 200, response_page = "/index.html" }
  ]
  ssl_acm_certificate_arn = module.acm_example.arn
}
```

### SPA application with AOI

```terraform
variable accountID { default = "123456789012"}

module "s3_bucket_example" {
  source   = "git::https://github.com/virsas/mod-terraform-aws-cf.git?ref=v1.0.0"

  profile = "default"
  accountID = var.accountID
  region = "eu-west-1"

  source_domain         = "example.com"
  source_domain_aliases = ["www.example.com"]

  endpoint              = module.s3_example_spa_app.bucket_regional_domain_name
  default_root_object   = "index.html"
  custom_errors         = [
    { error_code = 404, response_code = 200, response_page = "/index.html" },
    { error_code = 403, response_code = 200, response_page = "/index.html" }
  ]
  ssl_acm_certificate_arn = module.acm_example.arn
}
```

## Outputs

- id
- arn
- caller_reference
- status
- domain_name
- last_modified_time
- etag
- hosted_zone_id
