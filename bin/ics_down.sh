#!/bin/bash
## LAN-Schnittstelle stoppen
ETH0=enp3s0
/bin/ifconfig $ETH0 down

## iptables/Masquerading - vorhandene Regeln und Ketten löschen, dnsmasq stoppen
/sbin/iptables -F
 /sbin/iptables -X
  /sbin/iptables -t nat -F
   /usr/bin/killall dnsmasq
    /sbin/sysctl -w net.ipv4.ip_forward=0

exit 0
