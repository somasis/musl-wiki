#!/bin/sh

set -e

markdown_flags="-f links,smarty,html,ext,superscript,emphasis,strikethrough,toc,autolink,header,divquote,alphalist,definitionlist,dldiscount,dlextra,footnote,style,fencedcode,githubtags"

stderr() {
    printf '%s\n' "$*" >&2
}

edo() {
    printf '%s\n' "$*" >&2
    "$@"
}

temp_recurse() {
    # recurse to find parent templates
    base=$(basename "${file}" .md)
    old_pwd="${PWD}"
    cd "${dir}"
    until [ "${PWD}" = / ];do
        for f in "${PWD}"/page.template "${PWD}"/${base}.template;do
            [ -e "${f}" ] && printf '%s' "${f}" && return 0
        done
        cd ..
    done
    cd "${old_pwd}"
    stderr "couldn't find a template to use for \"${file}\"."
    return 1
}

finish() {
    rm -f "${body}" "${bodymd}" "${html}" "${html2}" "${toc}" "${temp}" "${temp2}"
}

trap finish EXIT

if [ "$1" = --template ];then
    template_only=true
    shift
fi

file="$1"; shift
[ "$#" -eq 1 ] && output="$1" && shift
dir=$(readlink -f "${file}")
dir=${dir%/*}

temp=$(temp_recurse "${file}")

if [ "${template_only}" = true ];then
    printf '%s\n' "${temp}"
    temp=
    exit 0
fi

temp2=$(mktemp)
cat "${temp}" > "${temp2}"
temp="${temp2}";temp2=$(mktemp)

# Remove top markdown header; just the body is needed
body=$(mktemp)
bodymd=$(mktemp)
html=$(mktemp)
html2=$(mktemp)
toc=$(mktemp)

if [ $(sed -n '1p' "${file}" | grep -Ec '^# ') -eq 1 ] && \
   [ $(sed -n '2p' "${file}" | grep -Ec '^## ') -lt 1 ];then
    title=$(sed '1!d;s/^# //' "${file}")
    description=
    has_title=true
    has_description=false
elif [ $(sed -n '1p' "${file}" | grep -c '^# ') -eq 1 ] && \
     [ $(sed -n '2p' "${file}" | grep -c '^% ') -eq 1 ];then
    title=$(sed '1!d;s/^# //' "${file}")
    template=$(sed '2!d;s/^% //' "${file}")
    has_title=true
    has_description=false
elif [ $(sed -n '1p;2p' "${file}" | grep -Ec '^#{1,2} ') -lt 2 ];then
    stderr "error: \"${file}\" should contain a title and description in the format of:"
    stderr "# Title"
    stderr "## Description."
    stderr "as the first two lines of the file."
    exit 5
else
    title=$(sed '1!d;s/^# //' "${file}")
    description=$(sed '2!d;s/^## //' "${file}")
    has_title=true
    has_description=true
fi

title_unprefixed="${title}"
[ "${title}" = "musl libc" ] || title="musl libc - ${title}"

case ${has_title}${has_description} in
    truetrue)
        stderr "sed '1d2d' \"${file}\" > \"${bodymd}\""
        sed '1d2d' "${file}" > "${bodymd}"
    ;;
    truefalse)
        stderr "sed '1d' \"${file}\" > \"${bodymd}\""
        sed '1d' "${file}" > "${bodymd}"
    ;;
    *)
        exit 6
esac

$(dirname "$(readlink -f "${0}")")/genwikilinks.sh >> "${bodymd}"

stderr "markdown ${markdown_flags} \"${bodymd}\" > \"${body}\""
markdown ${markdown_flags} "${bodymd}" > "${body}"

stderr "markdown ${markdown_flags} -T -n \"${bodymd}\" > \"${toc}\""
markdown ${markdown_flags} -T -n "${bodymd}" > "${toc}"

# get metadata about markdown file
tree_commit=$(git rev-parse HEAD 2>/dev/null || printf unknown)
file_commit=$(git log --format='%H' -1 "${file}" || printf unknown)
author=$(git shortlog -ns "${file}" | cut -d$'\t' -f2 | sed 's/$/,/')
if [ $(printf '%s\n' "${author}" | wc -l) -gt 10 ];then
    author=$(printf '%s\n' "${author}" | head -n 10)
    author=$(printf '%s\n' "${author}" "...")
fi
author=$(printf '%s\n' "${author}" | tr '\n' ' ' | sed -r 's/,? $//')
date=$(git log --date='format:%Y-%m-%d' --format='%ad' -1 "${file}")

edo sed \
    -e "s|<?makefile commit?>|${tree_commit} / ${file_commit}|g" \
    -e "s|<?makefile title?>|${title}|g" \
    -e "s|<?makefile title_unprefixed?>|${title_unprefixed}|g" \
    -e "s|<?makefile description?>|${description}|g" \
    -e "s|<?makefile author?>|${author}|g" \
    -e "s|<?makefile date?>|${date}|g" \
    -e "s|<?makefile version?>|$(markdown -VV)|g" \
    "${temp}" > "${temp2}"
edo sed \
    "/<?makefile body?>/{
        r ${body}
        d
    }" "${temp2}" > "${html}"
edo sed \
    "/<?makefile toc?>/{
        r ${toc}
        d
    }" "${html}" > "${temp2}"

if [ -n "${output}" ];then
    cat "${temp2}" > "${output}"
else
    cat "${temp2}"
fi
