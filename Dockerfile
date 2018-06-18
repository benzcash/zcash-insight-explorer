FROM debian:latest

RUN apt-get update

RUN apt-get install -y curl
RUN apt-get install -y gnupg2
RUN apt-get install -y wget
RUN apt-get install -y libzmq3-dev
RUN apt-get install -y git
RUN apt-get install -y build-essential

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

RUN wget -qO - https://apt.z.cash/zcash.asc | apt-key add -
RUN echo "deb [arch=amd64] https://apt.z.cash/ jessie main" | tee /etc/apt/sources.list.d/zcash.list
RUN apt-get update && apt-get install -y zcash

RUN useradd -m zcashd 

RUN mkdir -p /home/zcashd/.npm-global ; \
    mkdir -p /home/zcashd/.zcash/ ; \ 
    mkdir -p /home/zcashd/.zcash-params/ ; \
    chown -R zcashd /home/zcashd
ENV PATH=/home/zcashd/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX=/home/zcashd/.npm-global

ENV x x 
COPY --chown=zcashd:zcashd ./zcash.conf /home/zcashd/.zcash/zcash.conf

USER zcashd 

RUN npm install -g npm@latest
RUN npm -g install zcash-hackworks/bitcore-node-zcash

WORKDIR /home/zcashd/
RUN bitcore-node create zc
COPY --chown=zcashd:zcashd ./bitcore-node.json /home/zcashd/zc/

WORKDIR /home/zcashd/zc/
RUN bitcore-node install zcash-hackworks/insight-api-zcash zcash-hackworks/insight-ui-zcash

RUN zcash-fetch-params --testnet

RUN sed -i 's/testnet = false/testnet = true/g' /home/zcashd/zc/node_modules/insight-ui-zcash/public/src/js/app.js

ENTRYPOINT ["/home/zcashd/zc/node_modules/bitcore-node-zcash/bin/bitcore-node", "start"]
