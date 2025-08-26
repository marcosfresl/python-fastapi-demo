FROM python:3.10.8-alpine

RUN python -m pip install --upgrade pip setuptools wheel

#app directory
WORKDIR /app
#demo user
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN addgroup -g ${GROUP_ID} demo \
 && adduser -D demo -u ${USER_ID} -g demo -G demo -s /bin/sh

#copy files
COPY --chown=demo . /app/

#install depedencies
RUN apk add --no-cache --virtual .build-deps \
        gcc libc-dev make musl-dev python3-dev libffi-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del .build-deps


USER demo

#entrypoint
CMD ["uvicorn", "app.main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8080"]