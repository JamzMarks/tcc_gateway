
docker exec -it nginx-lua-gateway sh

apk update && apk add curl

resty -e "local jwt = require 'resty.jwt'; print('JWT OK')"
