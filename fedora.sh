echo "Installing all the programs with flatpak..."

sudo flatpak install flathub com.github.tchx84.Flatseal && sudo flatpak install flathub com.visualstudio.code && sudo flatpak install flathub io.github.liberodark.OpenDrive && flatpak install flathub ca.desrt.dconf-editor

echo "33% finished"

sudo flatpak install flathub org.gnucash.GnuCash &&  sudo flatpak install flathub com.bitwarden.desktop 

echo "66% finished"

sudo flatpak install flathub com.github.tchx84.Flatseal && sudo flatpak install flathub com.visualstudio.code && sudo flatpak install flathub io.github.liberodark.OpenDrive && flatpak install flathub ca.desrt.dconf-editor


echo "Installing dnf"

sudo dnf install gnome-tweak-tool


echo "Everything has been installed"
