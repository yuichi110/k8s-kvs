docker-compose -f docker-compose.local.yml down
docker-compose -f docker-compose.local.yml up -d --build
docker container exec c8kvs_local_webtest pytest -v test_app.py
docker container exec c8kvs_local_webtest pytest -v test_static.py
docker container exec c8kvs_local_webtest pytest -v test_selenium.py