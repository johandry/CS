#=======================================================================================================
# Author: Johandry Amador <johandry@gmail.com>
# Title:  Common Utilities
#
# Usage: source /path/to/common.sh
#
# Options:
#     -h, --help		Display this help message. bash {script_name} -h
#
# Description: This script is to be imported from other script, not to be executed from command line. It have functions and variables usefull for any shell script.
#
# Report Issues or create Pull Requests in http://github.com/johandry/
#=======================================================================================================

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
SCRIPT_NAME="$( basename "$0" )"
LOG_FILE=/tmp/${SCRIPT_NAME%.*}.log

COMMON_VERSION='1.0.1'

log () {
  msg="\x1B[${3};1m[${1}]\x1B[0m\t${2}\n"
  log="$(date +'%x - %X')\t[${1}]\t${2}\n"
  if [[ "${3}" == "ERROR" || "${3}" == "WARN" || "${3}" == "DBUG" ]]
    then
    echo -ne "$msg" >&2
  else # OK || INFO
    echo -ne "$msg"
  fi
  echo -ne $log >> "${LOG_FILE}"
}

error () {
  # Red [ERROR]
  log "ERROR" "${1}" 91
}

ok () {
  # Green [ OK ]
  log " OK " "${1}" 92  
}

warn () {
  # Yellow [WARN]
  log "WARN" "${1}" 93
}

info () {
  # Blue [INFO]
  log "INFO" "${1}" 94
}

debug () {
  # Purple [DBUG]
  log "DBUG" "${1}" 92
}

usage () {
  sed  -ne '/^# Usage/,/^# Report/p' "${0}" |
  sed   -e 's/^#\(.*\)/\1/' |
  sed   -e 's/^ \(.*\)/\1/' |
  sed   -e "s/{script_name}/${SCRIPT_NAME}/g" 
  echo

  exit 0
}

[[ "${1}" == "-h" || "${1}" == "--help" ]] && usage

update_common(){
  info TODO
}

common_version(){
  info "Common Utilities version ${COMMON_VERSION}"

  tmpfile=$(mktemp /tmp/common.sh.XXXXXX)
  curl -k -s -o ${tmpfile} https://raw.githubusercontent.com/johandry/CS/master/common.sh

  update_required=0

  latest_version=$(grep COMMON_VERSION /tmp/common.sh | cut -f2 -d= | tr -d "'")
  info "Common Utilities latest version ${latest_version}"
  [[ ${latest_version} != ${COMMON_VERSION} ]] && update_required=1
  [[ ${update_required} -eq 1 ]] && warn "Versions are different (${latest_version} <> ${COMMON_VERSION})"

  if [[ ${update_required} -eq 0 ]]
    then
    current_md5=$(md5 -q ~/bin/common.sh)
    latest_md5=$(md5 -q ${tmpfile})

    [[ "${current_md5}" != "${latest_md5}" ]] && \
      warn "Files are different. Update the version variable in GitHub" && \
      update_required=1
  fi

  # if [[ ${update_required} -eq 1 ]]
  #   then
  #   echo -ne "Common Utilities is not the latest version (${latest_version}), do you want to update now? \x1B[94;1m(Y/n)\x1B[0m: "
  #   read -r -n 1 response
  #   response=${response,,} # to lower case
  #   [[ ${response} =~ ^(y| ) ]] && update_common
  # fi
  
  rm "${tmpfile}"
}