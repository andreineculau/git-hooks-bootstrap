#!/usr/bin/env bash

source ${STASH_ADMIN_HOME}/misc.fun

function stash_get_repo_link() {
    BASE_URL=${1}
    PROJECT=$(echo ${2} | ${TR} "[:lower:]" "[:upper:]")
    REPO=$(echo ${3} | ${TR} "[:upper:]" "[:lower:]")
    echo "${BASE_URL}/projects/${PROJECT}/repos/${REPO}"
}

function stash_get_ref_link() {
    BASE_URL=${1}
    PROJECT=${2}
    REPO=${3}
    REF=${4}
    echo "$(stash_get_repo_link ${BASE_URL} ${PROJECT} ${REPO})/commits?until=$(urlencode "${REF}")"
}

function stash_get_commit_link() {
    BASE_URL=${1}
    PROJECT=${2}
    REPO=${3}
    SHA=${4}
    echo "$(stash_get_repo_link ${BASE_URL} ${PROJECT} ${REPO})/commits/${SHA}"
}

function stash_get_compare_link() {
    BASE_URL=${1}
    PROJECT=${2}
    REPO=${3}
    SOURCE_REF=${4}
    TARGET_REF=${5}
    echo "$(stash_get_repo_link ${BASE_URL} ${PROJECT} ${REPO})/compare/commits?sourceBranch=$(urlencode "${SOURCE_REF}")&targetBranch=$(urlencode "${TARGET_REF}")"
}

function stash_get_pr_link() {
    BASE_URL=${1}
    PROJECT=${2}
    REPO=${3}
    ID=${4}
    echo "$(stash_get_repo_link ${BASE_URL} ${PROJECT} ${REPO})/pull-requests/${ID}/overview"
}
