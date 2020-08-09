#!/usr/bin/env bash

# ==== Resource Group ====
export SUBSCRIPTION=685ba005-af8d-4b04-8f16-a7bf38b2eb5a # customize this
export RESOURCE_GROUP=spring-cloud-gateway # customize this
export REGION=westus2

# ==== Service and App Instances ====
export SPRING_CLOUD_SERVICE=gateway # customize this
export GATEWAY=gateway
export BOOK_STORE=book-store
export MOVIE_STORE=movie-store
export HYSTRIX_DASHBOARD=hystrix-dashboard

# ==== JARS ====
export GATEWAY_JAR=gateway/target/gateway-1.0.0-SNAPSHOT.jar
export BOOK_STORE_JAR=bookstore/target/bookstore-1.0.0-SNAPSHOT.jar
export MOVIE_STORE_JAR=moviestore/target/moviestore-1.0.0-SNAPSHOT.jar
export HYSTRIX_DASHBOARD_JAR=hystrix-dashboard/target/hystrix-dashboard-1.0.0-SNAPSHOT.jar

# ==== REDIS INFO ====
export REDIS_CACHE_NAME=redis-4-gateway # customize this