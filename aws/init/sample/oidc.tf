data "tls_certificate" "github" {
  count = var.create_oidc ? 1 : 0
  url   = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

resource "aws_iam_openid_connect_provider" "github" {
  count           = var.create_oidc ? 1 : 0
  url             = "https://token.actions.githubusercontent.com"
  thumbprint_list = [data.tls_certificate.github[0].certificates[0].sha1_fingerprint]
  client_id_list  = ["sts.amazonaws.com"]
}
