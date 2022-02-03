FROM toxchat/toxcore-js AS js
FROM toxchat/flutter-web AS build

# Copy files to container and build
RUN mkdir /app/
COPY --from=js /work/wasm/* /app/asset/
COPY lib /app/lib
COPY web /app/web
COPY pubspec.* /app/
WORKDIR /app/
RUN flutter build web

# Stage 2 - Create the run-time image
FROM toxchat/bootstrap-node:latest-websocket

RUN /usr/local/bin/tox-bootstrapd --config /etc/tox-bootstrapd.conf --log-backend stdout \
 && sleep 1 \
 && cp /var/lib/tox-bootstrapd/keys /var/lib/tox-bootstrapd/keys-new

COPY --from=build /app/build/web /web/
COPY --from=js /work/wasm /web/asset/
COPY .heroku/keys /var/lib/tox-bootstrapd/
