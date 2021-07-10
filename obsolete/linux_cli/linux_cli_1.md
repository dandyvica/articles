Whether you're a Linux or an OS/X user, you often ends up starting a terminal and typing some shell commands. 

Following is a list of some commands I often use, and they're by no means exhaustive. They are given as examples, and a second list will include other topics like benchmarking, network, or performance. Some require the *root* password or at least be part of the _sudoers_.

Be warned these are mainly *Linux* commands, used from a Linux Mint 19.3 machine. My advice is to _man_ each one (when available) to list all the numerous possibilities for a specific command. *man* is always your friend and you can often discover the missing parameter you need to solve your problem.

# Dealing with hardware

* list your hardware configuration (the most comprehensive): *inxi -Fxz*


* disks

| what? | command |
| --- | --- |
| list all hard disks                             | *lsblk -o NAME,TYPE,SIZE,MODEL,SERIAL,VENDOR -d*                 |
| get information on a disk                       | *sudo hdparm -i /dev/sda*|
| list partitions                                 | *sudo sfdisk -l /dev/sda*|
| mounted disks                                   | *df -T -x squashfs -x tmpfs -x devtmpfs*|
| sanitize or partition                           | *dcfldd if=/dev/urandom od=/dev/sdX*|
| copy a disk or partition to a file image        | *dcfldd if=/dev/sdX of=image.img hash=sha1 conv=sync,noerror*|
| list usb devices                                | *lsusb*|
| list PCI devices                                | *lspci*|



# Files

## Listing files with _ls_

|list | command|
|--- | --- |
|sort by size (largest first)       | *ls -lS*|
|sort by time (newest first)        | *ls -lt*|
|reverse sorting order              | add the *-r* flag|
|recursive                          | *ls -lR*|
|sort by extension                  | *ls -lX*|


## Using the _tree_ command

If not installed:    *sudo apt-get install tree*

|list | command|
|--- | --- |
|only directories                   | *tree -d*|
|full path with files               | *tree /usr -f*|
|on the current filesystem only     | *tree . -x*|
|only subdirectories                | *tree . -L 1*|
|only files with pattern            | *tree . -P "*.jpg"*|
|without indentation (like find)    | *tree . -i -f*|
|output as a JSON object            | *tree . -J*|
|output as an XML object            | *tree . -X*|

## Finding files
_find_ is a very feature rich command and not easy to master at first. _man find_ is your friend!

|find | command|
|--- | --- |
|files matching a pattern                        | *find . -name '*.jpg'*|
|files matching a pattern (case insensitive)     | *find . -iname '*.jpg'*|
|files only on current mounted filesystems       | *find . -mount -name "*.jpg"*|
|owned by userID                                 | *find . -user 1000*|
|whose permissions are 644                       | *find . -perm 644*|
|greater than 50M                                | *find / -size +50M*|
|modified more than 1 day                        | *find . -mtime +1*|
|only directories                                | *find . -type d*|
|only (regular) files                            | *find . -type f*|
|executable files                                | *find . -executable -type f*|
|using a regex                                   | *find . -regextype posix-extended -regex "(.*\.jpg|.*\.gif)"*|

## Open files
_lsof_ is a very powerful and versatile command. 

|find | command|
|--- | --- |
|open files for a list of users             | *lsof -u johndoe,1000*|
|open files by a list of processes          | *lsof -p 1999,2050*|
|on a specific fiessystem                   | *lsof /dev/sdb1*|

