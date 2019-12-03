pipeline {
  agent any
  environment {
    DOCKERHUB_USER = "yuichi110"
    BUILD_HOST = "root@10.149.245.120"
    PROD_HOST = "root@10.149.245.121"
    BUILD_TIMESTAMP = sh(script: "date +%Y%m%d.%H%M%S", returnStdout: true).trim()
  }
  stages {
    stage('Pre Check') {
      steps {
        sh "test -f ~/.docker/config.json"
        sh "cat ~/.docker/config.json | grep docker.io"
        sh "kubectl config use-context prod"
        sh "kubectl config use-context build"
      }
    }
    stage('Build') {
      steps {
        sh "cat docker-compose.build.yml"
        sh "docker-compose -H ssh://${BUILD_HOST} -f docker-compose.build.yml build"
        sh "docker -H ssh://${BUILD_HOST} tag c8kvs_build_web ${DOCKERHUB_USER}/c8kvs_test_web:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} tag c8kvs_build_app ${DOCKERHUB_USER}/c8kvs_test_app:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} tag c8kvs_build_webtest ${DOCKERHUB_USER}/c8kvs_test_webtest:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} push ${DOCKERHUB_USER}/c8kvs_test_web:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} push ${DOCKERHUB_USER}/c8kvs_test_app:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} push ${DOCKERHUB_USER}/c8kvs_test_webtest:${BUILD_TIMESTAMP}"
      }
    }
    stage('Test') {
      steps {
        sh "./k8s_build/generate.sh ${DOCKERHUB_USER} ${BUILD_TIMESTAMP}"
        sh "kubectl config use-context build"
        sh "kubectl apply -f ./k8s_build/webtest.yml"
        sh "kubectl apply -f ./k8s_build/db.yml"
        sh "kubectl apply -f ./k8s_build/webapp.yml"
        sh "kubectl apply -f ./k8s_build/service.yml"
        sh "kubectl exec -it webtest -- pytest -v test_app.py"
        sh "kubectl exec -it webtest -- pytest -v test_static.py"
        sh "kubectl exec -it webtest -- pytest -v test_selenium.py"
        sh "kubectl delete -f ./k8s_build/webtest.yml -f ./k8s_build/service.yml"
        sh "kubectl delete -f ./k8s_build/webapp.yml -f ./k8s_build/db.yml"
      }
    }
    stage('Deploy') {
      steps {
        sh "docker -H ssh://${BUILD_HOST} tag c8kvs_build_web ${DOCKERHUB_USER}/c8kvs_prod_web:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} tag c8kvs_build_app ${DOCKERHUB_USER}/c8kvs_prod_app:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} push ${DOCKERHUB_USER}/c8kvs_prod_web:${BUILD_TIMESTAMP}"
        sh "docker -H ssh://${BUILD_HOST} push ${DOCKERHUB_USER}/c8kvs_prod_app:${BUILD_TIMESTAMP}"
        sh "./k8s_prod/generate.sh ${DOCKERHUB_USER} ${BUILD_TIMESTAMP}"
        sh "kubectl config use-context prod"
        sh "kubectl create namespace common; true"
        sh "kubectl apply -f ./k8s_build/db.yml -n common"
        sh "kubectl create namespace ${BUILD_TIMESTAMP}"
        sh "kubectl apply -f ./k8s_build/webapp.yml -n ${BUILD_TIMESTAMP}"
        sh "kubectl apply -f ./k8s_build/service.yml -n ${BUILD_TIMESTAMP}"
        sh "kubectl get services -n ${BUILD_TIMESTAMP}"
      }
    }
  }
}