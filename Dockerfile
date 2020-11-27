FROM ubuntu:20.04

LABEL maintainer="Mathew Fleisch <mathew.fleisch@gmail.com>"
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""
ENV S3_CONFIG_BUCKET ""
WORKDIR /root
RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt dist-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt install -y curl sudo golang awscli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# RUN curl -s https://s3.amazonaws.com/download.draios.com/dependencies/get-dependency-installer.sh | bash
#WORKDIR /root/dependency-installer
#COPY dependencies.yaml dependencies.yaml
#RUN ./bootstrap-build.sh && ./installer.sh ./dependencies.yaml

    # && DEBIAN_FRONTEND=noninteractive apt install -y \
    #     curl sudo golang vim wget jq python3 python3-pip openssl git awscli \
    #     software-properties-common lsb-release apt-transport-https ca-certificates \
    #     zlib1g-dev libpam0g-dev libselinux1-dev \
    # && pip3 install awscli --upgrade --user \
RUN mkdir -p /bashbot
WORKDIR /bashbot
COPY . .
RUN mkdir -p vendor
RUN go install -v ./...
RUN go get github.com/slack-go/slack@master

CMD ["/bin/bash", "entrypoint.sh"]
