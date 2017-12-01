FROM ubuntu:16.04

RUN apt-get update && apt-get install -y ruby ruby-bundler ruby-compass && \
    apt-get install -y git nano && \
    echo 'gem: --no-document' > /etc/gemrc

RUN apt-get install -y nodejs npm && ln -s /usr/bin/nodejs /usr/bin/node

RUN gem install sass -v 3.4
RUN gem install --pre sass-css-importer

RUN npm install -g grunt-cli
RUN npm install -g gulp-cli
RUN npm install -g bower
RUN npm install -g node-sass
RUN npm install -g node-gyp
RUN npm rebuild node-sass
RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN npm install -g webpack@1
RUN npm install -g yarn

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /var/www