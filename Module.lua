local _ENV = (getgenv or getrenv or getfenv)()

local Utils = {}
local Settings = {}
local Threads = {}
local Fallback = {}

local Owner = "vita6it"
local Repository = "Antigravity"

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

local Cascade = fetch("Utils/Cascade")

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
    local Files = "Antigravity"

    local makefolder = makefolder or function( ... ) return ... end
    local writefile = writefile or function( ... ) return ... end
    local isfolder = isfolder or function( ... ) return ... end
    local readfile = readfile or function( ... ) return ... end
    local isfile = isfile or function( ... ) return ... end

    Configurations.FullPaths = `{Configurations.Set}/{PlaceId}.json`
    Configurations.Paths = { Files, Configurations.Set }
    Configurations.Files = Files or "Antigravity"
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

                while task.wait(not Settings['Smooth Mode'] and 0 or 1) do
                    _ENV.OnFarm = if GetQueue() then true else false
                end
            end)

            if not Success then
                ShowErrorMessage(ErrorMessage)

                task.delay(3, function()
                    if _ENV.error_message then
                        _ENV.error_message.Text = "- Antigravity Model -\nStart Refresh Options ..."

                        task.wait(2)

                        if _ENV.RunningOption and Fallback[_ENV.RunningOption] then
                            Fallback[_ENV.RunningOption].Value = false
                            _ENV.error_message.Text = "- Antigravity Model -\nHas been Disabled " .. _ENV.RunningOption
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
                        return not Value
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

AddModule("Library", function()
    local Library = {}

    local app = Cascade.New({
        Theme = Cascade.Themes.Light
    })

    local Camera = workspace.CurrentCamera
    local ViewportSize = Camera.ViewportSize
    local Size = UDim2.new(0, ViewportSize.X * 0.8, 0, ViewportSize.Y * 0.95)

    local function Convert(asset)
        local t = typeof(asset)

        if t == "number" then
            return "rbxassetid://" .. asset
        end

        if t == "string" then
            if asset:find("rbxassetid://", 1, true) then
                return asset
            end

            return Cascade.Symbols[asset]
        end

        return asset
    end

    local function ToIndex(options, value)
        if typeof(value) == "table" then
            local indexes = {}

            for _, v in ipairs(value) do
                for i, opt in ipairs(options) do
                    if opt == v then
                        table.insert(indexes, i)
                        break
                    end
                end
            end

            return indexes
        else
            for i, opt in ipairs(options) do
                if opt == value then
                    return i
                end
            end

            return 1
        end
    end

    Library.Window = (function(Info)
        app.Window = app:Window({
            Title = Info[1],
            Subtitle = Info[2],
            Size = Size,
            UIBlur = false
        })

        return app.Window
    end)

    Library.Section = (function(Title)
        return app.Window:Section({ Title = Title })
    end)

    Library.Tab = (function(Section, Info, Select)
        return Section:Tab({
            Title = " " .. Info[1],
            Selected = Select or false,
            Icon = Info[2] and Convert(Info[2]) or nil,
        })
    end)

    Library.NewPage = function(Tab, Info)
        return Tab:PageSection({
            Title = Info[1],
            Subtitle = Info[2] or nil
        }):Form()
    end

    Library.Rows = (function(Forms, Search)
        local Rows = Forms:Row({ SearchIndex = Search })
        local Module = {}

        Module.Right = function()
            return Rows:Right()
        end

        Module.Left = {} do
            function Module.Left:Text(Info)
                local Text = Rows:Left():TitleStack({
                    Title = Info[1],
                    Subtitle = Info[2] or nil,
                })

                function Text:SetText(Main, Sub)
                    if Main then Text.Title = Main end
                    if Sub then Text.Subtitle = Sub end
                end

                return Text
            end

            function Module.Left:Call()
                return Rows:Left()
            end
        end

        return Module
    end)

    Library.TextLabel = function(Forms, Info)
        local Module = Library.Rows(Forms, Info[1]) do
            Module.TextLabel = Module.Left:Text(Info) 
        end

        return Module
    end

    Library.Toggle = (function(Forms, Info, Value, Callback)
        local Module = Library.TextLabel(Forms, Info) do
            local Toggle = Module.Right():Toggle({
                Value = Value,
                ValueChanged = Callback,
            }) 

            Module.Toggle = Toggle
        end

        return Module.Toggle
    end)

    Library.Slider = (function(Forms, Info, Value, Callback, Rounding)
        local Module = Library.TextLabel(Forms, Info) do
            local Text = Library.RightLabel(Module.Right(), "N/A")
            local Slider = Module.Right():Slider({
                Minimum = Value[1],
                Maximum = Value[2],
                Value   = Value[3],
            })

            local Rounding_Value = Rounding and tonumber(Rounding) or 0

            local factor = 10 ^ Rounding_Value

            local function Round(v)
                return math.floor(v * factor + 0.5) / factor
            end

            Slider.ValueChanged = function(self, value)
                local rounded = Round(value)
                Text.Text = tostring(rounded)

                if Callback then Callback(self, rounded) end
            end

            Module.Slider = Slider

            Text.Text = tostring(Round(Slider.Value or 0))
        end

        return Module.Slider
    end)

    Library.Dropdown = function(Forms, Info, Value, Callback)
        local Module = Library.TextLabel(Forms, Info) do
            local options = Value[1] or { "None" }
            local default = Value[3] or 1

            local Dropdown = Module.Right():PopUpButton({
                Options = options,
                Maximum = Value[2] or #options,
                Value = (function()
                    if typeof(default) == "table" then
                        local indexes = {}

                        for _, v in ipairs(default) do
                            table.insert(indexes, ToIndex(options, v))
                        end

                        return indexes
                    else
                        return ToIndex(options, default)
                    end
                end)(),
                ValueChanged = function(self, value)
                    if typeof(value) == "table" then
                        local Collection = {}

                        for _, idx in ipairs(value) do
                            table.insert(Collection, self.Options[idx])
                        end

                        if Callback then Callback(Collection) end
                    else
                        if Callback then Callback(self.Options[value]) end
                    end
                end,
            })

            function Dropdown:Reset()
                if self.Maximum and self.Maximum > 1 then
                    self.Value = {}
                else
                    self.Value = 1
                end
            end

            function Dropdown:Clear()
                for i = #self.Options, 1, -1 do
                    self:Remove(i)
                end
                self.Options = {}
                self:Reset()
            end

            function Dropdown:Refresh(New)
                self:Clear()
                for _, idx in ipairs(New) do
                    self:Option(idx)
                end
                self:Reset()
            end

            function Dropdown:AddRefresh(New)
                return Library.RightButton(Module.Right(), "Refresh", function()
                    self:Refresh(New)
                end)
            end

            Module.Dropdown = Dropdown
        end
        return Module.Dropdown
    end

    Library.RightButton = (function(Right, Label, Callback, State)
        return Right:Button({
            Label = Label,
            State = State or "Primary",
            Pushed = Callback,
        })
    end)

    Library.RightLabel = (function(Right, Text)
        return Right:Label({ Text = Text })
    end)

    Library.Button = (function(Forms, Info, Label, Callback, State)
        local TextLabel = Library.TextLabel(Forms, Info) do
            return Library.RightButton(TextLabel.Right(), Label or "Click", Callback, State)
        end
    end)

    Library.Textfield = (function(Forms, Info, Value, Callback)
        local TextLabel = Library.TextLabel(Forms, Info) do
            local Textfield = TextLabel.Right():TextField({
                Placeholder = " ... ",
                Value = Value or "None",
                ValueChanged = Callback,
            })

            TextLabel.Textfield = Textfield
        end

        return TextLabel.Textfield
    end)

    Library.Symbol = (function(Forms, Info, Icon)
        local TextLabel = Library.TextLabel(Forms, Info) do
            return TextLabel.Right():Symbol({
                Style = "Secondary",
                Image = Convert(Icon),
            })
        end
    end)

    Library.app = app

    return Library
end)

AddModule("Plugins", function()
    local Plugins = {
        NewTabs = true
    }

    local Configurations = Utils.Configurations
    local Parallels = Utils.Parallels
    local Library = Utils.Library
    local Others = Utils.Others


    local Utils = _ENV.Utils or (function(owner, repo, file)
        local URL = string.format(
            "https://raw.githubusercontent.com/%s/%s/main/%s",
            owner, repo, file
        )

        return loadstring(game:HttpGet(URL))()
    end)

    local Enabled, Options = Parallels.Options()

    function Plugins:Window(Info)
        return Library.Window(Info)
    end

    function Plugins:Section(Text)
        return Library.Section(Text)
    end

    function Plugins:MakeTab(Section, Info, Select)
        return Library.Tab(Section, Info, Select)
    end

    function Plugins:NewPage(Tab, Info)
        return Library.NewPage(Tab, Info)
    end

    function Plugins:TextLabel(Forms, Info, Mode)
        if Mode == "r" then
            local TextLabel = Library.TextLabel(Forms, Info) do
                return Library.RightLabel(TextLabel.Right(), Info[3] or "N/A") 
            end
        end

        return Library.TextLabel(Forms, Info).TextLabel
    end

    function Plugins:Symbol(Forms, Info, Icon)
        return Library.Symbol(Forms, Info, Icon)
    end

    function Plugins:Toggle(Forms, Info, Flag, Callback)
        local Thread = nil

        local Toggle = Library.Toggle(Forms, Info, Settings[Flag], function(self, value)
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
        end)

        Fallback[Flag] = Toggle

        return Toggle
    end

    function Plugins:Slider(Forms, Info, Value, Flag, Callback)
        return Library.Slider(Forms, Info, { Value[1], Value[2], Settings[Flag] }, function(self, value)
            Settings[Flag] = value
            Configurations:Save(Flag, value)
            if Callback then Callback(value) end
        end, Value[3])
    end

    function Plugins:Dropdown(Forms, Info, List, Maximum, Flag, Callback)
        return Library.Dropdown(Forms, Info, { List, Maximum, Settings[Flag] }, function(value)
            Settings[Flag] = value
            Configurations:Save(Flag, value)

            if Callback then Callback(value) end
        end)
    end

    function Plugins:Button(Forms, Info, Callback, State)
        return Library.Button(Forms, Info, Info[3] or nil, Callback, State)
    end

    function Plugins:Textfield(Forms, Info, Flag, Callback)
        return Library.Textfield(Forms, Info, Settings[Flag], function(self, value)
            Settings[Flag] = value
            Configurations:Save(Flag, value)

            if Callback then Callback(value) end
        end)
    end

    function Plugins:Dashboard()
        local Section = Plugins:Section("Dashboard")

        local Analysis = Plugins:MakeTab(Section, { "Analysis", 136648496711424 }) do

        end

        local Update = Plugins:MakeTab(Section, { "Tutorial", 84780130894041 }) do

        end

        return Analysis
    end

    function Plugins:SetValue(index, value)
        Library.app.Window[index] = value
    end

    function Plugins:Managers()
        local Section = Plugins:Section("Managers")

        local Server = Plugins:MakeTab(Section, { "Server", 105159951926712 }) do
            local _1 = Plugins:NewPage(Server, { "Server", "Allows users to join and change to target server." }) do

                Configurations:Default("JobId", JobId)

                Plugins:Textfield(_1, { "Enter JobId", "Paste the target server JobId to join a specific server instance."  }, "JobId")

                Plugins:Button(_1, { "Join", "Connect to the server using the provided JobId.", "Join" }, function()
                    Others.Server:Join(Settings['JobId'])
                end)

                Plugins:Button(_1, {  "Copy JobId", "Copy the current server JobId to your clipboard.", "Copy" }, function()
                    pcall(setclipboard, JobId)
                end)

                Plugins:Button(_1, { "Change Server", "Teleport to a different public server instance.", "Change" }, function()
                    Others.Server:Change()
                end)

                Plugins:Button(_1, { "Rejoin Server", "Reconnect to the current server instance.", "Rejoin" }, function()
                    Others.Server:Rejoin()
                end)
            end
        end

        local Optimize = Plugins:MakeTab(Section, { "Optimize", 134831414664674 }) do
            local _1 = Plugins:NewPage(Optimize, { "Optimize", "Allows users to improve performance, efficiency" }) do

                Configurations:Default("White Screen", false)

                Plugins:Toggle(_1, { "Smooth Mode", "Add a delay to the loop execution to slow it down, making the farming smoother and more stable." }, "Smooth Mode")

                Plugins:Toggle(_1, { "White Screen", "Disabled 3D Rendering to improve performance" }, "White Screen", function(value)
                    Others.Optimize:Set3d(value)
                end)

                Plugins:Button(_1, { "Fast Mode", "Set graphics quality to low", "Boost" }, function()
                    Others.Optimize:Low()
                end)
            end
        end

        local Appearance = Plugins:MakeTab(Section, { "Appearance", 92721515638108 }) do
            local _1 = Plugins:NewPage(Appearance, { "Theme", "Customize the overall look and visual style of the system." }) do
                Plugins:Toggle(_1, { "Dark Mode", "Dark Mode is a application appearance setting that uses a dark color palette to provide a comfortable viewing experience tailored for low-light environments." }, "Dark Mode", function(value)
                    Library.app['Theme'] = value and Cascade.Themes.Dark or Cascade.Themes.Light
                end)
            end

            local _2 = Plugins:NewPage(Appearance, { "Input", "Configure input behavior and interaction settings." }) do

                Configurations:Default("Searchable", true)
                Configurations:Default("Draggable", true)
                Configurations:Default("Resizable", true)

                Plugins:Toggle(_2, { "Searchable", "Allows pages to be searched using a text field in the title bar." }, "Searchable", function(value)
                    Plugins:SetValue('Searching', value)
                end)

                Plugins:Toggle(_2, { "Draggable", "Allows users to move the window with a mouse or touch device." }, "Draggable", function(value)
                    Plugins:SetValue('Draggable', value)
                end)

                Plugins:Toggle(_2, { "Resizable", "Allows users to resize the window with a mouse or touch device." }, "Resizable", function(value)
                    Plugins:SetValue('Resizable', value)
                end)
            end

            local _3 = Plugins:NewPage(Appearance, { "Effects", "These effects may be resource intensive across different systems." }) do

                Configurations:Default("Shadow", true)
                Configurations:Default("Acrylic", false)

                Plugins:Toggle(_3, { "Shadow", "Enables a dropshadow effect on the window." }, "Shadow", function(value)
                    Plugins:SetValue('Dropshadow', value)
                end)

                Plugins:Toggle(_3, { "Acrylic", "Enables a UI background blur effect on the window." }, "Acrylic", function(value)
                    Plugins:SetValue('UIBlur', value)
                end)
            end
        end

        local Config = Plugins:MakeTab(Section, { "Configuration", 134261589888025 }) do
            local _1 = Plugins:NewPage(Config, { "Configurations", "Manage and customize system configuration settings." }) do
                local Button = Plugins:Button(_1, { "Remove Worksapce", "Reset save setting file to default value.", "Remove" }, function()
                    local Files = Configurations.FullPaths

                    if Files and isfile(Files) then
                        pcall(delfile, Configurations.FullPaths)
                        warn('Remove Success')
                    else
                        warn('File not found')
                    end
                end, "Destructive")
            end
        end
    end

    return Plugins
end)

do
    Settings = Utils.Configurations:Load()
    Utils.Settings = Settings
end

return Utils
