local Library = {}

local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local Players = game:GetService('Players')
local CoreGui = game:GetService('CoreGui')

local Mobile = if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then true else false

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

function Library:Parent()
    if not RunService:IsStudio() then
        return (gethui and gethui()) or CoreGui
    end
    return PlayerGui
end

function Library:Create(Class, Properties)
    local Creations = Instance.new(Class)
    for prop, value in Properties do
        Creations[prop] = value
    end
    return Creations
end

function Library:Draggable(a)
    local Dragging, DragInput, DragStart, StartPosition = nil, nil, nil, nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(a, TweenInfo.new(0.3), {Position = pos}):Play()
    end

    a.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = a.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    a.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

function Library:Button(Parent): TextButton
    return Library:Create("TextButton", {
        Name = "Click",
        Parent = Parent,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.SourceSans,
        Text = "",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 14,
        ZIndex = Parent.ZIndex + 3
    })
end

function Library:Tween(info)
    return TweenService:Create(info.v, TweenInfo.new(info.t, Enum.EasingStyle[info.s], Enum.EasingDirection[info.d]), info.g)
end

function Library:Asset(rbx)
    if typeof(rbx) == 'number' then
        return "rbxassetid://" .. rbx
    end
    if typeof(rbx) == 'string' and rbx:find('rbxassetid://') then
        return rbx
    end
    return rbx
end

function Library:Rows(Parent, Args)
    local Title = Args.Title
    local Desc = Args.Desc

    local Template_1 = Library:Create("Frame", {
        BackgroundTransparency = 1,
        Name = "Template",
        Parent = Parent,
        Size = UDim2.new(1, 0, 0, 40),
        Selectable = false,
    })

    local Scale_1 = Library:Create("Frame", {
        BackgroundTransparency = 1,
        Name = "Scale",
        Parent = Template_1,
        Size = UDim2.new(1, 0, 1, 0),
        Selectable = false,
    })

    local Left_1 = Library:Create("Frame", {
        BackgroundTransparency = 1,
        Name = "Left",
        Parent = Scale_1,
        Size = UDim2.new(1, 0, 1, 0),
        Selectable = false,
    })

    Library:Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        Parent = Left_1,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })

    Library:Create("UIPadding", {
        Parent = Left_1,
        PaddingBottom = UDim.new(0, 1),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 50),
    })

    local Text_1 = Library:Create("Frame", {
        BackgroundTransparency = 1,
        Name = "Text",
        Parent = Left_1,
        Position = UDim2.new(0.07010302692651749, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Selectable = false,
    })

    Library:Create("UIListLayout", {
        Parent = Text_1,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })

    local Title_1 = Library:Create("TextLabel", {
        BackgroundTransparency = 1,
        Name = "Title",
        Parent = Text_1,
        Size = UDim2.new(0, 42, 0, 12),
        Selectable = false,
        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        Text = Title,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local Sub_1
    
    if Desc then
        Sub_1 = Library:Create("TextLabel", {
            BackgroundTransparency = 1,
            Name = "Sub",
            Parent = Text_1,
            Size = UDim2.new(0, 72, 0, 9),
            Selectable = false,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            Text = Desc,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 9,
            TextTransparency = 0.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
        })
    end

    local Right_1 = Library:Create("Frame", {
        BackgroundTransparency = 1,
        Name = "Right",
        Parent = Scale_1,
        Size = UDim2.new(1, 0, 1, 0),
        Selectable = false,
    })

    Library:Create("UIListLayout", {
        Parent = Right_1,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })

    Library:Create("UIPadding", {
        Parent = Right_1,
        PaddingRight = UDim.new(0, 10),
    })

    local Line_1 = Library:Create("Frame", {
        BackgroundTransparency = 0.9700000286102295,
        Name = "Line",
        Parent = Template_1,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 1),
        Selectable = false,
    })

    return {
        Template = Template_1,
        Right = Right_1,
        Line_1 = Line_1,
        Title = Title_1,
        Desc = Sub_1
    }
end

function Library:UpdateLine(Rows)
    for i, row in Rows do
        if row.Line_1 then
            row.Line_1.Visible = (i ~= #Rows)
        end
    end
end

function Library:Window(Args)
    local Title = Args.Title or "Xynapse"
    local Footer = Args.Footer or "Blox Fruit | https://xynapse.lol"
    local Logo = Args.Logo and Library:Asset(Args.Logo) or ""

    local Xynpase_1 = Library:Create("ScreenGui", {
        ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
        IgnoreGuiInset = true,
        Name = "Xynpase",
        Parent = Library:Parent(),
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
    })

    local Background_1 = Library:Create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        Name = "Background",
        Parent = Xynpase_1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 475, 0, 360),
        Selectable = false,
    })

    function Library:IsDropdownOpen()
        for _, v in pairs(Background_1:GetChildren()) do
            if v.Name == "Dropdown" and v.Visible then
                return true
            end
        end
    end

    Library:Create("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Name = "Shadow",
        Parent = Background_1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 120, 1, 120),
        ZIndex = -999,
        Image = "rbxassetid://8992230677",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageContent = Content.fromUri("rbxassetid://8992230677"),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(99, 99, 99, 99),
    })

    Library:Create("UICorner", {
        Parent = Background_1,
    })

    local Header_1 = Library:Create("Frame", {
        BackgroundTransparency = 1,
        Name = "Header",
        Parent = Background_1,
        Size = UDim2.new(1, 0, 0, 50),
        Selectable = false,
    })

    local Left_1 = Library:Create("Frame", {
        BackgroundTransparency = 1,
        Name = "Left",
        Parent = Header_1,
        Size = UDim2.new(1, 0, 1, 0),
        Selectable = false,
    })

    Library:Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        Parent = Left_1,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })

    Library:Create("ImageLabel", {
        BackgroundTransparency = 1,
        Name = "Logo",
        Parent = Left_1,
        Size = UDim2.new(0, 25, 0, 25),
        Image = Logo,
    })

    Library:Create("UIPadding", {
        Parent = Left_1,
        PaddingLeft = UDim.new(0, 15),
    })

    local Text_1 = Library:Create("Frame", {
        BackgroundTransparency = 1,
        Name = "Text",
        Parent = Left_1,
        Position = UDim2.new(0.07010302692651749, 0, 0, 0),
        Size = UDim2.new(-0.17319577932357788, 300, 1, 0),
        Selectable = false,
    })

    Library:Create("UIListLayout", {
        Parent = Text_1,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })

    Library:Create("TextLabel", {
        BackgroundTransparency = 1,
        Name = "Title",
        Parent = Text_1,
        Size = UDim2.new(0, 42, 0, 14),
        Selectable = false,
        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        Text = Title,
        TextColor3 = Color3.fromRGB(234, 234, 234),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    Library:Create("TextLabel", {
        BackgroundTransparency = 1,
        Name = "Sub",
        Parent = Text_1,
        Size = UDim2.new(0, 72, 0, 9),
        Selectable = false,
        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        Text = Footer,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 9,
        TextTransparency = 0.5,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
    })

    local Right_1 = Library:Create("Frame", {
        BackgroundTransparency = 1,
        Name = "Right",
        Parent = Header_1,
        Size = UDim2.new(1, 0, 1, 0),
        Selectable = false,
    })

    Library:Create("UIListLayout", {
        Parent = Right_1,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })

    Library:Create("UIPadding", {
        Parent = Right_1,
        PaddingRight = UDim.new(0, 10),
    })

    local Tabs_1 = Library:Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Name = "Tabs",
        Parent = Right_1,
        Size = UDim2.new(0, 240, 0, 35),
        CanvasSize = UDim2.new(2, 0, 0, 0),
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarImageTransparency = 1,
        BorderSizePixel = 0,
    })

    local UIListLayout_4 = Library:Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        Parent = Tabs_1,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })

    do
        UIListLayout_4:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
            Tabs_1.CanvasSize = UDim2.new(0, UIListLayout_4.AbsoluteContentSize.X + 15, 0, 0)
        end)
    end

    local Inner_1 = Library:Create("Frame", {
        BackgroundTransparency = 1,
        Name = "Inner",
        Parent = Background_1,
        Size = UDim2.new(1, 0, 1, 0),
        Selectable = false,
    })

    Library:Create("UIPadding", {
        Parent = Inner_1,
        PaddingBottom = UDim.new(0, 15),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 50),
    })

    local Window = {}

    function Window:NewPage(Icon)
        local NewTab_1 = Library:Create("Frame", {
            BackgroundTransparency = 1,
            Name = "NewTab",
            Parent = Tabs_1,
            Size = UDim2.new(0, 30, 0, 30),
            ClipsDescendants = true,
            Selectable = false,
        })

        local Asset_1 = Library:Create("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Name = "Asset",
            Parent = NewTab_1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 16, 0, 16),
            Image = Library:Asset(Icon),
            ImageColor3 = Color3.fromRGB(161, 161, 170),
            ImageTransparency = 0.5,
        })

        Library:Create("UICorner", {
            Parent = NewTab_1,
        })

        local ClickSelectTab = Library:Button(NewTab_1)

        local Tab = {} do
            local NewPages_1 = Library:Create("ScrollingFrame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Name = "NewPages",
                Parent = Inner_1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                ElasticBehavior = Enum.ElasticBehavior.Never,
                ScrollBarThickness = 0,
                Visible = false,
                ScrollBarImageTransparency = 1,
                BorderSizePixel = 0,
            })

            local UIListLayout_1 = Library:Create("UIListLayout", {
                Parent = NewPages_1,
                SortOrder = Enum.SortOrder.LayoutOrder,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                Padding = UDim.new(0, 10),
            })

            UIListLayout_1:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                NewPages_1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_1.AbsoluteContentSize.Y + 15)
            end)

            Library:Create("UIPadding", {
                Parent = NewPages_1,
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
            })

            local function OnSelect()
                for _, v in Inner_1:GetChildren() do
                    if v.Name == "NewPages" then
                        v.Visible = false
                    end
                end

                for _, v in Tabs_1:GetChildren() do
                    if v.Name == 'NewTab' then
                        Library:Tween({ v = v, t = 0.5, s = "Exponential", d = "Out", g = { BackgroundTransparency = 1 } }):Play()
                        Library:Tween({ v = v.Asset, t = 0.5, s = "Exponential", d = "Out", g = { ImageTransparency = 0.5 } }):Play()
                    end
                end

                NewPages_1.Position = UDim2.new(0.5, 0, 0.475, 0)
                NewPages_1.Visible = true

                Library:Tween({ v = NewPages_1, t = 0.5, s = "Exponential", d = "Out", g = { Position = UDim2.new(0.5, 0, 0.5, 0) } }):Play()
                Library:Tween({ v = NewTab_1, t = 0.5, s = "Exponential", d = "Out", g = { BackgroundTransparency = 0.95 } }):Play()
                Library:Tween({ v = Asset_1, t = 0.5, s = "Exponential", d = "Out", g = { ImageTransparency = 0.1 } }):Play()
            end

            function Tab:Section(Args)
                local Header = Args.Header or "Header"
                local Light = Args.Light or Color3.fromRGB(108, 108, 108)

                local Section_1 = Library:Create("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                    Name = "Section",
                    Parent = NewPages_1,
                    Size = UDim2.new(1, 0, 0, 0),
                    Selectable = false,
                })

                Library:Create("UICorner", {
                    CornerRadius = UDim.new(0, 5),
                    Parent = Section_1,
                })

                Library:Create("UIListLayout", {
                    Parent = Section_1,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                })

                local Header_1 = Library:Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(27, 27, 27),
                    LayoutOrder = -999,
                    Name = "Header",
                    Parent = Section_1,
                    Size = UDim2.new(1, 0, 0, 30),
                    Selectable = false,
                })

                local Text_1 = Library:Create("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Name = "Text",
                    Parent = Header_1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    Selectable = false,
                })

                Library:Create("UIListLayout", {
                    Parent = Text_1,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                })

                local Title_1 = Library:Create("TextLabel", {
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundTransparency = 1,
                    Name = "Title",
                    Parent = Text_1,
                    Size = UDim2.new(1, -20, 1, -4),
                    Selectable = false,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                    Text = Header,
                    TextColor3 = Color3.fromRGB(234, 234, 234),
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local Light_1 = Library:Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Light,
                    Name = "Light",
                    Parent = Title_1,
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 9, 0, 9),
                    Selectable = false,
                })

                Library:Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = Light_1,
                })

                Library:Create("UIStroke", {
                    Thickness = 0.5,
                    Transparency = 0.5,
                    Parent = Light_1,
                })

                Library:Create("UICorner", {
                    CornerRadius = UDim.new(0, 5),
                    Parent = Header_1,
                })

                Library:Create("Frame", {
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundColor3 = Color3.fromRGB(27, 27, 27),
                    Name = "Squire",
                    Parent = Header_1,
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 4),
                    BorderSizePixel = 0,
                    Selectable = false,
                })

                Library:Create("UIStroke", {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 0.75,
                    Transparency = 0.949999988079071,
                    Parent = Section_1,
                })

                local Section = {}
                local Rows = {}

                function Section:TextLabel(Info)
                    local Title = Info.Title
                    local Desc = Info.Desc
                    local Icon = Info.Icon
                    local Text = Info.Text

                    local Template = Library:Rows(Section_1, { Title = Title, Desc = Desc })
                    table.insert(Rows, Template)
                    Library:UpdateLine(Rows)

                    if Icon then
                        Library:Create("ImageLabel", {
                            BackgroundTransparency = 1,
                            Name = "Asset",
                            Parent = Template.Right,
                            Size = UDim2.new(0, 16, 0, 16),
                            Image = Library:Asset(Icon),
                            ImageTransparency = 0.5,
                            LayoutOrder = 999,
                        })
                    end

                    if Text then
                        local Text_1 = Library:Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Name = "Text",
                            Parent = Template.Right,
                            Size = UDim2.new(0, 72, 0, 9),
                            Selectable = false,
                            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                            RichText = true,
                            Text = "N/A",
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 11,
                            TextTransparency = 0.5,
                            TextXAlignment = Enum.TextXAlignment.Right,
                            TextYAlignment = Enum.TextYAlignment.Top,
                        })

                        function Template:Text(text)
                            Text_1.Text = text
                        end
                    end

                    if Text and Icon then
                        Template.Right.UIListLayout.Padding = UDim.new(0, 10)
                    end

                    return Template
                end

                function Section:Toggle(Info)
                    local Title = Info.Title
                    local Desc = Info.Desc
                    local Value = Info.Value
                    local Callback = Info.Callback

                    local Template = Library:Rows(Section_1, { Title = Title, Desc = Desc })
                    table.insert(Rows, Template)
                    Library:UpdateLine(Rows)

                    do
                        local Toggle_1 = Library:Create("Frame", {
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            Name = "Toggle",
                            Parent = Template.Right,
                            Size = UDim2.new(0, 40, 0, 22),
                            Selectable = false,
                        })

                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(1, 0),
                            Parent = Toggle_1,
                        })

                        Library:Create("UIStroke", {
                            Thickness = 0.5,
                            Transparency = 0.5,
                            Parent = Toggle_1,
                            BorderStrokePosition = Enum.BorderStrokePosition.Outer,
                        })

                        Library:Create("UIStroke", {
                            Color = Color3.fromRGB(55, 55, 55),
                            Thickness = 0.5,
                            Transparency = 0.5,
                            Parent = Toggle_1,
                            BorderStrokePosition = Enum.BorderStrokePosition.Inner,
                        })

                        local Onder_1 = Library:Create("Frame", {
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundColor3 = Color3.fromRGB(55, 55, 55),
                            BackgroundTransparency = 0.5,
                            Name = "Onder",
                            Parent = Toggle_1,
                            Position = UDim2.new(0, 5, 0.5, 0),
                            Size = UDim2.new(0, 13, 0, 13),
                            Selectable = false,
                        })

                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(1, 0),
                            Parent = Onder_1,
                        })

                        local function OnChanged(value)
                            if value then
                                Onder_1.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                                Toggle_1.BackgroundColor3 = Color3.fromRGB(234, 234, 234)
                                Library:Tween({ v = Onder_1, t = 0.5, s = "Exponential", d = "Out", g = { BackgroundTransparency = 0 } }):Play()
                                Library:Tween({ v = Onder_1, t = 0.5, s = "Exponential", d = "Out", g = { Position = UDim2.new(0, 23, 0.5, 0) } }):Play()
                                Callback(Value)
                            else
                                Onder_1.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                                Toggle_1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                                Library:Tween({ v = Onder_1, t = 0.5, s = "Exponential", d = "Out", g = { BackgroundTransparency = 0.5 } }):Play()
                                Library:Tween({ v = Onder_1, t = 0.5, s = "Exponential", d = "Out", g = { Position = UDim2.new(0, 5, 0.5, 0) } }):Play()
                                Callback(Value)
                            end
                        end

                        local function Init()
                            if Library:IsDropdownOpen() then return end
                            Value = not Value
                            OnChanged(Value)
                        end

                        function Template:SetValue(value)
                            Value = value
                            OnChanged(Value)
                        end

                        local Click = Library:Button(Template.Template)
                        Click.MouseButton1Click:Connect(Init)
                        OnChanged(Value)
                    end

                    return Template
                end

                function Section:Button(Info)
                    local Title = Info.Title
                    local Desc = Info.Desc
                    local Type = Info.Type
                    local Callback = Info.Callback

                    local Template = Library:Rows(Section_1, { Title = Title, Desc = Desc })

                    do
                        local Button_1
                        if Type == "Primary" then
                            Button_1 = Library:Create("Frame", {
                                BackgroundColor3 = Color3.fromRGB(234, 234, 234),
                                Name = "Button",
                                Parent = Template.Right,
                                Size = UDim2.new(0, 60, 0, 20),
                                Selectable = false,
                            })

                            Library:Create("UICorner", {
                                CornerRadius = UDim.new(1, 0),
                                Parent = Button_1,
                            })

                            Library:Create("TextLabel", {
                                BackgroundTransparency = 1,
                                Name = "Title",
                                Parent = Button_1,
                                Size = UDim2.new(1, 0, 1, 0),
                                Selectable = false,
                                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                                Text = "Click",
                                TextSize = 10,
                            })

                            Library:Create("UIStroke", {
                                Thickness = 0.5,
                                Transparency = 0.5,
                                Parent = Button_1,
                                BorderStrokePosition = Enum.BorderStrokePosition.Outer,
                            })
                        else
                            Button_1 = Library:Create("Frame", {
                                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                                Name = "Button",
                                Parent = Template.Right,
                                Size = UDim2.new(0, 60, 0, 20),
                                Selectable = false,
                            })

                            Library:Create("UICorner", {
                                CornerRadius = UDim.new(1, 0),
                                Parent = Button_1,
                            })

                            Library:Create("UIStroke", {
                                Thickness = 0.5,
                                Transparency = 0.5,
                                Parent = Button_1,
                                BorderStrokePosition = Enum.BorderStrokePosition.Outer,
                            })

                            Library:Create("UIStroke", {
                                Color = Color3.fromRGB(55, 55, 55),
                                Thickness = 0.5,
                                Transparency = 0.5,
                                Parent = Button_1,
                                BorderStrokePosition = Enum.BorderStrokePosition.Inner,
                            })

                            Library:Create("TextLabel", {
                                BackgroundTransparency = 1,
                                Name = "Title",
                                Parent = Button_1,
                                Size = UDim2.new(1, 0, 1, 0),
                                Selectable = false,
                                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                                Text = "Click",
                                TextColor3 = Color3.fromRGB(234, 234, 234),
                                TextSize = 10,
                                TextStrokeTransparency = 0.6499999761581421,
                            })
                        end

                        local Click = Library:Button(Button_1)
                        Click.MouseButton1Click:Connect(function()
                            if Library:IsDropdownOpen() then return end
                            if Callback then Callback() end
                            Button_1.Title.TextSize = 12
                            task.delay(0.12, function()
                                Button_1.Title.TextSize = 10
                            end)
                        end)
                    end

                    table.insert(Rows, Template)
                    Library:UpdateLine(Rows)

                    return Template
                end

                function Section:Textbox(Info)
                    local Title = Info.Title
                    local Desc = Info.Desc
                    local Text = Info.Text
                    local Callback = Info.Callback

                    local Template = Library:Rows(Section_1, { Title = Title, Desc = Desc })

                    do
                        local Textbox_1 = Library:Create("Frame", {
                            BackgroundTransparency = 0.9800000190734863,
                            Name = "Textbox",
                            Parent = Template.Right,
                            Size = UDim2.new(0, 100, 0, 20),
                            Selectable = false,
                        })

                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(1, 0),
                            Parent = Textbox_1,
                        })

                        Library:Create("UIStroke", {
                            Color = Color3.fromRGB(55, 55, 55),
                            Thickness = 0.5,
                            Parent = Textbox_1,
                            BorderStrokePosition = Enum.BorderStrokePosition.Inner,
                        })

                        Library:Create("UIStroke", {
                            Thickness = 0.5,
                            Parent = Textbox_1,
                            BorderStrokePosition = Enum.BorderStrokePosition.Outer,
                        })

                        local TextBox_1 = Library:Create("TextBox", {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundTransparency = 1,
                            Parent = Textbox_1,
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(1, -20, 1, 0),
                            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                            PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
                            PlaceholderText = "...",
                            Text = tostring(Text),
                            TextColor3 = Color3.fromRGB(150, 150, 150),
                            TextSize = 10,
                            TextTruncate = Enum.TextTruncate.AtEnd,
                            TextXAlignment = Enum.TextXAlignment.Right,
                        })

                        TextBox_1.FocusLost:Connect(function()
                            Text = TextBox_1.Text
                            if Callback then Callback(Text) end
                        end)
                    end

                    table.insert(Rows, Template)
                    Library:UpdateLine(Rows)

                    return Template
                end

                function Section:Slider(Info)
                    local Title = Info.Title
                    local Desc = Info.Desc
                    local Min = Info.Min or 1
                    local Max = Info.Max or 100
                    local Rounding = Info.Rounding or 0
                    local Value = Info.Value or Min
                    local Callback = Info.Callback

                    local Template = Library:Rows(Section_1, { Title = Title, Desc = Desc })
                    Template.Right.UIListLayout.Padding = UDim.new(0, 6)

                    do
                        local ScaleSlider_1 = Library:Create("Frame", {
                            BackgroundTransparency = 1,
                            LayoutOrder = 100,
                            Name = "ScaleSlider",
                            Parent = Template.Right,
                            Size = UDim2.new(0, 160, 1, 0),
                            Selectable = false,
                        })

                        local Slider_1 = Library:Create("Frame", {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundColor3 = Color3.fromRGB(16, 16, 16),
                            LayoutOrder = 999,
                            Name = "Slider",
                            Parent = ScaleSlider_1,
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(0, 150, 0, 3),
                            Selectable = false,
                        })

                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(1, 0),
                            Parent = Slider_1,
                        })

                        local Value_1 = Library:Create("Frame", {
                            BackgroundColor3 = Color3.fromRGB(234, 234, 234),
                            Name = "Value",
                            Parent = Slider_1,
                            Size = UDim2.new(0.4609929025173187, 0, 1, 0),
                            Selectable = false,
                        })

                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(1, 0),
                            Parent = Value_1,
                        })

                        local Circle_1 = Library:Create("Frame", {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                            Name = "Circle",
                            Parent = Value_1,
                            Position = UDim2.new(1, 0, 0.5, 0),
                            Size = UDim2.new(0, 15, 0, 15),
                            Selectable = false,
                        })

                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(1, 0),
                            Parent = Circle_1,
                        })

                        local White_1 = Library:Create("Frame", {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundColor3 = Color3.fromRGB(234, 234, 234),
                            Name = "White",
                            Parent = Circle_1,
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(0.800000011920929, 0, 0.800000011920929, 0),
                            Selectable = false,
                        })

                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(1, 0),
                            Parent = White_1,
                        })

                        Library:Create("UIStroke", {
                            Color = Color3.fromRGB(22, 22, 22),
                            Thickness = 1.5,
                            Parent = Circle_1,
                        })

                        local TextValue_1 = Library:Create("TextBox", {
                            BackgroundTransparency = 1,
                            LayoutOrder = -1,
                            Name = "TextValue",
                            Parent = Template.Right,
                            Size = UDim2.new(0, 30, 0, 20),
                            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                            PlaceholderColor3 = Color3.fromRGB(128, 128, 128),
                            Text = tostring(Value),
                            TextColor3 = Color3.fromRGB(100, 100, 100),
                            TextSize = 10,
                            TextTruncate = Enum.TextTruncate.AtEnd,
                            TextXAlignment = Enum.TextXAlignment.Right,
                        })

                        local Slide = Library:Button(ScaleSlider_1)
                        local dragging = false

                        local function Round(n, decimals)
                            local factor = 10 ^ decimals
                            return math.floor(n * factor + 0.5) / factor
                        end

                        local function UpdateSlider(val)
                            val = math.clamp(val, Min, Max)
                            val = Round(val, Rounding)
                            local ratio = (val - Min) / (Max - Min)
                            Library:Tween({ v = Value_1, t = 0.1, s = "Linear", d = "Out", g = { Size = UDim2.new(ratio, 0, 1, 0) } }):Play()
                            TextValue_1.Text = tostring(val)
                            Callback(val)
                            return val
                        end

                        local function GetValueFromInput(input)
                            local absX = Slider_1.AbsolutePosition.X
                            local absW = Slider_1.AbsoluteSize.X
                            local ratio = math.clamp((input.Position.X - absX) / absW, 0, 1)
                            return ratio * (Max - Min) + Min
                        end

                        Slide.InputBegan:Connect(function(input)
                            if Library:IsDropdownOpen() then return end
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                dragging = true
                                UpdateSlider(GetValueFromInput(input))
                            end
                        end)

                        Slide.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                dragging = false
                            end
                        end)

                        UserInputService.InputChanged:Connect(function(input)
                            if Library:IsDropdownOpen() then return end
                            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                                UpdateSlider(GetValueFromInput(input))
                            end
                        end)

                        TextValue_1.FocusLost:Connect(function()
                            local val = tonumber(TextValue_1.Text) or Value
                            Value = UpdateSlider(val)
                        end)

                        UpdateSlider(Value)
                    end

                    table.insert(Rows, Template)
                    Library:UpdateLine(Rows)

                    return Template
                end

                function Section:Dropdown(Info)
                    local Title = Info.Title
                    local List = Info.List or {}
                    local Value = Info.Value or "N/A"
                    local IsMulti = typeof(Value) == 'table' and true or false
                    local Callback = Info.Callback

                    local Template = Library:Rows(Section_1, { Title = Title, Desc = "N/A" })
                    local Description = Template.Desc
                    local ClickOpen = Library:Button(Template.Template)

                    do
                        Library:Create("ImageLabel", {
                            BackgroundTransparency = 1,
                            Name = "Asset",
                            Parent = Template.Right,
                            Size = UDim2.new(0, 16, 0, 16),
                            Image = Library:Asset(132291592681506),
                            ImageTransparency = 0.5,
                            LayoutOrder = 999,
                        })
                    end

                    do
                        local Dropdown_1 = Library:Create("Frame", {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                            Name = "Dropdown",
                            Parent = Background_1,
                            Position = UDim2.new(0.5, 0, 0.3, 0),
                            Size = UDim2.new(0, 250, 0, 250),
                            Visible = false,
                            Selectable = false,
                        })

                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(0, 5),
                            Parent = Dropdown_1,
                        })

                        Library:Create("UIListLayout", {
                            Parent = Dropdown_1,
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        })

                        Library:Create("UIStroke", {
                            Color = Color3.fromRGB(255, 255, 255),
                            Transparency = 0.95,
                            Parent = Dropdown_1,
                            BorderStrokePosition = Enum.BorderStrokePosition.Inner,
                        })

                        local Header_1 = Library:Create("Frame", {
                            BackgroundColor3 = Color3.fromRGB(27, 27, 27),
                            LayoutOrder = -999,
                            Name = "Header",
                            Parent = Dropdown_1,
                            Size = UDim2.new(1, 0, 0, 30),
                            Selectable = false,
                        })

                        local Text_1 = Library:Create("Frame", {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundTransparency = 1,
                            Name = "Text",
                            Parent = Header_1,
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(1, 0, 1, 0),
                            Selectable = false,
                        })

                        Library:Create("UIListLayout", {
                            Parent = Text_1,
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                            VerticalAlignment = Enum.VerticalAlignment.Center,
                        })

                        Library:Create("TextLabel", {
                            AnchorPoint = Vector2.new(0.5, 0),
                            BackgroundTransparency = 1,
                            Name = "Title",
                            Parent = Text_1,
                            Size = UDim2.new(1, -20, 1, -4),
                            Selectable = false,
                            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                            Text = Title,
                            TextColor3 = Color3.fromRGB(200, 200, 200),
                            TextSize = 13,
                            TextXAlignment = Enum.TextXAlignment.Left,
                        })

                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(0, 5),
                            Parent = Header_1,
                        })

                        Library:Create("Frame", {
                            AnchorPoint = Vector2.new(0, 1),
                            BackgroundColor3 = Color3.fromRGB(27, 27, 27),
                            Name = "Squire",
                            Parent = Header_1,
                            Position = UDim2.new(0, 0, 1, 0),
                            Size = UDim2.new(1, 0, 0, 4),
                            Selectable = false,
                            BorderSizePixel = 0,
                        })

                        local Front_1 = Library:Create("Frame", {
                            AnchorPoint = Vector2.new(1, 0.5),
                            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                            Name = "Front",
                            Parent = Header_1,
                            Position = UDim2.new(1, -5, 0.5, 0),
                            Size = UDim2.new(0, 110, 1, -10),
                            Selectable = false,
                        })

                        Library:Create("UICorner", {
                            CornerRadius = UDim.new(0, 4),
                            Parent = Front_1,
                        })

                        local Search_1 = Library:Create("TextBox", {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundTransparency = 1,
                            Name = "Search",
                            Parent = Front_1,
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            Size = UDim2.new(1, -20, 1, 0),
                            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                            PlaceholderColor3 = Color3.fromRGB(55, 55, 55),
                            PlaceholderText = "Search",
                            Text = "",
                            TextColor3 = Color3.fromRGB(100, 100, 100),
                            TextSize = 11,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            TextTruncate = Enum.TextTruncate.AtEnd,
                        })

                        Library:Create("UIStroke", {
                            Thickness = 0.44999998807907104,
                            Transparency = 0.5,
                            Parent = Dropdown_1,
                            BorderStrokePosition = Enum.BorderStrokePosition.Outer,
                        })

                        local Scrolling_1 = Library:Create("ScrollingFrame", {
                            BackgroundTransparency = 1,
                            Name = "Scrolling",
                            Parent = Dropdown_1,
                            Size = UDim2.new(1, 0, 1, -35),
                            ScrollBarImageTransparency = 1,
                            ScrollBarThickness = 0,
                        })

                        local UIListLayout_3 = Library:Create("UIListLayout", {
                            Padding = UDim.new(0, 3),
                            Parent = Scrolling_1,
                            SortOrder = Enum.SortOrder.LayoutOrder,
                            HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        })

                        UIListLayout_3:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                            Scrolling_1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_3.AbsoluteContentSize.Y + 15)
                        end)

                        Library:Create("UIPadding", {
                            Parent = Scrolling_1,
                            PaddingBottom = UDim.new(0, 4),
                            PaddingLeft = UDim.new(0, 5),
                            PaddingRight = UDim.new(0, 5),
                            PaddingTop = UDim.new(0, 4),
                        })

                        local function GetText()
                            if IsMulti then
                                return table.concat(Value, ", ")
                            end
                            return tostring(Value)
                        end

                        Description.Text = GetText()

                        local selectedValues = {}
                        local selectedOrder = 0

                        local function isValueInTable(val, tbl)
                            if type(tbl) ~= "table" then return false end
                            for _, v in pairs(tbl) do
                                if v == val then return true end
                            end
                            return false
                        end

                        local function Settext()
                            Description.Text = GetText()
                        end

                        local isOpen = false

                        UserInputService.InputBegan:Connect(function(A)
                            if not isOpen then return end
                            local mouse = LocalPlayer:GetMouse()
                            local mx, my = mouse.X, mouse.Y
                            local DBP, DBS = Dropdown_1.AbsolutePosition, Dropdown_1.AbsoluteSize
                            if A.UserInputType == Enum.UserInputType.MouseButton1 or A.UserInputType == Enum.UserInputType.Touch then
                                if not (mx >= DBP.X and mx <= DBP.X + DBS.X and my >= DBP.Y and my <= DBP.Y + DBS.Y) then
                                    isOpen = false
                                    Dropdown_1.Visible = false
                                    Dropdown_1.Position = UDim2.new(0.5, 0, 0.3, 0)
                                end
                            end
                        end)

                        ClickOpen.MouseButton1Click:Connect(function()
                            if Library:IsDropdownOpen() then return end
                            isOpen = not isOpen
                            if isOpen then
                                Dropdown_1.Visible = true
                                Library:Tween({ v = Dropdown_1, t = 0.3, s = "Back", d = "Out", g = { Position = UDim2.new(0.5, 0, 0.5, 0) } }):Play()
                            else
                                Dropdown_1.Visible = false
                                Dropdown_1.Position = UDim2.new(0.5, 0, 0.3, 0)
                            end
                        end)

                        function Template:Clear(a)
                            for _, v in ipairs(Scrolling_1:GetChildren()) do
                                if v:IsA("Frame") then
                                    local shouldClear = a == nil or (type(a) == "string" and v.Title.Text == a) or (type(a) == "table" and isValueInTable(v.Title.Text, a))
                                    if shouldClear then v:Destroy() end
                                end
                            end
                            if a == nil then
                                Value = nil
                                selectedValues = {}
                                selectedOrder = 0
                                Description.Text = "None"
                            end
                        end

                        function Template:AddList(Name)
                            local NewList_1 = Library:Create("Frame", {
                                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                                BackgroundTransparency = 1,
                                Name = "NewList",
                                Parent = Scrolling_1,
                                Size = UDim2.new(1, 0, 0, 25),
                                ZIndex = 500,
                                Selectable = false,
                            })

                            Library:Create("UICorner", {
                                CornerRadius = UDim.new(0, 3),
                                Parent = NewList_1,
                            })

                            local Title_1 = Library:Create("TextLabel", {
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                BackgroundTransparency = 1,
                                LayoutOrder = -1,
                                Name = "Title",
                                Parent = NewList_1,
                                Position = UDim2.new(0.5, 0, 0.5, 0),
                                Size = UDim2.new(1, -15, 1, 0),
                                ZIndex = 500,
                                Selectable = false,
                                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
                                RichText = true,
                                Text = tostring(Name),
                                TextColor3 = Color3.fromRGB(200, 200, 200),
                                TextSize = 11,
                                TextTransparency = 0.5,
                                TextTruncate = Enum.TextTruncate.AtEnd,
                                TextXAlignment = Enum.TextXAlignment.Left,
                            })

                            local function OnValue(value)
                                if value then
                                    Library:Tween({ v = NewList_1, t = 0.2, s = "Linear", d = "Out", g = { BackgroundTransparency = 0.85 } }):Play()
                                    Library:Tween({ v = Title_1, t = 0.2, s = "Linear", d = "Out", g = { TextTransparency = 0 } }):Play()
                                else
                                    Library:Tween({ v = NewList_1, t = 0.2, s = "Linear", d = "Out", g = { BackgroundTransparency = 1 } }):Play()
                                    Library:Tween({ v = Title_1, t = 0.2, s = "Linear", d = "Out", g = { TextTransparency = 0.5 } }):Play()
                                end
                            end

                            local Click = Library:Button(NewList_1)

                            local function OnSelected()
                                if IsMulti then
                                    if selectedValues[Name] then
                                        selectedValues[Name] = nil
                                        NewList_1.LayoutOrder = 0
                                        OnValue(false)
                                    else
                                        selectedOrder = selectedOrder - 1
                                        selectedValues[Name] = selectedOrder
                                        NewList_1.LayoutOrder = selectedOrder
                                        OnValue(true)
                                    end
                                    local selectedList = {}
                                    for i in pairs(selectedValues) do table.insert(selectedList, i) end
                                    if #selectedList > 0 then
                                        table.sort(selectedList)
                                        Value = selectedList
                                        Settext()
                                    else
                                        Description.Text = "None"
                                    end
                                    pcall(Callback, selectedList)
                                else
                                    for _, v in pairs(Scrolling_1:GetChildren()) do
                                        if v:IsA("Frame") and v.Name == 'NewList' then
                                            Library:Tween({ v = v, t = 0.2, s = "Linear", d = "Out", g = { BackgroundTransparency = 1 } }):Play()
                                            Library:Tween({ v = v.Title, t = 0.2, s = "Linear", d = "Out", g = { TextTransparency = 0.5 } }):Play()
                                        end
                                    end
                                    OnValue(true)
                                    Value = Name
                                    Settext()
                                    pcall(Callback, Value)
                                end
                            end

                            delay(0, function()
                                if IsMulti then
                                    if isValueInTable(Name, Value) then
                                        selectedOrder = selectedOrder - 1
                                        selectedValues[Name] = selectedOrder
                                        NewList_1.LayoutOrder = selectedOrder
                                        OnValue(true)
                                        local selectedList = {}
                                        for i in pairs(selectedValues) do table.insert(selectedList, i) end
                                        if #selectedList > 0 then
                                            table.sort(selectedList)
                                            Settext()
                                        else
                                            Description.Text = "None"
                                        end
                                        pcall(Callback, selectedList)
                                    end
                                else
                                    if Name == Value then
                                        OnValue(true)
                                        Settext()
                                        pcall(Callback, Value)
                                    end
                                end
                            end)

                            Click.MouseButton1Click:Connect(OnSelected)
                        end

                        Search_1.Changed:Connect(function()
                            local SearchT = string.lower(Search_1.Text)
                            for _, v in pairs(Scrolling_1:GetChildren()) do
                                if v:IsA("Frame") and v.Name == 'NewList' then
                                    v.Visible = string.find(string.lower(v.Title.Text), SearchT, 1, true) ~= nil
                                end
                            end
                        end)

                        for _, name in ipairs(List) do
                            Template:AddList(name)
                        end
                    end

                    table.insert(Rows, Template)
                    Library:UpdateLine(Rows)

                    return Template
                end

                return Section
            end

            function Tab:Navative()
                OnSelect()
            end

            function Tab:Banner(Image)
                local Banner_1 = Library:Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Name = "Banner",
                    Parent = NewPages_1,
                    Size = UDim2.new(1, 0, 0, 250),
                    ScaleType = Enum.ScaleType.Crop,
                    Image = Library:Asset(Image),
                })

                Library:Create("UICorner", {
                    CornerRadius = UDim.new(0, 3),
                    Parent = Banner_1,
                })
            end

            ClickSelectTab.MouseButton1Click:Connect(OnSelect)

            return Tab
        end
    end

    do
        Library:Draggable(Background_1)
    end

    do
        local ToggleScreen = Library:Create("ScreenGui", {
            Name = "Xynapse Pillow",
            Parent = Library:Parent(),
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            IgnoreGuiInset = true,
        })

        local Pillow_1 = Library:Create("TextButton", {
            Name = "Pillow",
            Parent = ToggleScreen,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BorderSizePixel = 0,
            Position = UDim2.new(0.06, 0, 0.15, 0),
            Size = UDim2.new(0, 50, 0, 50),
            Text = "",
        })

        Library:Create("UICorner", {
            Parent = Pillow_1,
            CornerRadius = UDim.new(0, 15),
        })

        Library:Create("ImageLabel", {
            Name = "Logo",
            Parent = Pillow_1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0.5, 0, 0.5, 0),
            Image = Library:Asset(Logo),
        })

        Library:Draggable(Pillow_1)

        Pillow_1.MouseButton1Click:Connect(function()
            Background_1.Visible = not Background_1.Visible
        end)

        local holdingSpace = false

        UserInputService.InputBegan:Connect(function(Input, Processed)
            if Processed then return end
            if Input.KeyCode == Enum.KeyCode.Space then
                holdingSpace = true
            end
            if holdingSpace and Input.KeyCode == Enum.KeyCode.LeftShift then
                Background_1.Visible = not Background_1.Visible
            end
        end)

        UserInputService.InputEnded:Connect(function(Input)
            if Input.KeyCode == Enum.KeyCode.Space then
                holdingSpace = false
            end
        end)
    end

    do
        local Scality = Library:Create("UIScale", {
            Parent = Xynpase_1,
            Scale = if Mobile then 1 else 1.45,
        })
        
        function Window:SetScale(scale)
            Scality.Scale = scale
        end
    end

    return Window
end

return Library
