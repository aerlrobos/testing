--[[
    OTC UI v1.0.6
    Native WindUI runtime + OTC defaults and Roman Reigns theme.
    WindUI upstream: https://github.com/Footagesus/WindUI
    Upstream license: MIT (see LICENSE-WindUI.txt)
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local WINDUI_VERSION = "1.6.66"
local WINDUI_RELEASE_URL = "https://github.com/Footagesus/WindUI/releases/download/" .. WINDUI_VERSION .. "/main.lua"
local OTC_VERSION = "1.0.6"
local ROMAN_USER_IDS = {
    [572117566] = true,
}
local ROMAN_IMAGE = "rbxassetid://102159565539986"

local function isRomanThemeAllowed()
    return LocalPlayer ~= nil and ROMAN_USER_IDS[LocalPlayer.UserId] == true
end

local ok, source = pcall(function()
    return game:HttpGet(WINDUI_RELEASE_URL)
end)
if not ok or type(source) ~= "string" or #source == 0 then
    error("[OTC UI] Unable to download WindUI " .. WINDUI_VERSION .. ". Check HTTP access.")
end

local loader, compileError = loadstring(source)
if not loader then
    error("[OTC UI] WindUI compilation failed: " .. tostring(compileError))
end

local WindUI = loader()
if type(WindUI) ~= "table" then
    error("[OTC UI] WindUI did not return its library table.")
end

local RomanTheme = {
    Name = "Roman Reigns",
    Accent = Color3.fromHex("#C6A04A"),
    Dialog = Color3.fromHex("#17130C"),
    Outline = Color3.fromHex("#8C6A25"),
    Text = Color3.fromHex("#F7F0DF"),
    Placeholder = Color3.fromHex("#B6A57F"),
    Background = Color3.fromHex("#0B0B0D"),
    Button = Color3.fromHex("#6D5018"),
    Icon = Color3.fromHex("#E2BE63"),
    Toggle = Color3.fromHex("#C6A04A"),
    Slider = Color3.fromHex("#C6A04A"),
    Checkbox = Color3.fromHex("#C6A04A"),
    Primary = Color3.fromHex("#C6A04A"),
    PanelBackground = Color3.fromHex("#17130C"),
    PanelBackgroundTransparency = 0.18,
    LabelBackground = Color3.fromHex("#17130C"),
    LabelBackgroundTransparency = 0.12,
    ElementBackground = Color3.fromHex("#242019"),
    ElementBackgroundTransparency = 0,
}

if isRomanThemeAllowed() and type(WindUI.AddTheme) == "function" then
    pcall(function()
        WindUI:AddTheme(RomanTheme)
    end)
end

-- Preserve WindUI's native CreateWindow implementation and all native elements.
-- For the authorized account only, provide Roman Reigns theme and image as defaults.
local originalCreateWindow = WindUI.CreateWindow
if type(originalCreateWindow) == "function" then
    WindUI.CreateWindow = function(self, config)
        config = type(config) == "table" and config or {}
        if isRomanThemeAllowed() then
            if config.Theme == nil then
                config.Theme = "Roman Reigns"
            end
            if config.Background == nil then
                config.Background = ROMAN_IMAGE
            end
            if config.BackgroundImageTransparency == nil then
                config.BackgroundImageTransparency = 0.72
            end
        end
        return originalCreateWindow(self, config)
    end
end

WindUI.OTCUI = {
    Name = "OTC UI",
    Version = OTC_VERSION,
    WindUIVersion = WINDUI_VERSION,
    RomanReignsImage = ROMAN_IMAGE,
    IsRomanReignsAllowed = isRomanThemeAllowed,
    IsThemeAvailable = function(themeName)
        if themeName == "Roman Reigns" and not isRomanThemeAllowed() then
            return false
        end
        return WindUI.GetThemes and WindUI:GetThemes()[themeName] ~= nil or false
    end,
    SetTheme = function(themeName)
        if themeName == "Roman Reigns" and not isRomanThemeAllowed() then
            warn("[OTC UI] Roman Reigns theme is private and unavailable for this account.")
            return false
        end
        if type(WindUI.SetTheme) ~= "function" then
            return false
        end
        return WindUI:SetTheme(themeName) ~= nil
    end,
}

return WindUI
