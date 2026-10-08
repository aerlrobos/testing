--[[
    OTC Hub
    Loader (latest or a specific version)
    by Aerlro

    LATEST VERSION:
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Aerlro/OTC-Hub-v1/main/loader.lua"))()

    SPECIFIC VERSION (set it before loading):
        getgenv().OTC_VERSION = "1.0.2"
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Aerlro/OTC-Hub-v1/main/loader.lua"))()

    A specific version is downloaded from the git tag "v<version>" (for example v1.0.2),
    so every version you want to keep available needs a tag / release on GitHub.
]]

local Env = (type(getgenv) == "function" and getgenv()) or _G

local REPOSITORY = "aerlrobos/testing"

local Requested = Env.OTC_VERSION
local Ref

if Requested == nil or tostring(Requested):lower() == "latest" or tostring(Requested) == "main" then
    Ref = "main"
else
    Ref = "v" .. (tostring(Requested):gsub("^[vV]", ""))
end

local Url = "https://raw.githubusercontent.com/" .. REPOSITORY .. "/" .. Ref .. "/otc.lua"

local Success, Source = pcall(function()
    return game:HttpGet(Url)
end)

if not Success or type(Source) ~= "string" or Source == "" then
    error(
        "[OTC Hub] Version '" .. tostring(Requested or "latest") .. "' could not be downloaded (" .. Url .. ")"
    )
end

-- older versions download their modules from "main": point them to the same tag
if Ref ~= "main" then
    Source = Source:gsub("aerlrobos/testing/main/", function()
        return "aerlrobos/testing/" .. Ref .. "/"
    end)
end

Env.OTC_REF = Ref

local Chunk, CompileError = loadstring(Source, "=OTC-Hub-" .. Ref)

if not Chunk then
    error("[OTC Hub] Failed to compile version '" .. tostring(Requested or "latest") .. "': " .. tostring(CompileError))
end

return Chunk()
