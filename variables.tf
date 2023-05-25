# Account setup
variable "profile" {
  description           = "The profile from ~/.aws/credentials file used for authentication. By default it is the default profile."
  type                  = string
  default               = "default"
}

variable "accountID" {
  description           = "ID of your AWS account. It is a required variable normally used in JSON files or while assuming a role."
  type                  = string

  validation {
    condition           = length(var.accountID) == 12
    error_message       = "Please, provide a valid account ID."
  }
}

variable "region" {
  description           = "The region for the resources. By default it is eu-west-1."
  type                  = string
  default               = "eu-west-1"
}

variable "assumeRole" {
  description           = "Enable / Disable role assume. This is disabled by default and normally used for sub organization configuration."
  type                  = bool
  default               = false
}

variable "assumableRole" {
  description           = "The role the user will assume if assumeRole is enabled. By default, it is OrganizationAccountAccessRole."
  type                  = string
  default               = "OrganizationAccountAccessRole"
}

variable "name" {
  description = "Instance name. Required value"
  type        = string
}

variable "oai" {
  description = "If you want to create a distribution with Origin Access Identity you have already created. Configure this value with its ID"
  type        = string
  default     = ""
}
variable "create_oai" {
  description = "If you want to create a distribution with Origin Access Identity, but you dont have one and you would like one to be created. Enable this variable. Defaults to false."
  type        = bool
  default     = false
}
variable "oac" {
  description = "If you want to create a distribution with Origin Access Control you have already created. Configure this value with its ID"
  type        = string
  default     = ""
}
variable "create_oac" {
  description = "If you want to create a distribution with Origin Access Control, but you dont have one and you would like one to be created. Enable this variable. Defaults to false."
  type        = bool
  default     = false
}
variable "oac_origin_type" {
  description = "The type of origin that this Origin Access Control is for. Allowed values s3 and mediastore. Defaults to s3."
  type        = string
  default     = "s3"

  validation {
    condition           = contains(["s3", "mediastore"], var.oac_origin_type)
    error_message       = "Expected values: s3, mediastore."
  }
}
variable "oac_behaviour" {
  description = "Specifies which requests CloudFront signs. Specify always for the most common use case. Allowed values: always, never, and no-override"
  type        = string
  default     = "always"

  validation {
    condition           = contains(["always", "never", "no-override"], var.oac_behaviour)
    error_message       = "Expected values: always, never, no-override."
  }
}
variable "enabled" {
  description = "You can change this variable to false if you want to disable distribution temporarily."
  type        = bool
  default     = true
}
variable "source_domain" {
  description = "Main CNAME record this cloudfront distribution will be serving. Required value."
  type        = string
}
variable "source_domain_aliases" {
  description = "List of alternative domains."
  type        = list(string)
  default     = []
}
variable "s3_config_enabled" {
  description = "S3 config prefered in case S3 REST API Endpoint is used. Defaults to true."
  type        = bool
  default     = true
}
variable "custom_config_enabled" {
  description = "Custom config prefered in case S3 Website Endpoint is used. Defaults to false."
  type        = bool
  default     = false
}
variable "endpoint" {
  description = "S3 API or Website endpoint. Required value"
  type        = string
}
variable "default_root_object" {
  description = "Object that you want CloudFront to return. Eg. index.html. For website endpoint, leave it empty and let the endpoint to make the call. Defaults to index.html"
  type        = string
  default     = "index.html"
}
variable "origin_connection_attempts" {
  description = "Number of times that CloudFront attempts to connect to the origin. Must be between 1-3. Defaults to 3."
  type        = number
  default     = 3
}
variable "origin_connection_timeout" {
  description = "Number of seconds that CloudFront waits when trying to establish a connection to the origin. Must be between 1-10. Defaults to 10."
  type        = number
  default     = 10
}
variable "origin_custom_header" {
  description = "Add extra headers to traffic between CF and Endpoint. Eg. [{name: \"Referer\", value: \"ref-01\"}]"
  type        = list(object{name = string, value = string})
  default     = []
}
variable "custom_endpoint_http_port" {
  description = "Endpoint http port. Defaults to 80."
  type        = number
  default     = 80
}
variable "custom_endpoint_https_port" {
  description = "Endpoint https port. Defaults to 443."
  type        = number
  default     = 443
}
variable "custom_endpoint_protocol_policy" {
  description = "Origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer. Fow S3 website endpoint, it must be http-only. Default value."
  type        = string
  default     = "http-only"
}
variable "custom_endpoint_ssl_protocols" {
  description = "SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS. Allowed one to many values. By default TLSv1.2. Full list [\"SSLv3\", \"TLSv1\", \"TLSv1.1\", \"TLSv1.2\"]"
  type        = list(string)
  default     = ["TLSv1.2"]
}
variable "ipv6_enabled" {
  description = "Enable/Disable IPv6 for Cloudfront distribution. Enabled by default."
  type        = bool
  default     = true
}
variable "custom_errors" {
  description = "List of errors you would want to server customized page for. Eg.: [{error_code = 404, response_code = 200, response_page = \"/index.html\" }]"
  type        = list(object{error_code = number, response_code = number, response_page = string})
  default     = []
}
variable "allowed_methods" {
  description = "Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin. Allowed value GET | HEAD | POST | PUT | PATCH | OPTIONS | DELETE. Defaults to [\"GET\", \"HEAD\", \"OPTIONS\"]"
  type        = list(string)
  default     = ["GET", "HEAD", "OPTIONS"]
}
variable "cache_policy_id" {
  description = "Unique identifier of the cache policy that is attached to the cache behavior. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html Defaults to 4135ea2d-6df8-44a3-9df3-4b5a84be39ad."
  type        = string
  default     = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
}
variable "compress" {
  description = "Whether you want CloudFront to automatically compress content for web requests. Defaults to true"
  type        = bool
  default     = true
}
variable "protocol_policy" {
  description = "Use this element to specify the protocol that users can use to access the files in the origin. allow-all, https-only or redirect-to-https. Defaults to the redirect."
  type        = string
  default     = "redirect-to-https"
}
variable "function_associations" {
  description = "List of up to 2 cf functions. Eg.: [{event_type = \"viewer-request\", function_arn = \"function_arn\" }]. Allowed event types: viewer-request or viewer-response"
  type        = list(object{event_type = string, function_arn = string})
  default     = []
}
variable "lambda_functions" {
  description = "List of up to 4 lambda functions. Eg.: [{event_type = \"viewer-request\", lambda_arn = \"lambda_arn\", include_body = false }]. Allowed event types: viewer-request, origin-request, viewer-response, origin-response"
  type        = list(object{event_type = string, lambda_arn = string, include_body = bool})
  default     = []
}
variable "http_version" {
  description = "Maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3 and http3. The default is http2"
  type        = string
  default     = "http2"
}
variable "geo_restriction_locations" {
  description = "ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your content. Defaults to empty array."
  type        = list(string)
  default     = []
}
variable "geo_restriction_type" {
  description = "Method that you want to use to restrict distribution of your content by country: none, whitelist, or blacklist. Defaults to none"
  type        = string
  default     = "none"
}
variable "ssl_acm_certificate_arn" {
  description = "ACM ARN used for SSL access. Required value."
  type        = string
}
variable "ssl_minimum_protocol_version" {
  description = "Minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections. Defaults to TLSv1.2_2019"
  type        = string
  default     = "TLSv1.2_2019"
}
variable "default_ttl" {
  description = "Default amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request. Defaults to 3600."
  type        = number
  default     = 3600
}
variable "min_ttl" {
  description = "Minimum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request. Defaults to 0."
  type        = number
  default     = 0
}
variable "max_ttl" {
  description = "Maximum amount of time (in seconds) that an object is in a CloudFront cache before CloudFront forwards another request. Defaults to 86400."
  type        = number
  default     = 86400
}
