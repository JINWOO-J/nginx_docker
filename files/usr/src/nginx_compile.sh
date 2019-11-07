#!/bin/bash

function print_w(){
	RESET='\e[0m'  # RESET
	BWhite='\e[7m';    # backgroud White
	printf "${BWhite} ${1} ${RESET}\n";
}

function PrintOK() {
    IRed='\e[0;91m'         # Rosso
    IGreen='\e[0;92m'       # Verde
    RESET='\e[0m'  # RESET
    MSG=${1}
    CHECK=${2:-0}

    if [ ${CHECK} == 0 ];
    then
        printf "${IGreen} [OK] ${MSG} ret=${CHECK} ${RESET} \n"
    else
        printf "${IRed} [FAIL] ${MSG} ret=${CHECK} ${RESET} \n"
        printf "${IRed} [FAIL] Stopped script ${RESET} \n"
        exit 127;
    fi
}
DEBUG_BUILD=${DEBUG_BUILD:-"no"}
print_w "DEBUG_BUILD = ${DEBUG_BUILD}"
if [ $DEBUG_BUILD == "yes" ];
then

    set -x
fi

print_w "NGINX_VERSION = ${NGINX_VERSION} \n";
apt-get update > /dev/null
PrintOK "apt-get update" $?
apt-get install -y $NGINX_BUILD_DEPS $NGINX_EXTRA_BUILD_DEPS --no-install-recommends > /dev/null
PrintOK "apt-get install" $?

rm -rf /var/lib/apt/lists/*
mkdir -p /var/log/nginx
#set -x

for server in ha.pool.sks-keyservers.net hkp://keyserver.ubuntu.com:80 hkp://p80.pool.sks-keyservers.net:80 pgp.mit.edu; 
do
    echo "Fetching GPG key $NGINX_GPG from $server";
    gpg --keyserver "$server" --keyserver-options timeout=10 --recv-keys $NGINX_GPG && found=yes && break; 
done 
PrintOK "import to gpg keyserver [$server]" $?

curl -SL --silent -f "http://nginx.org/download/${NGINX_VERSION}.tar.gz" -o nginx.tar.bz2
PrintOK "Download ${NGINX_VERSION}.tar.gz" $?
curl -SL --silent -f "http://nginx.org/download/${NGINX_VERSION}.tar.gz.asc" -o nginx.tar.bz2.asc
PrintOK "Download ${NGINX_VERSION}.tar.gz.asc" $?

gpg --verify nginx.tar.bz2.asc > /dev/null 2>&1
PrintOK "gpg --verify nginx.tar.bz2.asc" $?

mkdir -p /usr/src/nginx
tar -xof nginx.tar.bz2 -C /usr/src/nginx --strip-components=1

PrintOK "extract source code from nginx.tar.bz2 " $?

rm nginx.tar.bz2*
cd /usr/src/nginx
## ADD nginx-module-vts module
git clone --quiet git://github.com/vozlt/nginx-module-vts.git

PrintOK "git clone nginx-module-vts " $?
./configure ${NGINX_EXTRA_CONFIGURE_ARGS} --add-module=nginx-module-vts >/dev/null
PrintOK "nginx configure" $?
make -j"$(nproc)" -s > /dev/null 2>&1
PrintOK "make" $?
make install -s
PrintOK "make install" $?
#find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' +
make clean -s
PrintOK "make clean" $?
curl -SL --silent -f -O https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
PrintOK "Download dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz" $?

tar -C /usr/local/bin -xzf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
rm -f dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz
rm -rf /usr/src/nginx
apt-get purge --yes --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $NGINX_EXTRA_BUILD_DEPS > /dev/null
PrintOK "apt clean up" $?
