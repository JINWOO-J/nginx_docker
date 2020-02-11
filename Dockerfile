#
# - Base nginx
#
FROM ubuntu:18.04
LABEL maintainer="JINWOO <jinwoo@iconloop.com>"
#
# Prepare the container
#
ENV TZ "Asia/Seoul"

# Nginx allow Prep dynamic IP - cron Setting
ADD ./policy/prepnode_ipscan_cron /etc/cron.d/prepnode_ipscan_cron
ADD ./logrotate/nginx_logrotate_cron /etc/cron.d/nginx_logrotate_cron
ADD ./logrotate/nginx /etc/logrotate.d/nginx
RUN chmod 0644 /etc/cron.d/prepnode_ipscan_cron
RUN chmod 0644 /etc/cron.d/nginx_logrotate_cron
RUN chmod 0644 /etc/logrotate.d/nginx

RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list
RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata inotify-tools jq cron logrotate && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

ARG DEBUG_BUILD
ENV DEBUG_BUILD $DEBUG_BUILD
ARG NGINX_VERSION
ENV NGINX_VERSION $NGINX_VERSION
RUN echo $NGINX_VERSION
ENV DOCKERIZE_VERSION v0.6.1


ARG NGINX_GPG="573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
               A09CD539B8BB8CBE96E82BDFABD4D3B3F5806B4D \
               4C2C85E705DC730833990C38A9376139A524C53E \
               65506C02EFC250F1B7A3D694ECF0E90B2C172083 \
               B0F4253373F8F6F510D42178520A9993A1C052F8 \
               7338973069ED3F443F4D37DFA64FD5B17ADB39A8"

ENV TERM "xterm-256color"
ENV USERID 24988

ENV NGINX_EXTRA_CONFIGURE_ARGS --sbin-path=/usr/sbin \
                                --conf-path=/etc/nginx/nginx.conf \
                                --with-md5=/usr/lib --with-sha1=/usr/lib \
                                --with-http_ssl_module --with-http_dav_module \
                                --without-mail_pop3_module --without-mail_imap_module \
                                --without-mail_smtp_module \
                                --with-http_stub_status_module \
                                --with-http_realip_module \
                                --with-http_v2_module


ENV NGINX_BUILD_DEPS bzip2 \
        file \
        openssl \
        curl \
        libc6 \
        libpcre3 \
        tmux \
        vim \
        runit \
        iproute2 \
        gnupg

ENV NGINX_EXTRA_BUILD_DEPS gcc make pkg-config  \
                            libbz2-dev \
                            libpcre3-dev \
                            libc-dev \
                            libcurl4-openssl-dev \
                            libmcrypt-dev \
                            libreadline6-dev \
                            libssl-dev \
                            libxslt1-dev \
                            libxml2-dev \
                            autoconf \
                            libxml2 \
                            git \
                            ca-certificates \
                            wget \
                            nano less

RUN sed -i 's/archive.ubuntu.com/ftp.daum.net/g' /etc/apt/sources.list

RUN echo 'export PS1=" \[\e[00;32m\]${NGINX_VERSION}\[\e[0m\]\[\e[00;37m\]@\[\e[0m\]\[\e[00;31m\]\H :\\$\[\e[0m\] "' >> /root/.bashrc

RUN userdel www-data && groupadd -r www-data -g ${USERID} && \
    mkdir /home/www-data && \
    mkdir -p /var/www && \
    useradd -u ${USERID} -r -g www-data -d /home/www-data -s /sbin/nologin -c "Docker image user for web application" www-data && \
    chown -R www-data:www-data /home/www-data /var/www && \
    chmod 700 /home/www-data && \
    chmod 711 /var/www && \
	mkdir -p /etc/nginx/conf.d/

# Nginx allow Prep IP conf file
COPY policy /etc/nginx/policy/
COPY error /var/www/error/

COPY files /

RUN bash -c "/usr/src/nginx_compile.sh"

VOLUME [ "/var/www" , "/var/log/nginx" ]

EXPOSE 443
EXPOSE 80

CMD ["/run.sh"]
# CMD ["/usr/local/sbin/runsvdir-init"]
