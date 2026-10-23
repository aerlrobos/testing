-- OTC UI v1.1.0 showcase
local URL = "https://raw.githubusercontent.com/aerlrobos/testing/main/otc-ui.lua"
local UI = loadstring(game:HttpGet(URL))()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local isRoman = player and player.UserId == 572117566
local romanImage = "rbxassetid://102159565539986"

local Window = UI:CreateWindow({
    Title = "OTC UI", Author = "OTC • Aerlro", Folder = "OTC_UI_1_1",
    Icon = "door-open", Theme = isRoman and "Roman Reigns" or "Dark",
    Background = isRoman and romanImage or nil, BackgroundImageTransparency = 0.72,
    Size = UDim2.fromOffset(760, 560), MinSize = Vector2.new(320, 300),
    Resizable = true, SideBarWidth = 190, HideSearchBar = false,
    ScrollBarEnabled = true, ToggleKey = Enum.KeyCode.RightControl,
    OpenButton = {Enabled = true, Title = "Open OTC UI", Draggable = true, OnlyMobile = false, Scale = 0.85},
    User = {Enabled = true, Anonymous = false, Callback = function()
        UI:Notify({Title = "OTC UI", Content = "Hello, " .. (player and player.Name or "Player"), Duration = 3})
    end},
    Topbar = {Height = 44, ButtonsType = "Mac"},
})
pcall(function() Window:Tag({Title = "v1.1.0", Icon = "check-circle", Color = Color3.fromHex("#C6A04A"), Border = true}) end)

local Home = Window:Tab({Title = "Home", Icon = "house"})
local Elements = Window:Tab({Title = "Elements", Icon = "layout-grid"})
local Appearance = Window:Tab({Title = "Appearance", Icon = "palette"})
local Configs = Window:Tab({Title = "Configs", Icon = "folder-cog"})
local About = Window:Tab({Title = "About", Icon = "info"})

Home:Paragraph({Title = "OTC UI v1.1", Desc = isRoman and "Roman Reigns theme active." or "Native WindUI elements with OTC branding.", Image = "rbxassetid://95900623719417", ImageSize = 48, Thumbnail = isRoman and romanImage or nil, ThumbnailSize = 110})
Home:Section({Title = "Quick actions", Desc = "Test notifications and dialogs."})
Home:Button({Title = "Notification", Desc = "Show an OTC notification.", Icon = "bell", Callback = function()
    UI:Notify({Title = "OTC UI", Content = "Notifications are working.", Duration = 3, Icon = "check-circle"})
end})
Home:Button({Title = "Confirmation dialog", Icon = "message-square", Callback = function()
    Window:Dialog({Title = "OTC UI", Icon = "shield-check", Content = "Native dialog test.", Buttons = {
        {Title = "OK", Callback = function() end}, {Title = "Cancel", Callback = function() end},
    }}):Show()
end})

Elements:Section({Title = "Native controls", Desc = "All controls use the upstream implementations."})
Elements:Button({Title = "Button", Desc = "Callback test.", Icon = "mouse-pointer-click", Callback = function() print("[OTC] Button OK") end})
Elements:Toggle({Title = "Toggle", Desc = "Test toggle state.", Flag = "OTC_TestToggle", Value = false, Callback = function(v) print("[OTC] Toggle", v) end})
Elements:Slider({Title = "Slider", Desc = "Value from 0 to 100.", Flag = "OTC_TestSlider", Step = 1, Value = {Min = 0, Max = 100, Default = 35}, Callback = function(v) print("[OTC] Slider", v) end})
Elements:Dropdown({Title = "Dropdown", Desc = "Choose one.", Flag = "OTC_TestDropdown", Values = {"Classic", "Modern", "Compact"}, Value = "Modern", Callback = function(v) print("[OTC] Dropdown", v) end})
Elements:Dropdown({Title = "Multi-select", Desc = "Choose multiple values.", Flag = "OTC_TestMulti", Values = {"Home", "Elements", "Appearance", "Configs"}, Value = {"Home"}, Multi = true, AllowNone = true, Callback = function(v) print("[OTC] Multi-select changed") end})
Elements:Input({Title = "Text input", Desc = "Try typing.", Flag = "OTC_TestInput", Placeholder = "Type here...", Callback = function(v) print("[OTC] Input", v) end})
Elements:Colorpicker({Title = "Accent color", Flag = "OTC_TestColor", Default = Color3.fromHex("#C6A04A"), Callback = function(v) print("[OTC] Color changed") end})
Elements:Keybind({Title = "Keybind", Desc = "Press a key.", Flag = "OTC_TestKeybind", Value = "G", Callback = function(v) print("[OTC] Keybind", v) end})

Appearance:Section({Title = "Themes", Desc = "Roman Reigns theme is private to the authorized account."})
Appearance:Button({Title = "Apply Roman Reigns", Icon = "crown", Callback = function()
    if not isRoman then UI:Notify({Title = "Private theme", Content = "Not enabled for this account.", Duration = 4, Icon = "lock"}); return end
    UI:SetTheme("Roman Reigns")
end})
Appearance:Button({Title = "Apply Dark", Icon = "moon", Callback = function() UI:SetTheme("Dark") end})
Appearance:Button({Title = "Apply Light", Icon = "sun", Callback = function() UI:SetTheme("Light") end})
if isRoman then Appearance:Paragraph({Title = "Tribal Chief", Desc = "Roman Reigns artwork.", Image = romanImage, ImageSize = 180, Thumbnail = romanImage, ThumbnailSize = 120}) end

Configs:Paragraph({Title = "Config support", Desc = "Save/load depends on runtime and executor filesystem support."})
local manager = Window.ConfigManager
if manager then
    local cfg = manager:CreateConfig("OTC_Default")
    Configs:Button({Title = "Save config", Icon = "save", Callback = function()
        local ok = pcall(function() cfg:Save() end)
        UI:Notify({Title = "OTC UI", Content = ok and "Save requested." or "Could not save config.", Duration = 3})
    end})
    Configs:Button({Title = "Load config", Icon = "folder-open", Callback = function()
        local ok = pcall(function() cfg:Load() end)
        UI:Notify({Title = "OTC UI", Content = ok and "Load requested." or "Could not load config.", Duration = 3})
    end})
else
    Configs:Paragraph({Title = "Unavailable", Desc = "ConfigManager is not exposed by this runtime."})
end

About:Paragraph({Title = "OTC UI v1.1.0", Desc = "OTC branding and Roman Reigns customization on the official WindUI runtime. Upstream MIT attribution is retained."})
About:Button({Title = "Runtime info", Icon = "info", Callback = function() UI:Notify({Title = "OTC UI", Content = "OTC UI 1.1.0 • runtime 1.6.66", Duration = 4}) end})
About:Button({Title = "Destroy test window", Icon = "trash-2", Callback = function() Window:Destroy() end})
print("[OTC UI] v1.1.0 showcase loaded.")
