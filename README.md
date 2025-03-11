# Winbox Auto Installer
A simple auto install Mikrotik's Winbox in GNU/Linux

## Feature:
1. Supported GNU/Linux distributtions: 
 - Debian
 - Ubuntu
 - Elementary OS, 
 - Zorin OS, 
 - Linux Mint
 - Kali Linux
 - Fedora 
 - RHEL
 - CentOS
 - IGOS Nusantara, 
 - Archlinux
2. Install wine and with dependencies
3. Upgrades wine (from the distribution's repo) to a newer version (only for Fedora, RHEL, CentOS, IGN)
4. Menu entry in the application launcher

## How to install:
Copy and paste this commands to your terminal:

1. `cd /tmp`
2. `git clone https://github.com/kingmikomv/wbox.git`
3. `cd wbox`
4. `sudo ./setup install` **OR** `sudo bash setup install`

## Firewall setting:
On Fedora/CentOS/Redhat, if you experience neighbor discovery problems, open the port in the firewall

`firewall-cmd --permanent --add-port=5678/udp`

`firewall-cmd --reload`

## Icon cache in GTK based desktop:
Optional step for GTK based desktop, if the icon is not loaded or loaded with wrong size. Update icon cache with this command:

`gtk-update-icon-cache -f -t /usr/share/icons/hicolor`

## How to Uninstall:
If you want to Uninstall winbox, just run this command:

`sudo ./setup purge` **OR** `sudo ./setup purge`

# wbxinstall
