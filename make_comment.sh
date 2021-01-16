#!/bin/sh

MOV_SIZE=1280x720
echo "MOV_SIZE: $MOV_SIZE"

\rm -rf text/* > /dev/null 2>&1
mkdir text > /dev/null 2>&1

convert -size $MOV_SIZE xc:none aaa.png

egrep -v '^#' $1 > tmp_COMMENT.csv
n=0
while read line
do
    font=`echo $line | awk -F, '{print $1}'`
    size=`echo $line | awk -F, '{print $2}'`
    color=`echo $line | awk -F, '{print $3}'`
    stroke_width=`echo $line | awk -F, '{print $4}'`
    stroke_color=`echo $line | awk -F, '{print $5}'`
    gravity=`echo $line | awk -F, '{print $6}'`
    annotate=`echo $line | awk -F, '{print $7}'`
    comment=`echo $line | sed -e 's/^[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,[^,]*,//' -e 's@<[Bb][Rr]>@\\\\n@'g`
    echo "\ncomment_$n.png:"
    echo "  font=$font"
    echo "  size=$size"
    echo "  color=$color"
    echo "  stroke_width=$stroke_width"
    echo "  stroke_color=$stroke_color"
    echo "  gravity=$gravity"
    echo "  annotate=$annotate"
    echo "  comment=$comment"
    echo "convert -font $font -pointsize $size -fill $color -strokewidth $stroke_width -stroke $stroke_color  -gravity $gravity -annotate $annotate \"$comment\" aaa.png text/comment_$n.png"

    convert -font $font -pointsize $size -fill "$color" -strokewidth $stroke_width -stroke $stroke_color -gravity $gravity -annotate $annotate "$comment" aaa.png text/comment_$n.png

    n=`expr $n + 1`
done < tmp_COMMENT.csv

\rm tmp_COMMENT.csv aaa.png

