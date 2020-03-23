Whether you're a Linux or an OS/X user, you often ends up starting a terminal and typing some shell commands. 

Following is a list of some commands I use, and they're by no means exhaustive. They are given as examples, and could include other topics like benchmarking, network, or performance. Some needs the root password or at least be part of the _sudoers_.

Be warned these are mainly Linux commands, used from Linux Mint 19.2 machine. My advice is to _man_ each one (when available) to list all the numerous possibilities of a specific command.

# Dealing with hardware

* list your hardware configuration (the most comprehensive): ```inxi -Fxz```


* disks

what? | command
--- | --- 
list all hard disks | ```lsblk -o NAME,TYPE,SIZE,MODEL,SERIAL,VENDOR -d```
get information on a disk | ```sudo hdparm -i /dev/sda```
list partitions | ```sudo sfdisk -l /dev/sda```
mounted disks | ```df -T -x squashfs -x tmpfs -x devtmpfs```
copy a disk or partition|

* list usb & PCI devices
```
$ lsusb
$ lspci
```


# Files

## Listing files with _ls_

list | command
--- | --- 
sort by size (largest first)| ```ls -lS```
sort by time (newest first)|  ```ls -lt```
reverse sorting order | add the ```-r``` flag
recursive|                    ```ls -lR```
sort by extension |           ```ls -lX```


## Using the _tree_ command

If not installed: ```sudo apt-get install tree```

list | command
--- | --- 
only directories | ```tree -d```

## Finding files
_find_ is a very feature rich command and not easy to master at first. _man find_ is your friend!

find | command
--- | --- 
files matching a pattern                        | ```find . -name '*.jpg'```
files matching a pattern (case insensitive)     | ```find . -iname '*.jpg'```
files only on current mounted filesystem        | ```find . -name "*.jpg" -mount```
owned by userID                                 | ```find . -user 1000```
whose permissions are 644                       | ```find . -perm 644```
greater than 50M                                | ```find / -size +50M```
modified more than 1 day                        | ```find . -mtime +1```
only directories                                | ```find . -type d```
only (regular) files                            | ```find . -type f```
executable files                                | ```find . -executable -type f```
using a regex                                   | ```find . -regextype posix-extended -regex "(.*\.jpg|.*\.gif)"```

## Open files
_lsof_ is a very powerful and versatile command. 

find | command
--- | --- 
open files for a user                      | ```lsof -u johndoe```
open files by a process                    | ```lsof -u johndoe```
open files by a process                    | ```lsof -u johndoe```



# Processes

# Network

# Benchmarking

# Performance

## CPU & processes

_top_ and _htop_ are a must. To install _htop_: ```sudo apt-get install htop```

## Disks

To assess disk I/Os: 

## Network
