#!/bin/bash
check=""
exclude=""
while getopts ":he:c" opt; do
    case $opt in
        h)
            printf 'A tool to see all music files artists in a directory\n-h    print this\n-e [FORMAT,FORMAT...]    exclude a file format\n-c   check: paste not tagged files, too'
            exit 0
            ;;
        e)
            IFS=',' read -ra exclude <<< "$OPTARG"
            ;;
        c)
            check="v"
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
            if [ -n "$artist" ] || [ -n "$check" ]; then
                ((n+=1))
                names[n]="$name"
                artists[n]=$(echo "$artist" | head -n 1 | cut -d ':' -f2- | sed 's/^[[:space:]]*//')
            fi
        fi
    fi
done
paste <(printf "%s\n" "${names[@]}") <(printf "%s\n" "${artists[@]}") | column -t