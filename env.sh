#!/usr/bin/env bash

# NOTE: use the default pattern only

export STASH_ADMIN_HOME="${STASH_ADMIN_HOME:-$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)}"
export STASH_WWW_BASE_URL=${STASH_WWW_BASE_URL:-https://stash.example.com}
export STASH_GIT_BASE_URL=${STASH_GIT_BASE_URL:-git@stash.example.com}
export STASH_REPO_MAIN_REFS=${STASH_REPO_MAIN_REFS:-refs/heads/master refs/heads/develop}
export STASH_ALLOW_ANYTHING_BEFORE_COMMIT_DATE=${STASH_ALLOW_ANYTHING_BEFORE_COMMIT_DATE:-0}

export STASH_MAIL_ERROR_FROM="${STASH_MAIL_ERROR_FROM:-git@example.com}"
export STASH_MAIL_ERROR_SUBJECT="${STASH_MAIL_ERROR_SUBJECT:-git hook error}"
export STASH_MAIL_ERROR_TO="${STASH_MAIL_ERROR_TO:-git@example.com}"
