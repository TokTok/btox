FROM toxchat/flutter-web:latest

COPY --chown=builder:builder . .
RUN tools/prepare-web && flutter build web --release && mv build/web _site
