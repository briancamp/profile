#!/bin/sh

get_config() {
    local search=$(grep '^search ' /etc/resolv.conf 2> /dev/null | head -n 1)
    local domain=$(echo "$search" | sed -re 's/search +//' -e 's/ .*//')
    if [ -z "$domain" ]; then
        echo "Couldn't get domain from /etc/resolv.conf. Exiting."
        exit 1
    fi

    for iface in $@; do
        local line=$(ifconfig "$iface" inet6 | egrep 'inet6 [^f]' | tail -n 1)
        local addr=$(echo $line | sed -e 's/.*inet6 //' -e 's/ .*//')
        if [ -z "$addr" ]; then
            echo "Couldn't get IP address for $if, skipping."
            continue
        fi
	cat <<EOF
interface $iface {
	dns {
		nameserver $addr
		search $domain
	}
}
EOF
    done
}

if [ -z "$1" ]; then
    cat <<EOF
Usage: $0 <interface> ...

Generate a rad.conf with a DNS configuration for the provided interfaces,
and restart rad if necessary.
EOF
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "Must be run as root."
    exit 1
fi

set -e
tmpf="$(mktemp)"
get_config "$@" > "$tmpf"

if cmp -s "$tmpf" /etc/rad.conf; then
    rm -f "$tmpf"
else
    mv -f "$tmpf" /etc/rad.conf
    rcctl restart rad
fi
