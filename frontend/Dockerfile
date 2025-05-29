# Stage 1
FROM debian:latest AS build-env

RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
# This disables the flutter root warning
ENV CI=true

RUN flutter doctor -v

RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

RUN mkdir /app/
COPY aerialib_ui /app/
WORKDIR /app/aerialib_ui
RUN flutter build web --release

# Stage 2
#FROM nginx:stable-alpine
FROM cgr.dev/chainguard/nginx:latest

# Install curl
#RUN apk add --no-cache curl

# Bundle the NGINX config files
COPY webproxy/nginx.conf /etc/nginx/
COPY webproxy/conf.d /etc/nginx/conf.d

# Bundle app sources
COPY --from=build-env /app/build/web /usr/share/nginx/html



# Port
EXPOSE 80

# Health Check
HEALTHCHECK --interval=15s --timeout=3s CMD curl -f http://localhost || exit 1
