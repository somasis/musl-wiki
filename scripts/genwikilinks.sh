#!/bin/sh

gen() {
    pwd_escaped=$(printf '%s' "${PWD}" | sed 's/[\/&]/\\&/g')
    for f in "$@";do
        if [ $(sed '1!d' "${f}" | grep -c '^# ') -eq 1 ];then
            title=$(sed '1!d;s/^# //' "${f}")
            title_esc=$(printf '%s' "${title}" | sed 's/\//\\\//g')
            f_full=$(readlink -f "${f}" | sed "s/${pwd_escaped}//;s/\.md$/\.html/")
            f_esc=$(printf '%s' "${f_full}" | sed 's/\//\\\//g')
            printf "[%s]: %s\n" "${title}" "${f_full}"
            markdown -f toc -T "${f}" | sed -r "/<a name=(.*)\n/N;/^(<h[1-6]>|<a name=)/!d;N;s/\n//;s/<a name=\"(.*)\"><\/a><h[1-6]>(.*)<\/h[1-6]>/[${title_esc}#\2]: ${f_esc}#\1/"
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

