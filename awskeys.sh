#!/usr/bin/env bash

username='Johandry.Amador'

C_STD="\033[0m"
C_RED="\033[91m"
C_GREEN="\033[92m"
C_YELLOW="\033[93m"
C_BLUE="\033[94m"
I_CROSS="\xe2\x95\xb3"
I_CHECK="\xe2\x9c\x94"
I_BULLET="\xe2\x80\xa2"

list() {
  echo "Access Keys:"
  currentKey=$(cat ~/.aws/credentials | grep aws_access_key_id | head -1 | cut -f2 -d= | tr -d ' ')
  aws iam list-access-keys --user-name ${username} --query 'AccessKeyMetadata[*].[AccessKeyId,Status]' --output text | while read ks; do
    key=$(echo $ks | cut -f1 -d' ')
    # Active key: green bullet and text
    bullet="${C_GREEN}${I_BULLET}${C_STD} "; color="${C_GREEN}"; sign='active'
    # Inactive key: red bullet and text
    [[ "$(echo $ks | cut -f2 -d' ')" == "Inactive" ]] && bullet="${C_RED}${I_BULLET}${C_STD} " && color="${C_RED}" && sign='inactive'
    # Used key: green bullet, yellow text
    [[ $key == $currentKey ]] && color="${C_YELLOW}" && sign="${sign} and used"
    echo  -e "${bullet} ${color}${key}${C_STD} (${sign})"
  done
}

wait4Sync() {
  echo -n "Waiting for the new access keys to be set "
  aws iam list-access-keys --user-name ${username} > /dev/null 2>&1
  while [[ $? -ne 0 ]]; do 
    echo -n "."
    sleep 1
    aws iam list-access-keys --user-name ${username} > /dev/null 2>&1
  done
  echo
}

new() {
  totalKeys=$(aws iam list-access-keys --user-name ${username} --query 'AccessKeyMetadata[*].[AccessKeyId,Status]' --output text | wc -l)
  [[ ${totalKeys} -ge 2 ]] && echo -e "${C_RED}[ERROR]${C_STD} You have 2 or more access key, delete the one you don't use with: $0 -d ACCESS_KEY_ID" && exit 1
  
  currentKey=$(aws iam list-access-keys --user-name ${username} --query 'AccessKeyMetadata[?Status==`Active`].[AccessKeyId]' --output text | head -1)
  if [[ -n ${currentKey} ]]; then
    aws iam update-access-key --user-name ${username} --access-key-id ${currentKey} --status 'Inactive'
    echo -e "${C_YELLOW}[WARN]${C_STD} Access key ${C_YELLOW}${currentKey}${C_STD} have been set as inactive" 
  fi
 
  newKey=$(aws iam create-access-key --user-name ${username} --query 'AccessKey.[AccessKeyId,SecretAccessKey]' --output text)
  [[ $? -ne 0 ]] && exit 1

  accessKeyId=$(echo ${newKey} | cut -f1 -d' ')
  secretAccessKey=$(echo ${newKey} | cut -f2 -d' ')

  aws configure set aws_access_key_id ${accessKeyId}
  aws configure set aws_secret_access_key ${secretAccessKey}
  aws configure set default.region us-west-2

  echo -e "Access key ${C_YELLOW}${accessKeyId}${C_STD} have been created and added to your AWS credentials"

  wait4Sync

  [[ $1 == --rotate ]] && delete "${currentKey}" --force
}

delete() {
  totalActiveKeys=$(aws iam list-access-keys --user-name ${username} --query 'AccessKeyMetadata[?Status==`Active`].[AccessKeyId]' --output text | wc -l)
  if [[ -n $1 ]]; then
    if [[ ${totalActiveKeys} -eq 1 && $2 != --force ]]; then
      echo -e "${C_RED}[ERROR]${C_STD} You cannot delete your only active key. Unless you use '--force' after the key id"
      exit 1
    fi
    aws iam delete-access-key --user-name ${username} --access-key-id ${1}
    [[ $? -eq 0 ]] && echo -e "${C_YELLOW}[WARN]${C_STD} Access key ${C_YELLOW}${1}${C_STD} have been deleted"
    return
  fi

  totalInactiveKeys=$(aws iam list-access-keys --user-name ${username} --query 'AccessKeyMetadata[?Status==`Inactive`].[AccessKeyId]' --output text | wc -l)
  [[ ${totalInactiveKeys} -eq 0 ]] && echo -e "${C_RED}[ERROR]${C_STD} No inactive keys to delete, mark as Inactive the keys to delete" && exit 1

  aws iam list-access-keys --user-name ${username} --query 'AccessKeyMetadata[?Status==`Inactive`].[AccessKeyId]' --output text | while read inactiveKey; do
    aws iam delete-access-key --user-name ${username} --access-key-id ${inactiveKey}
    [[ $? -eq 0 ]] && echo -e "${C_YELLOW}[WARN]${C_STD} Access key ${C_YELLOW}${inactiveKey}${C_STD} have been deleted"
  done
}

usage() {
  echo "Usage: $( basename "$0" ) OPTION"
  echo
  echo "Options:"
  echo 
  echo "  -h | --help:          Print this help"
  echo "  -l | --list:          List current keys"
  echo "  -n | --new:           Creates a new key and add it to the AWS credentials. The previous key is mark as inactive"
  echo "  -d | --delete [KEY]:  Deletes the given access key or all the inactive keys"
  echo "  -r | --rotate:        Rotates delete the current key and create a new one"
}

[[ $# -eq 0 ]] && usage && exit 1

while (( "$#" )); do 
  case $1 in
    -h | --help ) 
      usage
      exit 0
    ;;
    -l | --list ) list
    ;;

    -n | --new ) new
    ;;

    -d | --delete ) 
      delete $2 $3
      [[ -n $2 ]] && shift
      [[ -n $2 ]] && shift
    ;;

    -r | --rotate )
      list
      echo
      new --rotate
      echo
      list
    ;;
  esac
  shift
done
