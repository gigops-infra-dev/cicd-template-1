#!/bin/bash
set -e
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
  if [ -n "$(git branch -a --format="%(refname:short)" | grep -e ^origin/pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR})" ]; then
    git checkout pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR}
  else
    git checkout -b pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR} origin/${BASE_REF}
  fi
}

main(){
  option=`setOption`
  checkout "$option"
  git merge -Xtheirs ${HEAD_REF}
  git add --all
  git reset HEAD^ ./${TERRAFORM_BASE_DIR}
  if ! isTmp; then
    git add ./${TERRAFORM_BASE_DIR}/${TARGET_DIR}
  fi

  echo "commit"
  git commit -m "Merge pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR}"
  if [ $? != 0 ]; then
    echo "no changes"
    echo "::set-output name=commit::false"
    exit 0
  fi

  echo "push"
  git push -f origin pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR}
  echo "::set-output name=commit::true"
}

main