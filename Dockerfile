FROM python:3.7-alpine

RUN apk add --no-cache --update \
    bash \
    curl \
    ffmpeg \
    gcc \
    git \
    libffi-dev \
    libjpeg \
    libjpeg-turbo-dev \
    libwebp-dev \
    linux-headers \
    musl \
    musl-dev \
    neofetch \
    rsync \
    zlib \
    zlib-dev \
    libxslt-dev \
    libxml2-dev

WORKDIR /usr/src/app/Tbot

RUN git clone https://github.com/Thagoo/Tbot2.git /usr/src/app/Tbot/ --depth=1
RUN pip3 install --upgrade pip
RUN pip3 install --no-warn-script-location --no-cache-dir -r requirements.txt

RUN rm -rf /var/cache/apk/* /tmp/* /usr/src/app/Tbot
