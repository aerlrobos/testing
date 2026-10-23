# OTC UI v1.0.6

OTC UI is a thin branding/theme layer over the official WindUI 1.6.66 runtime by Footagesus. Native WindUI elements and behavior are retained.

## Files
- `otc-ui.lua` — loads the official pinned WindUI release, registers the Roman Reigns theme for the authorized user ID, and applies the Roman Reigns theme/background as defaults for that account.
- `TestScript-1.0.6.lua` — test showcase for native WindUI elements and Roman Reigns image/theme.
- `LICENSE-WindUI.txt` — upstream MIT license notice.
- `UPSTREAM.md` — provenance notes.

## Quick start

```lua
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/aerlrobos/testing/main/otc-ui.lua"))()
local Window = WindUI:CreateWindow({
    Title = "OTC UI",
    Author = "Aerlro",
    Folder = "OTC_UI",
    Icon = "rbxassetid://95900623719417",
})
local Tab = Window:Tab({ Title = "Main", Icon = "house" })
Tab:Button({ Title = "Test", Callback = function() print("OTC UI works") end })
```

## Roman Reigns theme and image
The custom theme/background is enabled for user ID `572117566` and uses `rbxassetid://102159565539986`. On that account, `CreateWindow` uses the Roman Reigns theme and image by default unless the caller supplies explicit values. On other accounts, native WindUI themes/defaults remain unchanged.

## Upstream
WindUI is maintained by Footagesus and licensed under MIT:
https://github.com/Footagesus/WindUI

This package loads the official pinned runtime from:
`https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua`

The upstream bundle is fetched at runtime rather than copied into this repository. The image asset must be accessible to Roblox for it to display.
