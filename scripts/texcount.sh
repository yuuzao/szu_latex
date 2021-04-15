#!/bin/bash
# Author: yuuzao <w@tcp.cat>
# 使用latex自带的texcount程序来统计文章字符数

excludeFile=("acknowledgements.tex appendix.tex cnabstract.tex enabstract.tex copyright.tex cover.tex publications.tex")

# totalStr=" "

for file in $1/*.tex; do
	echo $file

	# continue if it is not a tex file
	if [[ ! "${file##*.}" == "tex" ]]; then
		continue
	fi

	# skip excluded files
	if [[ ! " ${excludeFile[@]} " =~ " ${file##*/} " ]]; then
		totalStr="${totalStr} ${file}"
	fi

done

echo $totalStr

# using the texcount tool of latex.
texcount $totalStr
