iptables --flush

#
#Set default policies for INPUT, FORWARD and OUTPUT chains
#
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# lo
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

iptables -A OUTPUT -o wlx76011020c516 -m state --state ESTABLISHED,RELATED -j ACCEPT

#---------------------------------------------------------------
# Allow port 80 (www) and 22 (SSH) connections to the firewall
#---------------------------------------------------------------

iptables -A INPUT -p tcp -i wlx76011020c516 --dport 2222 --sport 1024:65535 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp -i wlx76011020c516 --dport 80 --sport 1024:65535 -m state --state NEW -j ACCEPT

#---------------------------------------------------------------
# Allow port 80 (www) and 443 (https) connections from the firewall
#---------------------------------------------------------------

iptables -A OUTPUT -j ACCEPT -m state --state NEW,ESTABLISHED,RELATED -o wlx76011020c516 -p tcp --dport 80 --sport 1024:65535
iptables -A OUTPUT -j ACCEPT -m state --state NEW,ESTABLISHED,RELATED -o wlx76011020c516 -p tcp --dport 443 --sport 1024:65535

#---------------------------------------------------------------
# Allow previously established connections
# - Interface eth0 is the internet interface
#---------------------------------------------------------------

iptables -A INPUT -j ACCEPT -m state --state ESTABLISHED,RELATED -i wlx76011020c516 -p tcp

#dns
iptables -A OUTPUT -p udp -o wlx76011020c516 --dport 53 --sport 1024:65535 -j ACCEPT
iptables -A INPUT -p udp -i wlx76011020c516 --sport 53 --dport 1024:65535 -j ACCEPT


