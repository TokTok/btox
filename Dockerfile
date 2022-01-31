FROM ubuntu:20.04 AS build

# Install flutter dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
 ca-certificates \
 curl \
 fonts-droid-fallback \
 gdb \
 git \
 lib32stdc++6 \
 libgconf-2-4 \
 libglu1-mesa \
 libstdc++6 \
 python3 \
 unzip \
 wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

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
COPY . /app/
WORKDIR /app/
RUN flutter build web

# Stage 2 - Create the run-time image
FROM nginx:1.21.1-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
