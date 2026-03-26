#!/bin/sh
str_path="$1"
search="asakiyuki@server.asakiyuki.com:15523/home/asakiyuki/PUBLIC/"

prefix=${str_path%%"$search"*}
prefix_index=${#prefix}

if [ $(expr length "$str_path") -gt $prefix_index ]; then
    prefix_index=$(($prefix_index + $(expr length $search)))
    output=${str_path:prefix_index}
    wl-copy "https://static.asakiyuki.com/${output// /"%20"}"
fi 