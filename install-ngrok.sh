!#/bin/bash
set -e
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
unzip ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/sbin/ngrok
chmod o+x /usr/sbin/ngrok
mkdir -p $HOME/.ngrok2 
cp ngrok.yml $HOME/.ngrok2/ngrok.yml
echo "https://dashboard.ngrok.com/get-started/your-authtoken, ngrok auth token?"
read line
sed -i "s/NGROK_AUTH_TOKEN/$line/g" $HOME/.ngrok2/ngrok.yml

ngrok 
