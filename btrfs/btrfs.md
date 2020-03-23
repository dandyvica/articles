---
title: Playing with the btrfs filesystem
published: true
tags: #filesystem #tutorial #linux
cover_image: https://thepracticaldev.s3.amazonaws.com/i/1hf6gav2jsfdm83dx67z.jpg
---

This article is meant to be an introduction to the _btrfs_ filesystem.
# TL;DR 

_btrfs_ :

* means _B-tree File System_ (you'll also see ButterFS) because most of the internal data structure are kept 
using B-trees tree structures (https://en.wikipedia.org/wiki/B-tree) which makes tree operations (searching, inserting, etc) in logarithm time
* is licensed under the GPL licence and therefore integrated into the Linux kernel since 2.6.14 (opposite to the _ZFS_ 
file system licensed under another more restrictive CDDL licence, being incompatible with the GPL. Note that the 
OpenZFS initiative is meant to fix licensing issues)
* was started in 2007 by a pool of companies (Oracle, Red Hat, Intel, ...). Now main contributors are Facebook, Fujitsu
SUSE, and Oracle.
* is currently under active development (last version 5.3 was released Oct. 2019)
* has the following modern features (see the _btrfs_ wiki for a detailed list)

  - on the fly compression with different algorithms. Note that you can enable compression from the beginning when creating the fs or at any moment. Then, only files created after this moment will be compressed

  - software RAID from RAID0 to RAID10

  - can have different RAID policies (e.g.: data striped
  and metadata mirrored by default)

  - data blocks (belonging to files) or metadata blocks (directory structures, filenames, file permissions, checksums, ...) kept separately

  - online conversion from an existing filesystem

  - spans on different partitions, which makes _LVM_ unnecessary. Adding space to a current filesystem is straightforward

  - online filesystem extend or shrink

  - uses CoW (Copy on Write). The best definition is defined in the _btrfs_ wiki glossary: 

> Instead of directly overwriting data in place, btrfs takes a copy of the data, alters it, and then writes the modified data back to a different (free) location on the disk. It then updates the metadata to reflect the new location of the data. In order to update the metadata, the affected metadata blocks are also treated in the same way

  - brings subvolumes. You'll often see subvolumes are considered like a POSIX filename. You can think of a different view on a filesystem structure.

  - brings snapshots to take a instant picture of a subvolume

  - partition-less filesystem when no partition is defined in a block device

* is used in production by Facebook, Synology, ...

Refer to the _btrfs_ kernel wiki for lots of details: https://btrfs.wiki.kernel.org/index.php/Main_Page

# Experimenting the _btrfs_ features

## Preliminary checks
First, you need to check you kernel to check whether _btrfs_ is supported:

```console
$ lsmod | grep btrfs
btrfs                1138688  0
xor                    24576  1 btrfs
zstd_compress         163840  1 btrfs
raid6_pq              114688  1 btrfs
```

and optionally install user space tools if not already installed:

```console
$ sudo apt install btrfs-progs
```

My version is pretty new on Linux Mint 19.2:

```console
$ mkfs.btrfs -V
mkfs.btrfs, part of btrfs-progs v4.15.1
```

## Creating and mounting a _btrfs_ filesystem
Now, if you want to dabble into _btrfs_ and you don't get a spare hard drive or partitions, you can play with disk images. Let's create an empty disk image:

```console
$ dd if=/dev/zero of=diskimage1.img bs=1M count=1000 
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 3.87838 s, 270 MB/s
=200 && sync
```
and associate the disk image with a virtual block device:

```console
$ sudo losetup loop1 diskimage1.img
$ losetup 
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE                          DIO LOG-SEC
/dev/loop1         0      0         0  0 /home/dandyvica/btrfs/diskimage1.img   0     512
$ lsblk | grep loop 
loop1    7:1    0  1000M  0 loop 
```

As _btrfs_ supports partition-less devices, let's create a _btrfs_ filesystem:

```console
$ sudo mkfs.btrfs -L "btrfs_sample" -f /dev/loop1
btrfs-progs v4.15.1
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM /dev/loop1 (1000.00MiB) ...
Label:              btrfs_sample
UUID:               1e76f758-6b66-4762-a810-c3b072bc3023
Node size:          16384
Sector size:        4096
Filesystem size:    1000.00MiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP              50.00MiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1  1000.00MiB  /dev/loop1
```

It's needed to add the _-f_ flag because the device has no partition.

Now, we can mount the filesystem using its UUID or device name:

```console
$ sudo mount -U 1e76f758-6b66-4762-a810-c3b072bc3023 ./btrfs_sample
$ mount | grep sample
/dev/loop1 on /home/dandyvica/btrfs/btrfs_sample type btrfs (rw,relatime,space_cache,subvolid=5,subvol=/)
```

## Using the filesystem
Now, we can use the spanking new filesystem:

```console
$ sudo dd if=/dev/zero of=./btrfs_sample/empty.dd bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0,0475632 s, 2,2 GB/s
```

To check the filesystem usage, you shouldn't use the traditional _df_ command. Because of the CoW nature of _btrfs_, _df_ sometimes reports wrong figures:

```console
$ df -m /dev/loop1
Filesystem     1M-blocks  Used Available Use% Mounted on
/dev/loop1          1000   117       783  13% /home/dandyvica/btrfs/btrfs_sample
```

We created a 100MB file on a 1GB filesystem, so reported usage should be around 10%. We must use the _btrfs filesystem df_ command:

```console
$ sudo btrfs filesystem df ./btrfs_sample
Data, single: total=120.00MiB, used=100.06MiB
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=50.00MiB, used=224.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B
```

## Resizing the filesystem
We can shrink the filesystem using _btrfs filesystem resize_:

```console
$ sudo btrfs filesystem resize -500M ./btrfs_sample
Resize './btrfs_sample' of '-500M'
$ sudo btrfs filesystem show ./btrfs_sample
Label: 'btrfs_sample'  uuid: 1e76f758-6b66-4762-a810-c3b072bc3023
	Total devices 1 FS bytes used 100.30MiB
	devid    1 size 500.00MiB used 236.00MiB path /dev/loop1
```

or extend it:

```console
$ sudo btrfs filesystem resize +500M ./btrfs_sample
Resize './btrfs_sample' of '+500M'
$ sudo btrfs filesystem show ./btrfs_sample        
Label: 'btrfs_sample'  uuid: 1e76f758-6b66-4762-a810-c3b072bc3023
	Total devices 1 FS bytes used 100.30MiB
	devid    1 size 1000.00MiB used 236.00MiB path /dev/loop1
```

## Adding another device to a filesystem

Let's define another disk image:

```console
$ dd if=/dev/zero of=diskimage2.img bs=1M count=1000 && sync
$ sudo losetup loop2 diskimage2.img       
$ losetup 
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE                          DIO LOG-SEC
/dev/loop1         0      0         0  0 /home/dandyvica/btrfs/diskimage1.img   0     512
/dev/loop2         0      0         0  0 /home/dandyvica/btrfs/diskimage2.img   0     512
```

We can add this second device to our filesystem immedialty:

```console
$ sudo btrfs device add /dev/loop2 ./btrfs_sample
Performing full device TRIM /dev/loop2 (1000.00MiB) ...
$ sudo btrfs filesystem show ./btrfs_sample      
Label: 'btrfs_sample'  uuid: 1e76f758-6b66-4762-a810-c3b072bc3023
	Total devices 2 FS bytes used 100.30MiB
	devid    1 size 1000.00MiB used 236.00MiB path /dev/loop1
	devid    2 size 1000.00MiB used 0.00B path /dev/loop2
```

Now the _btrfs filesystem show_ reports both devices. But data and metadata are located on a single device and not striped among both devices. To achieve that, we need to balance them on devices composing the filesystem:

```console
$ sudo btrfs filesystem balance ./btrfs_sample
WARNING:

	Full balance without filters requested. This operation is very
	intense and takes potentially very long. It is recommended to
	use the balance filters to narrow down the scope of balance.
	Use 'btrfs balance start --full-balance' option to skip this
	warning. The operation will start in 10 seconds.
	Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting balance without any filters.
Done, had to relocate 4 out of 4 chunks
```

This operation is potentially lengthy, depending on the amount of data in the original device.

## Dealing with subvolumes

A _btrfs_ subvolume is a kind of filesystem subdirectory, but with the ability to be mounted independently. It also relates to snapshots, see below.

Let's create 2 subvolumes into our root filesystem directory:

```console
$ sudo btrfs subvolume create ./btrfs_sample/subvol1        
Create subvolume './btrfs_sample/subvol1'
$ sudo btrfs subvolume create ./btrfs_sample/subvol2
Create subvolume './btrfs_sample/subvol2'
$ sudo btrfs subvolume list ./btrfs_sample
ID 259 gen 38 top level 5 path subvol1
ID 260 gen 40 top level 5 path subvol2
```

and create some dummy structure in each subvolume:

```console
$ sudo mkdir ./btrfs_sample/subvol1/1-A
$ sudo mkdir ./btrfs_sample/subvol1/1-B
$ sudo mkdir ./btrfs_sample/subvol1/1-C
$ sudo mkdir ./btrfs_sample/subvol2/2-D
$ sudo mkdir ./btrfs_sample/subvol2/2-E
$ sudo mkdir ./btrfs_sample/subvol2/2-F
$ tree btrfs_sample 
btrfs_sample
├── empty.dd
├── subvol1
│   ├── 1-A
│   ├── 1-B
│   └── 1-C
└── subvol2
    ├── 2-D
    ├── 2-E
    └── 2-F
```

Using their subvolumes IDs (259 and 260 here), we can mount them directly as if it was the filesystem root:

```console
$ sudo mount -U 1e76f758-6b66-4762-a810-c3b072bc3023 -o subvolid=259 ./A-C
$ sudo mount -U 1e76f758-6b66-4762-a810-c3b072bc3023 -o subvolid=260 ./D-F
$ mount | grep btrfs
/dev/loop1 on /home/dandyvica/btrfs/btrfs_sample type btrfs (rw,relatime,space_cache,subvolid=5,subvol=/)
/dev/loop1 on /home/dandyvica/btrfs/A-C type btrfs (rw,relatime,space_cache,subvolid=259,subvol=/subvol1)
/dev/loop1 on /home/dandyvica/btrfs/D-F type btrfs (rw,relatime,space_cache,subvolid=260,subvol=/subvol2)
```

Now we can check what we have in the different directories:

```console
$ tree A-C
A-C
├── 1-A
├── 1-B
└── 1-C

3 directories, 0 files
$ tree D-F 
D-F
├── 2-D
├── 2-E
└── 2-F

3 directories, 0 files
```

So we have now 3 mounted directories simultaneously coming from the same filesystem, each one have its own structure. It's like you're looking at the filesystem through different point of views.

## Snapshots
A snapshot is similar to what this word means in the photography field. It takes an instant image of a filesystem or subvolume. Due to the nature of how CoW works, this operation is instantaneous.
It just takes references to the underlying data and only saves links to that data.

As the original files evolve and change, the filesystem is able to keep track of what changed.

Let's create a dummy file in _./btrfs\_sample/A-C_, take a snapshot of this directory:

```console
$ sudo cp /var/log/syslog ./btrfs_sample/subvol1
$ sudo btrfs subvolume snapshot ./btrfs_sample/subvol1 ./btrfs_sample/subvol1_snapshot
Create a snapshot of './btrfs_sample/subvol1' in './btrfs_sample/subvol1_snapshot'
$ sudo md5sum ./btrfs_sample/subvol1/syslog ./btrfs_sample/subvol1_snapshot/syslog
482175fc488551ddc0295f47741a3ba7  ./btrfs_sample/subvol1/syslog
482175fc488551ddc0295f47741a3ba7  ./btrfs_sample/subvol1_snapshot/syslog
```

We can check that the original file _syslog_ taken from _/var/log_ is the same in both subvolumes.
Now if you mess up with this file, you can recover it from the snapshot:

```console
$ sudo rm ./btrfs_sample/subvol1/syslog
$ sudo md5sum ./btrfs_sample/subvol1_snapshot/syslog 
482175fc488551ddc0295f47741a3ba7  ./btrfs_sample/subvol1_snapshot/syslog
```

A snapshot is also a subvolume by itself, being mountable if necessary:

```console
$ sudo btrfs subvolume list ./btrfs_sample
ID 259 gen 50 top level 5 path subvol1
ID 260 gen 43 top level 5 path subvol2
ID 261 gen 49 top level 5 path subvol1_snapshot
```

# Preventing silent corruption of data

When using the duplication feature for data and metadata (RAID1 for example), _btrfs_ can prevent silent data corruption, due to its built-in checksumming for blocks of data and metadata. If a block's checksum is not the same on a device being part of a mirrored configuration, it can fix the error because it can calculate its checksum and compare it with what's in its trees.

Let's define a mirrored _btrfs_ filesystem, based on 2 devices:

```console
$ dd if=/dev/zero of=diskimage1.img bs=1M count=1000 && sync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 4.19358 s, 250 MB/s
$ dd if=/dev/zero of=diskimage2.img bs=1M count=1000 && sync
1000+0 records in
1000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 2.76397 s, 379 MB/s
$ sudo losetup loop1 diskimage1.img
$ sudo losetup loop2 diskimage2.img
$ losetup 
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE                          DIO LOG-SEC
/dev/loop1         0      0         0  0 /home/dandyvica/btrfs/diskimage1.img   0     512
/dev/loop2         0      0         0  0 /home/dandyvica/btrfs/diskimage2.img   0     512
$ sudo mkfs.btrfs -L "btrfs_sample" -d raid1 -m raid1 -f /dev/loop1 /dev/loop2
btrfs-progs v4.15.1
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM /dev/loop1 (1000.00MiB) ...
Performing full device TRIM /dev/loop2 (1000.00MiB) ...
Label:              btrfs_sample
UUID:               cf7ccf9f-0b1d-4939-9b09-98adf3d41e03
Node size:          16384
Sector size:        4096
Filesystem size:    1.95GiB
Block group profiles:
  Data:             RAID1           100.00MiB
  Metadata:         RAID1           100.00MiB
  System:           RAID1             8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  2
Devices:
   ID        SIZE  PATH
    1  1000.00MiB  /dev/loop1
    2  1000.00MiB  /dev/loop2
$ sudo mount -U cf7ccf9f-0b1d-4939-9b09-98adf3d41e03 ./btrfs_mirrored
```

Note that I added the _-d raid1_ and __m raid1_ for mirroring data and metadata on both devices.
Let's copy a dummy file in the filesystem root. This file has a peculiar structure, in order to be able to modify it in the underlying block device:

```console
$ echo "XXXXXXXXXXXXXXXXXXXX" | sudo tee ./btrfs_mirrored/x_file.txt 
XXXXXXXXXXXXXXXXXXXX
$ md5sum ./btrfs_mirrored/x_file.txt 
404fd1d136de6f192f66368f3dfa38d6  ./btrfs_mirrored/x_file.txt
```

Now, unmount the filesystem, and modify the file within one of the loopback device but changing the 'X' into 'Y':

```console
$ sudo umount ./btrfs_mirrored 
$ sudo losetup -d /dev/loop1
```
Now with _hexedit_, I just modified the "XXXXXXXXXXXXXXXXXXXX" string into "YYYYYYYYYYYYYYYYYYYY" in the _diskimage1.img_ file. Then remount the filesystem and check the MD5 sum:

```console
$ sudo losetup loop1 diskimage1.img 
$ sudo mount -U cf7ccf9f-0b1d-4939-9b09-98adf3d41e03 ./btrfs_mirrored
$ md5sum ./btrfs_mirrored/x_file.txt
404fd1d136de6f192f66368f3dfa38d6  ./btrfs_mirrored/x_file.txt
```

_btrfs_ has fixed the error and we have still the correct file:

```console
$ dmesg
BTRFS warning (device loop2): loop2 checksum verify failed on 30408704 wanted C2CC51CB found CCF180A7 level 0
BTRFS info (device loop2): read error corrected: ino 0 off 30408704 (dev /dev/loop1 sector 59392)
BTRFS info (device loop2): read error corrected: ino 0 off 30412800 (dev /dev/loop1 sector 59400)
BTRFS info (device loop2): read error corrected: ino 0 off 30416896 (dev /dev/loop1 sector 59408)
BTRFS info (device loop2): read error corrected: ino 0 off 30420992 (dev /dev/loop1 sector 59416)
```

# On the fly compression

Even if the filesystem has been created, you can still enable compression for subsequent files:

```console
$ sudo mount -U cf7ccf9f-0b1d-4939-9b09-98adf3d41e03 -o compress=lzo ./btrfs_mirrored
```

Check https://btrfs.wiki.kernel.org/index.php/Compression for a comprehensive list of options related to compression.


Hope this helps !

> Photo by Hannah Rodrigo on Unsplash

