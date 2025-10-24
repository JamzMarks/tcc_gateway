
docker exec -it nginx-lua-gateway sh

apk update && apk add curl
apk add --no-cache perl

resty -e "local jwt = require 'resty.jwt'; print('JWT OK')"
