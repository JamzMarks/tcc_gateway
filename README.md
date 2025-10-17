
docker exec -it nginx-lua-gateway sh

apk update && apk add curl

resty -e "local jwt = require 'resty.jwt'; print('JWT OK')"


sudo apt install mkcert libnss3-tools

mkcert -install

mkcert localhost 127.0.0.1

proxy_set_header Host $host;
proxy_pass_request_headers on;
proxy_pass_header Set-Cookie;
