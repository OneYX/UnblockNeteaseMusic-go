FROM alpine:3.12

WORKDIR /app
RUN set -x \
    && apk add --no-cache --virtual .cert-deps openssl \
       jq \
       curl \
    && spruce_type="linux-amd64" \
    && download_url=$(curl -s https://api.github.com/repos/cnsilvan/UnblockNeteaseMusic/releases/latest \
    	| jq -r ".assets[] | select(.name | test(\"${spruce_type}\")) | .browser_download_url") \
    && curl -fsSL $download_url -o linux-amd64.zip \
    && unzip linux-amd64.zip \
    && ./createCertificate.sh \
    && rm -f *.zip *.sh \
    && apk del .cert-deps

EXPOSE 80
EXPOSE 443

CMD ./UnblockNeteaseMusic
