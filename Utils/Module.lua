local _ENV = (getgenv or getrenv or getfenv)()

local Utils = {}
local Settings = {}
local Threads = {}
local Fallback = {}

local Owner = "vita6it"
local Repository = "Xynapse"

local THREAD_HASH = tostring(os.clock() + math.random()) do
    _ENV.__THREAD_HASH = THREAD_HASH
end

local function fetch(file)
    local URL = string.format(
        "https://raw.githubusercontent.com/%s/%s/main/%s",
        Owner, Repository, file
    )

    warn("Fetch : ", file)

    return loadstring(game:HttpGet(URL))()
end

local function AddModule(Name, Module)
    do Utils[Name] = Module()
        return Utils[Name]
    end
end

local UserInputService = game:GetService('UserInputService')
local TeleportService = game:GetService('TeleportService')
local HttpService = game:GetService('HttpService')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId
local JobId = game.JobId

AddModule("Connections", function()
    local Connections = {}
    local Cached = _ENV.Connections or {}

    do
        _ENV.Connections = Cached

        for i = 1, #Cached do
            Cached[i]:Disconnect()
        end

        table.clear(Cached)
    end

    function Connections.Connect(Instance, Callback)
        local Connection = Instance:Connect(Callback)

        table.insert(Cached, Connection)

        return Connection
    end 

    return Connections
end)

AddModule("Configurations", function()
    local Configurations = {}
    local Files = "XYN"

    local makefolder = makefolder or function( ... ) return ... end
    local writefile = writefile or function( ... ) return ... end
    local isfolder = isfolder or function( ... ) return ... end
    local readfile = readfile or function( ... ) return ... end
    local isfile = isfile or function( ... ) return ... end

    Configurations.FullPaths = `{Configurations.Set}/{PlaceId}.json`
    Configurations.Paths = { Files, Configurations.Set }
    Configurations.Files = Files or "XYN"
    Configurations.Set = `{Files}/settings`

    do
        function Configurations:Folder()
            for i = 1, #self.Paths do
                local str = self.Paths[i]

                if not isfolder(str) then
                    makefolder(str)
                end
            end
        end

        function Configurations:Default(index, value)
            if Settings[index] == nil then
                Settings[index] = value
            end
        end

        function Configurations:Save(index, value)
            if index ~= nil then
                Settings[index] = value
            end

            if not isfolder(Files) then
                makefolder(Files)
            end

            if not isfolder(Configurations.Set) then
                makefolder(Configurations.Set)
            end

            writefile(Configurations.FullPaths, HttpService:JSONEncode(Settings))
        end

        function Configurations:Load()
            if not isfile(Configurations.FullPaths) then
                self:Save()
            end

            local Reader = readfile(Configurations.FullPaths) do
                return HttpService:JSONDecode(Reader) 
            end
        end 
    end

    do Configurations:Folder()
        Configurations:Default("Success", true)
    end

    return Configurations
end)

AddModule("Others", function()
    local Others = {}

    Others.Server = (function()
        local Server = {}

        function Server:Reversed(cursor)
            local url = `https://games.roblox.com/v1/games/{PlaceId}/servers/Public?sortOrder=Asc&limit=100`

            if cursor then
                url ..= `&cursor={cursor}`
            end

            return HttpService:JSONDecode(game:HttpGet(url))
        end

        function Server:Rejoin()
            if #Players:GetPlayers() <= 1 then
                LocalPlayer:Kick("\nRejoining");wait()

                return TeleportService:Teleport(PlaceId, LocalPlayer)
            end

            return TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
        end

        function Server:Change()
            local Server, Next

            repeat
                local Servers = Server:Reversed(Next)

                Server = Servers and Servers.data and Servers.data[1]
                Next = Servers and Servers.nextPageCursor
            until Server

            if not Server or not Server.id then return end
            return TeleportService:TeleportToPlaceInstance(PlaceId, Server.id, LocalPlayer)
        end

        function Server:Join(id)
            return TeleportService:TeleportToPlaceInstance(PlaceId, id, LocalPlayer)
        end

        return Server
    end)()

    Others.Optimize = (function()
        local Optimize = {}

        function Optimize:Set3d(value)
            RunService:Set3dRenderingEnabled(if value then false else true)
        end

        function Optimize:Low()
            local Terrain = workspace:FindFirstChildOfClass('Terrain') do
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 0
                game.Lighting.GlobalShadows = false
                game.Lighting.FogEnd = 9e9
                settings().Rendering.QualityLevel = 1
            end
        end

        return Optimize
    end)()

    return Others
end)

AddModule("Parallels", function()
    local Parallels = {}

    local Options = {}
    local clonedEnabled = {}
    local Functions = _ENV.FUNCTIONS or {}
    local FarmFunctions = _ENV.FARM_FUNCTIONS or {}

    local Enabled_Toggle_Debounce = false
    local Enabled_New_Values = {}

    do
        local function ShowErrorMessage(ErrorMessage)
            _ENV.ISLOADED = false
            _ENV.OnFarm = false

            local text = (`error [ { _ENV.RunningOption or "Null" } ] { ErrorMessage }`)

            if _ENV.error_message then
                _ENV.error_message.Text ..= `\n\n{ text }`

                return nil
            end

            local Message = Instance.new("Message", workspace) do
                _ENV.error_message = Message
                Message.Text = text
            end
        end

        local function RunQueue(Options)
            local Success, ErrorMessage = pcall(function()
                local function GetQueue()
                    for _, Option in Options do

                        _ENV.RunningOption = Option.Name

                        local Method = Option.Function()

                        if Method then
                            if type(Method) == "string" then
                                _ENV.RunningMethod = Method
                            end

                            return Method
                        end
                    end

                    _ENV.RunningOption, _ENV.RunningMethod = nil, nil
                end

                while task.wait(0) do
                    if _ENV.__THREAD_HASH ~= THREAD_HASH then
                        _ENV.ISLOADED = false
                        _ENV.RunningOption, _ENV.RunningMethod = nil, nil
                        _ENV.OnFarm = false
                        warn('Break Old Queue')
                        break
                    end
                    
                    _ENV.OnFarm = if GetQueue() then true else false
                end
            end)

            if not Success then
                ShowErrorMessage(ErrorMessage)

                task.delay(3, function()
                    if _ENV.error_message then
                        _ENV.error_message.Text = "Xynapse Shield\nStart Refresh Options ..."

                        task.wait(2)

                        if _ENV.RunningOption and Fallback[_ENV.RunningOption] then
                            Fallback[_ENV.RunningOption]:SetValue(false)
                            _ENV.error_message.Text = "Xynapse Shield\nHas been Disabled " .. _ENV.RunningOption
                        end

                        task.wait(2)

                        _ENV.error_message:Destroy()
                        _ENV.error_message = nil

                        task.spawn(RunQueue, FarmFunctions)
                    end
                end)
            end
        end

        local function UpdateEnabledOptions()
            table.clear(FarmFunctions)

            for index, value in pairs(Enabled_New_Values) do
                clonedEnabled[index] = value or nil
                Enabled_New_Values[index] = nil
            end

            for i = 1, #Functions do
                local funcData = Functions[i]
                if clonedEnabled[funcData.Name] then
                    table.insert(FarmFunctions, funcData)
                end
            end
        end

        local Enabled = _ENV.ENABLED_OPTIONS or setmetatable({}, {
            __newindex = function(self, index, value)
                Enabled_New_Values[index] = value or false

                if not Enabled_Toggle_Debounce then
                    Enabled_Toggle_Debounce = false
                    task.spawn(UpdateEnabledOptions)
                end
            end,
            __index = clonedEnabled
        })

        do
            _ENV.FUNCTIONS = Functions
            _ENV.ENABLED_OPTIONS = Enabled
            _ENV.FARM_FUNCTIONS = FarmFunctions

            if not _ENV.ISLOADED then
                _ENV.ISLOADED = true
                task.spawn(RunQueue, FarmFunctions)
                warn('Run New Queue')
            end
        end

        do table.clear(Functions) end

        local index = {}

        local function While(a, b, c, d)
            while a do
                local t = tick()

                if c then c() end
                if d and d() then break end

                repeat
                    RunService.Heartbeat:Wait()
                until tick() - t >= (b or 0.1)
            end
        end

        local function NewOption(Tag, Function, Time)
            if Time then
                Threads[Tag] = function(Value)
                    While(Value, Time or 0.1, Function, function()
                        return not Value or _ENV.__THREAD_HASH ~= THREAD_HASH
                    end)
                end
            else
                local Data = { 
                    ["Name"] = Tag,
                    ["Function"] = Function
                }

                index[Tag] = Function
                table.insert(Functions, Data)
            end
        end

        Parallels.NewOption = NewOption
        Parallels.Options = function()
            return Enabled, Options
        end
    end

    return Parallels
end)

AddModule("Asset", function()
    local Asset = {}

    local getcustomasset = getcustomasset or function(...) return ... end

    local saved = {}

    function Asset:Download(url, filename)
        local data = game:HttpGet(url)

        writefile(filename, data)

        saved[filename] = data

        return data
    end

    function Asset:Get(filename)
        if saved[filename] then
            return getcustomasset(filename)
        end

        if isfile(filename) then
            saved[filename] = readfile(filename)
            return getcustomasset(filename)
        end

        return 0
    end

    do
        local Constant = "XYNAPSE404.png"
        
        if not isfile(Constant) then
            Asset:Download("https://raw.githubusercontent.com/vita6it/Xynapse/main/Assests/Cutie.png", Constant) 
        end
    end

    return Asset
end)

AddModule("Plugins", function()
    local Plugins = {}
    
    local Configurations = Utils.Configurations
    local Parallels = Utils.Parallels
    local Others = Utils.Others
    local Asset = Utils.Asset
    
    local Enabled, Options = Parallels.Options()
    local Library = fetch('Utils/Library.lua')
    
    function Plugins:Window(Info)
        self['Base'] = Library:Window({
            Title = Info[1],
            Footer = Info[2],
            Logo = Info[3]
        })
        
        return self['Base']
    end
    
    function Plugins:NewPage(Icon)
        return self['Base']:NewPage(Icon)
    end
    
    function Plugins:Section(Page, Info)
        return Page:Section({
            Header = Info[1],
            Light = Info[2] or nil
        })
    end
    
    function Plugins:Button(Section, Info, Callback)
        return Section:Button({
            Title = Info[1],
            Desc = Info[2],
            Type = Info[3] or "Primary",
            Callback = Callback,
        })
    end
    
    function Plugins:Toggle(Section, Info, Flag, Callback)
        local Thread = nil

        Fallback[Flag] = Section:Toggle({
            Title = Info[1],
            Desc = Info[2],
            Value = Settings[Flag],
            Callback = function(value)
                Settings[Flag] = value
                Configurations:Save(Flag, value)

                Enabled[Flag] = value

                if value then
                    Thread = task.spawn(function()
                        if Threads[Flag] then Threads[Flag](Settings[Flag]) end
                    end)
                else
                    if Thread then task.cancel(Thread) end
                end

                if Callback then Callback(value) end
            end
        })

        return Fallback[Flag]
    end

    function Plugins:Slider(Section, Info, Value, Flag, Callback)
        return Section:Slider({
            Title = Info[1],
            Desc = Info[2],
            Min = Value[1],
            Max = Value[2],
            Rounding = Value[3],
            Value = Settings[Flag],
            Callback = function(value)
                Settings[Flag] = value
                Configurations:Save(Flag, value)
                
                if Callback then Callback(value) end
            end
        })
    end
    
    function Plugins:Dropdown(Section, Info, List, Flag, Callback)
        return Section:Dropdown({
            Title = Info,
            Value = Settings[Flag] or "None",
            List = List,
            Callback = function(value)
                Settings[Flag] = value
                Configurations:Save(Flag, value)

                if Callback then Callback(value) end
            end
        })
    end
    
    function Plugins:Input(Section, Info, Flag, Callback)
        return Section:Textbox({
            Title = Info[1],
            Desc = Info[2],
            Text = Settings[Flag] or "None",
            Callback = Callback,
        })
    end
    
    function Plugins:TextLabel(Section, Info)
        return Section:TextLabel({
            Title = Info[1],
            Desc = Info[2],
            Icon = Info[3] or nil,
            Text = Info[4] or nil
        })
    end
    
    function Plugins:Community()
        local Community = Plugins:NewPage(115960025411300) do
            local _1 = Plugins:Section(Community, { "Community", Color3.fromRGB(85, 255, 127) }) do
                local Banner = Asset:Get("XYNAPSE404.png") do
                    Community:Banner(Banner or 133959433736215) 
                end
                
                Plugins:Button(_1, { "Discord", "Join our community" }, function()
                    pcall(setclipboard, "https://discord.com/invite/5f5dQeT4Yx")
                end)
            end
        end
        
        return Community:Navative()
    end
    
    function Plugins:Managers()
        local Managers = Plugins:NewPage(134261589888025) do
            local _1 = Plugins:Section(Managers, { "Server", Color3.fromRGB(85, 255, 127) }) do
                Configurations:Default("JobId", JobId)

                Plugins:Input(_1, { "JobId", "Put the job id." }, 'JobId')

                Plugins:Button(_1, { "Join", "Connect to the server using the provided JobId." }, function()
                    Others.Server:Join(Settings['JobId'])
                end)

                Plugins:Button(_1, { "Change", "Teleport to a different public server instance." }, function()
                    Others.Server:Change()
                end)

                Plugins:Button(_1, { "Rejoin", "Reconnect to the current server instance." }, function()
                    Others.Server:Rejoin()
                end)
            end
            
            local _2 = Plugins:Section(Managers, { "Optimization", Color3.fromRGB(85, 255, 127) }) do
                Plugins:Toggle(_2, { "White Screen", "Disabled 3D Rendering to improve performance" }, "White Screen", function(value)
                    Others.Optimize:Set3d(value)
                end)

                Plugins:Button(_2, { "Fast Mode", "Set graphics quality to low" }, function()
                    Others.Optimize:Low()
                end)
            end
            
            local _3 = Plugins:Section(Managers, { "Configurations", Color3.fromRGB(85, 255, 127) }) do
                local Mobile = if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then true else false
                
                Configurations:Default("Interface Scaler", Mobile and 1 or 1.45)
                
                Plugins:Slider(_3, { "Interface Scaler", "Set interface scale." }, { 1, 2, 2 }, "Interface Scaler", function(value)
                    Plugins.Base:SetScale(value)
                end)
                
                Plugins:Button(_3, { "Remove Worksapce", "Reset save setting file to default value." }, function()
                    local Files = Configurations.FullPaths

                    if Files and isfile(Files) then
                        pcall(delfile, Configurations.FullPaths)
                        warn('Remove Success')
                    else
                        warn('File not found')
                    end
                end)
            end
        end
        
        return Managers
    end
    
    return Plugins
end)

do
    Settings = Utils.Configurations:Load()
    Utils.Settings = Settings
end

return Utils
