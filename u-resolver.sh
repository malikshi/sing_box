#!/bin/bash
# Update default resolver
rm -f /etc/resolv.conf
cat >/etc/resolv.conf << EOF
nameserver 1.1.1.1
nameserver 8.8.8.8
2606:4700:4700::1111
2001:4860:4860::8888
EOF