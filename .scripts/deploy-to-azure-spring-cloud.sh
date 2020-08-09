#!/usr/bin/env bash

# ==== Build for cloud ====
mvn clean package -DskipTests -Denv=cloud

# ==== Create Resource Group ====
az group create --name ${RESOURCE_GROUP} \
    --location ${REGION}

az group lock create --lock-type CanNotDelete --name DoNotDelete \
    --notes For-DEMO \
    --resource-group ${RESOURCE_GROUP}

az configure --defaults \
    group=${RESOURCE_GROUP} \
    location=${REGION} \
    spring-cloud=${SPRING_CLOUD_SERVICE}

# ==== Create Azure Spring Cloud ====
az spring-cloud create --name ${SPRING_CLOUD_SERVICE} \
    --sku Standard \
    --resource-group ${RESOURCE_GROUP} \
    --location ${REGION}

# ==== Apply Config ====
az spring-cloud config-server set \
    --config-file application.yml \
    --name ${SPRING_CLOUD_SERVICE}

# ==== Create Redis Cache ====
az redis create \
    --name ${REDIS_CACHE_NAME} \
    --resource-group ${RESOURCE_GROUP} \
    --location ${REGION} \
    --vm-size C1 --sku Standard

export REDIS_CACHE_RESOURCE_ID=$(az redis show --name ${REDIS_CACHE_NAME} | jq -r '.id')

# ==== Create apps ====

az spring-cloud app create --name ${GATEWAY} --instance-count 1 --is-public true \
    --memory 2 \
    --jvm-options='-Xms2048m -Xmx2048m'

az spring-cloud app binding redis add \
    --app ${GATEWAY} \
    --name redis \
    --resource-id ${REDIS_CACHE_RESOURCE_ID}

az spring-cloud app create --name ${BOOK_STORE} --instance-count 1 \
    --memory 2 \
    --jvm-options='-Xms2048m -Xmx2048m'

az spring-cloud app create --name ${MOVIE_STORE} --instance-count 1 \
    --memory 2 \
    --jvm-options='-Xms2048m -Xmx2048m'

az spring-cloud app create --name ${HYSTRIX_DASHBOARD} --instance-count 1 --is-public true \
    --memory 2 \
    --jvm-options='-Xms2048m -Xmx2048m'

# ==== Deploy Apps ====

az spring-cloud app deploy --name ${GATEWAY} \
    --jar-path ${GATEWAY_JAR}

az spring-cloud app deploy --name ${BOOK_STORE} \
    --jar-path ${BOOK_STORE_JAR}

az spring-cloud app deploy --name ${MOVIE_STORE} \
    --jar-path ${MOVIE_STORE_JAR}

az spring-cloud app deploy --name ${HYSTRIX_DASHBOARD} \
    --jar-path ${HYSTRIX_DASHBOARD_JAR}

# ==== Scale apps ====
az spring-cloud app scale --name ${GATEWAY} --instance-count 2

az spring-cloud app scale --name ${BOOK_STORE} --instance-count 2

az spring-cloud app scale --name ${MOVIE_STORE} --instance-count 2