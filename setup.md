Setup SSH
==========
- https://devconnected.com/how-to-install-and-enable-ssh-server-on-ubuntu-20-04/
- sudo apt-get update
- sudo apt-get install openssh-server
- sudo systemctl status sshd
- netstat -tulpn | grep 22
## refer to setup firewall for ssh
- setup firewall for ssh
### check ssh service
- sudo systemctl list-unit-files | grep enabled | grep ssh

Setup SSH firewall
======================
### accept ssh port
- iptables -A INPUT -i eth0 -p tcp --dport 22 -j ACCEPT
### reject anything else
- iptables -A INPUT -j DROP

Firewall Command
====================
https://sites.google.com/site/manjumore/iptables
### To output all of the active iptables rules in a table,
- sudo iptables -L --line-numbers
### look at the INPUT chain
- sudo iptables -L INPUT
### showing Packet Counts and Aggregate Size
- sudo iptables -L INPUT -v
### to clear the counters for a specific rule, specify the chain name and the rule number.
- sudo iptables -Z INPUT 1
### Deleting Rules by Chain and Number
- sudo iptables -D INPUT 3


Backup & Restore Iptables
=========================
### backup
- iptables-save > /opt/iptables.backup
### restore
- iptables-restore < /opt/iptables.backup

### To list out all of the active iptables rules by specification,
- sudo iptables -S

Firewall sample
=================
### Flushing all rules
- iptables -F
- iptables -X
### Setting default filter policy
- iptables -P INPUT DROP
- iptables -P OUTPUT DROP
- iptables -P FORWARD DROP
### Allow unlimited traffic on loopback
- iptables -A INPUT -i lo -j ACCEPT
- iptables -A OUTPUT -o lo -j ACCEPT
 
### Allow incoming ssh only
- iptables -A INPUT -p tcp -s 0/0 -d $SERVER_IP --sport 513:65535 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
- iptables -A OUTPUT -p tcp -s $SERVER_IP -d 0/0 --sport 22 --dport 513:65535 -m state --state ESTABLISHED -j ACCEPT
### make sure nothing comes or goes out of this box
iptables -A INPUT -j DROP
iptables -A OUTPUT -j DROP

Setup static ip
================
- netplan is the tool
- backup original file before edit
- sudo cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
- then modify the file such as 
````
        dhcp4: no
         addresses:
           - 192.168.121.199/24
         gateway4: 192.168.121.1
         nameservers:
         addresses: [8.8.8.8, 1.1.1.1]
````
- sudo netplan apply

Setup Display resolution
===========================
- Open a Terminal by CTRL+ALT+T
- Type xrandr and ENTER
- Note the display name usually VGA-1 or HDMI-1 or DP-1
- Type cvt 1920 1080 (to get the --newmode args for the next step) and ENTER
- Type sudo xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync and ENTER
- Type sudo xrandr --addmode VGA-1 "1920x1080_60.00" and ENTER (replace VGA-1 with your display type (step 3) like HDMI-1 or DP-1)
- Now close the terminal and go to Settings >> Display settings and change it to 1920x1080

### persist the resolution when restart.
#### for integrated graphic (WITHOUT SUDO)
- goto your terminal and type vim ~/.profile ENTER
- Paste in the shell command from step 5 and 6, then save.
#### For external displays (WITHOUT SUDO)
- create a script called external_monitor_resolution.sh in the directory /etc/profile.d/. using sudo vim /etc/profile.d/external_monitor_resol.sh.
- Paste in the shell command from step 5 and 6, then save.

Headless Setup
==================
#### Disable GUI
- sudo systemctl set-default multi-user
- gnome-session-quit
#### Enable GUI
- sudo systemctl set-default graphical
- or sudo systemctl start gdm3

Change Vim colorschemes
==========================
- mkdir ~/.vim
- git clone <https://github.com/flazz/vim-colorschemes.git> ~/.vim
- echo 'colorscheme desert' >> ~/.vimrc
- :colorscheme + space + tab








         
          
