#!/bin/bash
command -v eyeD3 >/dev/null 2>&1 || {
    echo "eyeD3 wasn't found. Please install it to use ctag"
    exit 1
}
all=""
exclude=()
if [ -f "$HOME/.config/ctag" ]; then
    IFS=',' read -ra exclude <<< "$(sed "1{p;q}" "$HOME/.config/ctag")"; else
    echo " " > "$HOME/.config/ctag"
fi
while getopts ":he:ad:E:" opt; do
    case $opt in
        h)
            echo "A small CLI interface for Bash to see the tag of all the files in a directory, in particular the artist tag in mp3 files."
            echo "Usage: ctag [OPTIONS] DIRECTORY"
            echo "  -e FORMAT,FORMAT...         Exclude file formats"
            echo "  -E FORMAT,FORMAT...         Exclude just these formats: default exclusion is ignored"
            echo "  -a                          All: paste untagged files, too. Excluded files are still excluded"
            echo "Usage: ctag [OPTION]"
            echo "  -h                          Print this"
            echo "  -d MODE FORMAT,FORMAT...    Default formats to be always exluded"
            echo "                              MODE can be SET, ADD or SUB"
            echo "                              Use without DIRECTORY or other flags"
            exit 0
            ;;
        e)
            IFS=',' read -ra addExcl <<< "$OPTARG"
            for excl in "${addExcl[@]}"; do
                exclude+=("$excl")
            done
            ;;
        a)
            all=v
            ;;
        d)
            forms="${!#}"
            case $OPTARG in
                SET)
                    ;;
                ADD)
                    forms="${exclude[*]},$forms"
                    ;;
                SUB)
                    IFS=','
                    read -ra sub <<< "$forms"
                    forms=()
                    for form in "${exclude[@]}"; do
                        add=""
                        for su in "${sub[@]}"; do
                            if [ "$form" = "$su" ]; then
                                add=v
                            fi
                        done
                        if [ -z "$add" ]; then
                            forms+=("$form")
                        fi
                    done
                    ;;
                \?)
                    echo "Unknown MODE $OPTARG"
                    exit 1
                    ;;
            esac
            for form in "${forms[@]}"; do
                returner+=$form,
            done
            sed -i "1s/.*/${returner}/" "$HOME/.config/ctag"
            echo "Default exluded: $returner"
            exit 0
            ;;
        E)
            IFS=',' read -ra exclude <<< "$OPTARG"
            ;;
        \?)
            echo 'Option not found'
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))
if [ $# -ne 1 ]; then
    echo "Use just one directory"
    exit 1
fi
if [[ ! -d $1 ]]; then
  echo "$1: invalid directory"
  exit 1
fi
names=(Name)
artists=(Artist)
n=0
for file in "${!#}"/*; do 
    if [ -f "$file" ]; then
        name=$(basename "$file")
        if [ "${#exclude[@]}" -eq 0 ] || ! printf '%s\n' "${exclude[@]}" | grep -Fxq "${name##*.}"; then
            artist=$(eyeD3 --no-color "$file" | grep artist)
            if [ -n "$artist" ] || [ -n "$all" ]; then
                ((n+=1))
                names[n]="$name"
                artists[n]=$(echo "$artist" | head -n 1 | cut -d ':' -f2- | sed 's/^[[:space:]]*//')
            fi
        fi
    fi
done
paste <(printf "%s\n" "${names[@]}") <(printf "%s\n" "${artists[@]}") | column -t