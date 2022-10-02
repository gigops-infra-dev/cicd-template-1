#!/bin/bash
set -x

isTmp() {
  if [ "$TARGET_DIR" == 'tmp' ]; then
    return 0
  else
    return 1
  fi
}

setOption() {
  if isTmp; then
    echo '-v -e'
  else
    echo '-e'
  fi
}

checkout() {
  option=$1
  if [ -n "$(git branch -a --format="%(refname:short)" | grep -x ^origin/pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR})" ]; then
    git checkout pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR}
  else
    git checkout -b pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR} origin/${BASE_REF}
  fi
}

main(){
  option=`setOption`
  checkout "$option"
  ls=$(ls ${TERRAFORM_BASE_DIR} | grep -v -E ^${TARGET_DIR}$ )
  git checkout --no-overlay --theirs ${HEAD_REF} .
  echo "${ls}" | while read line; do 
    git restore -s HEAD ${TERRAFORM_BASE_DIR}/${line}/
  done
  git add --all
  git commit -m "Split commit ${HEAD_REF} to pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR}"
  git push origin HEAD

  if [ $? == 0 ]; then
    echo "success"
    echo "::set-output name=commit::true"
  else
    echo "no changes"
    echo "::set-output name=commit::false"
  fi
}

main