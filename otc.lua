--[[
    OTC Hub v1.0.3
    Main Library
    by Aerlro
]]

local OTC = {}

OTC.Version = "1.0.3"
OTC.Name = "OTC Hub"

--// Changelog: { Tag, Text } - Tag is REMOVED, ADDED, FIXED or CHANGED
OTC.Changelog = {
    ["1.0.3"] = {
        { "ADDED", "New floating-island window design (sidebar, header and content are separate cards)" },
        { "ADDED", "Search button in the header: filters the elements of every tab" },
        { "ADDED", "Image icons for minimize, close and search" },
        { "ADDED", "Version loader: load the latest version or any specific version" },
        { "ADDED", "Changelog popup with [REMOVED] [ADDED] [FIXED] [CHANGED] tags and version switcher" },
        { "ADDED", "OTC:GetVersions(), OTC:CheckForUpdates(), OTC:SetIcons()" },
        { "ADDED", "Window header page title and a draggable sidebar header" },
        { "FIXED", "Theme gradients were never applied (they are working now, with animation)" },
        { "FIXED", "Private theme is now strictly owner-only (removed for everybody else)" },
        { "FIXED", "Input connections of sliders and windows were never disconnected after unload" },
        { "FIXED", "Executing the script twice left the old window open" },
        { "FIXED", "Tab buttons showed an outline even when not selected" },
        { "FIXED", "Dropdown could leak a second render connection" },
        { "FIXED", "GUI now uses gethui() when available" },
        { "CHANGED", "Window is now 680x440 with rounded cards" },
        { "CHANGED", "Logo, title and subtitle moved to the top of the sidebar" },
        { "REMOVED", "Text glyphs used as button icons" }
    },
    ["1.0.2"] = {
        { "ADDED", "Keybind, Color Picker, Progress, Divider, Paragraph and Space elements" },
        { "ADDED", "Window tags, dialogs, notification types" },
        { "ADDED", "Config system: auto-save, auto-load, SaveConfig / LoadConfig" },
        { "ADDED", "6 new themes: Midnight, Ocean, Rose, Mocha, Aurora, Light" },
        { "FIXED", "Toggle key fired twice because the window was registered twice" },
        { "FIXED", "OTC:RegisterTheme did not exist" },
        { "FIXED", "Dropdown did not support Flag" },
        { "CHANGED", "Bigger window, wider sidebar, animated accent line" }
    },
    ["1.0.1"] = {
        { "ADDED", "Halloween loading screen and animated decorations" },
        { "ADDED", "Version badge and animated gradients" },
        { "CHANGED", "Improved unload confirmation and UI animations" },
        { "CHANGED", "Advanced theme system improvements" }
    }
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local Env = (type(getgenv) == "function" and getgenv()) or _G

--// Reference used to download the modules ("main" = latest, or a tag like "v1.0.2").
--// The loader sets Env.OTC_REF for you.
local REF = Env.OTC_REF or "main"
Env.OTC_REF = nil -- only valid for this execution
local REPOSITORY = "Aerlro/OTC-Hub-v1"
local BASE_URL = "https://raw.githubusercontent.com/" .. REPOSITORY .. "/" .. REF .. "/"

OTC.Ref = REF

--// Remove the previous instance if the script is executed again
do
    local Previous = Env.__OTC_HUB

    if type(Previous) == "table" and type(Previous.Destroy) == "function" then
        pcall(function()
            Previous:Destroy()
        end)
    end
end

--// Image icons used by the window (rbxassetid)
OTC.Icons = {
    Minimize = "rbxassetid://123120037399918",
    Close = "rbxassetid://97642116681622",
    Search = "rbxassetid://122340561776969"
}

OTC._Windows = {}
OTC._Themes = {}
OTC._Flags = {}
OTC._FlagObjects = {}
OTC._Connections = {}
OTC._Modules = {}

local function Download(Path)
    local Success, Source = pcall(function()
        return game:HttpGet(BASE_URL .. Path)
    end)

    if not Success then
        return nil, "Failed to download module: " .. Path .. "\n" .. tostring(Source)
    end

    local CompileSuccess, Module = pcall(function()
        return loadstring(Source)
    end)

    if not CompileSuccess or not Module then
        return nil, "Failed to compile module: " .. Path .. "\n" .. tostring(Module)
    end

    local RunSuccess, Result = pcall(Module)

    if not RunSuccess then
        return nil, "Failed to load module: " .. Path .. "\n" .. tostring(Result)
    end

    if Result == nil then
        return nil, "Module returned nil: " .. Path
    end

    return Result
end

local function LoadRawModule(Path)
    local Result, Err = Download(Path)

    if not Result then
        error("[OTC Hub] " .. Err)
    end

    return Result
end

--// Loading Screen
local LoadingModule = LoadRawModule("Core/loading.lua")

local ModulesToLoad = {
    "Core/tab.lua",
    "Core/window.lua",
    "Core/theme.lua",
    "Core/animation.lua",
    "Core/notification.lua",
    "Core/lucide.lua",
    "Core/config.lua",
    "Core/popup.lua",
    "Elements/button.lua",
    "Elements/toggle.lua",
    "Elements/slider.lua",
    "Elements/dropdown.lua",
    "Elements/input.lua",
    "Elements/keybind.lua",
    "Elements/colorpicker.lua",
    "Elements/progress.lua"
}

local Loading = LoadingModule.Create(#ModulesToLoad)

--// Module Loader (with loading screen feedback)
local function LoadModule(Path)
    Loading:Update(Loading.Current, "Loading OTC Hub...", "Downloading " .. Path)

    local Result, Err = Download(Path)

    if not Result then
        Loading:Update(Loading.Current, "Failed to load module", Path)

        task.delay(4, function()
            pcall(function()
                Loading:Destroy()
            end)
        end)

        error("[OTC Hub] " .. Err)
    end

    Loading.Current = Loading.Current + 1
    Loading:Update(Loading.Current, "Module loaded", Path)

    print("[OTC Hub] Loaded:", Path)

    return Result
end

--// Core Modules
local TabModule = LoadModule("Core/tab.lua")
local WindowModule = LoadModule("Core/window.lua")
local ThemeModule = LoadModule("Core/theme.lua")
local AnimationModule = LoadModule("Core/animation.lua")
local NotificationModule = LoadModule("Core/notification.lua")
local LucideModule = LoadModule("Core/lucide.lua")
local ConfigModule = LoadModule("Core/config.lua")
local PopupModule = LoadModule("Core/popup.lua")

--// Themes
OTC._Themes = ThemeModule.BuiltIn
OTC.CurrentTheme = "Default"

function OTC:GetTheme()
    return self._Themes[self.CurrentTheme] or self._Themes.Default
end

function OTC:RegisterTheme(Name, ThemeData)
    return ThemeModule:Register(Name, ThemeData)
end

local function ThemeAllowed(Name)
    if ThemeModule.IsPrivate(Name) and not ThemeModule.IsOwner() then
        return false
    end

    return OTC._Themes[Name] ~= nil
end

function OTC:SetTheme(Name)
    if not ThemeAllowed(Name) then
        warn("[OTC Hub] Theme does not exist:", Name)
        return false
    end

    self.CurrentTheme = Name

    for _, Window in ipairs(self._Windows) do
        if Window.SetTheme then
            Window:SetTheme(Name)
        elseif Window.RefreshTheme then
            Window:RefreshTheme()
        end
    end

    return true
end

function OTC:GetThemes()
    return ThemeModule.List()
end

--// Tween
function OTC:Tween(Object, Time, Properties, Style, Direction)
    if not Object then
        return
    end

    local Info = TweenInfo.new(
        Time or 0.25,
        Style or Enum.EasingStyle.Quint,
        Direction or Enum.EasingDirection.Out
    )

    local Animation = TweenService:Create(Object, Info, Properties)

    Animation:Play()

    return Animation
end

--// Flags
function OTC:SetFlag(Name, Value)
    self._Flags[Name] = Value

    if self._Config then
        self._Config:QueueSave()
    end
end

function OTC:GetFlag(Name)
    return self._Flags[Name]
end

function OTC:RegisterFlag(Name, Object)
    self._FlagObjects[Name] = Object

    if self._Config then
        self._Config:OnRegister(Name, Object)
    end
end

function OTC:GetFlagObject(Name)
    return self._FlagObjects[Name]
end

--// Connections
function OTC:Connect(Connection)
    table.insert(self._Connections, Connection)

    return Connection
end

function OTC:DisconnectAll()
    for _, Connection in ipairs(self._Connections) do
        if Connection and Connection.Disconnect then
            Connection:Disconnect()
        end
    end

    table.clear(self._Connections)
end

--// Core References
OTC._TabModule = TabModule
OTC._WindowModule = WindowModule
OTC._ThemeModule = ThemeModule
OTC._AnimationModule = AnimationModule
OTC._NotificationModule = NotificationModule
OTC._PopupModule = PopupModule
OTC._ConfigModule = ConfigModule

--// Element Modules
OTC._Modules = {
    Button = LoadModule("Elements/button.lua"),
    Toggle = LoadModule("Elements/toggle.lua"),
    Slider = LoadModule("Elements/slider.lua"),
    Dropdown = LoadModule("Elements/dropdown.lua"),
    Input = LoadModule("Elements/input.lua"),
    Keybind = LoadModule("Elements/keybind.lua"),
    ColorPicker = LoadModule("Elements/colorpicker.lua"),
    Progress = LoadModule("Elements/progress.lua")
}

--// Lucide
OTC._Lucide = LucideModule

--// Helpers
local function GetActiveWindow(Preferred)
    if Preferred and not Preferred.Closed then
        return Preferred
    end

    for _, Window in ipairs(OTC._Windows) do
        if Window and not Window.Closed and Window.ScreenGui then
            return Window
        end
    end

    return nil
end

--// Notifications
--  Data = { Title, Content, Duration, Icon, Accent, Type = "Success"|"Warning"|"Error"|"Info" }
function OTC:Notify(Data)
    Data = Data or {}

    local Window = GetActiveWindow(Data.Window)

    if not Window then
        warn("[OTC Hub] No active window for notification")
        return nil
    end

    local Theme = self:GetTheme()

    if Data.Type and not Data.Accent then
        local Key = tostring(Data.Type)
        Key = Key:sub(1, 1):upper() .. Key:sub(2):lower()

        Data.Accent = Theme[Key]

        if not Data.Title then
            Data.Title = Key
        end
    end

    return NotificationModule.Create(Window.ScreenGui, Theme, Data)
end

--// Dialog
function OTC:Dialog(Data)
    local Window = GetActiveWindow(Data and Data.Window)

    if not Window then
        warn("[OTC Hub] No active window for dialog")
        return nil
    end

    return Window:Dialog(Data)
end

--// Config
function OTC:ConfigureSaving(Settings)
    self._Config = ConfigModule.New(self, Settings or {})

    return self._Config
end

local function GetConfig()
    if not OTC._Config then
        OTC:ConfigureSaving({ fileName = "OTC" })
    end

    return OTC._Config
end

function OTC:GetConfigManager()
    return GetConfig()
end

function OTC:SaveConfig(Name)
    return GetConfig():Save(Name)
end

function OTC:LoadConfig(Name)
    return GetConfig():Load(Name)
end

function OTC:ListConfigs()
    return GetConfig():List()
end

function OTC:DeleteConfig(Name)
    return GetConfig():Delete(Name)
end

--// Versions
local function ParseVersion(Version)
    local A, B, C = tostring(Version):match("(%d+)%.(%d+)%.?(%d*)")

    return (tonumber(A) or 0) * 1000000 + (tonumber(B) or 0) * 1000 + (tonumber(C) or 0)
end

function OTC:GetVersions()
    local List = {}

    for Version in pairs(self.Changelog) do
        table.insert(List, Version)
    end

    table.sort(List, function(Left, Right)
        return ParseVersion(Left) > ParseVersion(Right)
    end)

    return List
end

--// Returns latestVersion, isNewer  (nil if the check failed)
function OTC:CheckForUpdates()
    local Success, Result = pcall(function()
        return game:HttpGet(
            "https://raw.githubusercontent.com/" .. REPOSITORY .. "/main/version.txt"
        )
    end)

    if not Success or type(Result) ~= "string" then
        return nil
    end

    local Latest = Result:match("%d+%.%d+%.?%d*")

    if not Latest then
        return nil
    end

    return Latest, ParseVersion(Latest) > ParseVersion(self.Version)
end

--// Change the image icons: OTC:SetIcons({ Close = "rbxassetid://..." }) before CreateWindow
function OTC:SetIcons(Icons)
    for Name, Image in pairs(Icons or {}) do
        self.Icons[Name] = tostring(Image)
    end
end

--// Window
function OTC:CreateWindow(Settings)
    Settings = Settings or {}

    if Settings.Theme then
        if not ThemeAllowed(Settings.Theme) then
            warn("[OTC Hub] Theme does not exist:", Settings.Theme, "| Using Default")
            Settings.Theme = "Default"
        end
    else
        Settings.Theme = self.CurrentTheme
    end

    local Window = WindowModule.Create(Settings, self)

    if not Window then
        error("[OTC Hub] Window creation failed")
    end

    if not table.find(self._Windows, Window) then
        table.insert(self._Windows, Window)
    end

    function Window:CreateTab(TabSettings)
        TabSettings = TabSettings or {}

        return TabModule.Create(self, OTC, TabSettings)
    end

    --// Tags: Tags = { "Beta", { Title = "VIP", Color = Color3 } }
    if type(Settings.Tags) == "table" and Window.CreateTag then
        for _, TagData in ipairs(Settings.Tags) do
            Window:CreateTag(TagData)
        end
    end

    --// Configuration
    local ConfigSettings = Settings.Configuration

    if type(ConfigSettings) == "table" then
        local Manager = self:ConfigureSaving(ConfigSettings)

        if Manager.AutoLoad then
            local SavedTheme = Manager:Preload()

            if SavedTheme and self._Themes[SavedTheme] then
                self:SetTheme(SavedTheme)
            end
        end
    end

    if Settings.CheckUpdates == true then
        task.spawn(function()
            local Latest, IsNewer = self:CheckForUpdates()

            if Latest and IsNewer then
                Window:Notify({
                    Type = "Info",
                    Title = "Update available",
                    Content = "v" .. Latest .. " is out (you are on v" .. self.Version .. ")",
                    Duration = 6
                })
            end
        end)
    end

    return Window
end

--// Destroy everything
function OTC:Destroy()
    for Index = #self._Windows, 1, -1 do
        local Window = self._Windows[Index]

        if Window and Window.Unload then
            pcall(function()
                Window:Unload()
            end)
        end
    end

    table.clear(self._Windows)
    table.clear(self._FlagObjects)

    self:DisconnectAll()
    self._InputInitialized = false
end

function OTC:SetToggleKey(Key)
    for _, Window in ipairs(self._Windows) do
        if Window.SetToggleKey then
            Window:SetToggleKey(Key)
        end
    end
end

--// Input
function OTC:InitializeInput()
    if self._InputInitialized then
        return
    end

    self._InputInitialized = true

    self:Connect(
        UserInputService.InputBegan:Connect(function(Input, GameProcessed)
            if GameProcessed then
                return
            end

            for _, Window in ipairs(self._Windows) do
                if Input.KeyCode == Window.ToggleKey and Window.Toggle then
                    Window:Toggle()
                end
            end
        end)
    )
end

OTC:InitializeInput()

Env.__OTC_HUB = OTC

--// Finish Loading
Loading:Finish()

return OTC
