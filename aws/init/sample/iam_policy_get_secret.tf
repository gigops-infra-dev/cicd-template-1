resource "aws_iam_policy" "get_secret_value" {
  name   = "GitHubActions_Terraform_${var.name}_get_secret_value"
  policy = data.aws_iam_policy_document.get_secret_value.json
}
data "aws_iam_policy_document" "get_secret_value" {
  statement {
    resources = ["arn:aws:secretsmanager:*"]
    actions   = ["secretsmanager:GetSecretValue"]
  }
}
