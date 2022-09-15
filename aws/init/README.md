# Setup aws for github actions

## what is this?
A collection of terraforms to create role and oicd provider used to github actions.

## install

1. Copy or rename sample directory
```
$ cp -r sample ./<dir_name>
or
$ mv sample ./<dir_name>
```

2. Edit tfvars
```
$ cd ./<dir_name>
$ vi ./terraform.tfvars
name = "${github_repository}" 
repo = "${github-owner}/${github_repository}" 
region = "${aws_region}"
create_oidc = true/false # if OIDC is undefined on the your AWS Account, select true.
```

3. Run terraform
Remember the variables in outputs.
```
$ terraform init
$ terraform plan
# terraform apply

Outputs:

iam_role_apply = "arn:aws:iam::xxxxxxxxxx:role/GitHubActions_Terraform_terraform-cicd_terraform_apply"
iam_role_plan = "arn:aws:iam::xxxxxxxxxx:role/GitHubActions_Terraform_terraform-cicd_terraform_plan"
```