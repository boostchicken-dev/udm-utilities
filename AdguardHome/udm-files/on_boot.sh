#!/bin/sh

mkdir -p /opt/cni
ln -s /mnt/data/podman/cni/ /opt/cni/bin
ln -s /mnt/data/podman/cni/20-dns.conflist  /etc/cni/net.d/20-dns.conflist

# Create a new bridge interface so the host can talk to containers inside the podman macvlan network
# Assumes your Podman network made in the controller is on VLAN 5
# Adjust the IP to match the address in your cni configuration
ip link set br5 promisc on

ip link add br5.mac link br5 type macvlan mode bridge
ip addr add 10.0.5.1/24 dev br5.mac noprefixroute
ip link set br5.mac promisc on
ip link set br5.mac up

ip route add 10.0.5.3/32 dev br5.mac
#Remove the # on the line below when Docker container is deployed. 
#podman start adguardhome

# Uncomment and adjust these rules if you want to use DNAT to force DNS to this container.
# iptables -t nat -C PREROUTING -i br0 -p udp ! --source 10.0.5.3 ! --destination 10.0.5.3 --dport 53 -j DNAT --to 10.0.5.3 || iptables -t nat -A PREROUTING -i br0 -p udp ! --source 10.0.5.3 ! --destination 10.0.5.3 --dport 53 -j DNAT --to 10.0.5.3
# iptables -t nat -C PREROUTING -i br0 -p tcp ! --source 10.0.5.3 ! --destination 10.0.5.3 --dport 53 -j DNAT --to 10.0.5.3 || iptables -t nat -A PREROUTING -i br0 -p tcp ! --source 10.0.5.3 ! --destination 10.0.5.3 --dport 53 -j DNAT --to 10.0.5.3

