sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
sudo apt-get update
sudo apt update
sudo apt-get install -y mongodb
sudo service mongod start
sudo apt-get install apache2

mongo --eval 'db.createUser({user: "grandnodeuser",pwd: "new_password_here",roles: [ "dbOwner" ]});' grandnode

sudo apt-get install -y gpg
sudo wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
sudo wget -q https://packages.microsoft.com/config/ubuntu/18.04/prod.list
sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-2.2

sudo apt-get install unzip libgdiplus
sudo wget https://github.com/grandnode/grandnode/releases/download/4.30/GrandNode4.30_NoSource.Web.zip
sudo unzip -d /var/www/html/grandnode /tmp/GrandNode4.30_NoSource.Web.zip

sudo chown -R www-data:www-data /var/www/html/grandnode

cd /var/www/html/grandnode
sudo -u www-data dotnet Grand.Web.dll

sudo mkdir /etc/systemd/system/


echo "[Unit]
 Description=GrandNode
 
  [Service]
  WorkingDirectory=/var/www/html/grandnode
  ExecStart=/usr/bin/dotnet /var/www/html/grandnode/Grand.Web.dll
  Restart=always
  RestartSec=10
  SyslogIdentifier=dotnet-grandnode
  User=www-data
  Environment=ASPNETCORE_ENVIRONMENT=Production
 
  [Install]
  WantedBy=multi-user.target" > /etc/systemd/system/grandnode-core.service


sudo systemctl enable grandnode-core.service
sudo systemctl start grandnode-core.service
