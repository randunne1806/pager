#!/usr/bin/env bash

transmitterIpv4='192.168.2.240'
stage1Ipv4='192.168.2.59'
projects=("pager-log" "pager-relay" "pager-view")

case "$1" in
    amitron)
        export TRANSMITTER_IPV4=$transmitterIpv4
        export REACT_APP_PAGER_LOG_BASE=http://$stage1Ipv4:8080
        export REACT_APP_PAGER_RELAY_BASE=http://$stage1Ipv4:5000
        export PAGER_LOG_DB_HOST=$stage1Ipv4
        export PAGER_LOG_DB_PORT=5432
        ;;
    local)
        export TRANSMITTER_IPV4=$transmitterIpv4
        export REACT_APP_PAGER_LOG_BASE=http://127.0.0.1:8080
        export REACT_APP_PAGER_RELAY_BASE=http://127.0.0.1:5000
        export PAGER_LOG_DB_HOST=pager-log-db
        export PAGER_LOG_DB_PORT=5432
        ;;
    *)
        echo "Usage: $(basename "$0") {amitron|local}"
        exit 1
esac

if [ "$2" = "ku" ]; then
    REGISTRY_PORT=10000
    REGISTRY_BASE=localhost
    REGISTRY_NAME=local-registry

    LOCAL_REGISTRY_EXISTS=$(docker container ls -a -f "name=$REGISTRY_NAME")
    LOCAL_REGISTRY_IS_ON=$(docker ps -f "name=$REGISTRY_NAME")

    if [ "$REGISTRY_BASE" = 'localhost' ]; then
        if [ -z "$LOCAL_REGISTRY_EXISTS" ]; then
            docker run -d -p "$REGISTRY_PORT:5000" --name "$REGISTRY_NAME" registry:2
        elif [ -z "$LOCAL_REGISTRY_IS_ON" ]; then
            docker container start "$REGISTRY_NAME"
        fi
    fi

    for p in "${projects[@]}"; do
        IMG_NAME="$REGISTRY_BASE:$REGISTRY_PORT/$p:latest"
        docker build -f "$p/Dockerfile" -t "$IMG_NAME" "$p"
        docker push "$IMG_NAME"
    done
fi