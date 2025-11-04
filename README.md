
docker exec -it nginx-lua-gateway sh

apk update && apk add curl
apk add --no-cache perl

resty -e "local jwt = require 'resty.jwt'; print('JWT OK')"

//start
Start-Service -Name Cloudflared
Get-Service -Name Cloudflared | Format-List *
# ou (resumo)
Get-Service -Name Cloudflared
Set-Service -Name Cloudflared -StartupType Automatic
Get-Process -Name cloudflared -ErrorAction SilentlyContinue

// nome do serviço rodando
Get-WmiObject -Class Win32_Service -Filter "Name='Cloudflared'" | Select-Object Name, PathName, StartMode, State | Format-List

 cloudflared tunnel run --url https://localhost:8443 --token eyJhIjoiM2IwMzFiYTZjMWIyYzExNmQzMjFjZTNkNDUwMzZjOTAiLCJ0IjoiOGNiMTIyNDMtM2RkMi00NjU4LWI2NmEtMDFiY2U0YTk1NDFjIiwicyI6Ik9EYzNOR0pqWXpFdE1qRTNNeTAwWmpBNUxXRmxNRFF0TURVNVltTTBNV1ZrTURObCJ9