#!/usr/bin/env bash

export AWK=$(which gawk 2>/dev/null || which awk 2>/dev/null || echo "GNU_AWK_NOT_FOUND")
export BASE64=$(which base64 2>/dev/null || echo "BASE64_NOT_FOUND")
export COMM=$(which gcomm 2>/dev/null || which comm 2>/dev/null || echo "GNU_COMM_NOT_FOUND")
export CURL=$(which curl 2>/dev/null || echo "CURL_NOT_FOUND")
export CUT=$(which gcut 2>/dev/null || which cut 2>/dev/null || echo "GNU_CUT_NOT_FOUND")
export FIND=$(which gfind 2>/dev/null || which find 2>/dev/null || echo "GNU_FIND_NOT_FOUND")
export FOLD=$(which gfold 2>/dev/null || which fold 2>/dev/null || echo "GNU_FOLD_NOT_FOUND")
export GREP=$(which ggrep 2>/dev/null || which grep 2>/dev/null || echo "GNU_GREP_NOT_FOUND")
export HEAD=$(which ghead 2>/dev/null || which head 2>/dev/null || echo "GNU_HEAD_NOT_FOUND")
export SED=$(which gsed 2>/dev/null || which sed 2>/dev/null || echo "GNU_SED_NOT_FOUND")
export SHASUM=$(which shasum 2>/dev/null || which sha1sum 2>/dev/null || echo "SHA1SUM_NOT_FOUND")
export SORT=$(which gsort 2>/dev/null || which sort 2>/dev/null || echo "GNU_SORT_NOT_FOUND")
export TAIL=$(which gtail 2>/dev/null || which tail 2>/dev/null || echo "GNU_TAIL_NOT_FOUND")
export TAR=$(which gtar 2>/dev/null || which gnutar 2>/dev/null || which tar 2>/dev/null || echo "GNU_TAR_NOT_FOUND")
export TR=$(which gtr 2>/dev/null || which tr 2>/dev/null || echo "GNU_TR_NOT_FOUND")
export UNZIP=$(which gunzip 2>/dev/null || echo "GNU_UNZIP_NOT_FOUND")
export XMLLINT=$(which xmllint 2>/dev/null || echo "XMLLINT_NOT_FOUND")
export WC=$(which gwc 2>/dev/null || which wc 2>/dev/null || echo "GNU_WC_NOT_FOUND")

[[ -n "${COLOR}" ]] && {
    export BLACK="$(tput setaf 0)"
    export RED="$(tput setaf 1)"
    export GREEN="$(tput setaf 2)"
    export YELLOW="$(tput setaf 3)"
    export BLUE="$(tput setaf 4)"
    export MAGENTA="$(tput setaf 5)"
    export CYAN="$(tput setaf 6)"
    export WHITE="$(tput setaf 7)"

    export BRIGHT="$(tput bold)"
    export BLINK="$(tput blink)"
    export REVERSE="$(tput smso)"
    export UNDERLINE="$(tput smul)"

    export NORMAL="$(tput sgr0)"
    export GREY="${BRIGHT}${BLACK}"

    export ONBLACK="$(tput setab 0)"
    export ONRED="$(tput setab 1)"
    export ONGREEN="$(tput setab 2)"
    export ONYELLOW="$(tput setab 3)"
    export ONBLUE="$(tput setab 4)"
    export ONMAGENTA="$(tput setab 5)"
    export ONCYAN="$(tput setab 6)"
    export ONWHITE="$(tput setab 7)"
}

# http://stackoverflow.com/a/10797966/465684
# VAR="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "${VAR}")"

function urlencode() {
    local data
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 string-to-urlencode"
        return 1
    fi
    data="$(curl -s -o /dev/null -w %{url_effective} --get --data-urlencode "=$@" "")"
    if [[ $? != 3 ]]; then
        echo "Unexpected error" 1>&2
        return 2
    fi
    echo "${data##/?}"
    return 0
}

function need_env() {
    local VAR="${!1}"
    [[ -n ${VAR} ]] || {
        echo >&2 "Variable \$$1 is not set!"
        exit 1
    }
}

function exe() {
    echo "\$ $@"
    "$@"
}
