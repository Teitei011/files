# Update
sudo apt update && sudo apt upgrade 
sudo apt list --upgradable
sudo apt upgrade

# System
sudo adduser server
sudo chage -d0 server
sudo usermod -a -G sudo server

# SSH
su - server
ssh-keygen -t RSA -b 2048

# https://www.tecmint.com/initial-ubuntu-server-setup-guide/

# UFW
sudo systemctl status ufw

sudo ufw allow 2345/tcp #SSH
sudo ufw allow 8080 # Pihole
sudo ufw allow 8090 # Homer
sudo ufw allow 8096 # Jellyfin
sudo ufw allow 80   # Nextcloud
sudo ufw allow 8082 # Calibre

sudo ufw enable

# Server time
sudo timedatectl
sudo timedatectl list-timezones 
sudo timedatectl set-timezone America/Sao_Paulo

# Snap
sudo apt install snapd
sudo snap install core


# Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker

sudo usermod -aG docker ${USER}
su - ${USER}
groups


# Nextcloud

#8080
sudo snap install nextcloud
sudo nextcloud.occ config:system:set trusted_domains 1 --value=teitei.sytes.net
sudo nextcloud.enable-https self-signed

# Jellyfin

#8096
echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/jellyfin.list
wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo apt-key add -
sudo apt install apt-transport-https ca-certificates

sudo apt update
sudo apt install jellyfin
sudo systemctl start jellyfin


# Pihole

#8080
docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 8080:8080 \
    -e TZ="America/Sao_Paulo" \
    -v "${PIHOLE_BASE}/etc-pihole:/etc/pihole" \
    -v "${PIHOLE_BASE}/etc-dnsmasq.d:/etc/dnsmasq.d" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    --hostname pi.hole \
    -e VIRTUAL_HOST="pi.hole" \
    -e PROXY_LOCATION="pi.hole" \
    -e ServerIP="127.0.0.1" \
    -e WEB_PORT=8080 \
    pihole/pihole:latest

docker exec -it pihole pihole -a -p

# Calibre-web
mkdir -p /volume1/books/calibre
chown -R root:users /volume1/
chmod -R 770 /volume1

docker create --name=calibre-web --restart=always -v /volume1/books/calibre:/books -e SET_CONTAINER_TIMEZONE=true -e CONTAINER_TIMEZONE=America/Sao_Paulo -e PGID=100 -e PUID=1000 -p 8082:8083 technosoft2000/calibre-web:v1.1.9
docker start calibre-web


# Homer

#8090
mkdir Homer
docker run -d \
  -p 8090:8090 \
  -v ~/Homer:/www/assets \
  --restart=always \
  b4bz/homer:latest


