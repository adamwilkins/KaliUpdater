#!/bin/bash
# This script will configure Kali from fresh to a ready to go state.

## Make sure the repo list is up to date
sudo apt update

## Install Wallpapers (VERY IMPORTANT)
sudo apt-get install -y kali-linux-default kali-linux-large kali-linux-everything kali-wallpapers-all

## Install VSS Code
sudo apt install -y curl gpg gnupg2 software-properties-common apt-transport-https
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code
rm microsoft.gpg

## Fix Proxychains
Proxy chains
sudo bash -c 'cat << "EOF" > /etc/proxychains4.conf
strict_chain
quiet_mode
remote_dns_subnet 224
tcp_read_time_out 1500
tcp_connect_time_out 800
localnet 127.0.0.1:7687/255.255.255.0
localnet 0.0.0.0/5
localnet 8.0.0.0/7
localnet 11.0.0.0/8
localnet 12.0.0.0/6
localnet 16.0.0.0/4
localnet 32.0.0.0/3
localnet 64.0.0.0/2
localnet 128.0.0.0/3
localnet 160.0.0.0/5
localnet 168.0.0.0/6
localnet 172.32.0.0/11
localnet 172.64.0.0/10
localnet 172.128.0.0/9
localnet 173.0.0.0/8
localnet 174.0.0.0/7
localnet 176.0.0.0/4
localnet 192.0.0.0/9
localnet 192.128.0.0/11
localnet 192.160.0.0/13
localnet 192.169.0.0/16
localnet 192.170.0.0/15
localnet 192.172.0.0/14
localnet 192.176.0.0/12
localnet 192.192.0.0/10
localnet 193.0.0.0/8
localnet 194.0.0.0/7
localnet 196.0.0.0/6
localnet 200.0.0.0/5
localnet 208.0.0.0/4
localnet 224.0.0.0/3
[ProxyList]
socks5 127.0.0.1 1080
EOF'

## Tillix
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /usr/local/share/fonts/
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /usr/local/share/fonts/
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /usr/local/share/fonts/
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /usr/local/share/fonts/
sudo ln -fs /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
dconf load /com/gexperts/Tilix/ < Tilix.conf
sudo apt install -y tilix

## Nuclei
if command -v nuclei &> /dev/null
then
  nuclei -reset
fi
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
nuclei -up
nuclei -ut

#Install PIPX 
sudo apt install -y pipx
pipx ensurepath
exec bash

## Netexec (CME)
apt install pipx git
pipx ensurepath
exec bash
pipx install git+https://github.com/Pennyw0rth/NetExec

## VMShare
if [ -d /mnt/hgfs ]; then
  :
else
  mkdir /mnt/hgfs
fi
if grep -Fxq "vmhgfs-fuse /mnt/hgfs  fuse defaults,allow_other   0   0" "/etc/fstab"; then
  :
else
  echo "vmhgfs-fuse /mnt/hgfs  fuse defaults,allow_other   0   0" | sudo tee -a /etc/fstab
fi

## Reboot
sudo reboot now
