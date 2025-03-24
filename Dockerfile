FROM node:18-alpine3.18 as base


# Base dependency for compilation
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
RUN npm install node-gyp -g --no-cache


FROM base as strapi
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/app
RUN npx create-strapi-app@5.11.1 \
      --ts \
      --use-yarn  \
      --no-run  \
      --skip-cloud \
      --dbclient postgres \
      --no-example \
      --no-git-init  \
      --skip-db  \
      --install .



FROM strapi as install
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}
ENV PATH=/opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY package.json .
RUN yarn install --no-cache


FROM node:18-alpine3.18 as final

# Installing libvips-dev for sharp Compatibility
EXPOSE 1337

RUN apk add --no-cache dcron
RUN apk add --no-cache bash

COPY --from=install /opt/app /opt/app



WORKDIR /opt/app

COPY . .
RUN [ "npm", "run", "build" ]


RUN mkdir -p /etc/cron.d/
RUN cat /etc/crontabs/root > /etc/cron.d/0
COPY cron/* /etc/cron.d/
RUN cat /etc/cron.d/* >> /etc/crontabs/root
RUN echo "" >> /etc/crontabs/root

COPY bin bin
RUN chmod +x bin/*.sh


CMD ["/bin/sh", "/opt/app/bin/start.sh"]


