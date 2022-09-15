resource "aws_iam_role" "terraform_apply" {
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy_main.json
  force_detach_policies = false
  max_session_duration  = 3600
  name                  = "GitHubActions_Terraform_${var.name}_terraform_apply"
}

# resource "aws_iam_role_policy_attachment" "terraform_apply_read_terraform_state" {
#   count = var.s3_bucket_name == "" ? 0 : 1

#   role       = aws_iam_role.terraform_apply.name
#   policy_arn = aws_iam_policy.read_terraform_state.arn
# }

resource "aws_iam_role_policy_attachment" "terraform_apply_readonly" {
  role       = aws_iam_role.terraform_apply.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# resource "aws_iam_role_policy_attachment" "terraform_apply_get_secret_value" {
#   role       = aws_iam_role.terraform_apply.name
#   policy_arn = aws_iam_policy.get_secret_value.arn
# }
