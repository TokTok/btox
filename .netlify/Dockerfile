FROM toxchat/flutter-web:latest

ARG TARGET=release

COPY --chown=builder:builder . .
RUN tools/prepare-web \
 && flutter build web --wasm "--$TARGET" \
 && mv build/web _site \
 && cp web/_headers _site/
