FROM toxchat/flutter-web AS build

# Copy files to container and build
RUN mkdir /home/builder/app/
COPY --chown=builder:builder lib /home/builder/app/lib
COPY --chown=builder:builder tools /home/builder/app/tools
COPY --chown=builder:builder web /home/builder/app/web
COPY --chown=builder:builder pubspec.* /home/builder/app/
WORKDIR /home/builder/app/
RUN tools/prepare-web
RUN flutter build web

# Stage 2 - Create the run-time image
FROM toxchat/bootstrap-node:latest-websocket

COPY --from=build /home/builder/app/build/web /web
COPY .heroku/keys /var/lib/tox-bootstrapd/
