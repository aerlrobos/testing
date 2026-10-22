# OTC UI v1.0.5

OTC UI v1.0.5 is an OTC-branded integration layer using the official WindUI runtime by Footagesus. The WindUI runtime is loaded from the official, pinned `1.6.66` release so the complete upstream build and its element implementations remain available.

## Files

- `otc-ui.lua` — loads the complete official WindUI build and registers the OTC UI Roman Reigns theme when allowed. Returns the WindUI library table.
- `TestScript-1.0.5.lua` — showcase/test UI covering buttons, toggles, sliders, dropdowns, multi-dropdowns, inputs, color picker, keybinds, notifications, popups, themes and image content.
- `latest.lua` — loader for the latest OTC UI root build.
- `v1.0.5.lua` — versioned loader for `versions/1.0.5/otc-ui.lua`.
- `LICENSE-WindUI.txt` — MIT license notice from WindUI.
- `UPSTREAM.md` — upstream provenance and license notes.
- `legacy/` — previous OTC Hub 1.0.4 source snapshot retained for reference.

## Quick start

```lua
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Aerlro/OTC-Hub-v1/main/otc-ui.lua"))()
local Window = WindUI:CreateWindow({
    Title = "OTC UI",
    Author = "Aerlro",
    Folder = "OTC_UI",
    Theme = "Dark",
    Icon = "rbxassetid://95900623719417",
})
local Tab = Window:Tab({ Title = "Main", Icon = "house" })
Tab:Button({ Title = "Test", Callback = function() print("OTC UI works") end })
```

## Roman Reigns theme

The custom theme is registered only when `Players.LocalPlayer.UserId == 572117566`. Its artwork asset is `rbxassetid://102159565539986`. Other accounts do not receive the custom theme in `WindUI:GetThemes()`. This is a client-side access restriction, not server-side security.

## Upstream build

The runtime is fetched from the official release URL:
`https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua`

WindUI is a separate open-source project by Footagesus, licensed under MIT. Its original attribution and license are retained. OTC UI does not claim authorship of WindUI.

## Changelog

### 1.0.5
- Renamed product identity from OTC Hub to OTC UI.
- Rebased the runtime on the full official WindUI 1.6.66 release.
- Added an OTC UI adapter and showcase test script.
- Reimplemented the private Roman Reigns theme as a WindUI custom theme.
- Preserved authorized user ID `572117566` and artwork asset `102159565539986`.
- Kept the previous OTC Hub 1.0.4 sources in `legacy/` for reference.

## Important

This package requires access to the official WindUI release URL at runtime. The package includes the OTC UI integration code and prior OTC source snapshot; it does not embed a local copy of WindUI's 1.35 MB generated bundle.
