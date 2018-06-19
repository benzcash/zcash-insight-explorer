docker service create -t \
	--constraint "node.hostname == ${NOD_HOSTNAME}" \
	--network $SWARM_NETWORK \
	--name  explorer \
	--hostname explorer.beta.z.cash \
	--label traefik.port=3001 \
	--label traefik.frontend.rule='Host:explorer.beta.z.cash;' \
	ianamunoz/insight-explorer-zcash:v1.1.1
