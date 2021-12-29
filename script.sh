echo Update
sudo apt update && sudo apt upgrade 
sudo apt list --upgradable
sudo apt upgrade

echo System
sudo adduser server
sudo chage -d0 server
sudo usermod -a -G sudo server

echo Hostaname
sudo hostnamectl set-hostname server

echo SSH
#su - server
#ssh-keygen -t RSA -b 2048

# https://www.tecmint.com/initial-ubuntu-server-setup-guide/

echo UFW
sudo systemctl status ufw

sudo ufw allow 2345/tcp #SSH
sudo ufw allow 8081 # Pihole
sudo ufw allow 80 # Homer
sudo ufw allow 8096 # Jellyfin
sudo ufw allow 8080   # Nextcloud
sudo ufw allow 8082 # Calibre

sudo ufw enable

echo Server time
sudo timedatectl
sudo timedatectl list-timezones 
sudo timedatectl set-timezone America/Sao_Paulo

echo Snap
sudo apt install snapd
sudo snap install core


echo Docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker

sudo usermod -aG docker ${USER}
su - ${USER}
groups


echo Nextcloud

#8080
docker run -d -p 8080:80 nextcloud

echo Jellyfin

#8096
echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/jellyfin.list
wget -O - https://repo.jellyfin.org/jellyfin_team.gpg.key | sudo apt-key add -
sudo apt install apt-transport-https ca-certificates

sudo apt update
sudo apt install jellyfin
sudo systemctl start jellyfin


echo Pihole

#8081
docker run -d \
    --name pihole \
    -p 53:53/tcp -p 53:53/udp \
    -p 8081:8081 \
    -e TZ="America/Sao_Paulo" \
    -v "${PIHOLE_BASE}/etc-pihole:/etc/pihole" \
    -v "${PIHOLE_BASE}/etc-dnsmasq.d:/etc/dnsmasq.d" \
    --dns=127.0.0.1 --dns=1.1.1.1 \
    --restart=unless-stopped \
    --hostname pi.hole \
    -e VIRTUAL_HOST="pi.hole" \
    -e PROXY_LOCATION="pi.hole" \
    -e ServerIP="127.0.0.1" \
    -e WEB_PORT=8081 \
    pihole/pihole:latest

docker exec -it pihole pihole -a -p

echo Calibre-web
mkdir -p /volume1/books/calibre
chown -R root:users /volume1/
chmod -R 770 /volume1

docker create --name=calibre-web --restart=always -v /volume1/books/calibre:/books -e SET_CONTAINER_TIMEZONE=true -e CONTAINER_TIMEZONE=America/Sao_Paulo -e PGID=100 -e PUID=1000 -p 8082:8083 technosoft2000/calibre-web:v1.1.9
docker start calibre-web


echo Homer

#80
mkdir Homer
docker run -d \
  -p 80:80 \
  -v ~/Homer:/www/assets \
  --restart=always \
  b4bz/homer:latest


