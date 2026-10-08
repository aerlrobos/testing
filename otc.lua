--[[
    OTC Hub v1.0.2
    Main Library
    by Aerlro
]]

local OTC = {}

OTC.Version = "1.0.2"
OTC.Name = "OTC Hub"

OTC.Changelog = {
    ["1.0.2"] = {
        "Brand new window design (bigger, wider sidebar, animated accent line)",
        "Smooth open animation",
        "New elements: Keybind, Color Picker, Progress, Divider, Paragraph, Space",
        "Window tags (Window:CreateTag)",
        "Dialog / Popup system (Window:Dialog)",
        "Notification types: Success, Warning, Error, Info",
        "Real config system: auto-save, auto-load, SaveConfig / LoadConfig",
        "Dropdown now supports Flag",
        "6 new themes: Midnight, Ocean, Rose, Mocha, Aurora, Light",
        "Fixed toggle key firing twice (window was registered twice)",
        "Auto-sizing Text element, new Section style"
    },
    ["1.0.1"] = {
        "New Halloween loading screen",
        "Animated Halloween decorations",
        "Improved loading screen fade-out",
        "Advanced Theme System improvements",
        "Animated gradients",
        "Version badge",
        "Improved unload confirmation",
        "Improved UI animations"
    }
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local BASE_URL =
    "https://raw.githubusercontent.com/Aerlro/OTC-Hub-v1/main/"

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
        task.wait(0.25)
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

function OTC:SetTheme(Name)
    if not self._Themes[Name] then
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

--// Window
function OTC:CreateWindow(Settings)
    Settings = Settings or {}

    if Settings.Theme then
        if not self._Themes[Settings.Theme] then
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

--// Finish Loading
Loading:Finish()

return OTC
