FROM node:alpine

COPY ./graphql/src /app/src
COPY ./graphql/package.json /app/package.json
WORKDIR /app

USER $USER
RUN yarn install

EXPOSE 5000
CMD [ "yarn", "server" ]