#!/bin/bash

bot_name=${BOT_NAME}

json=$(gh api --method GET -H "Accept: application/vnd.github.v3+json" /repos/${GITHUB_REPOSITORY}/issues/${PR_NUMBER}/comments)
length=$(echo $json | jq length)

for i in $( seq 0 $(($length - 1)) ); do
  user=$(echo $json | jq -r .[$i].user.login)
  body=$(echo $json | jq -r .[$i].body | tail -n 1)
  if [ "$user" == "$bot_name" ] && [[ "$body" =~ plan ]]; then
    url=$(echo $json | jq -r .[$i].url)
    repo=$(echo ${url#https://api.github.com})
    echo "set plan_url: ${repo}"
    echo "::set-output name=plan_url::$repo"
    break
  fi
done

for i in $( seq 0 $(($length - 1)) ); do
  user=$(echo $json | jq -r .[$i].user.login)
  body=$(echo $json | jq -r .[$i].body | tail -n 1)
  if [ "$user" == "$bot_name" ] && [[ "$body" =~ init ]]; then
    url=$(echo $json | jq -r .[$i].url)
    repo=$(echo ${url#https://api.github.com})
    echo "set init_url: ${repo}"
    echo "::set-output name=init_url::$repo"
    break
  fi
done

for i in $( seq 0 $(($length - 1)) ); do
  user=$(echo $json | jq -r .[$i].user.login)
  body=$(echo $json | jq -r .[$i].body | tail -n 1)
  target=$(echo $json | jq -r .[$i].body | tail -n 2 | head -n 1)
  if [ "$user" == "$bot_name" ] && [[ "$body" =~ apply ]]; then
    url=$(echo $json | jq -r .[$i].url)
    repo=$(echo ${url#https://api.github.com})
    echo "::set-output name=apply_url::$repo"
    echo "set apply_url: ${repo}"
    target_dir=$(echo ${target} | sed -r 's/^<\!-- TARGET_DIR: (.*) -->$/\1/')
    echo "::set-output name=target_dir::$target_dir"
    echo "set target_dir: $target_dir"
    break
  fi
done