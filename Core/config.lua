--[[
    OTC Hub v1.0.2
    Config Manager (save / load / auto-save)
    by Aerlro
]]

local HttpService = game:GetService("HttpService")

local Config = {}
Config.__index = Config

local function HasFileSystem()
    return type(writefile) == "function"
        and type(readfile) == "function"
        and type(isfile) == "function"
end

local function Encode(Value)
    local Kind = typeof(Value)

    if Kind == "Color3" then
        return { __t = "Color3", r = Value.R, g = Value.G, b = Value.B }
    elseif Kind == "EnumItem" then
        return { __t = "Enum", e = tostring(Value.EnumType), n = Value.Name }
    elseif Kind == "table" then
        local Out = {}
        for Key, Item in pairs(Value) do
            Out[Key] = Encode(Item)
        end
        return Out
    end

    return Value
end

local function Decode(Value)
    if type(Value) ~= "table" then
        return Value
    end

    if Value.__t == "Color3" then
        return Color3.new(Value.r or 0, Value.g or 0, Value.b or 0)
    elseif Value.__t == "Enum" then
        local Success, Item = pcall(function()
            return Enum[Value.e][Value.n]
        end)
        return Success and Item or nil
    end

    local Out = {}
    for Key, Item in pairs(Value) do
        Out[Key] = Decode(Item)
    end
    return Out
end

function Config.New(OTC, Settings)
    Settings = Settings or {}

    local self = setmetatable({}, Config)

    self.OTC = OTC
    self.Folder = Settings.customFolder or Settings.CustomFolder or "OTC"
    self.FileName = Settings.fileName or Settings.FileName or "OTC"
    self.AutoSave = (Settings.autoSave or Settings.AutoSave) == true
    self.AutoLoad = (Settings.autoLoad or Settings.AutoLoad) == true
    self.Supported = HasFileSystem()

    self._Pending = {}
    self._Queued = false
    self._Applying = false

    if self.Supported and type(makefolder) == "function" then
        pcall(function()
            if type(isfolder) ~= "function" or not isfolder(self.Folder) then
                makefolder(self.Folder)
            end
        end)
    end

    return self
end

function Config:Path(Name)
    Name = tostring(Name or self.FileName):gsub("[^%w%-_ ]", "")
    return self.Folder .. "/" .. Name .. ".json"
end

function Config:Exists(Name)
    if not self.Supported then
        return false
    end

    local Success, Result = pcall(isfile, self:Path(Name))
    return Success and Result == true
end

function Config:Collect()
    local Data = {}

    -- keep values of flags whose elements are not created yet
    for Flag, Value in pairs(self._Pending) do
        Data[Flag] = Value
    end

    for Flag, Object in pairs(self.OTC._FlagObjects) do
        if type(Object.GetValue) == "function" and Object.NoSave ~= true then
            local Success, Value = pcall(function()
                return Object:GetValue()
            end)

            if Success and Value ~= nil then
                Data[Flag] = Encode(Value)
            end
        end
    end

    Data.__theme = self.OTC.CurrentTheme

    return Data
end

function Config:Save(Name)
    if not self.Supported then
        return false, "File system is not supported by this executor"
    end

    local Success, Result = pcall(function()
        writefile(
            self:Path(Name),
            HttpService:JSONEncode(self:Collect())
        )
    end)

    if not Success then
        warn("[OTC Hub] Failed to save config:", Result)
        return false, tostring(Result)
    end

    return true
end

function Config:Apply(Data)
    self._Applying = true

    for Flag, Raw in pairs(Data) do
        if Flag == "__theme" then
            if type(Raw) == "string" and self.OTC._Themes[Raw] then
                pcall(function()
                    self.OTC:SetTheme(Raw)
                end)
            end
        else
            local Object = self.OTC._FlagObjects[Flag]

            if Object and type(Object.SetValue) == "function" then
                pcall(function()
                    Object:SetValue(Decode(Raw))
                end)
            else
                self._Pending[Flag] = Raw
            end
        end
    end

    self._Applying = false
end

function Config:Load(Name)
    if not self.Supported then
        return false, "File system is not supported by this executor"
    end

    if not self:Exists(Name) then
        return false, "Config does not exist"
    end

    local Success, Data = pcall(function()
        return HttpService:JSONDecode(readfile(self:Path(Name)))
    end)

    if not Success or type(Data) ~= "table" then
        warn("[OTC Hub] Failed to read config:", Data)
        return false, "Config file is corrupted"
    end

    self:Apply(Data)

    return true
end

-- called when a new element with a Flag is created
function Config:OnRegister(Flag, Object)
    local Raw = self._Pending[Flag]

    if Raw == nil then
        return
    end

    self._Pending[Flag] = nil

    task.defer(function()
        self._Applying = true
        pcall(function()
            Object:SetValue(Decode(Raw))
        end)
        self._Applying = false
    end)
end

function Config:QueueSave()
    if not self.AutoSave or self._Applying or self._Queued then
        return
    end

    self._Queued = true

    task.delay(1.5, function()
        self._Queued = false
        self:Save()
    end)
end

-- reads a config file into the pending list, so values are applied as soon as
-- each element with a matching Flag is created (works even if elements are created late)
function Config:Preload(Name)
    if not self.Supported or not self:Exists(Name) then
        return nil
    end

    local Success, Data = pcall(function()
        return HttpService:JSONDecode(readfile(self:Path(Name)))
    end)

    if not Success or type(Data) ~= "table" then
        return nil
    end

    local SavedTheme = Data.__theme
    Data.__theme = nil

    for Flag, Raw in pairs(Data) do
        self._Pending[Flag] = Raw
    end

    return SavedTheme
end

function Config:List()
    local Out = {}

    if not self.Supported or type(listfiles) ~= "function" then
        return Out
    end

    local Success, Files = pcall(listfiles, self.Folder)

    if Success and type(Files) == "table" then
        for _, Path in ipairs(Files) do
            local Name = tostring(Path):match("([^/\\]+)%.json$")
            if Name then
                table.insert(Out, Name)
            end
        end
    end

    table.sort(Out)

    return Out
end

function Config:Delete(Name)
    if not self.Supported or type(delfile) ~= "function" then
        return false
    end

    return pcall(delfile, self:Path(Name))
end

return Config
