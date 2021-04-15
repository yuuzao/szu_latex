#!/bin/bash
# Copyright (C) yuuzao <w@tcp.cat>
# This is free software: you can do whatever you want with it.
# Thanks for mohuangrui/ucasthesis

TexFile=$(echo *.tex)
FileName=${TexFile/.tex/}
scripts=scripts
#->> Set compilation out directory resembling the inclusion hierarchy
Tmp="Tmp"
Tex="Tex"
if [[ ! -d $Tmp/$Tex ]]; then
    mkdir -p $Tmp/$Tex
fi

usage() {
    echo "Usage: sh main.sh [option]"
    echo -e "compile a tex project\n"
    echo "Options:"
    echo "    -u  提取出使用过的bibtex条目"
    echo "    -c  删除编译过程产生的文件"
    echo "    -h  显示帮助信息"
    echo "    -w  显示统计信息"
    echo -e "\n当没有输入选项时，默认开始编译项目"
}

compile() {
    #---------------------------------------------------------------------------#
    # #->> Compiling
    # xelatex->bibtex->xelatex->xelatex

    TexCompiler="xelatex"
    BibCompiler="bibtex"

    $TexCompiler -output-directory=$Tmp $FileName || exit
    #- fix the inclusion path for hierarchical auxiliary files
    sed -i -e "s|\@input{|\@input{$Tmp/|g" $Tmp/"$FileName".aux
    #- extract and format bibliography database via auxiliary files
    $BibCompiler $Tmp/$FileName
    #- insert reference indicators into textual content
    $TexCompiler -output-directory=$Tmp $FileName || exit
    $TexCompiler -output-directory=$Tmp $FileName || exit
    #---------------------------------------------------------------------------#
    # #->> Postprocessing
    mv $Tmp/$FileName.pdf .

    echo "---------------------------------------------------------------------------"
    echo "$TexCompiler $BibCompiler "$FileName".tex finished..."
    echo "---------------------------------------------------------------------------"
}

clean() {

    texTempFile='__latexindent_temp.*'

    echo 'deleting' $texTempFile
    rm $texTempFile 2>/dev/null
    rm setup/$texTempFile 2>/dev/null
    rm $Tex/$texTempFile 2>/dev/null

    echo 'deleting' $Tmp
    rm -rf $Tmp 2>/dev/null
}

wordCount() {
    source $scripts/texcount.sh $(realpath $Tex)
}

usedbib() {
    if [[ ! -d $Tmp ]]; then
        echo 'Please comiple first and remain the Tmp directory'
        exit 1
    fi

    bbl=$(realpath $Tmp/$FileName.bbl)
    if [[ ! -e $bbl ]]; then
        echo 'No' $FileName.bbl 'in the' $Tmp 'directory, exit...'
        exit 1
    fi
    ref=$(realpath references.bib)
    useful=useful.bib
    usefulbib=$scripts/usefulbib.sh
    source $usefulbib $bbl $ref $useful
}

main() {
    while getopts ':chwu' OPT; do
        case "$OPT" in
        c)
            echo 'cleaning....'
            clean
            echo 'tmp files are deleted.'
            ;;
        h)
            usage
            ;;
        w)
            wordCount
            ;;
        u)
            usedbib
            ;;
        ?)
            usage
            ;;
        esac
        exit 1
    done

    # set compile as the default action if no option is assigned.
    compile

}

main $1
