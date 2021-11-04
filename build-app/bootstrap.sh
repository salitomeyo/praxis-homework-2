#!/usr/bin/env bash

#installing dependencies

#install git
sudo yum install git -y
#install go
wget -c https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.17.2.linux-amd64.tar.gz
sudo sh -c "echo export PATH=$PATH:/usr/local/go/bin >> /etc/profile"
source /etc/profile
#install node and npm
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install -y nodejs
sudo npm install -g npm@latest
#install vue/cli
sudo npm install -g -y @vue/cli

#showing dependencies versions installed
echo "git:"  && git version
echo "go:" && go version
echo "node:" && node --version
echo "vue cli:" && vue --version

#cloning git repository in which we be working
cd
git clone https://github.com/jdmendozaa/vuego-demoapp.git
cd ~/vuego-demoapp/server/ 
#building go project and moving it to shared folder
/usr/local/go/bin/go build
mv vuego-demoapp /shared

#getting endpoint and writing it in .env
cd
echo 'VUE_APP_API_ENDPOINT="http://10.0.0.8:4001/api"' > ~/vuego-demoapp/spa/.env.production.local
cd ~/vuego-demoapp/spa/
sudo npm install
#building app
sudo npm run build
tar -czf dist.tar.gz dist
#moving it to shared folder
mv dist.tar.gz /shared