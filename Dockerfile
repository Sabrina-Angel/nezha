FROM ubuntu:focal-20221130

ENV TZ="Asia/Shanghai"

ARG TARGETOS
ARG TARGETARCH

COPY ./script/entrypoint.sh /entrypoint.sh

RUN export DEBIAN_FRONTEND="noninteractive" && \
    apt update && apt install -y ca-certificates tzdata && \
    update-ca-certificates && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure tzdata && \
    chmod +x /entrypoint.sh 

WORKDIR /dashboard
COPY ./resource ./resource
COPY ./dashboard-${TARGETOS}-${TARGETARCH} ./app
RUN chmod +x /dashboard/app && chmod +x /dashboard && chmod +x /etc/resolv.conf && \
    printf "nameserver 127.0.0.11\nnameserver 8.8.4.4\nnameserver 223.5.5.5\n" > /etc/resolv.conf

VOLUME ["/dashboard/data"]
EXPOSE 80 5555
ENTRYPOINT ["/entrypoint.sh"]

USER 10000
