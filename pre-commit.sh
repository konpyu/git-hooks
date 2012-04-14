#!/bin/bash

NG_WORDS=(mstg gdev gwdev)
TGT_EXT=(html sub css js erb)

ngword_err_flg=0

for file in `git diff --cached --name-only`
do
    ext=${file##*.}

    is_ext_tgt=0
    for e in ${TGT_EXT[@]} ;do
        [ $ext = $e ] && is_ext_tgt=1
    done
    [ $is_ext_tgt -eq 0 ] && continue

    for ngword in ${NG_WORDS[@]} ;do
        hit_num=`grep -Ic $ngword $file`
        if [ ${hit_num} -gt 0 ]; then
            echo "ngword ${ngword} is detected on your commit at ${file}"
            ngword_err_flg=1
        fi
    done
done

if [ ${ngword_err_flg} = 1 ]; then
    echo "* commit-blocking ngword is detected on your commit. aborted commit."
    exit 1
else
    exit 0
fi
