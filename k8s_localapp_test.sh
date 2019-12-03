echo 'delete k8s resources'
kubectl delete -f ./k8s_local/webtest.yml -f ./k8s_local/service.yml
kubectl delete -f ./k8s_local/webtest.yml -f ./k8s_local/db.yml
echo 'create k8s resources...'
kubectl apply -f ./k8s_local/db.yml
kubectl apply -f ./k8s_local/webtest.yml
kubectl apply -f ./k8s_local/service.yml
kubectl apply -f ./k8s_local/webtest.yml
sleep 10
echo 'run tests'
kubectl exec -it webtest -- pytest -v test_api.py
kubectl exec -it webtest -- pytest -v test_static.py
kubectl exec -it webtest -- pytest -v test_selenium.py