--[[
    OTC Hub v1
    Lucide Icon Loader
    by Aerlro
]]

local Lucide = {
    Available = false
}

local SOURCE_URL =
    "https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/557dc709eeba0e783f1455f84693c02430a1420f/source.lua"

local Success, Source = pcall(function()
    return game:HttpGet(SOURCE_URL)
end)

if Success and type(Source) == "string" then
    local CompileSuccess, Loader = pcall(loadstring, Source)

    if CompileSuccess and type(Loader) == "function" then
        local RunSuccess, Library = pcall(Loader)

        if RunSuccess and type(Library) == "table" then
            Lucide.Library = Library
            Lucide.Available =
                type(Library.GetAsset) == "function"
        end
    end
end

function Lucide:GetIcon(Name)
    if not self.Available
        or type(Name) ~= "string" then
        return nil
    end

    Name = Name:lower()
    Name = Name:gsub("_", "-")
    Name = Name:gsub("%s+", "-")

    local Success, Icon = pcall(
        self.Library.GetAsset,
        Name
    )

    if Success and type(Icon) == "table" then
        return Icon
    end

    return nil
end

return Lucide