#!/bin/bash

count_lines() {
    local file="$1"
    local line_count=$(wc -l < "$file")
    echo "File: $file, Lines: $line_count"
}

count_lines_in_files() {
    local files=()
    local owner=""
    local month=""

    while getopts ":o:m:" opt; do
        case $opt in
            o)
                owner=$OPTARG
                ;;
            m)
                month=$OPTARG
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                show_help
                exit 1
                ;;
        esac
    done

    shift $((OPTIND - 1))

    if [ -n "$owner" ]; then
        files=$(find . -maxdepth 1 -type f -name "*.txt" -user "$owner")
    elif [ -n "$month" ]; then
        files=$(find . -maxdepth 1 -type f -name "*.txt" -newermt "01-$month-$(date +%Y)" ! -newermt "01-$((month+1))-$(date +%Y)")
    else
        files=$(find . -maxdepth 1 -type f -name "*.txt")
    fi

    if [ -z "$files" ]; then
        echo "No files found."
        exit
    fi

    for file in $files; do
        count_lines "$file"
    done
}

show_help() {
    echo "Usage: countlines.sh [options]"
    echo "Options:"
    echo "  -o <owner>   Select files where the owner is <owner>"
    echo "  -m <month>   Select files where the creation month is <month>"
}

count_lines_in_files "$@"
