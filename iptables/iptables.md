---
title: Securing your Linux desktop using iptables firewall rules
published: true
tags: #iptables #security #linux #firewall
cover_image: https://thepracticaldev.s3.amazonaws.com/i/mr2tvasavdn9hdtq0nk3.jpg
---

Today, I'll be tackling not a specific development topic, but rather a way of securing your Linux desktop access to the internet. I'm using a Linux Mint 19.1 version, but it should be the same across all Linux distributions as soon as the *iptables* package is installed.

*iptables* is a Linux command to manage firewall rules. It basically filters network packets coming from or going to the external world.

There're a lot of awesome resources describing the nuts and bolts of *iptables*, I'm not going to detail this here. I'm rather focusing on how to set up simple rules in order to secure your internet connection from your desktop. This comes up in addition to other safeguarding techniques like using privacy minded browser extensions like *uBlock origin* or *uMatrix*, or using *AppArmor* confinement framework to name a few.

The first thing to understand when dealing with *iptables* are chains. Chains are like channels where network packets are exchanged (not talking about *NAT* and *MANGLE* tables, not the subject here), in the *FILTER* table. A chain contains of a list of rules which are applied sequentially, in the order which they were created. If a packet doesn't match a rule, it's either rejected, accepted or dropped. 

To define a rule, you can use the *iptables* command (*root* access needed). Or create a rules file and import all rules using the *iptables-restore* command.

There're 3 chains:

* the INPUT chain is for all incoming packets from the outside world
* the FORWARD chain is used when the host is considered as a gateway forwarding packet to another host
* the OUTPUT chain is for all outgoing packets from my Linux desktop

The firewall strategy to harden you desktop is to deny everything, and then only accept the packets you want.

My setup is the following:

```
# load firewall config with iptables-restore < iptables.rules

*filter

# 1: set default DROP policy
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT DROP [0:0]

# 2: accept any related or established connection
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 3: allow all traffic on the loopback interface
-A INPUT -i lo -j ACCEPT
-A OUTPUT -o lo -j ACCEPT

# 4: allow outbound DHCP requests
-A OUTPUT -p udp --dport 67:68 --sport 67:68 -j ACCEPT

# 5: allow outbound DNS lookups
-A OUTPUT -p udp -m udp --dport 53 -j ACCEPT

# 6: allow outbound ping requests
-A OUTPUT -p icmp -j ACCEPT

# 7: allow outbound NTP requests
-A OUTPUT -p udp --dport 123 --sport 123 -j ACCEPT

# 8: allow outbound http/https requests
-A OUTPUT -p tcp -m tcp --dport 80 -m state --state NEW -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 443 -m state --state NEW -j ACCEPT

# commit changes
COMMIT
```

The previous rules are basically all the parameters which are passed to the *iptables* command. Mainly:

* -A: append to the chain name
* -p: the protocol name
* -m: additional option passed to an *iptables* module
* --sport: the source port
* --dport: the destination port
* -j: the action whenever such a packet is matched
* --state: the connection state module options

Let's breakdown those rules:

1. by default, drop all packets for all chains
1. accept, either incoming or outgoing, any packet where its state is either ESTABLISHED (connection is known and tracked) or RELATED (initiated from an already established connection)
1. the loopback interface is _127.0.0.1_ or *localhost*. It's a local one, so accept all connexions to it
1. allow dhcp requests, from tcp source port 67 or 68 to destination port 67 or 68
1. allow DNS requests to port 53
1. if you want to ping an address, you need this rule
1. if you're using the time protocol to set your clock, you need this rule
1. the core one: only allow *http* or *https* protocol from your box, those initiating the connection (*--state NEW*)


You can also fine tune those rules. You can for example list a couple of ip addresses or urls to restrict the destination address using the *-s* parameter. You can also define a rule for a specific interface name like *-i eht0*.

Then simply load those rules by:

```console
$ sudo iptables-restore < iptables.rules
```

These will be deleted during the next reboot. To make them permanent, install the *iptables-persistent* packed:

```
$ sudo apt-get install iptables-persistent
```

You can temporarily add another rule if needed. For example, to access your AWS instance:

```console
$ sudo iptables -A OUTPUT -p tcp -m tcp --dport 22 -j ACCEPT
```

Hope this helps !

> Photo by Andy Art on Unsplash