--[[
    OTC Hub v1.0.2 - full example
]]

local OTC = loadstring(game:HttpGet("https://raw.githubusercontent.com/aerlrobos/testing/refs/heads/main/otc.lua"))()

local Window = OTC:CreateWindow({
    Name = "OTC Hub",
    Subtitle = "by Aerlro",
    Theme = "Default",
    ToggleKey = Enum.KeyCode.RightControl,
    Tags = { "Beta", { Title = "VIP", Color = Color3.fromRGB(255, 190, 60) } },
    Configuration = {
        autoSave = true,
        autoLoad = true,
        fileName = "OTC",
        customFolder = "OTC"
    }
})

local Main = Window:CreateTab({ Name = "Main", Icon = "home" })

Main:CreateSection("Combat")

Main:CreateToggle({
    Name = "Auto Farm",
    Description = "Automatically farms resources",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(Value)
        print("Auto Farm:", Value)
    end
})

Main:CreateSlider({
    Name = "Walkspeed",
    Range = { 16, 250 },
    Increment = 1,
    CurrentValue = 16,
    Flag = "Walkspeed",
    Callback = function(Value)
        print("Walkspeed:", Value)
    end
})

Main:CreateDropdown({
    Name = "Target",
    Options = { "Nearest", "Lowest HP", "Highest HP" },
    CurrentOption = "Nearest",
    Flag = "Target",
    Callback = function(Value)
        print("Target:", Value)
    end
})

Main:CreateDivider("Binds & colors")

Main:CreateKeybind({
    Name = "Fly",
    Description = "Press the key to trigger (Backspace clears, Esc cancels)",
    CurrentKeybind = "F",
    Flag = "FlyKey",
    Callback = function(Key)
        OTC:Notify({ Type = "Info", Content = "Fly key pressed (" .. Key .. ")", Duration = 2 })
    end
})

Main:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 80, 80),
    Flag = "EspColor",
    Callback = function(Color)
        print("ESP color:", Color)
    end
})

local Bar = Main:CreateProgress({
    Name = "Download",
    CurrentValue = 0
})

Main:CreateButton({
    Name = "Run progress",
    Callback = function()
        task.spawn(function()
            for i = 0, 100, 5 do
                Bar:SetValue(i)
                task.wait(0.05)
            end

            OTC:Notify({ Type = "Success", Content = "Done!", Duration = 3 })
        end)
    end
})

Main:CreateParagraph({
    Title = "About",
    Content = "Paragraphs resize automatically and wrap long text, so you can write as much as you want."
})

local Settings = Window:CreateTab({ Name = "Settings", Icon = "settings" })

Settings:CreateSection("Interface")

Settings:CreateDropdown({
    Name = "Theme",
    Options = OTC:GetThemes(),
    CurrentOption = OTC.CurrentTheme,
    Callback = function(Value)
        OTC:SetTheme(type(Value) == "table" and Value[1] or Value)
    end
})

Settings:CreateButton({
    Name = "Show dialog",
    Callback = function()
        Window:Dialog({
            Title = "Are you sure?",
            Content = "This is a dialog. Buttons can be Primary, Danger or normal.",
            Buttons = {
                { Title = "Cancel" },
                {
                    Title = "Confirm",
                    Style = "Primary",
                    Callback = function()
                        OTC:Notify({ Type = "Success", Content = "Confirmed" })
                    end
                }
            }
        })
    end
})

Settings:CreateButton({
    Name = "Save config now",
    Callback = function()
        local Ok = OTC:SaveConfig()
        OTC:Notify({ Type = Ok and "Success" or "Error", Content = Ok and "Config saved" or "Could not save config" })
    end
})
