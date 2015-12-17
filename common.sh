#=======================================================================================================
# Author: Johandry Amador <johandry@gmail.com>
# Title:  Common Utilities
#
# Usage: source ~/bin/common.sh
#
# Options:
#     -h, --help		Display this help message. bash {script_name} -h
#     --version     Display the current version and the latest version.
#     --debug       Debug mode. Useful during development.
#     --update      Update the script to the latest version online.
#
# Description: This script is to be imported from other script, not to be executed from command line. It have functions and variables usefull for any shell script.
#
# Report Issues or create Pull Requests in http://github.com/johandry/
#=======================================================================================================

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
SCRIPT_NAME="$( basename "$0" )"
LOG_FILE="$(mktemp -t ${SCRIPT_NAME%.*}.XXXXXX).log"

GITHUB_RAW="https://raw.githubusercontent.com/johandry"
SOURCE="${GITHUB_RAW}/${GITHUB_PROJECT}/master/${SCRIPT_NAME}"

# Every script should have a version, project name and source
# VERSION=
# TITLE=
# GITHUB_PROJECT="CS"

# Set DEBUG to 1 using argument --debug in case you need it.
DEBUG=0

COMMON_VERSION='1.0.3'
COMMON_TITLE='Common Utilities'
COMMON_GITHUB_PROJECT="CS"
COMMON_SCRIPT_NAME="common.sh"
COMMON_SOURCE="${GITHUB_RAW}/${COMMON_GITHUB_PROJECT}/master/${COMMON_SCRIPT_NAME}"

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
  # Purple [DEBUG]
  (( ${DEBUG} )) && log "DEBUG" "${1}" 92
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

common_version () {
  tmpfile=$(mktemp -t ${COMMON_SCRIPT_NAME}.XXXXXX) || exit 1
  curl -k -s -o ${tmpfile} ${COMMON_SOURCE}

  online_version=$(grep '^COMMON_VERSION=' ${tmpfile} | cut -f2 -d= | tr -d "'")
  info "${COMMON_TITLE} version ${COMMON_VERSION}, online version ${online_version}"

  update_required=0

  latest_version=$(printf "${COMMON_VERSION}\n${online_version}" | sort -t '.' -k 1,1 -k 2,2 -k 3,3 -k 4,4 -g | tail -1)
  if [[ "${online_version}" != "${latest_version}" ]]
    then
    warn "Watchout, you have a newer version than the online one. Commit and push your changes."
    indent "See the differences with 'curl -k -s ${COMMON_SOURCE} | diff - ~/bin/${COMMON_SCRIPT_NAME} | less' "
    newer_version=1
  fi

  [[ ${online_version} != ${COMMON_VERSION} ]] && \
    update_required=1 && \
    warn "Versions are different (${online_version} <> ${COMMON_VERSION})"

  if [[ ${update_required} -eq 0 ]]
    then
    current_md5=$(md5 -q ~/bin/${COMMON_SCRIPT_NAME})
    latest_md5=$(md5 -q ${tmpfile})

    if [[ "${current_md5}" != "${latest_md5}" ]]
      then
      warn "Files are different. Update the version variables and verify you don't have a newer version."
      indent "See the differences with 'curl -k -s ${COMMON_SOURCE} | diff - ~/bin/${COMMON_SCRIPT_NAME} | less' "
      [[ $newer_version -ne 1 ]] && update_required=1
    fi
  fi

  # if [[ ${update_required} -eq 1 ]]
  #   then
  #   echo -ne "Looks like ${TITLE} is not the latest version (${online_version}), do you want to update now? \x1B[94;1m(Y/n)\x1B[0m: "
  #   read -r -n 1 response
  #   response=$(echo ${response:y} | tr '[:upper:]' '[:lower:]')
  #   [[ "${response}" == "y" || "${response}" == "" ]] && common_update
  # fi

  rm "${tmpfile}"
}

show_version () {
  tmpfile=$(mktemp -t ${SCRIPT_NAME}.XXXXXX) || exit 1
  curl -k -s -o ${tmpfile} ${SOURCE}

  online_version=$(grep '^VERSION=' ${tmpfile} | cut -f2 -d= | tr -d "'")
  info "${TITLE} version ${VERSION}, online version ${online_version}"

  update_required=0

  latest_version=$(printf "${VERSION}\n${online_version}" | sort -t '.' -k 1,1 -k 2,2 -k 3,3 -k 4,4 -g | tail -1)
  if [[ "${online_version}" != "${latest_version}" ]]
    then
    warn "Watchout, you have a newer version than the online one. Commit and push your changes."
    indent "See the differences with 'curl -k -s ${SOURCE} | diff - ${SCRIPT_NAME} | less' "
    newer_version=1
  fi

  [[ ${online_version} != ${VERSION} ]] && \
    update_required=1 && \
    warn "Versions are different (${online_version} <> ${VERSION})"

  if [[ ${update_required} -eq 0 ]]
    then
    current_md5=$(md5 -q "${SCRIPT_DIR}/${SCRIPT_NAME}")
    latest_md5=$(md5 -q ${tmpfile})

    if [[ "${current_md5}" != "${latest_md5}" ]]
      then
      warn "Files are different. Update the version variables and verify you don't have a newer version."
      indent "See the differences with 'curl -k -s ${SOURCE} | diff - ${SCRIPT_NAME} | less' "
      [[ $newer_version -ne 1 ]] && update_required=1
    fi
  fi

  # if [[ ${update_required} -eq 1 ]]
  #   then
  #   echo -ne "Looks like ${TITLE} is not the latest version (${online_version}), do you want to update now? \x1B[94;1m(Y/n)\x1B[0m: "
  #   read -r -n 1 response
  #   response=$(echo ${response:y} | tr '[:upper:]' '[:lower:]')
  #   [[ "${response}" == "y" || "${response}" == "" ]] && update_me
  # fi

  rm "${tmpfile}"

  indent
  common_version

  exit 0
}

common_update () {
  bkp_id=$(date +'%s')
  info "Backup of previous version in ~/bin/${COMMON_SCRIPT_NAME}.${bkp_id}.bak"
  cp "${SCRIPT_DIR}/${SCRIPT_NAME}" "~/bin/${COMMON_SCRIPT_NAME}.${bkp_id}.bak"

  info "Updating ${COMMON_TITLE} from online version"
  curl -k -s -o "~/bin/${COMMON_SCRIPT_NAME}" ${COMMON_SOURCE}
}

update_me () {
  bkp_id=$(date +'%s')
  info "Backup of previous version in ${SCRIPT_DIR}/${SCRIPT_NAME}.${bkp_id}.bak"
  cp "${SCRIPT_DIR}/${SCRIPT_NAME}" "${SCRIPT_DIR}/${SCRIPT_NAME}.${bkp_id}.bak"

  info "Updating ${TITLE} from online version"
  curl -k -s -o "${SCRIPT_DIR}/${SCRIPT_NAME}" ${SOURCE}

  common_update

  exit 0
}

for arg in "$@"
do
  [[ "${arg}" == "-h" || "${arg}" == "--help" ]] && usage
  [[ "${arg}" == "--debug" ]] && DEBUG=1 && debug "Debug mode is ON"
  [[ "${arg}" == "--version" ]] && show_version
  [[ "${arg}" == "--update" ]] && update_me
done

# Remember to exclude --debug in your parameter parsing.
