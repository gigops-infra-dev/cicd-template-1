#!/bin/bash

json="actions.json"

target=$(echo ${HEAD_REF} | awk -F "_" '{ print $NF }')
jq -c .targets[] ${json} | while read line; do
  ghaction_target=$(echo $line | jq -r .ghaction_target)
  if [ "${ghaction_target}" == "${target}" ]; then
    aws_profile=$(echo $line | jq -r .${BASE_REF}.aws_profile)
    aws_role_arn=$(echo $line | jq -r .${BASE_REF}.aws_role_arn)
    tf_workspace=$(echo $line | jq -r .${BASE_REF}.tf_workspace)
    
    echo "SET GHACTION_TARGET=$ghaction_target"
    echo "::set-output name=ghaction_target::$ghaction_target"

    echo "SET AWS_PROFILE=$aws_profile"
    echo "::set-output name=aws_profile::$aws_profile"

    echo "SET AWS_ROLE_ARN=$aws_role_arn"
    echo "::set-output name=aws_role_arn::$aws_role_arn"

    echo "SET TF_WORKSPACE=$tf_workspace"
    echo "::set-output name=tf_workspace::$tf_workspace"
    break
  fi
done