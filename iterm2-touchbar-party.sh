#!/bin/bash

I2TP_STATUS="${I2TP_STATUS:-true}"
I2TP_STATUS_PWD="${I2TP_STATUS_PWD:-true}"
I2TP_STATUS_GIT="${I2TP_STATUS_GIT:-true}"
I2TP_STATUS_KUBERNETES="${I2TP_STATUS_KUBERNETES:-true}"

function __i2tp_join() {
    local sep="$1"
    shift
    echo -n "$1"
    shift
    printf "%s" "${@/#/${sep}}"
}

function __i2tp_short_pwd() {
    local pwd="${PWD}"
    if [[ "${pwd##${HOME}}" != "${pwd}" ]]; then
        if [[ "${pwd##${HOME}}" == "" ]]; then
            echo -n "~"
            return
        fi
        pwd="~${pwd##${HOME}}"
    fi
    local base_pwd="$(echo "${pwd%/*}" | sed 's/\(\/.\)[^/]*/\1/g')"
    local curr_pwd="${pwd##*/}"
    echo -n "${base_pwd}/${curr_pwd}"
}

function __i2tp_trunc_string() {
    local str_width="$1"
    local str="$2"

    if [[ "${#str}" -gt "${str_width}" ]]; then
        local sep="..."
        local prefix_width="6"
        local suffix_width="$((${#str} - ${str_width} + ${#sep} + ${prefix_width}))"
        local prefix="${str:0:${prefix_width}}"
        local suffix="${str:${suffix_width}:${#str}}"
        local result="${prefix}${sep}${suffix}"
        echo -n "${result}"
    else
        echo -n "${str}"
    fi
}

function __i2tp_print_osc() {
    if [[ $TERM == screen* ]] ; then
        printf "\033Ptmux;\033\033]"
    else
        printf "\033]"
    fi
}

function __i2tp_print_st() {
    if [[ $TERM == screen* ]] ; then
        printf "\a\033\\"
    else
        printf "\a"
    fi
}

function __i2tp_set_kl() {
    __i2tp_print_osc
    printf "1337;SetKeyLabel=%s=%s" "$1" "$2"
    __i2tp_print_st
}

function __i2tp_pop_kl() {
    __i2tp_print_osc
    if [[ "$#" == 1 ]]; then
        printf "1337;PopKeyLabels"
    else
        printf "1337;PopLabels=%s=%s" "$1"
    fi
    __i2tp_print_st
}

function __i2tp_push_kl() {
    __i2tp_print_osc
    if [[ "$#" == 1 ]]; then
        printf "1337;PushKeyLabels"
    else
        printf "1337;PushLabels=%s=%s" "$1"
    fi
    __i2tp_print_st
}

function __i2tp_status_display() {
    local status=()
    if [[ "${I2TP_STATUS_PWD}" == "true" ]]; then
        local spwd="$(__i2tp_status_pwd)"
        status+=("$(__i2tp_trunc_string 30 "${spwd}")")
    fi

    if [[ "${I2TP_STATUS_GIT}" == "true" ]]; then
        local sgit="$(__i2tp_status_git)"
        if [[ "$?" == "0" ]]; then
            status+=("$(__i2tp_trunc_string 20 "${sgit}")")
        fi
    fi

    if [[ "${I2TP_STATUS_KUBERNETES}" == "true" ]]; then
        local skube="$(__i2tp_status_kube)"
        if [[ "$?" == "0" ]]; then
            status+=("$(__i2tp_trunc_string 20 "${skube}")")
        fi
    fi

    local result="$(__i2tp_join "⎜" ${status[@]})"
    __i2tp_set_kl status "${result}"
}

function __i2tp_status_pwd() {
    echo -n "$(__i2tp_short_pwd)"
}

function __i2tp_status_git() {
    local in_git="$(git rev-parse --is-in-git-dir 2> /dev/null)"
    if [[ "in_git" == "false" ]]; then
        return 1
    fi

    local branch="$(git symbolic-ref --quiet HEAD 2> /dev/null)"
    branch="${branch##refs/heads/}"

    echo -n "${branch}"
}

function __i2tp_status_kube() {
    local kctx="$(kubectl config current-context)"
    echo -n "${kctx}"
}

function __i2tp() {
    if [[ "${I2TP_STATUS}" == "true" ]]; then
        __i2tp_status_display
    fi
}
