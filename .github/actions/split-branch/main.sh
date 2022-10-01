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
  git checkout --theirs ${HEAD_REF} -- .
  git reset HEAD^ ./${TERRAFORM_BASE_DIR}
  if ! isTmp; then
    git add ./${TERRAFORM_BASE_DIR}/${TARGET_DIR}/
    diff=$(git diff ${HEAD_REF} --name-only --diff-filter=D | grep ${TERRAFORM_BASE_DIR}/${TARGET_DIR}/)
    if [ -n "${diff}" ]; then
      echo "${diff}" | while read line; do
        git rm $line
      done
    fi
    git commit -m "Merge pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR}"
  fi
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