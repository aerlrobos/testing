-- OTC UI v1.1.0
-- OTC-branded compatibility layer using official WindUI runtime (MIT).
-- Upstream: https://github.com/Footagesus/WindUI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local OTC = {
    Version = "1.1.0",
    RuntimeVersion = "1.6.66",
    RomanImage = "rbxassetid://102159565539986",
    RomanUserIds = {[572117566] = true},
}
function OTC:IsRomanThemeAllowed()
    return LocalPlayer ~= nil and self.RomanUserIds[LocalPlayer.UserId] == true
end
local url = "https://github.com/Footagesus/WindUI/releases/download/" .. OTC.RuntimeVersion .. "/main.lua"
local ok, source = pcall(function() return game:HttpGet(url) end)
if not ok or type(source) ~= "string" or #source == 0 then
    error("[OTC UI] Unable to download runtime. Check HTTP access.")
end
local compile, compileErr = loadstring(source)
if not compile then error("[OTC UI] Runtime compile failed: " .. tostring(compileErr)) end
local UI = compile()
if type(UI) ~= "table" then error("[OTC UI] Runtime did not return a library table.") end

local RomanTheme = {
    Name = "Roman Reigns", Accent = Color3.fromHex("#C6A04A"),
    Dialog = Color3.fromHex("#17130C"), Outline = Color3.fromHex("#8C6A25"),
    Text = Color3.fromHex("#F7F0DF"), Placeholder = Color3.fromHex("#B6A57F"),
    Background = Color3.fromHex("#0B0B0D"), Button = Color3.fromHex("#6D5018"),
    Icon = Color3.fromHex("#E2BE63"), Toggle = Color3.fromHex("#C6A04A"),
    Slider = Color3.fromHex("#C6A04A"), Checkbox = Color3.fromHex("#C6A04A"),
    Primary = Color3.fromHex("#C6A04A"), PanelBackground = Color3.fromHex("#17130C"),
    PanelBackgroundTransparency = 0.16, LabelBackground = Color3.fromHex("#17130C"),
    LabelBackgroundTransparency = 0.1, ElementBackground = Color3.fromHex("#242019"),
    ElementBackgroundTransparency = 0,
}
if OTC:IsRomanThemeAllowed() and type(UI.AddTheme) == "function" then
    pcall(function() UI:AddTheme(RomanTheme) end)
end

-- Keep native window implementation; only add OTC defaults.
local nativeCreateWindow = UI.CreateWindow
if type(nativeCreateWindow) == "function" then
    UI.CreateWindow = function(self, config)
        config = type(config) == "table" and table.clone(config) or {}
        config.Title = config.Title or "OTC UI"
        config.Author = config.Author or "OTC • Aerlro"
        config.Folder = config.Folder or "OTC_UI"
        config.Icon = config.Icon or "door-open"
        config.Size = config.Size or UDim2.fromOffset(760, 560)
        config.MinSize = config.MinSize or Vector2.new(320, 300)
        config.Resizable = config.Resizable ~= false
        config.SideBarWidth = config.SideBarWidth or 190
        config.ScrollBarEnabled = config.ScrollBarEnabled ~= false
        config.ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl
        config.Theme = config.Theme or (OTC:IsRomanThemeAllowed() and "Roman Reigns" or "Dark")
        if OTC:IsRomanThemeAllowed() then
            config.Background = config.Background or OTC.RomanImage
            config.BackgroundImageTransparency = config.BackgroundImageTransparency or 0.72
        elseif config.Theme == "Roman Reigns" then
            config.Theme = "Dark"
        end
        return nativeCreateWindow(self, config)
    end
end

OTC.UI = UI
OTC.CreateWindow = function(config) return UI:CreateWindow(config) end
OTC.Notify = function(config)
    config = type(config) == "table" and table.clone(config) or {}
    config.Title = config.Title or "OTC UI"
    return UI:Notify(config)
end
OTC.Popup = function(config)
    config = type(config) == "table" and table.clone(config) or {}
    config.Title = config.Title or "OTC UI"
    return UI:Popup(config)
end
OTC.SetTheme = function(name)
    if name == "Roman Reigns" and not OTC:IsRomanThemeAllowed() then
        warn("[OTC UI] Roman Reigns theme is not available for this account.")
        return false
    end
    if type(UI.SetTheme) ~= "function" then return false end
    return UI:SetTheme(name) ~= nil
end
OTC.GetThemes = function()
    local themes = type(UI.GetThemes) == "function" and UI:GetThemes() or {}
    if not OTC:IsRomanThemeAllowed() then themes["Roman Reigns"] = nil end
    return themes
end
UI.OTC = OTC
UI.OTCUI = {
    Name = "OTC UI", Version = OTC.Version, Runtime = "WindUI " .. OTC.RuntimeVersion,
    RomanReignsImage = OTC.RomanImage,
    IsRomanReignsAllowed = function() return OTC:IsRomanThemeAllowed() end,
    SetTheme = OTC.SetTheme,
}
pcall(function() UI:SetNotificationLower(true) end)
return UI
