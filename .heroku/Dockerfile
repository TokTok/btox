FROM ubuntu:20.04 AS build

ENV DEBIAN_FRONTEND="noninteractive"

# Install flutter dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
 autoconf \
 automake \
 ca-certificates \
 cmake \
 curl \
 fonts-droid-fallback \
 gdb \
 git \
 lib32stdc++6 \
 libgconf-2-4 \
 libglu1-mesa \
 libstdc++6 \
 libtool \
 make \
 ninja-build \
 pkg-config \
 python3 \
 unzip \
 wget \
 xz-utils \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /work/emsdk
RUN git clone --depth=1 https://github.com/emscripten-core/emsdk /work/emsdk \
 && ./emsdk install latest \
 && ./emsdk activate latest

# Build libsodium.
RUN . "/work/emsdk/emsdk_env.sh" \
 && git clone --depth=1 --branch=1.0.18 https://github.com/jedisct1/libsodium /work/libsodium \
 && cd /work/libsodium \
 && autoreconf -fi \
 && emconfigure ./configure --disable-shared \
  --without-pthreads \
  --disable-ssp --disable-asm --disable-pie \
 && emmake make install -j8

# Build c-toxcore.
RUN . "/work/emsdk/emsdk_env.sh" \
 && git clone --depth=1 https://github.com/TokTok/c-toxcore /work/c-toxcore \
 && cd /work/c-toxcore \
 && emcmake cmake -B_build -H. -GNinja -DBUILD_TOXAV=OFF -DENABLE_SHARED=OFF -DBOOTSTRAP_DAEMON=OFF -DCMAKE_INSTALL_PREFIX:PATH="/usr/local" \
 && emmake cmake --build _build --parallel 8 --target install

# Compile JavaScript bindings.
COPY .heroku/wasm.cpp /work/wasm.cpp
RUN . "/work/emsdk/emsdk_env.sh" \
 && emcc \
 -o /work/tox.js \
 /work/wasm.cpp \
 --std=c++17 \
 --bind \
 -s ALLOW_MEMORY_GROWTH=1 \
 $(pkg-config --cflags --libs libsodium toxcore)

# Clone the flutter repo
RUN git clone --depth=1 https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
# RUN /usr/local/flutter/bin/flutter doctor -v
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Run flutter doctor
RUN flutter doctor -v
# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Copy files to container and build
RUN mkdir /app/
COPY lib /app/lib
COPY web /app/web
COPY pubspec.* /app/
WORKDIR /app/
RUN flutter build web

FROM toxchat/bootstrap-node:latest AS tox
FROM golang:1.16-alpine AS websockify

COPY .heroku/websockify /work/websockify
RUN cd /work/websockify && go install

# Stage 2 - Create the run-time image
FROM alpine:latest

COPY --from=websockify /go/bin/websockify /usr/local/bin/
COPY --from=tox /usr/local /usr/local/
COPY --from=tox /etc/tox-bootstrapd.conf /etc/
COPY --from=build /app/build/web /web
COPY .heroku/keys /var/lib/tox-bootstrapd/
COPY .heroku/entrypoint.sh /

WORKDIR /web
CMD ["/entrypoint.sh"]
