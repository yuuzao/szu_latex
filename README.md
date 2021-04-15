本文档是为了帮助深圳大学硕士毕业生撰写毕业论文而编写的LaTeX论文模板。

本模板参考了湖南大学HNUThesis，在此对原作者表达感谢。

建议使用```xelatex->bibtex->xelatex->xelatex```的方式进行编译。

在Linux环境下，可以使用```main.sh```脚本辅助编译。

具体使用方法可以查看`template.pdf`第一章。

#### 脚本使用说明:
```
sh main.sh [option]

A helper script for tex projects on Linux.
Options:
    -c  删除编译过程产生的文件
    -u  提取出使用过的bibtex条目
    -w  显示统计信息
    -h  显示帮助信息

当没有输入选项时，默认开始编译。
```
