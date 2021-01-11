#!/bin/bash

EXPLORER_WAR=/usr/local/tomcat/webapps/explorer.war
if [ -f "$EXPLORER_WAR" ]; then
    echo "$EXPLORER_WAR exists, skip download"
else
    apt-get update
    apt-get install -y \
        zip
    
    rm -Rf /usr/local/tomcat/webapps
    # enable default tomcat apps
    cp -R /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps
    cp /opt/manager/context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
    
    echo "$EXPLORER_WAR does not exist, download it!!"

    wget https://github.com/yogh-io/bitcoin-transaction-explorer/releases/download/beta/explorer.war
    mkdir -p WEB-INF/classes/
    cp /opt/yoghurt.conf WEB-INF/classes/yoghurt.conf
    zip -ur ./explorer.war WEB-INF
    rm -Rf WEB-INF
    mv ./explorer.war $EXPLORER_WAR
fi

catalina.sh run
