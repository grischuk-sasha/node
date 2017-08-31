FROM node:6-alpine

RUN apk update && apk upgrade && apk --update add \
    ruby ruby-bundler nano git bash \
    &&  echo 'gem: --no-document' > /etc/gemrc

RUN gem install sass -v 3.4
RUN gem install --pre sass-css-importer

RUN npm install -g grunt-cli
RUN npm install -g gulp-cli
RUN npm install -g bower
RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN npm install -g webpack@2.2
RUN npm install -g yarn

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /var/www