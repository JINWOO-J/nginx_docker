#!/bin/sh

for image in nginx 
do
    echo "## $image docker setting" >README.md
    echo "" >>README.md
    cat files/run.sh  | grep ^export  | cut -d "=" -f 1 | sed 's/export//g' | sed 's/_/\\_/g' > text1
    cat files/run.sh | grep ^export  | cut -d ":" -f2 | sed -E 's/-|}|"//g'  | cut -d "#" -f1  | sed 's/_/\\_/g' > text2
    cat files/run.sh | grep ^export  | cut -d ":" -f2 | sed -E 's/-|}|"//g'  |  cut -d "#" -f2 | sed 's/_/\\_/g'  > text3
    echo "| enviroment variable |default |  Description|" >>README.md
    echo "|--------|--------|------|"     >>README.md
    paste -d "|"  text1  text2  text3  >>README.md
done

rm -f text1 text2 text3