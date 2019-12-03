apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  replicas: 3
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  minReadySeconds: 5
  selector:
    matchLabels:
      pod: webapp
  template:
    metadata:
      name: webapp
      labels: 
        pod: webapp
    spec:
      containers:
        - name: web
          image: {{DOCKERHUB_USER}}/c8kvs_test_web:{{BUILD_TIMESTAMP}}
          ports:
          - name: http
            containerPort: 80
          env:
          - name: API_PROXY_URL
            value: "http://127.0.0.1:8080"
        - name: app
          image: {{DOCKERHUB_USER}}/c8kvs_test_app:{{BUILD_TIMESTAMP}}
          env:
          - name: PORT
            value: "8080"
          - name: REDIS_HOST
            value: db
          - name: REDIS_PORT
            value: "6379"
          - name: REDIS_DB
            value: "0"