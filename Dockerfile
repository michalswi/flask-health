ARG PYTHON_VERSION
ARG ALPINE_VERSION

FROM python:${PYTHON_VERSION}-alpine${ALPINE_VERSION}

ENV APP_PORT PORT

RUN pip install pipenv

RUN adduser -D -h /app dummy
USER dummy

WORKDIR /app

COPY app.py .
COPY checkStatus.py .
COPY Pipfile .
COPY Pipfile.lock .

RUN pipenv install --deploy --system

ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
