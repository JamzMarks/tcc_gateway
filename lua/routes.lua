-- local uri = ngx.var.request_uri

-- -- URLs padrão (caso variáveis de ambiente não estejam setadas)
-- local ADMIN_API_URL = os.getenv("ADMIN_API_URL") or "http://host.docker.internal:4000/api/v1/"
-- local DEVICES_API_URL = os.getenv("DEVICES_API_URL") or "http://host.docker.internal:3005/api/v1/"
-- local METRICS_API_URL = os.getenv("METRICS_API_URL") or "http://host.docker.internal:3006/api/v1/"
-- local YOLO_API_URL = os.getenv("YOLO_API_URL_API_URL") or "http://host.docker.internal:7676"


-- local ADMIN_API_DOCS = os.getenv("ADMIN_API_DOCS") or "http://host.docker.internal:4000/docs"
-- local DEVICES_API_DOCS = os.getenv("DEVICES_API_DOCS") or "http://host.docker.internal:3005/docs"
-- local METRICS_API_DOCS = os.getenv("METRICS_API_DOCS") or "http://host.docker.internal:3006/docs"

-- local DEVICES_API_SOCKET = os.getenv("DEVICES_API_DOCS") or "http://host.docker.internal:3005/"
-- local METRICS_API_SOCKET = os.getenv("METRICS_API_DOCS") or "http://host.docker.internal:3006/"

-- local target_base
-- local path = uri

-- -- 🔹 Roteamento principal
-- if uri:match("^/ad") then
--     if uri:match("^/ad/docs") then
--         target_base = ADMIN_API_DOCS
--         path = uri:gsub("^/ad/docs", "")
--     else
--         target_base = ADMIN_API_URL
--         path = uri:gsub("^/ad", "")
--     end

-- elseif uri:match("^/dv") then
--     if uri:match("^/dv/docs") then
--         target_base = DEVICES_API_DOCS
--         path = uri:gsub("^/dv/docs", "")
--     else
--         target_base = DEVICES_API_URL
--         path = uri:gsub("^/dv", "")
--     end

-- elseif uri:match("^/mt") then
--     if uri:match("^/mt/docs") then
--         target_base = METRICS_API_DOCS
--         path = uri:gsub("^/mt/docs", "")
--     else
--         target_base = METRICS_API_URL
--         path = uri:gsub("^/mt", "")
--     end
-- elseif uri:match("^/yolo") then
--     target_base = YOLO_API_URL
--     path = uri:gsub("^/yolo", "")

-- else
--     ngx.status = 404
--     ngx.say("Route not found")
--     return ngx.exit(404)
-- end

-- -- 🔹 Montagem final da rota alvo
-- ngx.var.target = target_base:gsub("/$", "") .. path
-- ngx.log(ngx.ERR, "Roteando para target: ", ngx.var.target)

-- ngx.req.set_header("X-Gateway", "Nginx-Lua")
local uri = ngx.var.request_uri

-- 🔹 Configuração centralizada dos serviços
local services = {
    ad = {
        api    = os.getenv("ADMIN_API_URL")  or "http://host.docker.internal:4000/api/v1/",
        docs   = os.getenv("ADMIN_API_DOCS") or "http://host.docker.internal:4000/docs",
    },
    dv = {
        api    = os.getenv("DEVICES_API_URL")  or "http://host.docker.internal:3005/api/v1/",
        docs   = os.getenv("DEVICES_API_DOCS") or "http://host.docker.internal:3005/docs",
        socket = os.getenv("DEVICES_API_SOCKET") or "http://host.docker.internal:3005",
    },
    mt = {
        api    = os.getenv("METRICS_API_URL")  or "http://host.docker.internal:3006/api/v1/",
        docs   = os.getenv("METRICS_API_DOCS") or "http://host.docker.internal:3006/docs",
        socket = os.getenv("METRICS_API_SOCKET") or "http://host.docker.internal:3006",
    },
    yolo = {
        api    = os.getenv("YOLO_API_URL") or "http://host.docker.internal:7676",
    },
    mock = {
        api    = os.getenv("MOCK_ADAPTER_URL") or "http://host.docker.internal:4006",
    }
}

local target_base
local path = uri

-- 🔹 Loop genérico para roteamento
for prefix, cfg in pairs(services) do
    local pattern = "^/" .. prefix

    if uri:match(pattern) then

        -- /xx/docs
        if uri:match(pattern .. "/docs") and cfg.docs then
            target_base = cfg.docs
            path = uri:gsub(pattern .. "/docs", "")

        -- /xx/socket
        elseif uri:match(pattern .. "/socket") and cfg.socket then
            target_base = cfg.socket
            path = uri:gsub(pattern .. "/socket", "")

        -- /xx/*
        else
            target_base = cfg.api
            path = uri:gsub(pattern, "")
        end
        
        break
    end
end

-- 🔹 Caso nenhuma rota tenha batido
if not target_base then
    ngx.status = 404
    ngx.say("Route not found")
    return ngx.exit(404)
end

-- 🔹 Montagem final
ngx.var.target = target_base:gsub("/$", "") .. path
ngx.log(ngx.ERR, "Roteando para target: ", ngx.var.target)

ngx.req.set_header("X-Gateway", "Nginx-Lua")

