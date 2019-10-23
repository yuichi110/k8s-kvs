From python:3.7.4-slim
RUN pip install flask==1.1.1 redis==3.3.8
COPY ./start.py /usr/local/bin/start.py
ENV PORT       80
ENV REDIS_HOST 127.0.0.1
ENV REDIS_PORT 6379
ENV REDIS_DB   0
ENTRYPOINT ["python", "/usr/local/bin/start.py"]