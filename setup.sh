#!/bin/bash
loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true
read -p "Разметка диска 1)boot (ВВОД В МЕГАБАЙТАХ)" disk
read -p "Разметка диска 2)root (ВВОД В МЕГАБАЙТАХ)" disk1
read -p "Разметка диска 3)swap (ВВОД В МЕГАБАЙТАХ)" disk2
read -p "Разметка диска 4)home (ВВОД В МЕГАБАЙТАХ)" disk3
(
  echo o;

  echo n;
  echo;
  echo;
  echo;
  echo +$disk;

  echo n;
  echo;
  echo;
  echo;
  echo +$disk1;

  echo n;
  echo;
  echo;
  echo;
  echo +$disk2;

  echo n;
  echo p;
  echo;
  echo +$disk3;


  echo w;
) | fdisk /dev/sda

fdisk -l
mkfs.ext2  /dev/sda1 -L boot
mkfs.ext4  /dev/sda2 -L root
mkswap /dev/sda3 -L swap
mkfs.ext4  /dev/sda4 -L home

mount /dev/sda2 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot
swapon /dev/sda3
mount /dev/sda4 /mnt/home


pacstrap /mnt base base-devel

genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/magiclinuxoid/script/master/setup2.sh)"
