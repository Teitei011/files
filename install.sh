echo "Updating all the programs"

sudo pacman -Suy

echo "Editing pacman.conf"
sudo echo "ParallelDownloads = 5" >> /etc/pacman.conf

echo "DRI_PRIME configuration"
sudo echo "DRI_PRIME=1" >> /etc/enviroment

echo "Putting neofetch into bash/zsh"
echo "neofetch" >> .bashrc
echo "neofetch" >> .zshr


echo "Instaling go and git..."

sudo pacman -S go git 

echo "Downloading yay..."

git clone https://aur.archlinux.org/yay.git
cd yay 

echo "Installing yay..."
makepkg -si 

echo "Installing all other programs..."
yay -S btop htop cpu-x obsidian telegram-desktop brave-browser nextcloud-client aur/jellyfin-media-player stacer-git easyeffects noisetorch-git tlp community/gnome-multi-writer extra/transmission-qt vim


rm -r yay 

echo "Done!"

echo "You have to start tlp"

