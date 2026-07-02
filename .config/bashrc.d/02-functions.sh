get16colors () {
    local n=0
    while [ $n -lt 16 ]; do
        echo -e "\033[01;38;5;${n}m$n\033[m\033[48;5;$n;38;5;232m$n\033[m"
        ((n++))
    done
}

get256colors () {
    local n=0
    while [ $n -lt 256 ]; do
        echo -e "\033[01;38;5;${n}m$n\033[m\033[48;5;$n;38;5;232m$n\033[m"
        ((n++))
    done
}

gzbat () {
    if [ $# -ne 1 ]; then
        return 1
    else
        pigz --stdout --decompress "$1" | bat --file-name "${1%.gz}"
    fi
}

newexec () {
    if [ $# -lt 1 ]; then
        return 1
    elif [ -e "$1" ]; then
        echo "Error: '$1' already exists!" >&2
    else
        if [ $# -ge 2 ]; then
            echo "#!${*:2}" > "$1"
        else
            touch "$1"
        fi
        chmod u+x "$1" && echo "$1"
    fi
}
# vi:ft=bash 
