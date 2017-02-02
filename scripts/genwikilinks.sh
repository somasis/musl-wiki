#!/bin/sh

gen() {
    pwd_escaped=$(printf '%s' "${PWD}" | sed 's/[\/&]/\\&/g')
    for f in "$@";do
        if [ $(sed '1!d' "${f}" | grep -c '^# ') -eq 1 ];then
            title=$(sed '1!d;s/^# //' "${f}")
            f=$(readlink -f "${f}" | sed "s/${pwd_escaped}//;s/\.md$/\.html/")
            printf "[%s]: %s\n" "${title}" "${f}"
        fi
    done
}

#set -x

if [ "${1}" = --gen ];then
    shift
    gen "$@"
    exit 0
fi

find -name '*.md' -exec "$0" --gen {} +

