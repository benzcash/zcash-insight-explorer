Create an instance:

```
gcloud compute instances create testnet-explorer \
--zone=us-east1-b \
--machine-type=n1-standard-1 \
--subnet=default \
--network-tier=PREMIUM \
--tags=https-server \
--image=debian-9 \
--image-project=debian-cloud \
--boot-disk-size=24GB \
--boot-disk-type=pd-standard \
--boot-disk-device-name=testnet-explorer
```

ssh into the instance and install docker (using debian here for sanity)
```
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermad -aG $(whoami) docker
```
update and install dependencies
```
sudo apt-get update -y && sudo apt-get upgrade
sudo apt-get install git
```
Clone repo and build image
```
git clone https://github.com/zcash-hackworks/zcash-insight-explorer.git
cd zcash-insight-explorer
docker build -t zcash-hackworks/zcash-insight-explorer .
```

**Edit  `docker-compose.yml` and edit your host records etc.**
**Add DNS records to your public instance IP**

Stand up the stack:
```
docker stack deploy --compose-file docker-compose.yml testnet-explorer
```

Visit your domain to pick up letsencrypt cert.

Fin. 
