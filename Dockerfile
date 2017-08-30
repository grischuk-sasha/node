FROM node:6

RUN mkdir -p /usr/local/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /usr/local/etc/gemrc

ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.2.7
ENV RUBY_DOWNLOAD_SHA256 234c8aee6543da9efd67008e6e7ee740d41ed57a52e797f65043c3b5ec3bcb53
ENV RUBYGEMS_VERSION 2.6.12

RUN set -ex \
	\
	&& buildDeps=' \
		bison \
		dpkg-dev \
		libgdbm-dev \
		ruby \
	' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $buildDeps \
	\
	&& wget -O ruby.tar.xz "https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR%-rc}/ruby-$RUBY_VERSION.tar.xz" \
	&& echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.xz" | sha256sum -c - \
	\
	&& mkdir -p /usr/src/ruby \
	&& tar -xJf ruby.tar.xz -C /usr/src/ruby --strip-components=1 \
	&& rm ruby.tar.xz \
	\
	&& cd /usr/src/ruby \
	\
	&& { \
    		echo '#define ENABLE_PATH_CHECK 0'; \
    		echo; \
    		cat file.c; \
    	} > file.c.new \
    && mv file.c.new file.c \
    \
    && autoconf \
    && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && ./configure \
        --build="$gnuArch" \
        --disable-install-doc \
        --enable-shared \
    && make -j "$(nproc)" \
    && make install \
    \
    && apt-get purge -y --auto-remove $buildDeps \
    && cd / \
    && rm -r /usr/src/ruby \
    \
    && gem update --system "$RUBYGEMS_VERSION"

ENV BUNDLER_VERSION 1.15.3

RUN gem install bundler --version "$BUNDLER_VERSION"

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_BIN="$GEM_HOME/bin" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH

RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
	&& chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

RUN apt-get install -y nano

RUN gem install sass -v 3.4

RUN npm install -g grunt-cli
RUN npm install -g bower
RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN npm install -g webpack@2.2
RUN npm install -g yarn

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /var/www