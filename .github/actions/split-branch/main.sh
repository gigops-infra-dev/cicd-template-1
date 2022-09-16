#!/bin/bash
set +e

checkTarget() {
  if [ "$TARGET_DIR" != 'tmp' ]; then
    return 0
  else
    return 1
  fi
}

setOption() {
  if checkTarget; then
    echo '-e'
  else
    echo '-v -e'
  fi
}

checkout() {
  option=$1
  rc=1
  if [ -n "$(git branch -a --format="%(refname:short)" | grep -e ^origin/pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR})" ]; then
    if [ -n "$(git diff origin/pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR} --name-only | grep $option ^${TERRAFORM_BASE_DIR})" ];then
      git checkout pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR}
      rc=0
    fi
  else
    if [ -n "$(git diff origin/${BASE_REF} --name-only | grep $option ^${TERRAFORM_BASE_DIR})" ]; then
      git checkout -b pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR} origin/${BASE_REF}
      rc=0
    fi
    return $rc
  fi
}

option=`setOption`
if checkout "$option"; then
  git merge -Xtheirs ${HEAD_REF}
  git add --all
  git reset HEAD^ ./${TERRAFORM_BASE_DIR}
  if checkTarget; then
    git add ./${TERRAFORM_BASE_DIR}/${TARGET_DIR}
  fi
  git commit -m "Merge pr/${BASE_REF}/${HEAD_REF#feature/}_${TARGET_DIR}"
  git push -f origin HEAD
  echo "::set-output name=commit::true"
else
  echo "no changes"
  echo "::set-output name=commit::false"
fi