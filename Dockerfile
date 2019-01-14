FROM debian:latest
# Run 'docker build .' from github clone
# docker run -p80:3001 -v $(pwd)/dot-zcash:/home/zcashd/.zcash

RUN apt-get update \
    && apt-get install -y gnupg2 wget libzmq3-dev git \
# zcash build (see RTD User Guide):
    && apt-get -qqy install \
        build-essential pkg-config libc6-dev m4 g++-multilib \
        autoconf libtool ncurses-dev unzip git python python-zmq \
        zlib1g-dev wget curl bsdmainutils automake \
    \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

RUN useradd -m zcashd \
    && mkdir -p /home/zcashd/.npm-global \
    && mkdir -p /home/zcashd/.zcash/ \ 
    && mkdir -p /home/zcashd/.zcash-params/ \
    && chown -R zcashd /home/zcashd \
    && true
ENV PATH=/home/zcashd/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX=/home/zcashd/.npm-global

USER zcashd 
WORKDIR /home/zcashd/

RUN git clone https://github.com/zcash-hackworks/zcash-patched-for-explorer.git
WORKDIR /home/zcashd/zcash-patched-for-explorer
RUN git checkout v2.0.2-insight-explorer

# keep jobs low to minimize chances of running out of memory
RUN zcutil/build.sh -j2
RUN zcutil/fetch-params.sh

WORKDIR /home/zcashd/
RUN npm install -g npm@latest
RUN npm -g install zcash-hackworks/bitcore-node-zcash

RUN bitcore-node create zc
COPY --chown=zcashd:zcashd ./bitcore-node.json /home/zcashd/zc/

WORKDIR /home/zcashd/zc/
RUN bitcore-node install zcash-hackworks/insight-api-zcash zcash-hackworks/insight-ui-zcash

RUN sed -i 's/testnet = false/testnet = true/g' /home/zcashd/zc/node_modules/insight-ui-zcash/public/src/js/app.js

CMD ["/home/zcashd/zc/node_modules/bitcore-node-zcash/bin/bitcore-node", "start"]
