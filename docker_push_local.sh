#! /bin/sh
docker tag kvs2_web_local yuichi110/kvs2_web_local:latest
docker tag kvs2_app_local yuichi110/kvs2_app_local:latest
docker push yuichi110/kvs2_web_local:latest
docker push yuichi110/kvs2_app_local:latest