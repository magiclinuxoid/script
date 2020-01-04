#!/bin/bash
echo 'Прписываем имя компьютера'
read -p "Введите host имя" hostmane
echo $hostname > /etc/hostname
ln -svf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime

echo 'Добавляем русскую локаль системы'
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 

echo 'Обновим текущую локаль системы'
locale-gen

echo 'Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo 'Вписываем KEYMAP=ru FONT=cyr-sun16'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo 'Создадим загрузочный RAM диск'
mkinitcpio -p linux

echo 'Создаем root пароль'
passwd

echo '3.5 Устанавливаем загрузчик'
pacman -Syu
pacman -S grub --noconfirm 
grub-install /dev/sda

echo 'Обновляем grub.cfg'
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm 

echo 'Добавляем пользователя'
read -p "Имя пользователя " name
useradd -m -g users -G wheel -s /bin/bash $name

echo 'Устанавливаем пароль пользователя $name'
passwd $name
echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo "Куда устанавливем Arch Linux, на виртуальную машину?"
read -p "1 - Да, 0 - Нет: " vm_setting
if [[ $vm_setting == 0 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit"
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"
fi

echo 'Ставим иксы и драйвера'
pacman -S $gui_install --noconfirm

echo "Какую оболочку установить ?"
read -p "1 -Kde, 0 - gnome: " de_setting
if [[ $de_setting == 0 ]]; then
  pacman -S gnome gnome-extra gdm networkmanager network-manager-applet ppp 
  systemctl enable gdm NetworkManager
elif [[ $de_setting == 1 ]]; then
  pacman -S plasma sddm networkmanager network-manager-applet ppp
  systemctl enable sddm NetworkManager
fi


echo 'Ставим шрифты'
pacman -S ttf-liberation ttf-dejavu --noconfirm 

echo 'Ставим wget'
pacman -S wget --noconfirm 

read -p "Пауза 3 ceк." -t 3
reboot
