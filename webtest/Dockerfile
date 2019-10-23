From python:3.7.4-slim

RUN pip install pytest==5.2.0 requests==2.22.0 selenium==3.141.0
WORKDIR /test
COPY ./test_static.py /test
COPY ./test_selenium.py /test

CMD ["/bin/bash"]