FROM node:20-alpine AS builder

WORKDIR /app
EXPOSE 3000
COPY package.json ./
RUN yarn install --production

FROM node:20-alpine AS final

WORKDIR /app

# Copia somente os arquivos necessários da etapa anterior
COPY --from=builder /app/node_modules ./node_modules
COPY . .
RUN npm run build
CMD ["/bin/sh", "/app/bin/start.sh"]


#FROM node:18-alpine
## Installing libvips-dev for sharp Compatibility
#RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git
#ARG NODE_ENV=development
#ENV NODE_ENV=${NODE_ENV}
#
#WORKDIR /opt/
#COPY package.json package-lock.json ./
#RUN npm install -g node-gyp
#RUN npm config set fetch-retry-maxtimeout 600000 -g && npm install
#ENV PATH /opt/node_modules/.bin:$PATH
#
#WORKDIR /opt/app
#COPY . .
#RUN chown -R node:node /opt/app
#USER node
#RUN ["npm", "run", "build"]
#EXPOSE 1337
#CMD ["npm", "run", "develop"]

