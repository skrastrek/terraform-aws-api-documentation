# terraform-modules-aws-api-documentation

Terraform module that hosts API documentation on S3 using [ReDoc](https://github.com/Redocly/redoc). Supports multiple APIs in a single interface, with specs provided either as inline YAML strings or external URLs.

## Usage

```hcl
module "api_documentation" {
  source = "..."

  title = "My APIs"

  apis = {
    petstore = {
      name                 = "Pet Store API"
      open_api_spec_yaml   = file("${path.module}/specs/petstore.yaml")
    }
    payments = {
      name              = "Payments API"
      open_api_spec_url = "https://example.com/payments/openapi.yaml"
    }
  }

  tags = {
    Environment = "production"
  }
}
```

## CloudFront integration

To serve the documentation through a CloudFront distribution, pass the distribution ARNs to grant S3 bucket read access:

```hcl
module "api_documentation" {
  source = "..."

  title = "My APIs"
  apis  = { ... }

  resource_policy_allow_read_cloudfront_distribution_arns = [
    aws_cloudfront_distribution.this.arn
  ]

  tags = {}
}
```

## Variables

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `title` | `string` | yes | Title shown in the browser tab |
| `apis` | `map(object)` | yes | Map of APIs to document (see below) |
| `tags` | `map(string)` | yes | Tags applied to all AWS resources |
| `name_prefix` | `string` | no | Prefix for the S3 bucket name (default: `"api"`) |
| `resource_policy_allow_read_cloudfront_distribution_arns` | `list(string)` | no | CloudFront distribution ARNs allowed to read from the S3 bucket |

### `apis` object

Each entry in the `apis` map must have exactly one of `open_api_spec_yaml` or `open_api_spec_url`.

| Field                | Type | Description |
|----------------------|------|-------------|
| `name`               | `string` | Display name shown in the navigation bar |
| `open_api_spec_yaml` | `string` | OpenAPI spec as a YAML string (embedded in the page) |
| `open_api_spec_url`  | `string` | URL to an externally hosted OpenAPI spec |

## Outputs

| Name | Description |
|------|-------------|
| `s3_bucket_regional_domain_name` | Regional domain name of the S3 bucket — use as CloudFront origin |