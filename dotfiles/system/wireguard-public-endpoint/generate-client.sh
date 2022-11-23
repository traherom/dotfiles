#!/bin/bash
DIR=$(dirname "$(readlink -f "$0")")
cd "$DIR"

name=$1
name_dir="clients/$1"
if [ -z "$name" ]; then
	echo "Usage: generate.sh <name>"
	exit 1
fi

# Generate next IP
earliest_ip=50
last_ip_path=last-generated-ip.txt
if [ -f "$last_ip_path" ]; then
	last_ip=$(cat "$last_ip_path")
else
	last_ip=$earliest_ip
fi

ip=$(($last_ip+1))

if [ "$ip" -gt "254" ]; then
	ip=$earliest_ip
fi

echo $ip>"$last_ip_path"


set -x
mkdir -p "$name_dir"
wg genkey | sudo tee "$name_dir/$name.key" | wg pubkey | sudo tee "$name_dir/$name.key.pub"


cat >"$name_dir/$name.conf" <<EOF
[Interface]
PrivateKey = $(cat $name_dir/$name.key)
Address = 10.0.200.$ip/17
DNS = 10.0.0.10, 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = $(cat server.key.pub)
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = home.moreharts.com:51820
EOF

cat >>"wg0.conf" <<EOF
[Peer]
# $name
PublicKey = $(cat $name_dir/$name.key.pub)
AllowedIPs = 10.0.200.$ip/32
EOF

qrencode -t ansiutf8 < "$name_dir/$name.conf"

systemctl restart wg-quick@wg0
