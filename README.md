# OTC UI v1.1.0

OTC UI v1.1.0 is an OTC-branded compatibility layer over the official WindUI 1.6.66 runtime. It preserves the upstream API and components while adding OTC defaults, helper functions, mobile notification positioning and a private Roman Reigns theme.

## Features
- OTC defaults for window title, author, size, sidebar, toggle key and folder.
- Native upstream tabs, sections, buttons, toggles, sliders, dropdowns, inputs, color pickers, keybinds, paragraphs, dialogs, notifications and popups.
- Roman Reigns black/gold theme and background for user ID `572117566`.
- Showcase with appearance, configuration and mobile-friendly controls.
- Upstream attribution and MIT license retained.

## Loader
```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/aerlrobos/testing/main/otc-ui.lua"))()
local Window = UI:CreateWindow({Title = "OTC UI", Author = "OTC • Aerlro", Folder = "OTC_UI"})
local Tab = Window:Tab({Title = "Main", Icon = "house"})
Tab:Button({Title = "Test", Callback = function() print("OTC works") end})
```

The returned object remains the native library table for compatibility. OTC helpers are available at `UI.OTC` and `UI.OTCUI`.

## Branding limitation
The official runtime is loaded from WindUI's release rather than redistributed as a modified copy. Visible defaults use OTC branding, but internal identifiers and executor storage paths may still retain upstream naming.

Roman Reigns image: `rbxassetid://102159565539986`. Image visibility depends on Roblox asset permissions.
