#=======================================================================================================
# Author: Johandry Amador <johandry@gmail.com>
# Title:  Install all the scripts
#
# Usage: {script_name} <option>
#
# Options:
#     -h, --help		Display this help message. bash {script_name} -h
#
# Description: Execute this script to install all the programs and files to the required locations to be used.
#
# Report Issues or create Pull Requests in http://github.com/johandry/
#=======================================================================================================

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

source "${SCRIPT_DIR}/common.sh"

mkdir -p ~/bin/

cp -i "${SCRIPT_DIR}/common.sh" ~/bin/
cp -i "${SCRIPT_DIR}/sm" ~/bin/
