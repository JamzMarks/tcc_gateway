FROM openresty/openresty:1.25.3.1-0-alpine

# Instala dependências básicas
RUN apk add --no-cache bash curl perl openssl nss-tools

# Instala mkcert (para gerar certificados válidos localmente)
RUN curl -L https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64 -o /usr/local/bin/mkcert \
    && chmod +x /usr/local/bin/mkcert

# Cria o diretório dos certificados
RUN mkdir -p /etc/openresty/keys
# Gera CA e certificados para "localhost"
RUN mkdir -p /etc/openresty/certs 

# Instala módulos via OPM
RUN opm get SkyLothar/lua-resty-jwt
RUN opm get openresty/lua-resty-string

# Define os caminhos do Lua
ENV LUA_PATH="/usr/local/openresty/site/lualib/?.lua;/usr/local/openresty/site/lualib/?/init.lua;/usr/local/openresty/lualib/?.lua;/usr/local/openresty/lualib/?/init.lua;;"
ENV LUA_CPATH="/usr/local/openresty/site/lualib/?.so;/usr/local/openresty/lualib/?/init.lua;/usr/local/openresty/lualib/?.so;;"

# Copia configs e scripts
COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./keys/public.pem /etc/openresty/keys/public.pem
COPY ./lua /etc/openresty/lua/
COPY keys/ /etc/openresty/keys/

EXPOSE 80 443

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

