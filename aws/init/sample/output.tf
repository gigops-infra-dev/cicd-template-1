output "iam_role_plan" {
  value = aws_iam_role.terraform_plan.arn
}

output "iam_role_apply" {
  value = aws_iam_role.terraform_apply.arn
}
