FROM toxchat/flutter-web AS build

# Copy files to container and build
RUN mkdir /app/
COPY lib /app/lib
COPY tools /app/tools
COPY web /app/web
COPY pubspec.* /app/
WORKDIR /app/
RUN tools/prepare-web
RUN flutter build web

# Stage 2 - Create the run-time image
FROM toxchat/bootstrap-node:latest-websocket

COPY --from=build /app/build/web /web
COPY .heroku/keys /var/lib/tox-bootstrapd/
