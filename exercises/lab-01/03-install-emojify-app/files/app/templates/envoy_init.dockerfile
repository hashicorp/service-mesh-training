FROM alpine:latest

RUN apk update && apk add gettext

# Add Consul
RUN wget https://releases.hashicorp.com/consul/1.4.2/consul_1.4.2_linux_amd64.zip -O ./consul.zip && unzip ./consul.zip && mv ./consul /bin && rm ./consul.zip

RUN mkdir /app
COPY ./init.sh /app
RUN chmod +x /app/init.sh

WORKDIR /app

ENTRYPOINT "/app/init.sh"
