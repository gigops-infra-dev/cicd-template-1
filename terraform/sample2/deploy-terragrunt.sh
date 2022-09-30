#!/bin/bash

set -e

# terraform command (plan, apply, output, etc...)
COMMAND=$1
TARGET_DIR=$2

INCLUDE_DIR=''
STRICT_INCLUDE=''

TARGET_DIR=(${TARGET_DIR})

if [ "$TARGET_DIR" != "all" ]; then
  for i in "${TARGET_DIR[@]}"; do
    INCLUDE_DIR="${INCLUDE_DIR} --terragrunt-include-dir ./hcl/${i}"
  done 

  if [ "$COMMAND" == "destroy" ]; then
    STRICT_INCLUDE="--terragrunt-strict-include"
  fi
fi

command="terragrunt run-all ${COMMAND} ${INCLUDE_DIR} -no-color terragrunt-working-dir=hcl ${STRICT_INCLUDE}  --terragrunt-non-interactive" #--terragrunt-non-interactive  --terragrunt-source-update

echo "--------"
echo "COMMAND: ${command}"
echo "WORKSPACE: $TF_WORKSPACE"
echo "AWS_PROFILE: $AWS_PROFILE"
echo "--------"

$command
