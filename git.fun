#!/usr/bin/env bash

source ${STASH_ADMIN_HOME}/misc.fun

function git_get_root() {
    git rev-parse --show-toplevel 2>/dev/null
}

function git_get_short_hash() {
    SHA=${1}
    git rev-parse --short ${SHA}
}

function git_get_svn_id() {
    SHA=${1}
    git log --format=%B -1 ${SHA} | \
        ${GREP} "git-svn-id" | \
        ${SED} -n "s|.*\@\([0-9]\+\).*|\1|p"
}

function git_get_commit_message() {
    SHA=${1}
    git log --format=%B -1 ${SHA} | \
        ${GREP} -v "git-svn-id"
}

function git_get_commit_subject() {
    SHA=${1}
    git_get_commit_message ${SHA} | \
        ${HEAD} -n1
}

function git_get_commit_tickets() {
    SHA=${1}
    git_get_commit_subject ${SHA} | \
        ${GREP} -o "#[0-9]\+" |
        ${SED} "s|#||g"
}

function git_get_commit_ticket() {
    SHA=${1}
    git_get_commit_tickets ${SHA} | \
        ${HEAD} -n1 || \
        echo "no ticket"
}

function git_is_delete_commit() {
    SHA=${1}
    [[ ${SHA} =~ (^0+$) ]]
}

function git_is_merge_commit() {
    SHA=${1}
    [[ $(git log -1 --format=%P ${SHA} | ${WC} -w) -gt 1 ]]
}

function git_is_revert_commit() {
    SHA=${1}
    [[ $(git log -1 --format=%s ${SHA}) =~ Revert* ]]
}

function git_is_branch_ref() {
    REF=${1}
    [[ ${REF} =~ (^refs/heads/) ]]
}

function git_is_tag_ref() {
    REF=${1}
    [[ ${REF} =~ (^refs/tags/) ]]
}

function git_check_attr_in_sha() {
    SHA=${1}
    shift

    # useful for bare repositories where git check-attr does not work
    export GIT_INDEX_FILE=index.check_attr.$$
    git read-tree --reset -i ${SHA}
    git check-attr --cached $@
    rm ${GIT_INDEX_FILE}
    unset GIT_INDEX_FILE
}

function git_guess_main_branch_of_commit() {
    REF=${1:-HEAD}
    POSSIBLE_MAIN_BRANCHES=${2}
    eval "git branch --list -a --contains ${REF} ${POSSIBLE_MAIN_BRANCHES}" | cut -c 3-
}

function git_guess_main_branch() {
    POSSIBLE_MAIN_BRANCHES=${1}
    STARTING_REF=${2:-HEAD}
    git rev-list --first-parent ${STARTING_REF} | while read REF; do
        BRANCH_REFS=$(git_guess_main_branch_of_commit ${REF} "${POSSIBLE_MAIN_BRANCHES}")
        [[ -n ${BRANCH_REFS} ]] && echo "${BRANCH_REFS}" && return 0
    done
    return 1
}

function git_find_branching_commit() {
    REF1=${1}
    REF2=${2}
    [[ -z ${REF1} ]] && echo >&2 "Missing REF1" && return 1
    [[ -z ${REF2} ]] && echo >&2 "Missing REF2" && return 1
    ${COMM} --nocheck-order -1 -2 <(git rev-list --reverse --first-parent ${REF1}) <(git rev-list --reverse --first-parent ${REF2}) | ${TAIL} -1
}
