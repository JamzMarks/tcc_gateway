local uri = ngx.var.request_uri

local administration_url = os.getenv("ADMIN_API_URL") or "https://host.docker.internal:4000/api/v1/"
local devices_url = os.getenv("DEVICES_API_URL") or "http://host.docker.internal:3005/api/v1/"
local metrics_url = os.getenv("METRICS_API_URL") or "http://host.docker.internal:3006/api/v1/"

local target_base
local path = uri

if uri:match("^/ad") then
    target_base = administration_url
    path = uri:gsub("^/ad", "")
elseif uri:match("^/dv") then
    target_base = devices_url
    path = uri:gsub("^/dv", "")
elseif uri:match("^/mt") then
    target_base = metrics_url
    path = uri:gsub("^/mt", "")
else
    ngx.status = 404
    ngx.say("Route not found")
    return ngx.exit(404)
end

ngx.var.target = target_base:gsub("/$", "") .. path
ngx.log(ngx.ERR, "Roteando para target: ", ngx.var.target)

ngx.req.set_header("X-Gateway", "Nginx-Lua")
