FROM node:alpine

RUN apk update && apk add yarn git
RUN yarn global add babel-cli

RUN mkdir /home/md2gslides
RUN adduser -h /home/md2gslides -D md2gslides
RUN chown md2gslides /home/md2gslides

RUN mkdir /md2gslides
RUN git clone --single-branch --branch merge_nic https://github.com/nicholasjackson/md2googleslides.git /md2gslides
WORKDIR /md2gslides
RUN yarn install && yarn compile

WORKDIR /slides
USER md2gslides

ENTRYPOINT ["node", "/md2gslides/bin/md2gslides.js"]
