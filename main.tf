provider "aws" {
  profile = var.profile
  region = var.region

  assume_role {
    role_arn = var.assumeRole ? "arn:aws:iam::${var.accountID}:role/${var.assumableRole}" : null
  }
}

resource "aws_cloudfront_distribution" "vss" {
  enabled                             = var.enabled

  origin {
    domain_name                       = var.endpoint
    origin_id                         = var.source_domain

    connection_attempts               = var.origin_connection_attempts
    connection_timeout                = var.origin_connection_timeout

    dynamic "custom_header" {
      for_each = var.origin_custom_header

      content {
        name                          = custom_header.value.name
        value                         = custom_header.value.value
      }
    }

    origin_access_control_id          = var.s3_config_enabled && !var.custom_config_enabled && var.oac != "" ? var.oac : null

    dynamic "s3_origin_config" {
      for_each = var.s3_config_enabled && !var.custom_config_enabled && var.oai != "" && var.oac == "" ? [{ oai = var.oai }] : []

      content {
        origin_access_identity        = s3_origin_config.value.oai
      }
    }

    dynamic "custom_origin_config" {
      for_each = var.custom_config_enabled && !var.s3_config_enabled ? [{ http_port = var.custom_endpoint_http_port, https_port = var.custom_endpoint_https_port, protocol_policy = var.custom_endpoint_protocol_policy, ssl_protocols = var.custom_endpoint_ssl_protocols }] : []

      content {
        http_port                     = custom_origin_config.value.http_port
        https_port                    = custom_origin_config.value.https_port
        origin_protocol_policy        = custom_origin_config.value.protocol_policy
        origin_ssl_protocols          = custom_origin_config.value.ssl_protocols
      }
    }
  }

  aliases                             = var.source_domain_aliases
  http_version                        = var.http_version
  is_ipv6_enabled                     = var.ipv6_enabled
  // leave empty for website endpoints or index.html for s3 rest api endpoints
  default_root_object                 = var.default_root_object

  dynamic "custom_error_response" {
    for_each = var.custom_errors

    content {
      error_code                      = custom_error_response.value.error_code
      response_code                   = custom_error_response.value.response_code
      response_page_path              = custom_error_response.value.response_page
    }
  }

  default_cache_behavior {
    allowed_methods                   = var.allowed_methods
    cached_methods                    = var.allowed_methods

    target_origin_id                  = var.source_domain

    cache_policy_id                   = var.cache_policy_id

    compress                          = var.compress

    viewer_protocol_policy            = var.protocol_policy
    default_ttl                       = var.default_ttl
    min_ttl                           = var.min_ttl
    max_ttl                           = var.max_ttl

    dynamic "function_association" {
      for_each = var.function_associations

      content {
        event_type                    = function_association.value.event_type
        function_arn                  = function_association.value.function_arn
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.lambda_functions

      content {
        event_type                    = lambda_function_association.value.event_type
        lambda_arn                    = lambda_function_association.value.lambda_arn
        include_body                  = lambda_function_association.value.include_body
      }
    }
  }

  restrictions {
    geo_restriction {
      locations                       = var.geo_restriction_locations
      restriction_type                = var.geo_restriction_type
    }
  }

  viewer_certificate {
    acm_certificate_arn               = var.ssl_acm_certificate_arn
    minimum_protocol_version          = var.ssl_minimum_protocol_version
    ssl_support_method                = "sni-only"
  }

}