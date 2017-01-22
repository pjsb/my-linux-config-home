#!/bin/bash

ETH0=enp3s0
WLAN0=wlp9s0
## LAN-Schnittstelle konfigurieren
/bin/ifconfig $ETH0 down
 /bin/sleep 2
  /bin/ifconfig $ETH0 192.168.3.1 broadcast 192.168.3.255 netmask 255.255.255.0
    /bin/sleep 2
     /bin/ifconfig $ETH0 up
     /sbin/iptables -t nat -A POSTROUTING -o $ETH0 -j MASQUERADE

## Maskieren der WLAN-Schnittstelle, Port-Forwarding & Nat aktivieren
/sbin/iptables -A FORWARD -o $WLAN0 -i $ETH0 -s 192.168.3.0/24 -m conntrack --ctstate NEW -j ACCEPT
 /sbin/iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
  /sbin/iptables -t nat -A POSTROUTING -o $WLAN0 -j MASQUERADE 
   /sbin/sysctl -w net.ipv4.ip_forward=1 

## dnsmasq-base starten
/bin/sleep 2
 /usr/bin/killall dnsmasq
  /bin/sleep 2
   /usr/sbin/dnsmasq -i $ETH0 -I $WLAN0 -F 192.168.3.10,192.168.3.20,infinite
exit 0
