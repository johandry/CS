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
LOG_FILE="$(mktemp -t ${SCRIPT_NAME%.*}.XXXXXX).log"

COMMON_VERSION='1.0.1'
SOURCE="https://raw.githubusercontent.com/johandry/CS/master/common.sh"

log () {
  msg_type="\x1B[${3};1m[${1}]\x1B[0m"
  msg_type_log="[${1}]"

  [[ "${1}" == " OK " || "${1}" == "WARN" || "${1}" == "INFO" ]] && \
    msg_type="${msg_type} " && \
    msg_type_log="${msg_type_log} "

  [[ -z "${1}" ]] && msg_type='       ' && msg_type_log=${msg_type}

  msg="${msg_type}\t${2}\n"
  log="$(date +'%x - %X')\t${msg_type_log}\t${2}\n"

  if [[ "${1}" == "ERROR" || "${1}" == "WARN" || "${1}" == "DEBUG" ]]
    then
    echo -ne "$msg" >&2
  else # OK || INFO || Indent
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
  log "DEBUG" "${1}" 92
}

indent () {
  # Indent, 7 spaces
  log '' "${1}" 0
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

common_update(){
  info TODO
}

common_version(){
  info "Common Utilities version ${COMMON_VERSION}"

  tmpfile=$(mktemp -t common.sh.XXXXXX) || exit 1
  curl -k -s -o ${tmpfile} ${SOURCE}

  update_required=0

  latest_version=$(grep '^COMMON_VERSION=' ${tmpfile} | cut -f2 -d= | tr -d "'")
  info "Common Utilities latest version ${latest_version}"
  [[ ${latest_version} != ${COMMON_VERSION} ]] && update_required=1
  [[ ${update_required} -eq 1 ]] && warn "Versions are different (${latest_version} <> ${COMMON_VERSION})"

  if [[ ${update_required} -eq 0 ]]
    then
    current_md5=$(md5 -q ~/bin/common.sh)
    latest_md5=$(md5 -q ${tmpfile})

    if [[ "${current_md5}" != "${latest_md5}" ]]
    then
      warn "Files are different. Update the version variable in GitHub"
      indent "See the differences with 'curl -k -s ${SOURCE} | diff - ${SCRIPT_NAME} | less' "
      update_required=1
    fi
  fi

  # if [[ ${update_required} -eq 1 ]]
  #   then
  #   echo -ne "Common Utilities is not the latest version (${latest_version}), do you want to update now? \x1B[94;1m(Y/n)\x1B[0m: "
  #   read -r -n 1 response
  #   response=${response,,} # to lower case
  #   [[ ${response} =~ ^(y| ) ]] && common_update
  # fi

  rm "${tmpfile}"
}
