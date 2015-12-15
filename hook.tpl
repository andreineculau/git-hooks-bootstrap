#!/usr/bin/env bash
set -e
# More logging for post hooks
[[ $(basename ${BASH_SOURCE[0]}) = "post" ]] && set -x || true

LOGFILE="${BASH_SOURCE[0]}.log"
LOGFILE_TMP=${LOGFILE}.$$
echo "" > ${LOGFILE_TMP}

function finish() {
    [[ $? -ne 0 ]] || {
        # More logging (temporary)
        cat ${LOGFILE_TMP} >> ${LOGFILE}
        rm -f ${LOGFILE_TMP}
        rm -f HAS_ERRORS.$$
        return
    }
    MAIL_ERROR_SUBJECT="${MAIL_ERROR_SUBJECT:-git hook error}"
    MAIL_ERROR_TO="${MAIL_ERROR_TO:-git@example.com}"
    cat ${LOGFILE_TMP} >> ${LOGFILE}
    (
        pwd
        cat ${LOGFILE_TMP}
    ) | mail -s ${MAIL_ERROR_SUBJECT} ${MAIL_ERROR_TO}
    rm -f ${LOGFILE_TMP}
    rm -f HAS_ERRORS.$$
}
trap finish EXIT

# ------------------------------------------------------------------------------

DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)
[[ -f ${DIR}/env.sh ]] && source ${DIR}/env.sh
source ${HOME}/stash-admin/env.sh

# https://github.com/ngsru/atlassian-external-hooks/issues/22
export STASH_PROJECT_KEY=${STASH_PROJECT_KEY:-$(basename $(cd ${DIR}/.. && pwd))}
export STASH_REPO_NAME=${STASH_REPO_NAME:-${STASH_REPO}}
export STASH_REPO_NAME=${STASH_REPO_NAME:-$(basename $(cd ${DIR} && pwd))}
export STASH_HOOK_PID=$$

echo "
=============================
$(date)
STASH_USER_NAME: ${STASH_USER_NAME}
STASH_GIT_BASE_URL: ${STASH_GIT_BASE_URL}
STASH_PROJECT_KEY: ${STASH_PROJECT_KEY}
STASH_REPO_NAME: ${STASH_REPO_NAME}
STASH_HOOK_PID: ${STASH_HOOK_PID}
" >> ${LOGFILE_TMP}

# using a file to detect errors due to the subshelling
rm -f HAS_ERRORS.${STASH_HOOK_PID}
while read PREV_SHA NEW_SHA REF; do
    echo " REF ${REF}"
    echo "from ${PREV_SHA}"
    echo "  to ${NEW_SHA}"
    for process_range in $(ls ${BASH_SOURCE[0]}.process_range* | sort); do
        ${process_range} ${PREV_SHA} ${NEW_SHA} ${REF} || {
            res=$?
            touch HAS_ERRORS.${STASH_HOOK_PID} # HAS_ERRORS=true
            echo $(basename ${process_range}). EXIT CODE: ${res}
        }
    done
done 2>&1 | tee -a ${LOGFILE_TMP}

echo

[[ -f HAS_ERRORS.${STASH_HOOK_PID} ]] && {

    # http://www.chris.com/ascii/index.php?art=people/body%20parts/hand%20gestures
    echo
    echo "           ___________    ____        ."
    echo "    ______/   \\__//   \\__/____\\       ."
    echo "  _/   \\_/  :           //____\\\\      ."
    echo " /|      :  :  ..      /        \\     ."
    echo "| |     ::     ::      \\        /     ."
    echo "| |     :|     ||     \\ \\______/      ."
    echo "| |     ||     ||      |\\  /  |       ."
    echo " \\|     ||     ||      |   / | \\      ."
    echo "  |     ||     ||      |  / /_\\ \\     ."
    echo "  | ___ || ___ ||      | /  /    \\    ."
    echo "   \\_-_/  \\_-_/ | ____ |/__/      \\   ."
    echo "                _\\_--_/    \\      /   ."
    echo "               /____             /    ."
    echo "              /     \\           /     ."
    echo "              \\______\\_________/      ." "${STASH_HOOK_PID}"
    echo

    exit 1
} || true
