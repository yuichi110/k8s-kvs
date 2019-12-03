#!/bin/sh
if [ $# -ne 2 ]; then
  echo "error. please set <dockerhub-user> <build-timestamp>"
  exit 1
fi
cd `dirname $0`
sed -e "s/{{DOCKERHUB_USER}}/$1/g" webapp.tpl > webapp.yml
sed -i -e "s/{{BUILD_TIMESTAMP}}/$2/g" webapp.yml
sed -e "s/{{DOCKERHUB_USER}}/$1/g" webtest.tpl > webtest.yml
sed -i -e "s/{{BUILD_TIMESTAMP}}/$2/g" webtest.yml