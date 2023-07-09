FROM php:8.2-cli

COPY app/wp /usr/local/bin/wp

RUN --mount=type=cache,target=/var/lib/apt/lists --mount=type=cache,target=/var/cache/apt/archives \
 apt update \
 && apt install -y  --no-install-recommends curl less ssh vim  imagemagick libmagickwand-dev \
 && curl -o /usr/local/bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x /usr/local/bin/wp \
 && useradd -s /bin/bash -d /home/wp-cli -m wp-cli \
 && mkdir -p /var/www/html \
 && docker-php-ext-install mysqli \
 && yes | pecl install imagick \
 && docker-php-ext-enable imagick \
 && curl -L https://raw.githubusercontent.com/holly/dotfiles/main/.vimrc -o /root/.vimrc \
 && cp /root/.vimrc /home/wp-cli/.vimrc \
 && mkdir /home/wp-cli/.ssh \
 && chmod 700 /home/wp-cli/.ssh \
 && chown wp-cli.wp-cli /home/wp-cli/.ssh /home/wp-cli/.vimrc 
 
USER wp-cli
WORKDIR /home/wp-cli
#CMD [ "/bin/bash" ]
ENTRYPOINT [ "/usr/local/bin/wp" ]
