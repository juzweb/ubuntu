Setup SSH
==========
- sudo apt-get update
- sudo apt-get install openssh-server
- sudo systemctl status sshd
- netstat -tulpn | grep 22

Firewall Command
====================
# To output all of the active iptables rules in a table,
sudo iptables -L --line-numbers
# look at the INPUT chain
sudo iptables -L INPUT
# showing Packet Counts and Aggregate Size
sudo iptables -L INPUT -v
# to clear the counters for a specific rule, specify the chain name and the rule number.
sudo iptables -Z INPUT 1
# Deleting Rules by Chain and Number
sudo iptables -D INPUT 3


Backup & Restore Iptables
=========================
# backup
iptables-save > /opt/iptables.backup
# restore
iptables-restore < /opt/iptables.backup

# To list out all of the active iptables rules by specification,
sudo iptables -S

Firewall sample
=================
# Flushing all rules
iptables -F
iptables -X
# Setting default filter policy
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
# Allow unlimited traffic on loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
 
# Allow incoming ssh only
iptables -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT
# make sure nothing comes or goes out of this box
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP
