# sing_box
Tutorial sing-box client

# Tutorial step by step
Secara singkat prosesnya yakni compile/build sing-box terlebih dahulu, selanjutnya Setting DNS Updater. Tahap Terakhir tinggal start sing-box.

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

## Setting DNS
Disini akan menggantikan default dns dari WAN/Modem.

  - add resolver updater

```sh
wget -O /usr/local/bin/u-resolver https://raw.githubusercontent.com/malikshi/sing_box/main/u-resolver.sh && chmod +x /usr/local/bin/u-resolver && u-resolver
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

Jika menggunakan akun dari vvip-iptunnels silahkan ubah `false` menjadi `true` pada bagian `multiplex` untuk memperoleh ping lebih bagus namun untuk speedtest/streaming menjadi kurang bagus. Dokumentasi lebih lengkap cek sing-box [configuration](https://sing-box.sagernet.org/configuration/outbound/)

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