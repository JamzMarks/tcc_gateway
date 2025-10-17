
docker exec -it nginx-lua-gateway sh

apk update && apk add curl

resty -e "local jwt = require 'resty.jwt'; print('JWT OK')"


sudo apt install mkcert libnss3-tools

mkcert -install

mkcert localhost 127.0.0.1

    proxy_pass $target;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_ssl_verify off;

    proxy_pass_header Set-Cookie;
    proxy_hide_header Set-Cookie;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "DENY" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
