#!/bin/sh
# Author: yuuzao <w@tcp.cat>

file=$1
ref=$2
usefulbib=$3

# empty a file at first.
echo -e '% !Mode:: "TeX:UTF-8\n' >$usefulbib

pattern=']{'
x=$(grep -E $pattern $file)

used() {

    # a line with line numer
    line=$(grep -n $1 $ref)
    if [[ -z $line ]]; then
        return 0
    fi

    # pure line number
    linenum=$(sed 's/:.*//' <<<$line)
    start=$linenum
    left_brace=0

    # parse bibtex items, a stack is used to store left brace symbol.
    while true; do
        content=$(sed -e "${linenum}!d" $ref)
        for ((i = 0; i < ${#content}; i++)); do
            char=${content:$i:1}
            if [[ $char == '{' ]]; then
                ((left_brace++))
            elif [[ $char == '}' ]]; then
                ((left_brace--))
            fi
        done

        if [[ $left_brace == 0 ]]; then
            break
        fi

        ((linenum++))
    done

    # copy a bibtex item to another file
    sed -n "${start},${linenum}p" $ref >>$usefulbib
    # format it with newline
    echo '' >>$usefulbib

    return 1
}

# Warning: the default demilter of shell list is space, it can be changed to '\n' by IFS.
export IFS=$'\n'
counter=0
for bib in $x; do
    bib=${bib/*\]\{/}
    bib=${bib/\}/}
    used $bib
    ((counter += $?))
done

echo $counter 'bibtex items in total are used in your Tex content'
echo 'Now you can find them in' $3
