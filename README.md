# Linux-Installation
Ideal way to install a Linux Distro

## An ideal intallation would be:
1.  fast start-up time
2.  Easy re-installation/refresh of Distro

## To this end:
1.  Install OS and executables to SSD for fast start-up time
2.  Install /home, /var, /tmp, /srv to HD to preserve user's data (/home) and minimize disk write damage (/var, /tmp, /srv) as SSD is sensitive to writes.

## Basic Steps for first time installation:
1.  Pull out the HD (hard disk)
2.  Install the Linux Distro to an SSD (Solid State Disk). Use only one partition - /. In this way, you maximize the disk space and not run out of space on your /usr/bin or /var directories. 
 - Add users. 
 - Shutdown when installation is finished; 
 - re-attach the HD, then, power-up to boot.
3.  If your HD has contents, don't do anything. Otherwise, format the HD as a **single** partition. 
4.  Run **fdisk l** to determine the device numbers of the HD and SSD (eg. /dev/sda1, /dev/sdb1). Identify which device number is which disk.
5.  Create the mount point directory **/hd** in the SSD and mount the HD to **/hd** (sudo mount /dev/sdxx /hd).
6.  Use the **blkid** command to determine the UUID of your hard disk (eg. blkid /dev/sda1). You **won't** be able to get any value
    out of **blkid** unless the disk is mounted.
7.  Edit /etc/fstab using the guide below. Use the UUIDs determined in Step 6. A copy of this file is in the repository.

Sample ##/etc/fstab## will look like this:
---
\# /etc/fstab: static file system information.

\# Use 'blkid' to print the universally unique identifier for a

\# device; this may be used with UUID= as a more robust way to name devices

\# that works even if disks are added and removed. See fstab(5).

\# <file system> <mount point>   <type>  <options>       <dump>  <pass> 
  
\# / was on /dev/sda1 during installation

UUID=4e40df13-dbe0-4aae-b378-6a5950d9ca8f /               ext4    errors=remount-ro 0       1

\# /hd was on /dev/sda2 during installation

UUID=858d78e2-550f-45e2-becc-117cef6553b2 /hd             ext4    defaults        0       2
  
\# swap was on /dev/sda1 during installation

UUID=109abccf-7c8b-404a-b68e-2ffa168bc4ca none            swap    sw              0       0

/hd/var      /var     none    bind       0     0

/hd/tmp      /tmp     none    bind       0     0

\#/hd/home     /home    none    bind       0     0

/hd/srv      /srv     none    bind       0     0

---  
8.  **rm -rf /hd/var**
9.  **cp -pr /var /hd/var**
10.  if your hd is blank, **cp -pr /home /hd/home** else, DON'T DO ANYTHING; link old contents instead **mv /home/user1 /home/user1.orig; ln -s /hd/home/user1 /home/user1**. Link will not allow you to create a soft link to an existing directory, hence, the need to rename the existing directory first. Don't forget that if you ever added a new user, say, user10, you have to **mkdir /hd/home/user10; cp -pr /home/user10 /hd/home/user10; ln -s /hd/home/user10 /home/user10**. The intent is that user10 data would go to /hd instead of the ssd. You also may have to change the group and owndership for each of these users. e.g. **sudo chown -L -R userN:userN userN**
11. **rm -rf /hd/tmp**
12. **cp -pr /tmp /hd/tmp**
13. If /srv exist, **cp -pr /srv /hd/srv; ln -s /hd/srv /srv**
Steps 8, 9, 11, and 12 are to make the new installation consistent because installation information are stored here.
12. Reboot and confirm that there are no problems.
13. Install git: **sudo apt-get install git**
14. **cd**
15. **git clone https://github.com/protein53/Linux-Installation.git**
16. **cd Linux-Installation**
17. **sudo bash install_my_fave_apps_and_dots.sh**
18. **sudo vim /etc/passwd - change your shell to /usr/bin/zsh**
# Auto Installer Script

**install_my_fave_apps_and_dots.sh** automatically installs your favourite apps on Fedora, Debian/Ubuntu, or Arch/CachyOS Linux.

## How to use
1. Edit `favourite_apps.txt` to include your apps (one per line).
2. Edit 'flatpak_apps.txt' to include your other apps that has so many dependencies.
3. Run the script:
  sudo bash install_my_fave_apps_and_dots.sh



