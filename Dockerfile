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
RUN chmod +x /dashboard/app && chmod +x /dashboard

VOLUME ["/dashboard/data"]
EXPOSE 80 5555
ENTRYPOINT ["/entrypoint.sh"]

USER 10000
