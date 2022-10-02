# sing_box
Tutorial sing-box client

# Tutorial step by step
Secara singkat prosesnya yakni compile/build sing-box terlebih dahulu, selanjutnya install DNS client DNS over HTTPS menggunakan cloudflared. Tahap Terakhir tinggal start sing-box.

## Build sing-box
- Login as root

```sh
sudo su
```
- Install Golang terbaru.

```sh
cd
curl -fsL https://raw.githubusercontent.com/jetsung/golang-install/main/install.sh | bash
source /root/.bashrc
```

- Compile sing-box

```sh
go install -v -tags "with_acme with_clash_api with_quic with_grpc with_wireguard with_ech with_utls with_gvisor with_shadowsocksr" github.com/sagernet/sing-box/cmd/sing-box@dev-next
```
- Copy binary sing-box

```sh
cp ~/go/bin/sing-box /usr/local/bin/
```

## Install DoH
Disini akan menggunakan cloudflared karena simple penggunaannya, ada beberapa opsi lainnya seperti DNScrypt, Unbound, Knot Resolver.

- Check arsitektur perangkat

```sh
dpkg --print-architecture
```

- Download cloudflared, Go to https://github.com/cloudflare/cloudflared/releases , copy link url binary yang sesuai dengan arsitektur perangkat, dan download. contoh:

```sh
wget https://github.com/cloudflare/cloudflared/releases/download/2022.9.1/cloudflared-linux-arm64
```
  - Copy binary dan beri permission 755

```sh
cp cloudflared-linux-arm64 /usr/local/bin/cloudflared && chmod +x /usr/local/bin/cloudflared
```
  - set user cloudflared

```sh
useradd -s /usr/sbin/nologin -r -M cloudflared
```
  - set config default cloudflared

```sh
cat >/etc/default/cloudflared << EOF
CLOUDFLARED_OPTS="--port 53 --max-upstream-conns 0 --upstream https://1.1.1.1/dns-query --upstream https://1.0.0.1/dns-query --upstream https://[2620:119:35::35]/dns-query --upstream https://[2620:119:53::53]/dns-query"
EOF
```
  - set permission to cloudflared

```sh
chown cloudflared:cloudflared /etc/default/cloudflared && chown cloudflared:cloudflared /usr/local/bin/cloudflared
```
  - add systemd cloudflared

```sh
cd /lib/systemd/system && wget https://raw.githubusercontent.com/trinib/Adguard-Wireguard-Unbound-Cloudflare/main/cloudflared.service && cd $h
```
  - enable cloudflared

```sh
systemctl daemon-reload && systemctl enable cloudflared && systemctl start cloudflared
```
  - add resolver updater

```sh
wget -O /usr/local/bin/u-resolver https://raw.githubusercontent.com/malikshi/sing_box/main/u-resolver.sh && chmod +x /usr/local/bin/u-resolver
```

## Setting sing-box

- Create folder

```
mkdir /etc/sing-box/
cd /etc/sing-box/
```
- Download GEO Assets

```sh
wget -c -P /etc/sing-box/ "https://github.com/SagerNet/sing-geoip/releases/latest/download/geoip.db"
wget -c -P /etc/sing-box/ "https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db"
```
- Download dashboard clash

```sh
wget -O /etc/sing-box/gh-pages.zip https://github.com/haishanh/yacd/archive/gh-pages.zip
unzip /etc/sing-box/gh-pages.zip
```

- Download Config

```sh
wget -c -P /etc/sing-box/ https://raw.githubusercontent.com/malikshi/sing_box/main/vvip.json
```
- Edit Config

Silahkan isi akun dengan akun vvip-iptunnels, jika bukan dari vvip-iptunnels silahkan ubah `true` menjadi `false` pada bagian `multiplex`. Dokumentasi lebih lengkap cek sing-box [configuration](https://sing-box.sagernet.org/configuration/outbound/)

- Install Systemd sing-box

```sh
cat >/etc/systemd/system/sing-box.service << EOF
[Unit]
Description=sing-box Service
Documentation=https://sing-box.sagernet.org/
After=network.target nss-lookup.target
Wants=network.target
[Service]
Type=simple
ExecStartPre=/usr/local/bin/u-resolver
ExecStart=/usr/local/bin/sing-box run -c /etc/sing-box/vvip.json
Restart=on-failure
RestartSec=30s
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000
[Install]
WantedBy=multi-user.target
EOF
```
- Enable systemd sing-box

```sh
systemctl daemon-reload && systemctl enable sing-box && systemctl start sing-box
```

# Feedback/Laporan
- Telegram : https://t.me/synricha
- Telegram Group : https://t.me/+O08-QK6VNXU5NzU1
- Telegram Channel: https://t.me/iptunnelscom

# Donasi / Support
![qris-iptunnels](https://raw.githubusercontent.com/malikshi/sing_box/main/qris-iptunnels.png)