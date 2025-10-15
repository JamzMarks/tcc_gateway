local uri = ngx.var.request_uri

local administration_url = os.getenv("ADMIN_API_URL") or "https://host.docker.internal:4000/api/v1/"
local devices_url = os.getenv("DEVICES_API_URL") or "http://host.docker.internal:3005/api/v1/"
local metrics_url = os.getenv("METRICS_API_URL") or "http://host.docker.internal:3006/api/v1/"


if uri:match("^/ad") then
    ngx.var.target = administration_url
elseif uri:match("^/dv") then
    ngx.var.target = devices_url
elseif uri:match("^/mt") then
    ngx.var.target = metrics_url
else
    ngx.var.target = administration_url -- fallback
end

ngx.req.set_header("X-Gateway", "Nginx-Lua")
