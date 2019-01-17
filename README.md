This repo contains a Dockerfile to run and set up an insight explorer for the Zcash blockchain.

To build the image run:

`docker build -t ianamunoz/zcash-insight-explorer .`

* Note that this build will pull in all the parameters so it is a bit heavy at 2.48GB. It will require some bandwidth and beware of your /var/lib directory if you have a default docker install.

To run locally without to test operation run:

```
docker run -d \
-p 80:3001 \
ianamunoz/zcash-insight-explorer
```

The `docker-service.sh` file shows you might might manually run it as a service behind a traefik reverse proxy as seen for example in the `docker-compose.yml`.

ToDo: tags for versions

Set up ad-hoc [Google Cloud](.docs/ad_hoc_gcp.md) instance.
