--[[
    OTC UI v1.0.5
    Aerlro / OTC UI integration layer for WindUI.

    WindUI upstream: https://github.com/Footagesus/WindUI
    Upstream license: MIT (see LICENSE-WindUI.txt)

    The full WindUI runtime is loaded from the official, pinned 1.6.66 release.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local WINDUI_VERSION = "1.6.66"
local WINDUI_RELEASE_URL = "https://github.com/Footagesus/WindUI/releases/download/" .. WINDUI_VERSION .. "/main.lua"
local OTC_VERSION = "1.0.5"
local ROMAN_USER_IDS = {
    [572117566] = true,
}
local ROMAN_IMAGE = "rbxassetid://102159565539986"

local function isRomanThemeAllowed()
    return LocalPlayer ~= nil and ROMAN_USER_IDS[LocalPlayer.UserId] == true
end

local source
local ok, result = pcall(function()
    return game:HttpGet(WINDUI_RELEASE_URL)
end)
if not ok or type(result) ~= "string" or #result == 0 then
    error("[OTC UI] Unable to download WindUI " .. WINDUI_VERSION .. ". Check executor HTTP access and try again.")
end
source = result

local loader, compileError = loadstring(source)
if not loader then
    error("[OTC UI] WindUI loader compilation failed: " .. tostring(compileError))
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

-- Private theme: it is not registered at all for other user IDs.
if isRomanThemeAllowed() and type(WindUI.AddTheme) == "function" then
    pcall(function()
        WindUI:AddTheme(RomanTheme)
    end)
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
        if not WindUI.SetTheme then
            return false
        end
        return WindUI:SetTheme(themeName) ~= nil
    end,
}

return WindUI
