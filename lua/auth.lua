local uri = ngx.var.request_uri
local jwt = require "resty.jwt"
local cjson = require "cjson"

local public_paths = {
    "^/auth/signin",
    "^/auth/refresh",
    "^/auth/logout"
}

for _, pattern in ipairs(public_paths) do
    if uri:match(pattern) then
        return 
    end
end

local f = io.open("/etc/openresty/keys/public.pem", "r")
local public_key = f:read("*a")
f:close()


local token = ngx.var.cookie_access_token

if not token then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say("Unauthorized: Missing token")
    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end


local jwt_obj, err = jwt:verify(public_key, token)

if not jwt_obj or not jwt_obj.verified then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say("Unauthorized: Invalid token", err or "")
    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

ngx.req.set_header("X-User-ID", jwt_obj.payload.sub)
ngx.req.set_header("X-Auth-Verified", "true")
