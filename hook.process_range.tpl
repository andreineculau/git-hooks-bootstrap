#!/usr/bin/env bash
set -e

# source ${STASH_ADMIN_HOME}/common.fun
# source ${STASH_ADMIN_HOME}/git.fun

# need_env ENV_VAR
need STASH_REPO_MAIN_REFS

function process_range() {
    PREV_SHA=${1}
    PREV_SHA_IS_0=$(git_is_delete_commit ${PREV_SHA} && echo true || echo false)
    NEW_SHA=${2}
    NEW_SHA_IS_0=$(git_is_delete_commit ${NEW_SHA} && echo true || echo false)
    REF=${3}
    PUSH_FORCE=$(git merge-base --is-ancestor ${PREV_SHA} ${NEW_SHA} 2>/dev/null && echo false || echo true)
    if [[ ${NEW_SHA_IS_0} = false ]]; then
        if [[ ${PREV_SHA_IS_0} = false && ${PUSH_FORCE} = false ]]; then
            # new commits on an existing ref
            SHAS="$(git rev-list --reverse ${PREV_SHA}..${NEW_SHA})"
        else
            # new ref or push --force
            SHAS="$(git rev-list --reverse $(git for-each-ref --format="%(refname)" ${STASH_REPO_MAIN_REFS} | ${SED} "s/^/^/") ${NEW_SHA})"
        fi
    fi

    # Insert here early checks

    for SHA in ${SHAS}; do
        process_sha ${SHA} ${REF}
    done

    process_ref ${REF}
}

function process_sha() {
    SHA=${1}
    REF=${2}

    # Insert here SHA processing
}

function process_ref() {
    REF=${1}

    # Insert here REF processing
}

process_range $@
