#!/bin/bash
all=""
exclude=""
while getopts ":he:a" opt; do
    case $opt in
        h)
            echo "A small CLI interface for Bash to see the tag of all the files in a directory, in particular the artist tag in mp3 files."
            echo "Usage: ctag [OPTIONS] DIRECTORY"
            echo "  -h                      Print this"
            echo "  -e [FORMAT,FORMAT...]   Exclude file formats"
            echo "  -a                      All: paste untagged files, too"
            exit 0
            ;;
        e)
            IFS=',' read -ra exclude <<< "$OPTARG"
            ;;
        a)
            all="v"
            ;;
        \?)
            echo 'Option not found'
            exit 1
            ;;
    esac
done
names=(Name)
artists=(Artist)
n=0
for file in "${!#}"/*; do 
    if [ -f "$file" ]; then
        name=$(basename "$file")
        if [ "${#exclude[@]}" -eq 0 ] || ! printf '%s\n' "${exclude[@]}" | grep -Fxq "${name##*.}"; then
            artist=$(eyeD3 "$file" | grep artist)
            if [ -n "$artist" ] || [ -n "$all" ]; then
                ((n+=1))
                names[n]="$name"
                artists[n]=$(echo "$artist" | head -n 1 | cut -d ':' -f2- | sed 's/^[[:space:]]*//')
            fi
        fi
    fi
done
paste <(printf "%s\n" "${names[@]}") <(printf "%s\n" "${artists[@]}") | column -t