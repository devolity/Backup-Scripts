#!/bin/bash
while read x; do
    echo -n `date +%d-%b-%Y:%p\ %H:%M:%S`;
    echo -n " ";
    echo $x;
done
