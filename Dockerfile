FROM node:18-alpine3.18

ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}


EXPOSE 1337

WORKDIR /opt/app
# Installing libvips-dev for sharp Compatibility
RUN apk update
RUN apk add --no-cache build-base
RUN apk add --no-cache gcc
RUN apk add --no-cache autoconf
RUN apk add --no-cache automake
RUN apk add --no-cache zlib-dev
RUN apk add --no-cache libpng-dev
RUN apk add --no-cache nasm
RUN apk add --no-cache bash
RUN apk add --no-cache vips-dev

RUN apk add --no-cache git
RUN apk add --no-cache dcron

RUN npm install -g node-gyp

COPY package.json ./
RUN npm config set fetch-retry-maxtimeout 600000 -g
RUN npm install


COPY bin bin
RUN chmod +x bin/*.sh

COPY . .

RUN ["npm", "run", "build"]

CMD ["/bin/sh", "/opt/app/bin/start.sh"]


