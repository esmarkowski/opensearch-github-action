#!/bin/bash

set -euxo pipefail

if [[ -z $VERSION ]]; then
  echo -e "\033[31;1mERROR:\033[0m Required environment variable [VERSION] not set\033[0m"
  exit 1
fi

MAJOR_VERSION=`echo ${VERSION} | cut -c 1`
network_name="opensearch-net"

if [[ "$(docker network ls | grep -w "${network_name}")" == "" ]] ; then
    docker network create "${network_name}"
fi

mkdir -p /os/plugins/
chown -R 1000:1000 /os/


for (( node=1; node<=${NODES-1}; node++ ))
do
  port_com=$((9600 + $node - 1))
  UNICAST_HOSTS+="os$node:${port_com},"
done

for (( node=1; node<=${NODES-1}; node++ ))
do
  port=$((PORT + $node - 1))
  port_com=$((9600 + $node - 1))
    docker run \
      --rm \
      --env "node.name=os${node}" \
      --env "cluster.name=docker-opensearch" \
      --env "cluster.routing.allocation.disk.threshold_enabled=false" \
      --env "bootstrap.memory_lock=true" \
      --env "OPENSEARCH_JAVA_OPTS=-Xms1g -Xmx1g" \
      --env "discovery.type=single-node" \
      --env "http.port=${port}" \
      --env "OPENSEARCH_INITIAL_ADMIN_PASSWORD=${OPENSEARCH_INITIAL_ADMIN_PASSWORD}" \
      --env "DISABLE_INSTALL_DEMO_CONFIG=true" \
      --env "DISABLE_SECURITY_PLUGIN=${SECURITY_DISABLED}" \
      --publish "${port}:${port}" \
      --publish "${port_com}:${port_com}" \
      --detach \
      --network=${network_name} \
      -v opensearch-data1:/usr/share/opensearch/data \
      --name="os${node}" \
      opensearchproject/opensearch:${VERSION}
 
done

sleep 20

echo "Opensearch up and running"