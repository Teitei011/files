echo "Updating all the programs"

sudo pacman -Suy

echo "Instaling go and git..."

sudo pacman -S go git 

echo "Downloading yay..."

git clone https://aur.archlinux.org/yay.git
cd yay 

echo "Installing yay..."
makepkg -si 

echo "Installing all other programs..."
yay -S btop htop cpu-x obsidian telegram-desktop brave-browser nextcloud-client aur/jellyfin-media-player stacer-git easyeffects noisetorch-git


rm -r yay 
