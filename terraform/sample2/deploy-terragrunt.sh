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
    INCLUDE_DIR="${INCLUDE_DIR} --terragrunt-include-dir ./hcl/${i} --terragrunt-non-interactive"
  done 
else
  INCLUDE_DIR="--terragrunt-non-interactive"
fi

if [ "$COMMAND" == "destroy" ]; then
  STRICT_INCLUDE="--terragrunt-strict-include"
fi

command="terragrunt run-all ${COMMAND} ${INCLUDE_DIR} -no-color terragrunt-working-dir=hcl ${STRICT_INCLUDE}  --terragrunt-source-update " #--terragrunt-non-interactive  

echo "--------"
echo "COMMAND: ${command}"
echo "WORKSPACE: $TF_WORKSPACE"
echo "AWS_PROFILE: $AWS_PROFILE"
echo "--------"

$command
