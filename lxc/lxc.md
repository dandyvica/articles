* install lxc: sudo apt-get install lxc
* create an image from a template: lxc-create --lxcpath /ssd/lxc --template download --name impish1 -- --dist ubuntu --release impish --arch amd64
* add iptables rules for GPG vetting: sudo iptables -A OUTPUT -p tcp --dport 11371 -j ACCEPT

* start a container: lxc-start --name nzbget
* attach to shell: lxc-attach --name nzbget
* list containers: lxc-ls --fancy


* not simple to understand: for priviledged containers, ls ~/.config/lxc