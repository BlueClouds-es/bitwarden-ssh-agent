FROM node:alpine

ARG uid=1100
ARG gid=1100
ARG user=ssh-agent
ARG group=ssh-agent
ARG userapp=${uid}:${gid}
RUN addgroup -S ${group} --gid ${gid} && adduser --uid ${uid} -S -G ${group} ${user}

USER root
RUN npm install -g @bitwarden/cli
RUN apk update && \
	apk add openssh-client && \
	apk add bash && \
	apk add socat && \
	apk add python3 && \
	apk add py3-pip && \
	pip install setuptools

VOLUME /home/ssh-agent/.config/Bitwarden CLI/
RUN chown -R ${user}:${group} /home/ssh-agent/

USER ${userapp}

RUN mkdir /tmp/ssh-agent
ENV SSH_AUTH_SOCK="/tmp/ssh-agent/agent"

ENV BW_CLIENTID=""
ENV BW_CLIENTSECRET=""

WORKDIR /ssh-agent
COPY bw_add_sshkeys.py .
COPY entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
