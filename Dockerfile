FROM toxchat/tox.js AS js
FROM toxchat/flutter-web AS build

# Copy files to container and build
RUN mkdir /app/
COPY --from=js /work/wasm/* /app/asset/
COPY lib /app/lib
COPY web /app/web
COPY pubspec.* /app/
WORKDIR /app/
RUN flutter build web

FROM toxchat/bootstrap-node:latest AS tox
FROM golang:1.16-alpine AS websockify

COPY .heroku/websockify /work/websockify
RUN cd /work/websockify && go mod download github.com/gorilla/websocket && go install

# Stage 2 - Create the run-time image
FROM alpine:latest

COPY --from=websockify /go/bin/websockify /usr/local/bin/
COPY --from=tox /usr/local /usr/local/
COPY --from=tox /etc/tox-bootstrapd.conf /etc/
COPY --from=build /app/build/web /web/
COPY --from=js /work/wasm /web/asset/
COPY .heroku/keys /var/lib/tox-bootstrapd/
COPY .heroku/entrypoint.sh /

WORKDIR /web
CMD ["/entrypoint.sh"]
