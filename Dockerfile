ARG PYTHON_VERSION
ARG ALPINE_VERSION

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

WORKDIR /app

COPY app.py .
COPY checkStatus.py .
COPY requirements .

RUN pip install -r requirements

ENV SERVER_PORT 8080

ENTRYPOINT [ "python3" ]
CMD [ "app.py" ]