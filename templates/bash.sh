#!/usr/bin/env bash

#=======================================================================================================
# Author: Johandry Amador <johandry@gmail.com>
# Title:  {title}
# Version: {version}
#
# Usage: {script_name} <options>
#
# Options:
#     -h, --help                  Display this help message. bash {script_name} -h
#     --version                   Print {title} version 
#     --update                    Update to latest online version of {title} and create a backup of local copy.
#     --debug                     Useful when {title} is in development
#
# Description: {title} is a script to ...
#
# Report Issues or create Pull Requests in http://github.com/johandry/{project_name}
#=======================================================================================================

VERSION='1.0.0'
TITLE='Bash Template'
PROJECT="CS"

source ~/bin/common.sh

[[ "$#" == "0" ]] && usage && exit 0

action=

while (( $# ))
do
  case $1 in
    # -h and --help are covered in common.sh script
    option1)
      action="echo Option1"
    ;;

    option2)
      param=$2 ; shift
      action="echo 'Option2 ${param}'"
    ;;

    --debug)
    ;;

    *)
    ;;
  esac
  shift
done

eval "${action}"
