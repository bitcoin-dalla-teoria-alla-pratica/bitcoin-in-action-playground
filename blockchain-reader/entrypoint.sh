#!/bin/bash

set -e

EXPLORER_WAR=/usr/local/tomcat/webapps/explorer.war
if [ -f "$EXPLORER_WAR" ]; then
    echo "$EXPLORER_WAR exists, skip download"
else
    apt-get update
    apt-get install -y \
        zip \
        maven
    
    rm -Rf /usr/local/tomcat/webapps
    # enable default tomcat apps
    cp -R /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps
    cp /opt/manager-webapp-context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
    
    echo "$EXPLORER_WAR does not exist, download it!!"

    git clone https://github.com/yogh-io/bitcoin-yogh-explorer.git
    cd bitcoin-yogh-explorer

    # use our blockstream esplora node API
    sed -i 's/https:\/\/blockstream.info/http:\/\/localhost:8094\/regtest/g' ./yogh-explorer-client/src/main/java/nl/yogh/wui/explorer/service/ElectrServiceAsyncImpl.java 
    mvn install
    
    cp ./yogh-explorer-server/target/*.war ../webapps/explorer.war
fi

if [[ -z "${DOCKER_BUILD}" ]]; then
	# foreground tomcat
	catalina.sh run
else
	echo "DOCKER_BUILD set, no foreground jobs.."
fi
