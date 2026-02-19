#!/bin/sh

set -eu

PROGRAM="ebash"

usage() {
    cat <<EOF
Usage:
  $PROGRAM --net <foldername> <targets...>
  $PROGRAM --web <args...>

Example:
  $PROGRAM --net scan1 192.168.1.1 10.0.0.0/24
EOF
    exit 1
}

check_dep() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Error: required dependency '$1' not found." >&2
        exit 1
    }
}

[ "$#" -lt 1 ] && usage

MODE="$1"
shift

case "$MODE" in
    --net)
        [ "$#" -lt 2 ] && usage

        FOLDER="$1"
        shift

        check_dep nmap

        if [ -d "$FOLDER" ]; then
            echo "Error: directory '$FOLDER' already exists." >&2
            exit 1
        fi

        mkdir -p "$FOLDER"

        echo "[*] Targets: $*"
        echo "[*] Output directory: $FOLDER"

        # -sV
        echo "[*] Running nmap -sV ..."
        nmap -sV "$@" -oN "$FOLDER/${FOLDER}-sV.txt"

        # -Pn
        echo "[*] Running nmap -Pn ..."
        nmap -Pn "$@" -oN "$FOLDER/${FOLDER}-Pn.txt"

        # -PU
        echo "[*] Running nmap -PU ..."
        nmap -PU "$@" -oN "$FOLDER/${FOLDER}-PU.txt"

        echo "[+] All scans completed."
        ;;

    --web)
        echo "Web mode not implemented yet."
        exit 0
        ;;

    -h|--help)
        usage
        ;;

    *)
        usage
        ;;
esac
