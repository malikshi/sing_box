#!/bin/bash
# Update default resolver
rm -f /etc/resolv.conf
cat >/etc/resolv.conf << EOF
nameserver 127.0.0.1
nameserver ::1
EOF