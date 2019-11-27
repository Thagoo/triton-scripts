
ENV PATH="/app/bin/env"
WORKDIR /app

RUN git clone https://github.com/Thagoo/triton-script /app

CMD ["bash","build.sh"]
