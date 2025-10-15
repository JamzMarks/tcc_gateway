FROM openresty/openresty:1.25.3.1-0-alpine

# Instala dependências
RUN apk add --no-cache curl openresty-opm

# Instala módulos Lua necessários
RUN opm get SkyLothar/lua-resty-jwt && \
    opm get openresty/lua-resty-string

# Define caminho explícito para módulos Lua
ENV LUA_PATH="/usr/local/openresty/site/lualib/?.lua;/usr/local/openresty/site/lualib/?/init.lua;/usr/local/openresty/lualib/?.lua;/usr/local/openresty/lualib/?/init.lua;;"
ENV LUA_CPATH="/usr/local/openresty/site/lualib/?.so;/usr/local/openresty/lualib/?.so;;"

# Copia tuas configs
COPY ./nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY ./lua /etc/openresty/lua/

# Expõe a porta
EXPOSE 8081

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
