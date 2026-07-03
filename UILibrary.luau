export type Window = any
export type Page = any
export type Section = any
export type Toggle = any
export type Slider = any
export type Dropdown = any
export type Colorpicker = any
export type Keybind = any
export type Label = any
export type Textbox = any

if getgenv().Library and getgenv().Library.Exit then
    getgenv().Library:Exit()
end

cloneref = cloneref or function(Object) return Object end 

local Players = cloneref(game:GetService("Players"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))
local TweenService = cloneref(game:GetService("TweenService"))
local GuiService = cloneref(game:GetService("GuiService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Workspace = cloneref(game:GetService("Workspace"))
local Lighting = cloneref(game:GetService("Lighting"))

local AssetManager = require(script.AssetManager)

local function IsAssetUri(Name: any): boolean
    return type(Name) == "string" and (Name:find("^[%a]+://") ~= nil or Name:find("^https?://") ~= nil)
end

local function ResolveCachedAsset(Name: any): any
    if type(Name) ~= "string" or Name == "" or IsAssetUri(Name) then
        return Name
    end

    return AssetManager:GetCachedAsset(Name)
end

local function ResolveAsset(Name: any): any
    if type(Name) ~= "string" or Name == "" then
        return Name
    end

    if IsAssetUri(Name) then
        return Name
    end

    return AssetManager:GetAsset(Name) or Name
end

gethui = gethui or function() return CoreGui end

local LocalPlayer = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled or false
local GuiInset = GuiService:GetGuiInset().Y
local Mouse = cloneref(LocalPlayer:GetMouse())
local Camera = Workspace.CurrentCamera

local Library = { 
    Flags = { },

    MenuKeybind = tostring(Enum.KeyCode.RightShift),

    Directory = "Tyronex",
    Folders = {
        Assets = "/Assets",
        Configs = "/Configs"
    },

    FontSize = 14,

    Animation = {
        Time = .35,
        Style = "Cubic",
        Direction = "Out"
    },

    ZIndexOrder = {
        ["OptionHolder"] = 5,
        ["KeybindWindow"] = 5,
        ["ColorpickerWindow"] = 6
    },

    -- Ignore below
    Threads = { },
    Connections = { },
    SetFlags = { },

    ThemingStuff = { },
    ThemeMap = { },

    OpenFrames = { },

    Notifications = { },

    Holder = nil,
    UnusedHolder = nil,

    SearchItems = { },

    Theme = nil,

    Font = nil,
} do 
    Library.__index = Library

    local Flags = Library.Flags 
    local SetFlags = Library.SetFlags

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    -- Folders
    if not isfolder(Library.Directory) then 
        makefolder(Library.Directory)
    end

    for _, Folder in Library.Folders do 
        if not isfolder(Library.Directory .. Folder) then 
            makefolder(Library.Directory .. Folder)
        end
    end
    
    if not isfile(Library.Directory .."/autoload.json") then 
        writefile(Library.Directory .."/autoload.json", "")
    end

    local Themes = {
        ["Preset"] = {
            ["Background"] = Color3.fromRGB(16, 17, 20),
            ["Inline"] = Color3.fromRGB(20, 21, 25),
            ["Accent"] = Color3.fromRGB(255, 30, 60),
            ["Text"] = Color3.fromRGB(245, 242, 255),
            ["Inactive Text"] = Color3.fromRGB(96, 95, 100),
            ["Element"] = Color3.fromRGB(26, 29, 33),
            ["Outline"] = Color3.fromRGB(28, 30, 35),
            ["Section"] = Color3.fromRGB(21, 23, 26),
            ["Hovered Element"] = Color3.fromRGB(36, 37, 41),
            ["Tab"] = Color3.fromRGB(24, 26, 30)
        }
    }

    Library.Theme = table.clone(Themes["Preset"])

    local function BuildCustomFont(Name: string, Weight: number, Style: string): Font?
        local FontAsset = ResolveAsset(Name)
        if type(FontAsset) ~= "string" or FontAsset == Name then
            return nil
        end

        local FontDirectory = Library.Directory .. Library.Folders.Assets .. "/Fonts"
        if not isfolder(FontDirectory) then
            makefolder(FontDirectory)
        end

        local DescriptorPath = `{FontDirectory}/{Name}.font`
        local Descriptor = {
            name = Name,
            faces = {
                {
                    name = Name,
                    weight = Weight,
                    style = Style,
                    assetId = FontAsset,
                },
            },
        }

        local Success, CustomFont = pcall(function()
            writefile(DescriptorPath, HttpService:JSONEncode(Descriptor))
            return Font.new(getcustomasset(DescriptorPath))
        end)

        return Success and CustomFont or nil
    end

    Library.Font = BuildCustomFont("InterSemibold", 400, "Regular") or Font.fromEnum(Enum.Font.Gotham)

    local function GetBrandTitleText(Name: any): string
        local Text = tostring(Name or "Tyronex")
        if Text ~= "Tyronex" and Text ~= "Tryonex" then
            return Text
        end

        local Accent = Library.Theme["Accent"]
        local Red = math.round(Accent.R * 255)
        local Green = math.round(Accent.G * 255)
        local Blue = math.round(Accent.B * 255)
        return `<font color="rgb(255,255,255)">yro</font><font color="rgb({Red},{Green},{Blue})">nex</font>`
    end

    local function SetGuiTreeZIndex(Root: Instance?, ZIndex: number)
        if not Root then
            return
        end

        if Root:IsA("GuiObject") then
            Root.ZIndex = ZIndex
        end

        for _, Descendant in Root:GetDescendants() do
            if Descendant:IsA("GuiObject") then
                Descendant.ZIndex = ZIndex
            end
        end
    end

    Library.GetAsset = function(_Self, Name)
        return ResolveAsset(Name)
    end

    Library.PreloadCoreAssets = function(_Self)
        AssetManager:PreloadCoreAssets()
    end

    Library.ShowAssetDownloadStatus = function(Self)
        if Self._AssetDownloadStatusStarted then
            return
        end

        Self._AssetDownloadStatusStarted = true
        Self._AssetDownloadCancelled = false

        local DownloadGui = Instance.new("ScreenGui")
        DownloadGui.Name = "TyronexAssetDownload"
        DownloadGui.DisplayOrder = 10001
        DownloadGui.IgnoreGuiInset = true
        DownloadGui.OnTopOfCoreBlur = true
        DownloadGui.ResetOnSpawn = false
        DownloadGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        DownloadGui.Parent = gethui()
        Self.DownloadGui = DownloadGui

        local Holder = Instance.new("Frame")
        Holder.AnchorPoint = Vector2.new(0.5, 0)
        Holder.BackgroundColor3 = Library.Theme["Inline"]
        Holder.BorderSizePixel = 0
        Holder.Position = UDim2.new(0.5, 0, 0, -42)
        Holder.Size = UDim2.new(1, -32, 0, 34)
        Holder.Parent = DownloadGui

        local SizeConstraint = Instance.new("UISizeConstraint")
        SizeConstraint.MaxSize = Vector2.new(420, 34)
        SizeConstraint.MinSize = Vector2.new(260, 34)
        SizeConstraint.Parent = Holder

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 7)
        Corner.Parent = Holder

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Library.Theme["Outline"]
        Stroke.Thickness = 1
        Stroke.Transparency = 0.2
        Stroke.Parent = Holder

        local Accent = Instance.new("Frame")
        Accent.BackgroundColor3 = Library.Theme["Accent"]
        Accent.BorderSizePixel = 0
        Accent.Position = UDim2.fromOffset(8, 5)
        Accent.Size = UDim2.new(0, 3, 1, -10)
        Accent.Parent = Holder

        local AccentCorner = Instance.new("UICorner")
        AccentCorner.CornerRadius = UDim.new(1, 0)
        AccentCorner.Parent = Accent

        local Label = Instance.new("TextLabel")
        Label.BackgroundTransparency = 1
        Label.FontFace = Library.Font
        Label.Position = UDim2.fromOffset(18, 0)
        Label.Size = UDim2.new(1, -28, 1, 0)
        Label.Text = "Preparing assets..."
        Label.TextColor3 = Library.Theme["Text"]
        Label.TextSize = 12
        Label.TextTruncate = Enum.TextTruncate.AtEnd
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Holder

        TweenService:Create(Holder, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, 14),
        }):Play()

        Self._CancelAssetDownloads = function()
            Self._AssetDownloadCancelled = true
            Self._AssetDownloadStatusStarted = false
            Self._CancelAssetDownloads = nil
            if DownloadGui.Parent then
                DownloadGui:Destroy()
            end
            Self.DownloadGui = nil
        end

        AssetManager:LoadAssetsAsync(function(Current, Total, AssetName)
            if Self._AssetDownloadCancelled or not DownloadGui.Parent then
                return
            end

            local DisplayName = AssetName:match("([^/\\]+)$") or AssetName
            Label.Text = `Downloading {Current}/{Total}: {DisplayName}`
        end, function(Total)
            if Self._AssetDownloadCancelled or not DownloadGui.Parent then
                return
            end

            Label.Text = Total > 0 and `Downloaded {Total} assets` or "Assets ready"

            task.delay(1, function()
                if Self._AssetDownloadCancelled or not DownloadGui.Parent then
                    return
                end

                local Out = TweenService:Create(Holder, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Position = UDim2.new(0.5, 0, 0, -42),
                })
                Out.Completed:Connect(function()
                    if DownloadGui.Parent then
                        DownloadGui:Destroy()
                    end
                    Self.DownloadGui = nil
                    Self._AssetDownloadStatusStarted = false
                    Self._CancelAssetDownloads = nil
                end)
                Out:Play()
            end)
        end, function()
            return Self._AssetDownloadCancelled
        end)
    end

    Library.ShowLoadingScreen = function(Self, Params)
        Params = Params or {}

        if Self.LoadingGui then
            Self.LoadingGui:Destroy()
        end
        Self._LoadingScreenObjects = nil
        Self._LoadingScreenHiding = false

        local LoadingGui = Instance.new("ScreenGui")
        LoadingGui.Name = "TyronexLoading"
        LoadingGui.DisplayOrder = 10000
        LoadingGui.IgnoreGuiInset = true
        LoadingGui.OnTopOfCoreBlur = true
        LoadingGui.ResetOnSpawn = false
        LoadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
        LoadingGui.Parent = gethui()
        Self.LoadingGui = LoadingGui

        local Backdrop = Instance.new("Frame")
        Backdrop.BackgroundColor3 = Library.Theme["Background"]
        Backdrop.BackgroundTransparency = 1
        Backdrop.BorderSizePixel = 0
        Backdrop.Size = UDim2.fromScale(1, 1)
        Backdrop.Parent = LoadingGui

        local Panel = Instance.new("Frame")
        Panel.AnchorPoint = Vector2.new(0.5, 0.5)
        Panel.BackgroundColor3 = Library.Theme["Inline"]
        Panel.BackgroundTransparency = 1
        Panel.BorderSizePixel = 0
        Panel.Position = UDim2.fromScale(0.5, 0.53)
        Panel.Size = UDim2.new(1, -32, 0, 136)
        Panel.Parent = Backdrop

        local SizeConstraint = Instance.new("UISizeConstraint")
        SizeConstraint.MaxSize = Vector2.new(340, 136)
        SizeConstraint.MinSize = Vector2.new(280, 136)
        SizeConstraint.Parent = Panel

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 10)
        Corner.Parent = Panel

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Library.Theme["Outline"]
        Stroke.Thickness = 1.5
        Stroke.Transparency = 1
        Stroke.Parent = Panel

        local AccentLine = Instance.new("Frame")
        AccentLine.BackgroundColor3 = Library.Theme["Accent"]
        AccentLine.BackgroundTransparency = 1
        AccentLine.BorderSizePixel = 0
        AccentLine.Position = UDim2.fromOffset(12, 0)
        AccentLine.Size = UDim2.new(1, -24, 0, 2)
        AccentLine.Parent = Panel

        local AccentLineGradient = Instance.new("UIGradient")
        AccentLineGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.18, 0.35),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.82, 0.35),
            NumberSequenceKeypoint.new(1, 1),
        })
        AccentLineGradient.Parent = AccentLine

        local PanelGlow = Instance.new("ImageLabel")
        PanelGlow.BackgroundTransparency = 1
        PanelGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        PanelGlow.Position = UDim2.fromScale(0.5, 0.5)
        PanelGlow.Size = UDim2.new(1, 44, 1, 44)
        PanelGlow.Image = ResolveCachedAsset("ui-glow") or ""
        PanelGlow.ImageColor3 = Library.Theme["Accent"]
        PanelGlow.ImageTransparency = 1
        PanelGlow.ScaleType = Enum.ScaleType.Slice
        PanelGlow.SliceCenter = Rect.new(22, 22, 78, 78)
        PanelGlow.SliceScale = 3
        PanelGlow.ZIndex = 0
        PanelGlow.Parent = Panel

        if PanelGlow.Image == "" then
            AssetManager:GetAssetAsync("ui-glow", function(AssetUrl)
                if PanelGlow.Parent then
                    PanelGlow.Image = AssetUrl
                end
            end)
        end

        local Brand = Instance.new("Frame")
        Brand.AnchorPoint = Vector2.new(0.5, 0)
        Brand.BackgroundTransparency = 1
        Brand.BorderSizePixel = 0
        Brand.Position = UDim2.new(0.5, -8, 0, 14)
        Brand.Size = UDim2.new(1, -36, 0, 40)
        Brand.Parent = Panel

        local BrandLayout = Instance.new("UIListLayout")
        BrandLayout.FillDirection = Enum.FillDirection.Horizontal
        BrandLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        BrandLayout.Padding = UDim.new(0, -14)
        BrandLayout.SortOrder = Enum.SortOrder.LayoutOrder
        BrandLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        BrandLayout.Parent = Brand

        local Logo = Instance.new("ImageLabel")
        Logo.BackgroundTransparency = 1
        Logo.BorderSizePixel = 0
        local LogoAsset = Params.Logo or "default-logo"
        Logo.Image = ResolveCachedAsset(LogoAsset) or ""
        Logo.ImageColor3 = Library.Theme["Accent"]
        Logo.ImageTransparency = 1
        Logo.LayoutOrder = 1
        Logo.ScaleType = Enum.ScaleType.Fit
        Logo.Size = UDim2.fromOffset(34, 34)
        Logo.Parent = Brand

        if Logo.Image == "" and type(LogoAsset) == "string" and not IsAssetUri(LogoAsset) then
            AssetManager:GetAssetAsync(LogoAsset, function(AssetUrl)
                if Logo.Parent then
                    Logo.Image = AssetUrl
                end
            end)
        end

        local Title = Instance.new("TextLabel")
        Title.AutomaticSize = Enum.AutomaticSize.XY
        Title.BackgroundTransparency = 1
        Title.FontFace = Library.Font
        Title.LayoutOrder = 2
        Title.RichText = true
        Title.Size = UDim2.fromOffset(0, 24)
        Title.Text = GetBrandTitleText(Params.Title or "Tyronex")
        Title.TextColor3 = Library.Theme["Text"]
        Title.TextSize = Library.FontSize + 5
        Title.TextTransparency = 1
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Brand

        local Subtitle = Instance.new("TextLabel")
        Subtitle.BackgroundTransparency = 1
        Subtitle.FontFace = Library.Font
        Subtitle.Position = UDim2.fromOffset(18, 62)
        Subtitle.Size = UDim2.new(1, -36, 0, 18)
        Subtitle.Text = Params.Subtitle or "Preparing interface..."
        Subtitle.TextColor3 = Library.Theme["Text"]
        Subtitle.TextSize = 14
        Subtitle.TextTransparency = 1
        Subtitle.TextXAlignment = Enum.TextXAlignment.Center
        Subtitle.Parent = Panel

        local Track = Instance.new("Frame")
        Track.BackgroundColor3 = Library.Theme["Element"]
        Track.BackgroundTransparency = 1
        Track.BorderSizePixel = 0
        Track.ClipsDescendants = true
        Track.Position = UDim2.fromOffset(18, 100)
        Track.Size = UDim2.new(1, -36, 0, 5)
        Track.Parent = Panel

        local TrackCorner = Instance.new("UICorner")
        TrackCorner.CornerRadius = UDim.new(1, 0)
        TrackCorner.Parent = Track

        local Shimmer = Instance.new("Frame")
        Shimmer.BackgroundColor3 = Library.Theme["Text"]
        Shimmer.BackgroundTransparency = 1
        Shimmer.BorderSizePixel = 0
        Shimmer.Position = UDim2.new(-0.18, 0, 0, 0)
        Shimmer.Size = UDim2.new(0, 38, 1, 0)
        Shimmer.ZIndex = 2
        Shimmer.Parent = Track

        local ShimmerCorner = Instance.new("UICorner")
        ShimmerCorner.CornerRadius = UDim.new(1, 0)
        ShimmerCorner.Parent = Shimmer

        local Fill = Instance.new("Frame")
        Fill.BackgroundColor3 = Library.Theme["Accent"]
        Fill.BorderSizePixel = 0
        Fill.Size = UDim2.fromScale(0, 1)
        Fill.Parent = Track

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill

        local Count = Instance.new("TextLabel")
        Count.BackgroundTransparency = 1
        Count.FontFace = Library.Font
        Count.Position = UDim2.fromOffset(18, 112)
        Count.Size = UDim2.new(1, -36, 0, 13)
        Count.Text = "0%"
        Count.TextColor3 = Library.Theme["Inactive Text"]
        Count.TextSize = 10
        Count.TextTransparency = 1
        Count.TextXAlignment = Enum.TextXAlignment.Right
        Count.Parent = Panel

        TweenService:Create(Backdrop, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(Panel, TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0,
            Position = UDim2.fromScale(0.5, 0.5),
        }):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Transparency = 0}):Play()
        TweenService:Create(AccentLine, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
        TweenService:Create(PanelGlow, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {ImageTransparency = 0.48}):Play()
        TweenService:Create(Logo, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {ImageTransparency = 0}):Play()
        TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
        TweenService:Create(Subtitle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
        TweenService:Create(Track, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
        TweenService:Create(Count, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()

        local ShimmerActive = true
        Self._LoadingScreenObjects = {
            Backdrop = Backdrop,
            Panel = Panel,
            Stroke = Stroke,
            StopShimmer = function()
                ShimmerActive = false
            end,
        }

        task.spawn(function()
            task.wait(0.45)
            while ShimmerActive and Shimmer.Parent do
                Shimmer.Position = UDim2.new(-0.18, 0, 0, 0)
                local Sweep = TweenService:Create(Shimmer, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Position = UDim2.new(1.08, 0, 0, 0),
                    BackgroundTransparency = 0.62,
                })
                Sweep:Play()
                Sweep.Completed:Wait()
                task.wait(0.08)
            end
        end)

        task.wait(0.38)
        for Percent = 0, 100, 5 do
            TweenService:Create(Fill, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromScale(Percent / 100, 1),
            }):Play()
            Count.Text = `{Percent}%`
            task.wait(0.02)
        end

        Subtitle.Text = "Building interface..."
        Subtitle.TextTransparency = 0
        Count.Text = "100%"
        Fill.Size = UDim2.fromScale(1, 1)
        Self._AssetDownloadPending = true
    end

    Library.HideLoadingScreen = function(Self, Callback)
        if not Self.LoadingGui or Self._LoadingScreenHiding then
            if Callback then
                Callback()
            end
            return
        end

        Self._LoadingScreenHiding = true

        local LoadingGui = Self.LoadingGui
        local Objects = Self._LoadingScreenObjects or {}
        local Backdrop = Objects.Backdrop
        local Panel = Objects.Panel
        local Stroke = Objects.Stroke
        local PanelSize = Panel and Panel.Size

        if Objects.StopShimmer then
            Objects.StopShimmer()
        end

        local Fade = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local Collapse = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.In)

        if Backdrop and Backdrop.Parent then
            TweenService:Create(Backdrop, TweenInfo.new(0.36, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        end

        if Panel and Panel.Parent then
            Panel.ClipsDescendants = true
            TweenService:Create(Panel, Collapse, {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.48),
                Size = UDim2.new(0, 0, PanelSize.Y.Scale, PanelSize.Y.Offset),
            }):Play()

            for _, Descendant in Panel:GetDescendants() do
                if Descendant:IsA("TextLabel") then
                    TweenService:Create(Descendant, Fade, {TextTransparency = 1}):Play()
                elseif Descendant:IsA("ImageLabel") then
                    TweenService:Create(Descendant, Fade, {ImageTransparency = 1, BackgroundTransparency = 1}):Play()
                elseif Descendant:IsA("Frame") then
                    TweenService:Create(Descendant, Fade, {BackgroundTransparency = 1}):Play()
                elseif Descendant:IsA("UIStroke") then
                    TweenService:Create(Descendant, Fade, {Transparency = 1}):Play()
                end
            end
        end

        if Stroke and Stroke.Parent then
            TweenService:Create(Stroke, Fade, {Transparency = 1}):Play()
        end

        task.delay(0.34, function()
            if LoadingGui and LoadingGui.Parent then
                LoadingGui:Destroy()
            end

            if Self.LoadingGui == LoadingGui then
                Self.LoadingGui = nil
                Self._LoadingScreenObjects = nil
                Self._LoadingScreenHiding = false
            end

            if Callback then
                Callback()
            end
        end)
    end

    Library.Exit = function(Self)
        if Self._Exiting or Self._Exited then
            return
        end

        Self._Exiting = true

        if Self._CancelAssetDownloads then
            Self._CancelAssetDownloads()
        end

        for _, Connection in Self.Connections or {} do
            pcall(function()
                Connection:Disconnect()
            end)
        end
        table.clear(Self.Connections)

        for _, Thread in Self.Threads or {} do
            if coroutine.status(Thread) ~= "dead" then
                pcall(coroutine.close, Thread)
            end
        end
        table.clear(Self.Threads)

        if Self.Holder and Self.Holder.Instance then
            Self.Holder.Instance:Destroy()
            Self.Holder = nil
        end

        if Self.UnusedHolder and Self.UnusedHolder.Instance then
            Self.UnusedHolder.Instance:Destroy()
            Self.UnusedHolder = nil
        end

        if Self.LoadingGui then
            Self.LoadingGui:Destroy()
        end

        if Self.DownloadGui then
            Self.DownloadGui:Destroy()
        end

        Self.LoadingGui = nil
        Self._LoadingScreenObjects = nil
        Self._LoadingScreenHiding = false
        Self.DownloadGui = nil
        Self._Exited = true
        Self._Exiting = false

        if getgenv().Library == Self then
            getgenv().Library = nil
        end
    end

    Library.Create = function(Self, Class, Properties)
        local Data = {
            Class = Class,
            Properties = Properties,
            Instance = Instance.new(Class)
        }
        local PendingImage: string? = nil

        if Class == "ScrollingFrame" then
            Data.Instance.ClipsDescendants = true
        end

        for Property, Value in Properties do
            if Property == "FontFace" then
                Data.Instance.FontFace = Library.Font
            elseif Property == "TextSize" then
                Data.Instance.TextSize = Library.FontSize
            elseif Property == "Name" then
                Data.Instance.Name = "\0"
            elseif Property == "Image" then
                local CachedImage = ResolveCachedAsset(Value)
                Data.Instance.Image = CachedImage or ""
                if not CachedImage and type(Value) == "string" and not IsAssetUri(Value) then
                    PendingImage = Value
                end
            else
                Data.Instance[Property] = Value
            end
        end

        if PendingImage then
            local ImageName = PendingImage
            AssetManager:GetAssetAsync(ImageName, function(AssetUrl)
                if Data.Instance.Parent then
                    Data.Instance.Image = AssetUrl
                end
            end)
        end

        return setmetatable(Data, Library)
    end

    Library.Thread = function(Self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        table.insert(Library.Threads, NewThread)
        return NewThread
    end

    Library.Connect = function(Self, Signal, Callback)
        local Connection

        if Self.Instance then
            if Self.Instance[Signal] then 
                if IsMobile and Signal == "MouseButton1Down" then 
                    Connection = Self.Instance.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Callback(Input)
                        end
                    end)

                    table.insert(Library.Connections, Connection)
                    return
                end
                
                Connection = Self.Instance[Signal]:Connect(Callback)
            else
                Connection = Signal:Connect(Callback)
            end
        else
            Connection = Signal:Connect(Callback)
        end

        table.insert(Library.Connections, Connection)
        return Connection
    end

    Library.Tween = function(Self, Properties, Info, IsRawItem)
        local Object = Self.Instance or IsRawItem
        Info = Info or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

        if not Object then 
            return 
        end

        local NewTween = TweenService:Create(Object, Info, Properties)
        NewTween:Play()

        return NewTween
    end

    Library.GetTweenProperty = function(Self, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then 
            return { }
        end

        if Object:IsA("ViewportFrame") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Object:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Object:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Object:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.Fade = function(Self, Property, Visibility, IsRawItem)
        local Object = Self.Instance or IsRawItem

        if not Object then 
            return 
        end

        local OldTransparency = Object[Property]
        Object[Property] = Visibility and 1 or OldTransparency

        local NewTween = Library:Tween({
            [Property] = Visibility and OldTransparency or 1
        }, nil, Object)

        Library:Connect(NewTween.Completed, function()
            if not Visibility then 
                task.wait()
                Object[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.FadeDescendants = function(Self, Visibility, Callback)
        if Visibility then 
            Self.Instance.Visible = true 
        end

        local NewTween 

        local Children = Self.Instance:GetDescendants()
        table.insert(Children, Self.Instance)

        for _, Child in Children do 
            local TransparencyProperty = Library:GetTweenProperty(Child)

            if not TransparencyProperty then 
                continue 
            end

            if type(TransparencyProperty) == "table" then
                for _, Property in TransparencyProperty do
                    NewTween = Library:Fade(Property, Visibility, Child)
                end
            else
                NewTween = Library:Fade(TransparencyProperty, Visibility, Child)
            end
        end

        if NewTween then
            Library:Connect(NewTween.Completed, function()
                if Callback and type(Callback) == "function" then 
                    Callback()
                end
    
                Self.Instance.Visible = Visibility
            end)
        else
            Self.Instance.Visible = Visibility
            if Callback then Callback() end
        end
    end

    Library.PrepareInterfaceReveal = function(Self, RootItem)
        local Root = RootItem and RootItem.Instance

        if not Root then
            return nil
        end

        local Snapshot = {
            Root = Root,
            Position = Root.Position,
            Objects = {},
        }

        local Objects = Root:GetDescendants()
        table.insert(Objects, Root)

        for _, Object in Objects do
            local Properties = Library:GetTweenProperty(Object)

            if not Properties then
                continue
            end

            local Values = {}

            for _, Property in Properties do
                Values[Property] = Object[Property]
                Object[Property] = 1
            end

            table.insert(Snapshot.Objects, {
                Object = Object,
                Values = Values,
            })
        end

        Root.Position = UDim2.new(Snapshot.Position.X.Scale, Snapshot.Position.X.Offset, Snapshot.Position.Y.Scale, Snapshot.Position.Y.Offset + 18)

        return Snapshot
    end

    Library.PlayInterfaceReveal = function(Self, Snapshot)
        if not Snapshot or not Snapshot.Root then
            return
        end

        local Info = TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        Library:Tween({Position = Snapshot.Position}, Info, Snapshot.Root)

        for _, Entry in Snapshot.Objects do
            if Entry.Object and Entry.Object.Parent then
                Library:Tween(Entry.Values, Info, Entry.Object)
            end
        end
    end

    Library.MakeDraggable = function(Self)
        if not Self.Instance then 
            return
        end
    
        local Gui = Self.Instance
        local Dragging = false 
        local DragStart
        local StartPosition 

        local function IsViewportInput(Input): boolean
            local Position = Input.Position
            for _, Descendant in Gui:GetDescendants() do
                if Descendant:IsA("ViewportFrame") and Descendant.Visible then
                    local TopLeft = Descendant.AbsolutePosition
                    local BottomRight = TopLeft + Descendant.AbsoluteSize
                    if Position.X >= TopLeft.X and Position.X <= BottomRight.X
                        and Position.Y >= TopLeft.Y and Position.Y <= BottomRight.Y then
                        return true
                    end
                end
            end

            return false
        end
    
        local Set = function(Input)
            local DragDelta = Input.Position - DragStart
            local NewX = StartPosition.X.Offset + DragDelta.X
            local NewY = StartPosition.Y.Offset + DragDelta.Y

            local ScreenSize = Gui.Parent.AbsoluteSize
            local GuiSize = Gui.AbsoluteSize
    
            NewX = math.clamp(NewX, 0, ScreenSize.X - GuiSize.X)
            NewY = math.clamp(NewY, 0, ScreenSize.Y - GuiSize.Y)
    
            Self:Tween({Position = UDim2.new(0, NewX, 0, NewY)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end
    
        local InputChanged
    
        Self:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if IsViewportInput(Input) then
                    return
                end

                Dragging = true
                DragStart = Input.Position
                StartPosition = Gui.Position
    
                if InputChanged then 
                    return
                end
    
                InputChanged = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        InputChanged:Disconnect()
                        InputChanged = nil
                    end
                end)
            end
        end)
    
        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                if Dragging then
                    Set(Input)
                end
            end
        end)
    
        return Dragging
    end

    Library.MakeResizeable = function(Self, Minimum)
        if not Self.Instance then 
            return
        end

        local Gui = Self.Instance

        local Resizing = false 
        local CurrentSide = nil

        local StartMouse = nil 
        local StartPosition = nil 
        local StartSize = nil
        
        local EdgeThickness = 2

        local MakeEdge = function(Name, Position, Size)
            local Button = Library:Create("TextButton", {
                Name = "\0",
                Size = Size,
                Position = Position,
                BackgroundColor3 = Color3.fromRGB(166, 147, 243),
                BackgroundTransparency = 1,
                Text = "",
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Parent = Gui,
                ZIndex = 99999,
            })  Button:AddToTheme({BackgroundColor3 = "Accent"})

            return Button
        end

        local Edges = {
            {Button = MakeEdge(
                "Left", 
                UDim2.new(0, 0, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "L"
            },

            {Button = MakeEdge(
                "Right", 
                UDim2.new(1, -EdgeThickness, 0, 0), 
                UDim2.new(0, EdgeThickness, 1, 0)), 
                Side = "R"
            },

            {Button = MakeEdge(
                "Top", UDim2.new(0, 0, 0, 0), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "T"
            },

            {Button = MakeEdge(
                "Bottom", 
                UDim2.new(0, 0, 1, -EdgeThickness), 
                UDim2.new(1, 0, 0, EdgeThickness)), 
                Side = "B"
            },
        }

        local BeginResizing = function(Side)
            Resizing = true 
            CurrentSide = Side 

            StartMouse = UserInputService:GetMouseLocation()

            StartPosition = Vector2.new(Gui.Position.X.Offset, Gui.Position.Y.Offset)
            StartSize = Vector2.new(Gui.Size.X.Offset, Gui.Size.Y.Offset)
            
            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = (Value.Side == Side) and 0 or 1
            end
        end

        local EndResizing = function()
            Resizing = false 
            CurrentSide = nil

            for Index, Value in Edges do 
                Value.Button.Instance.BackgroundTransparency = 1
            end
        end

        for Index, Value in Edges do 
            Value.Button:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    BeginResizing(Value.Side)
                end
            end)
        end

        Library:Connect(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                if Resizing then
                    EndResizing()
                end
            end
        end)

        Library:Connect(RunService.RenderStepped, function()
            if not Resizing or not CurrentSide then 
                return 
            end

            local MouseLocation = UserInputService:GetMouseLocation()
            local dx = MouseLocation.X - StartMouse.X
            local dy = MouseLocation.Y - StartMouse.Y
        
            local x, y = StartPosition.X, StartPosition.Y
            local w, h = StartSize.X, StartSize.Y

            if CurrentSide == "L" then
                x = StartPosition.X + dx
                w = StartSize.X - dx
            elseif CurrentSide == "R" then
                w = StartSize.X + dx
            elseif CurrentSide == "T" then
                y = StartPosition.Y + dy
                h = StartSize.Y - dy
            elseif CurrentSide == "B" then
                h = StartSize.Y + dy
            end
        
            if w < Minimum.X then
                if CurrentSide == "L" then
                    x = x - (Minimum.X - w)
                end
                w = Minimum.X
            end
            if h < Minimum.Y then
                if CurrentSide == "T" then
                    y = y - (Minimum.Y - h)
                end
                h = Minimum.Y
            end
        
            Self:Tween({Position = UDim2.fromOffset(x, y)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            Self:Tween({Size = UDim2.fromOffset(w, h)}, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end)
    end

    Library.IsMouseOverFrame = function(Self)
        if not Self.Instance then 
            return 
        end

        local Object = Self.Instance

        local MousePosition = Vector2.new(Mouse.X, Mouse.Y)

        return MousePosition.X >= Object.AbsolutePosition.X and MousePosition.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X 
        and MousePosition.Y >= Object.AbsolutePosition.Y and MousePosition.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
    end

    Library.SafeCall = function(Self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, table.unpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success, Result
    end

    Library.Round = function(Self, Number, Float)
        Number = tonumber(Number) or 0
        Float = tonumber(Float) or 1

        if Number ~= Number then
            Number = 0
        end

        if Float ~= Float or Float <= 0 then
            Float = 1
        end

        local Multiplier = 1 / Float
        return math.floor(Number * Multiplier) / Multiplier
    end

    Library.GetConfig = function(Self)
        local Config = { }

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        if not Success then
            warn("Failed to get config:\n"..Result)
            return
        end

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(Self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.GetConfigsList = function(Self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Directory .. Library.Folders.Configs)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    table.insert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.AddToTheme = function(Self, Properties)
        local Object = Self.Instance

        local ThemeData = {
            Item = Object,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                if not Library.Theme[Value] then
                    Object[Property] = Value
                    continue
                end

                Object[Property] = Library.Theme[Value]
            else
                Object[Property] = Value()
            end
        end
        
        table.insert(Library.ThemingStuff, ThemeData)
        Library.ThemeMap[Object] = ThemeData
        return Self
    end

    Library.ChangeItemTheme = function(Self, Properties)
        local Object = Self.Instance

        if not Library.ThemeMap[Object] then 
            return
        end

        Library.ThemeMap[Object].Properties = Properties
        Library.ThemeMap[Object] = Library.ThemeMap[Object]
    end

    Library.ChangeTheme = function(Self, Theme, Color)
        Library.Theme[Theme] = Color

        for _, Item in Library.ThemingStuff do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.OnHover = function(Self, OnHoverEnter, OnHoverLeave)
        local Object = Self.Instance

        if not Object then 
            return 
        end 

        Library:Connect(Object.MouseEnter, OnHoverEnter)
        Library:Connect(Object.MouseLeave, OnHoverLeave)
    end

    Library.GetScreenScale = function(Self)
        local Scale = 1
    
        for _, Obj in Library.Holder.Instance:GetDescendants() do
            if Obj:IsA("UIScale") then
                Scale *= Obj.Scale
            end
        end
    
        return Scale
    end
    
    Library.PopupPosition = function(Self, Anchor, Popup, ExtraY)
        local Scale = Library:GetScreenScale()
        ExtraY = ExtraY or 0
    
        local X = Anchor.AbsolutePosition.X / Scale
        local Y = (Anchor.AbsolutePosition.Y + Anchor.AbsoluteSize.Y + GuiInset + ExtraY) / Scale
    
        return UDim2.fromOffset(X, Y)
    end

    Library.VisibleCheck = function(Self)
        local Object = Self.Instance 

        if not Object then 
            return 
        end

        local OriginalParent = Object.Parent

        Library:Connect(Object:GetPropertyChangedSignal("Visible"), function()
            local IsVisible = Object.Visible
            Object.Parent = IsVisible and OriginalParent or Library.UnusedHolder.Instance
        end)
    end

    Library.TweenDescendants = function(Self, TransparencyVal, Info) -- same thing as fade descendants but this one has  custom transparency and not the original transparency of a instance
        local Object = Self.Instance 
        Info = Info or TweenInfo.new(Library.Animation.Time, Enum.EasingStyle[Library.Animation.Style], Enum.EasingDirection[Library.Animation.Direction])

        if not Object then 
            return
        end

        local Children = Object:GetDescendants()
        table.insert(Children, Object)

        for _, Child in Children do 
            if Child:IsA("TextLabel") then
                Library:Tween({TextTransparency = TransparencyVal}, Info, Child)
            elseif Child:IsA("Frame") then
                Library:Tween({BackgroundTransparency = TransparencyVal}, Info, Child)
            elseif Child:IsA("UIStroke") then
                Library:Tween({Transparency = TransparencyVal}, Info, Child)
            end
        end
    end

    Library.GetCalculatedRayPosition = function(Self, Position, Normal, Origin, Direction)
        local N = Normal
        local D = Direction
        local V = Origin - Position

        local Number = (N.x * V.x) + (N.y * V.y) + (N.z * V.z)
        local Den = (N.x * D.x) + (N.y * D.y) + (N.z * D.z)
        local A = -Number / Den

        return Origin + (A * Direction)
    end

    Library.MakeBlurred = function(Self, Window)
        local BlurItem = Self.Instance 

        if not BlurItem then 
            return 
        end

        local Part = Library:Create("Part", {
            Material = Enum.Material.Glass,
            Transparency = 1,
            Reflectance = 1,
            CastShadow = false,
            Anchored = true,
            CanCollide = false,
            CanQuery = false,
            CollisionGroup = " ",
            Size = Vector3.new(1, 1, 1) * 0.01,
            Color = Color3.fromRGB(0,0,0),
            Parent = Camera
        })
            
        local BlockMesh = Library:Create("BlockMesh", {Parent = Part.Instance})

        local DepthOfField = Library:Create("DepthOfFieldEffect", {
            Parent = Lighting,
            Enabled = true,
            FarIntensity = 0,
            FocusDistance = 0,
            InFocusRadius = 1000,
            NearIntensity = 1,
            Name = ""
        })

        Library:Connect(RunService.RenderStepped, function()
            if Window.IsOpen then
                DepthOfField:Tween({NearIntensity = 1})

                Part:Tween({Transparency = 0.97})
                Part:Tween({Size = Vector3.new(1, 1, 1) * 0.01})

                local Corner0 = BlurItem.AbsolutePosition;
                local Corner1 = Corner0 + BlurItem.AbsoluteSize;
                    
                local Ray0 = Camera.ScreenPointToRay(Camera, Corner0.X, Corner0.Y, 1);
                local Ray1 = Camera.ScreenPointToRay(Camera, Corner1.X, Corner1.Y, 1);

                local Origin = Camera.CFrame.Position + Camera.CFrame.LookVector * (0.05 - Camera.NearPlaneZ);

                local Normal = Camera.CFrame.LookVector;

                local Position0 = Library:GetCalculatedRayPosition(Origin, Normal, Ray0.Origin, Ray0.Direction)
                local Position1 = Library:GetCalculatedRayPosition(Origin, Normal, Ray1.Origin, Ray1.Direction)

                Position0 = Camera.CFrame:PointToObjectSpace(Position0)
                Position1 = Camera.CFrame:PointToObjectSpace(Position1)

                local Size = Position1 - Position0
                local Center = (Position0 + Position1) / 2

                BlockMesh.Instance.Offset = Center
                BlockMesh.Instance.Scale  = Size / 0.0101

                Part.Instance.CFrame = Camera.CFrame
            else
                DepthOfField:Tween({NearIntensity = 0})

                BlockMesh.Instance.Offset = Vector3.new(0, 0, 0)
                BlockMesh.Instance.Scale  = Vector3.new(0, 0, 0)
            end
        end)
    end

    Library.Holder = Library:Create("ScreenGui", {
        Parent = gethui(),
        DisplayOrder = 999,
        Enabled = false,
        IgnoreGuiInset = true,
        Name = "\0",
        OnTopOfCoreBlur = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    Library.BackgroundButton = Library:Create("TextButton", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        Text = "",
        AutoButtonColor = false,
        Active = true,
        Selectable = false,
        Visible = false,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 0
    })

    Library.UnusedHolder = Library:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        Enabled = false,
        OnTopOfCoreBlur = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    do
        Library.CreateColorpicker = function(Self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = Color3.fromRGB(255, 255, 255),
                HexValue = "#FFFFFF",

                Flag = Data.Flag,
                IsOpen = false,

                Items = { }
            }

            local Items = { } do 
                Items["ColorpickerButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 18, 0, 18),
                    ZIndex = 2,
                    BackgroundColor3 = Colorpicker.Color
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["ColorpickerButton"].Instance,
                    ImageColor3 = Colorpicker.Color,
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.699999988079071,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                })

                Items["ColorpickerWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1107, 0, 273),
                    Size = UDim2.new(0, 231, 0, 214),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["ColorpickerWindow"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Palette"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -45, 1, -80),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Items["Saturation"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Saturation"].Instance,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Items["Value"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Value"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Items["PaletteDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Palette"].Instance,
                    Size = UDim2.new(0, 14, 0, 14),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Position = UDim2.new(0, 12, 0, 12),
                    ZIndex = 3,
                    BorderSizePixel = 0
                })
                
                Library:Create("UIShadow", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    BlurRadius = UDim.new(0, 12)
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["PaletteDragger"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["BackgroundOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -10),
                    Size = UDim2.new(1, -20, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["BackgroundOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Background"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["BackgroundOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({BackgroundColor3 = 'Section'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Background"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "255, 30, 60",
                    Size = UDim2.new(1, -16, 0, 0),
                    Position = UDim2.new(0, 8, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({PlaceholderColor3 = 'Inactive Text', TextColor3 = 'Text'})
                
                Items["Hue"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0),
                    Position = UDim2.new(1, -10, 0, 10),
                    Size = UDim2.new(0, 15, 1, -80),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    Rotation = 90,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }
                })
                
                Items["HueDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Hue"].Instance,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 0, 0, 8),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["HueDragger"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIShadow", {
                    Name = "\0",
                    Parent = Items["HueDragger"].Instance,
                    BlurRadius = UDim.new(0, 12)
                })
                
                Items["Alpha"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["ColorpickerWindow"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 10, 1, -45),
                    Size = UDim2.new(1, -20, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Checkers"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0, 6, 0, 6),
                    Image = "alpha-checkerboard",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 2,
                    ImageColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Checkers"].Instance,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.37, 0.5),
                    NumberSequenceKeypoint.new(1, 0)
                }
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Checkers"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Items["AlphaDragger"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Alpha"].Instance,
                    Size = UDim2.new(0, 8, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["AlphaDragger"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIShadow", {
                    Name = "\0",
                    Parent = Items["AlphaDragger"].Instance,
                    BlurRadius = UDim.new(0, 12)
                })                

                Colorpicker.Items = Items
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:Update(IsFromAlpha)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = Color3.fromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()
        
                Items["ColorpickerButton"]:Tween({BackgroundColor3 = Colorpicker.Color})
                Items["Glow"]:Tween({ImageColor3 = Colorpicker.Color})
                Items["Palette"]:Tween({BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)})

                Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Transparency = 1 - Colorpicker.Alpha
                }

                local Red, Green, Blue = math.floor(Colorpicker.Color.R * 255), math.floor(Colorpicker.Color.G * 255), math.floor(Colorpicker.Color.B * 255)
    
                Items["Input"].Instance.Text = tostring(Red)..", "..tostring(Green)..", "..tostring(Blue)
    
                if not IsFromAlpha then 
                    Items["Alpha"]:Tween({BackgroundColor3 = Colorpicker.Color})
                end
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local Debounce = false 
            local ColorpickerWindow = Items["ColorpickerWindow"].Instance
            local ColorpickerButton = Items["ColorpickerButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 
                
                if Colorpicker.IsOpen then 
                    ColorpickerWindow.Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, 0)

                    ColorpickerWindow.Visible = true
                    Items["ColorpickerWindow"]:Tween({Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, 10)})

                    Items["ColorpickerWindow"]:FadeDescendants(true, function()
                        Debounce = false
                    end)

                    for Index, Value in Library.OpenFrames do
                        if Value ~= IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker 
                else
                    Items["ColorpickerWindow"]:Tween({Position = Library:PopupPosition(ColorpickerButton, ColorpickerWindow, -10)})

                    Items["ColorpickerWindow"]:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Colorpicker] then 
                        Library.OpenFrames[Colorpicker] = nil
                    end
                end

                local Descendants = ColorpickerWindow:GetDescendants()
                table.insert(Descendants, ColorpickerWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow + 4 or 1
                    else
                        Value.ZIndex = Colorpicker.IsOpen and Library.ZIndexOrder.ColorpickerWindow or 1
                    end
                end
            end

            Items["ColorpickerWindow"]:VisibleCheck()
    
            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end
    
                local ValueX = math.clamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = math.clamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY
    
                local SlideX = math.clamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.93)
                local SlideY = math.clamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.89)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(SlideX, 0, SlideY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged
    
            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)
    
                Colorpicker.Hue = ValueY
    
                local SlideY = math.clamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.95)
    
                Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, SlideY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end
    
            local SlidingAlpha = false 
            local AlphaChanged
    
            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end
    
                local ValueX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
    
                Colorpicker.Alpha = ValueX
    
                local SlideX = math.clamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.96)
    
                Items["AlphaDragger"]:Tween({Position = UDim2.new(SlideX, 0, 0, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update(true)
            end
    
            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = Color3.fromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = Color3.fromHex(Color)
                else
                    Color = Color -- lul
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  
    
                local PaletteValueX = math.clamp(1 - Colorpicker.Saturation, 0, 0.93)
                local PaletteValueY = math.clamp(1 - Colorpicker.Value, 0, 0.89)
    
                local AlphaPositionX = math.clamp(Colorpicker.Alpha, 0, 0.95)
                    
                local HuePositionY = math.clamp(Colorpicker.Hue, 0, 0.96)
    
                Items["PaletteDragger"]:Tween({Position = UDim2.new(PaletteValueX, 0, PaletteValueY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["HueDragger"]:Tween({Position = UDim2.new(0, 0, HuePositionY, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["AlphaDragger"]:Tween({Position = UDim2.new(AlphaPositionX, 0, 0, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Colorpicker:Update()
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)
    
            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingPalette = true 
    
                    Colorpicker:SlidePalette(Input)
    
                    if PaletteChanged then
                        return
                    end
    
                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false
    
                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)
    
            Items["Hue"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingHue = true 
    
                    Colorpicker:SlideHue(Input)
    
                    if HueChanged then
                        return
                    end
    
                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false
    
                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)
    
            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    SlidingAlpha = true 
    
                    Colorpicker:SlideAlpha(Input)
    
                    if AlphaChanged then
                        return
                    end
    
                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false
    
                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)
    
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then 
                        Colorpicker:SlidePalette(Input)
                    end
    
                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end
    
                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Colorpicker.IsOpen then
                        if Items["ColorpickerWindow"]:IsMouseOverFrame() then 
                            return 
                        end

                        Colorpicker:SetOpen(false)
                    end
                end
            end)

            Items["Input"]:Connect("FocusLost", function()
                local Text = Items["Input"].Instance.Text
                local Red, Green, Blue = Text:match("(%d+),%s*(%d+),%s*(%d+)")

                if not Red or not Green or not Blue then
                    Colorpicker:Set(Colorpicker.Color, Colorpicker.Alpha)
                    return
                end

                Red = tonumber(Red)
                Green = tonumber(Green)
                Blue = tonumber(Blue)
    
                Colorpicker:Set({Red, Green, Blue}, Colorpicker.Alpha)
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end
    
            SetFlags[Colorpicker.Flag] = function(Value, Alpha)
                Colorpicker:Set(Value, Alpha)
            end

            return Colorpicker, Items 
        end

        Library.CreateKeybind = function(Self, Data)
            local Keybind = {
                Flag = Data.Flag,
                IsOpen = false,

                Key = "",
                Mode = "",
                Value = "",

                Toggled = false,
                Picking = false,

                Items = { },
            }

            local Items = { } do
                Items["KeyButtonOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Data.Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 0, 0, 18),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeyButtonOutline"].Instance,
                    PaddingTop = UDim.new(0, 1),
                    PaddingBottom = UDim.new(0, 1),
                    PaddingRight = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 1)
                })
                
                Items["KeyButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["KeyButtonOutline"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "...",
                    AutoButtonColor = false,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Items["KeyButton"].Instance.TextSize = Library.FontSize - 2
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeyButton"].Instance,
                    PaddingRight = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6)
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeyButtonOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })                

                Items["KeybindWindow"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 232, 0, 0),
                    Visible = false,
                    Position = UDim2.new(0, 1106, 0, 506),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({BackgroundColor3 = 'Section'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["KeybindWindow"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
                
                Keybind.Items = Items
            end

            local Debounce = false
            local KeybindWindow = Items["KeybindWindow"].Instance
            local KeyButton = Items["KeyButton"].Instance

            local IsSettings = Data.Section and Data.Section.IsSettings

            local KeyObject 

            if Library.KeyList and not Data.IgnoreKeybindList then 
                KeyObject = Library.KeyList:Add("", "")
            end

            local function IsUnboundKey(Key)
                local KeyString = tostring(Key or "")
                return Key == nil
                    or KeyString == ""
                    or KeyString == "None"
                    or KeyString == "Backspace"
                    or KeyString == "Enum.KeyCode.Backspace"
            end

            local function SetUnboundKey()
                Keybind.Key = ""
                Keybind.Value = "..."
                Items["KeyButton"].Instance.Text = "..."
            end

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Keybind.IsOpen = Bool

                Debounce = true 
                
                if Keybind.IsOpen then 
                    KeybindWindow.Visible = true
                    KeybindWindow.Position = Library:PopupPosition(KeyButton, KeybindWindow, 0)

                    Items["KeybindWindow"]:Tween({Position = Library:PopupPosition(KeyButton, KeybindWindow, 10)})
                    
                    Items["KeybindWindow"]:FadeDescendants(true, function()
                        Debounce = false 
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    Items["KeybindWindow"]:Tween({Position = Library:PopupPosition(KeyButton, KeybindWindow, -10)})

                    Items["KeybindWindow"]:FadeDescendants(false, function()
                        Debounce = false
                    end)

                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end
                end

                local Descendants = KeybindWindow:GetDescendants()
                table.insert(Descendants, KeybindWindow)

                for Index, Value in Descendants do 
                    if Value.ClassName:find("UI") then
                        continue
                    end

                    if IsSettings then 
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow or 1
                    else
                        Value.ZIndex = Keybind.IsOpen and Library.ZIndexOrder.KeybindWindow + 1 or 1
                    end
                end
            end

            Items["KeybindWindow"]:VisibleCheck()

            local Update = function()
                if not KeyObject then return end 
                
                if Keybind.Mode == "Hold" then 
                    KeyObject:Set(Data.Name, Keybind.Toggled and "Holding" or "Off")
                else
                    KeyObject:Set(Data.Name, Keybind.Toggled and "On" or "Off")
                end
            end
    
            function Keybind:SetMode()
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            local ModeDropdown = Library:Dropdown({
                Name = "Mode",
                Flag = Keybind.Flag .. "ModeDropdown",
                Parent = Items["KeybindWindow"],
                Window = "",
                Items = { "Toggle", "Hold", "Always" },
                Default = "Toggle",
                Callback = function(Value)
                    Keybind.Mode = Value

                    Keybind:SetMode()

                    if Value == "Always" then 
                        Keybind:Press(true)
                    end
                end
            })

            local ResetButton = Library:Button({
                Name = "Reset",
                Parent = Items["KeybindWindow"],
                Window = "",
                Callback = function()
                    if Data.Default then 
                        Keybind:Set({
                            Mode = Data.Mode or "Toggle",
                            Key = Data.Default,
                        })
                    end
                end
            })

            if KeyObject then
                local ShowInKeybindsList = Library:Toggle({
                    Name = "Show in Keybinds List",
                    Flag = Keybind.Flag .. "ShowInKeybindsList",
                    Window = "",
                    Parent = Items["KeybindWindow"],
                    Default = true,
                    Callback = function(Value)
                        if KeyObject then 
                            KeyObject:SetVis(Value)
                        end
                    end
                })
            end
    
            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end
    
                Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end
    
            function Keybind:Set(Key)
                if string.find(tostring(Key), "Enum") then 
                    if IsUnboundKey(Key) then
                        SetUnboundKey()

                        Flags[Keybind.Flag] = {
                            Mode = Keybind.Mode,
                            Key = Keybind.Key,
                            Toggled = Keybind.Toggled
                        }

                        if Data.Callback then 
                            Library:SafeCall(Data.Callback, Keybind.Toggled)
                        end

                        Update()
                        Keybind.Picking = false
                        return
                    end

                    Keybind.Key = tostring(Key)
    
                    Key = Key.Name
    
                    local KeyString = Keys[Keybind.Key] or string.gsub(Key, "Enum.", "") or "..."
                    local TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "..."
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay
    
                    Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif type(Key) == "table" then
                    local RealKey = Key.Key
                    local IsUnbound = IsUnboundKey(RealKey)
                    Keybind.Key = IsUnbound and "" or tostring(RealKey)
    
                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode("Toggle")
                    end
    
                    local TextToDisplay
                    if IsUnbound then
                        TextToDisplay = "..."
                    else
                        local KeyString = Keys[Keybind.Key] or string.gsub(tostring(RealKey), "Enum.", "") or RealKey
                        TextToDisplay = KeyString and string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "..."
                        TextToDisplay = string.gsub(string.gsub(KeyString, "KeyCode.", ""), "UserInputType.", "")
                    end
    
                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif table.find({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)
    
                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Keybind.Picking = false
            end
    
            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 
    
                Items["KeyButton"].Instance.Text = ". . ."
    
                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then 
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end
    
                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)
    
            Library:Connect(UserInputService.InputBegan, function(Input, GPE)
                if Keybind.Key == "" or Keybind.Value == "..." then
                    return
                end
    
                if not GPE then
                    if tostring(Input.KeyCode) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    elseif tostring(Input.UserInputType) == Keybind.Key then
                        if Keybind.Mode == "Toggle" then 
                            Keybind:Press()
                        elseif Keybind.Mode == "Hold" then 
                            Keybind:Press(true)
                        elseif Keybind.Mode == "Always" then 
                            Keybind:Press(true)
                        end
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
                    if Keybind.IsOpen then
                        if not Items["KeybindWindow"]:IsMouseOverFrame() and not ModeDropdown.Items.OptionHolder:IsMouseOverFrame() then
                            Keybind:SetOpen(false)
                        end
                    end
                end
            end)
    
            Library:Connect(UserInputService.InputEnded, function(Input, GPE)
                if GPE then
                    return
                end

                if Keybind.Key == "" or Keybind.Value == "..." then
                    return
                end
    
                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)
    
            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)
    
            Keybind:Set({
                Mode = Data.Mode or "Toggle",
                Key = Data.Default,
            })
    
            SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

        Library.Watermark = function(Self, Params)
            Params = Params or { }

            local Watermark = {
                Name = Params.Name or Params.name or "Watermark",
                _LayoutOrder = 2,

                Items = { }
            }

            local Items = { } do 
                Items["Watermark"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 20),
                    Size = UDim2.new(0, 100, 0, 40),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({BackgroundColor3 = 'Section'})
                
                Items["Watermark"]:MakeDraggable()
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    TopLeftRadius = UDim.new(0, 12),
                    TopRightRadius = UDim.new(0, 12),
                    BottomRightRadius = UDim.new(0, 12),
                    BottomLeftRadius = UDim.new(0, 12)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Items["Logo"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Fit,
                    Size = UDim2.new(0, 30, 0, 30),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Self.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, 0),
                    LayoutOrder = 1,
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})

                local function GetWatermarkTitle()
                    return GetBrandTitleText(Watermark.Name)
                end
                
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Watermark"].Instance,
                    RichText = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = GetWatermarkTitle(),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 40, 0.5, -1),
                    AutomaticSize = Enum.AutomaticSize.XY,
                    LayoutOrder = 2
                }):AddToTheme({
                    TextColor3 = 'Text',
                    Text = GetWatermarkTitle
                })

                Items["Title"].Instance.TextSize = Library.FontSize + 4
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Title"].Instance,
                    PaddingBottom = UDim.new(0, 2)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, -12),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                SetGuiTreeZIndex(Items["Watermark"].Instance, 0)
                Watermark.Items = Items
            end

            Self.Watermark = Watermark

            function Watermark:Add(Text)
                Watermark._LayoutOrder += 1
                local SeparatorOrder = Watermark._LayoutOrder
                Watermark._LayoutOrder += 1
                local TextOrder = Watermark._LayoutOrder

                local Separator = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Watermark"].Instance,
                    Size = UDim2.new(0, 1, 1, -25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"],
                    LayoutOrder = SeparatorOrder
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                local NewItem = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Watermark"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Text,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    LayoutOrder = TextOrder
                }):AddToTheme({TextColor3 = 'Text'})

                SetGuiTreeZIndex(Separator.Instance, 0)
                SetGuiTreeZIndex(NewItem.Instance, 0)

                function NewItem:SetText(Text)
                    NewItem.Instance.Text = tostring(Text)
                end

                function NewItem:SetVisibility(Bool)
                    NewItem.Instance.Visible = Bool
                end

                return NewItem
            end

            function Watermark:SetText(Text)
                Watermark.Name = tostring(Text)
                Items["Title"].Instance.Text = GetWatermarkTitle()
            end

            function Watermark:SetVisibility(Bool)
                Items["Watermark"].Instance.Visible = Bool
            end

            function Watermark:Center()
                local AbsPos = Items["Watermark"].Instance.AbsolutePosition
                Items["Watermark"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["Watermark"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            Watermark:Center()

            return setmetatable(Watermark, Library)
        end

        Library.KeybindList = function(Self, Params)
            Params = Params or { }

            local KeybindList = {
                Name = Params.Name or Params.name or "Keybind List",

                Items = { }
            }

            local Items = { } do 
                Items["KeybindList"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                })
                
                Items["KeybindList"]:MakeDraggable()
                
                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    Size = UDim2.new(0, 225, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    RichText = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = KeybindList.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    Size = UDim2.new(0, 18, 0, 18),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "keybind-list-icon",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -6, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Icon"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.699999988079071,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["KeybindList"].Instance,
                    Size = UDim2.new(1, 0, 0, 50),
                    Position = UDim2.new(0, 0, 0, 35),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({BackgroundColor3 = 'Section'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, 0),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                SetGuiTreeZIndex(Items["KeybindList"].Instance, 0)
                KeybindList.Items = Items 
            end

            Library.KeyList = KeybindList

            local KeybindTweenInfo = TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

            function KeybindList:SetVisibility(Bool)
                Items["KeybindList"].Instance.Visible = Bool
            end

            function KeybindList:SetText(Text)
                Items["Title"].Instance.Text = Text
            end

            function KeybindList:Center()
                local AbsPos = Items["KeybindList"].Instance.AbsolutePosition
                Items["KeybindList"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["KeybindList"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function KeybindList:Add(Name, Mode)
                local KeyItems = { } do 
                    KeyItems["NewKey"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Content"].Instance,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 209, 0, 15),
                        BorderSizePixel = 0
                    })
                    
                    KeyItems["Text"] = Library:Create("TextLabel", {
                        Name = "Text",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = KeyItems["NewKey"].Instance,
                        TextColor3 = Library.Theme["Inactive Text"],
                        Text = Name,
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0.5, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.XY
                    }):AddToTheme({TextColor3 = 'Inactive Text'})
                    
                    KeyItems["Status"] = Library:Create("TextLabel", {
                        Name = "Status",
                        FontFace = Library.Font,
                        TextSize = Library.FontSize,
                        Parent = KeyItems["NewKey"].Instance,
                        TextColor3 = Library.Theme["Inactive Text"],
                        Text = Mode,
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, 0, 0.5, 0),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.None
                    }):AddToTheme({TextColor3 = 'Inactive Text'})

                    KeyItems["Glow"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = KeyItems["Status"].Instance,
                        ImageColor3 = Library.Theme["Accent"],
                        ScaleType = Enum.ScaleType.Slice,
                        ImageTransparency = 1,
                        Size = UDim2.new(1, 10, 1, 10),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = "ui-glow",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        BorderSizePixel = 0,
                        SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                    }):AddToTheme({ImageColor3 = 'Accent'})                    
                end                    

                SetGuiTreeZIndex(KeyItems["NewKey"].Instance, 0)

                local CanShow = true

                function KeyItems:ToggleState(Bool)
                    if Bool then 
                        KeyItems["Status"]:ChangeItemTheme({TextColor3 = 'Accent'})
                        KeyItems["Status"]:Tween({TextColor3 = Library.Theme["Accent"]})

                        KeyItems["Glow"]:Tween({ImageTransparency = 0.7})

                        KeyItems["Text"]:ChangeItemTheme({TextColor3 = 'Text'})
                        KeyItems["Text"]:Tween({TextColor3 = Library.Theme["Text"]})
                    else
                        KeyItems["Status"]:ChangeItemTheme({TextColor3 = 'Inactive Text'})
                        KeyItems["Status"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})

                        KeyItems["Glow"]:Tween({ImageTransparency = 1})

                        KeyItems["Text"]:ChangeItemTheme({TextColor3 = 'Inactive Text'})
                        KeyItems["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                    end
                end

                function KeyItems:Set(Name, Mode)
                    local State = string.lower(tostring(Mode))
                    local DisplayMode = State == "holding" and "Holding" or State == "on" and "On" or "Off"
                    KeyItems._SetSerial = (KeyItems._SetSerial or 0) + 1
                    local SetSerial = KeyItems._SetSerial

                    if State == "holding" then 
                        KeyItems:ToggleState(true)

                        KeyItems["Status"]:Tween({Size = UDim2.fromOffset(46, 14)})
                    elseif State == "on" or State == "off" then
                        if State == "on" then
                            KeyItems:ToggleState(true)
                        else
                            KeyItems:ToggleState(false)
                        end

                        KeyItems["Status"]:Tween({Size = UDim2.fromOffset(18, 14)})
                    end

                    KeyItems["Text"].Instance.Text = Name
                    KeyItems["Status"]:Tween({TextTransparency = 1})
                    task.delay(0.1, function()
                        if KeyItems._SetSerial ~= SetSerial or not KeyItems["Status"].Instance.Parent then
                            return
                        end

                        KeyItems["Status"].Instance.Text = DisplayMode
                        KeyItems["Status"]:Tween({TextTransparency = 0})
                    end)
                end

                function KeyItems:SetVis(Bool)
                    KeyItems["NewKey"].Instance.Visible = Bool
                end

                return KeyItems
            end

            return setmetatable(KeybindList, Library)
        end

        local NotifTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

        Library.Notification = function(Self, Params)
            Params = Params or { }

            local Name = Params.Name or Params.name
            if not Name and Params.Title and Params.Message then
                Name = `{Params.Title}: {Params.Message}`
            end

            local Notification = {
                Name = Name or Params.Message or Params.Title or "Notification",
                Duration = Params.Duration or Params.duration or 5,
                Color = Params.Color or Params.color or Color3.fromRGB(255, 255, 255),

                Items = { },
                Removing = false
            }

            local Padding = 12
            local Spacing = 10
            local TopPadding = 0

            local UpdatePositions = function()
                local Y = Padding + TopPadding
            
                for _, Notif in Library.Notifications do
                    local Frame = Notif.Items["Notification"].Instance
                    local Height = Frame.AbsoluteSize.Y
                    local Width = Frame.AbsoluteSize.X
            
                    Notif.Items["Notification"]:Tween({Position = UDim2.new(1, -(Width + Padding), 0, Y)}, NotifTweenInfo)
            
                    Y += Height + Spacing
                end
            end

            local Items = { } do 
                Items["Notification"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    Position = UDim2.new(1, 100, 0, 117),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({BackgroundColor3 = 'Section'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 25),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Notification"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Notification.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Notification"].Instance,
                    AnchorPoint = Vector2.new(1, 1),
                    Position = UDim2.new(1, 0, 1, 16),
                    Size = UDim2.new(1, 0, 0, 6),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Notification.Color
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    ImageColor3 = Notification.Color,
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.699999988079071,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Glow"].Instance,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(111, 111, 111))
                }
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(111, 111, 111))
                }
                })                           

                Notification.Items = Items 
            end

            table.insert(Library.Notifications, 1, Notification)
        
            task.wait()
        
            local Width = Items["Notification"].Instance.AbsoluteSize.X
        
            Items["Notification"].Instance.Size = UDim2.new(0, Width, 0, Items["Notification"].Instance.AbsoluteSize.Y)
        
            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.None
            Items["Notification"].Instance.BackgroundTransparency = 1
        
            for _, Value in Items["Notification"].Instance:GetDescendants() do
                if Value:IsA("TextLabel") then
                    Value.TextTransparency = 1
                elseif Value:IsA("Frame") then
                    Value.BackgroundTransparency = 1
                elseif Value:IsA("UIStroke") then
                    Value.Transparency = 1
                end
            end
        
            UpdatePositions()
            Items["Notification"]:TweenDescendants(0)
            
            task.spawn(function()
                Items["Liner"]:Tween({Size = UDim2.new(0, 0, 0, 6)}, TweenInfo.new(Notification.Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))
                local Start = tick()
        
                while tick() - Start < Notification.Duration and not Notification.Removing do
                    task.wait(0.05)
                end
        
                if Notification.Removing then
                    return
                end
        
                Notification.Removing = true
        
                for Index, Value in Library.Notifications do
                    if Value == Notification then
                        table.remove(Library.Notifications, Index)
                        break
                    end
                end
        
                Items["Notification"]:Tween({Position = UDim2.new(1, Width + Padding, Items["Notification"].Instance.Position.Y.Scale, Items["Notification"].Instance.Position.Y.Offset)}, NotifTweenInfo)
        
                Items["Notification"]:TweenDescendants(1)
        
                task.delay(0.35, function()
                    Items["Notification"].Instance:Destroy()
                    UpdatePositions()
                end)
            end)
        
            return Notification
        end

        Library.Window = function(Self, Params)
            Params = Params or { }
            Self._Exited = false
            Self._InterfaceReady = false
            Self.Holder.Instance.Enabled = false

            local Window = {
                Name = Params.Name or Params.name or "Window",
                Logo = Params.Logo or Params.logo or "window-logo-default",

                IsOpen = true,
                Pages = { },
                Current = nil,
                Items = { }
            }

            local Items = { } do 
                if IsMobile then 
                    Library:Create("UIScale", {
                        Parent = Library.Holder.Instance,
                        Scale = 0.7
                    })
                end

                Items["MainFrame"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.Holder.Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 0,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 800, 0, 480),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                }):AddToTheme({BackgroundColor3 = 'Background'})
                
                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2.new(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y))

                -- you can uncomment this if you would ever want a blur.
                --Items["MainFrame"]:MakeBlurred(Window)
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    TopLeftRadius = UDim.new(0, 12),
                    TopRightRadius = UDim.new(0, 12),
                    BottomRightRadius = UDim.new(0, 12),
                    BottomLeftRadius = UDim.new(0, 12)
                })
                
                Items["Side"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    ClipsDescendants = true,
                    Size = UDim2.new(0, 80, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    TopLeftRadius = UDim.new(0, 12),
                    TopRightRadius = UDim.new(0, 0),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 12)
                })
                
                Items["AvatarOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 1, -15),
                    Size = UDim2.new(0, 50, 0, 50),
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["AvatarOutline"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["AvatarOutline"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = Color3.fromRGB(24, 26, 30),
                    Thickness = 1.5
                })
                
                Library:Thread(function()
                    Items["Avatar"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Items["AvatarOutline"].Instance,
                        Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 3, 0, 3),
                        Size = UDim2.new(1, -6, 1, -6),
                        BorderSizePixel = 0
                    })
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["Avatar"].Instance,
                        TopLeftRadius = UDim.new(1, 0),
                        TopRightRadius = UDim.new(1, 0),
                        BottomRightRadius = UDim.new(1, 0),
                        BottomLeftRadius = UDim.new(1, 0)
                    })
                    
                    Items["StatusOutline"] = Library:Create("Frame", {
                        Name = "\0",
                        Parent = Items["Avatar"].Instance,
                        AnchorPoint = Vector2.new(1, 1),
                        Position = UDim2.new(1, 0, 1, 0),
                        Size = UDim2.new(0, 15, 0, 15),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Inline"]
                    }):AddToTheme({BackgroundColor3 = 'Inline'})
                    
                    Library:Create("UICorner", {
                        Name = "\0",
                        Parent = Items["StatusOutline"].Instance,
                        TopLeftRadius = UDim.new(1, 0),
                        TopRightRadius = UDim.new(1, 0),
                        BottomRightRadius = UDim.new(1, 0),
                        BottomLeftRadius = UDim.new(1, 0)
                    })
                    
                    Items["Status"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Items["StatusOutline"].Instance,
                        ImageColor3 = Color3.fromRGB(43, 255, 103),
                        Size = UDim2.new(0, 12, 0, 12),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = "online-status-dot",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0
                    })
                    
                    Items["Glow"] = Library:Create("ImageLabel", {
                        Name = "\0",
                        Parent = Items["Status"].Instance,
                        ImageColor3 = Color3.fromRGB(43, 255, 103),
                        ScaleType = Enum.ScaleType.Slice,
                        ImageTransparency = 0.699999988079071,
                        Size = UDim2.new(1, 20, 1, 20),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Image = "ui-glow",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        BorderSizePixel = 0,
                        SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                    })
                end)
                
                Items["Pages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 15, 0, 15),
                    Size = UDim2.new(1, -30, 1, -95),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Pages"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Top"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    Position = UDim2.new(0, 80, 0, 0),
                    Size = UDim2.new(1, -80, 0, 50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                }):AddToTheme({BackgroundColor3 = 'Inline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, 12),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0)
                })
                
                Items["Logo"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Fit,
                    Size = UDim2.new(0, 30, 0, 30),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Window.Logo,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 4, 0.5, 4),
                    ZIndex = 3,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})

                local function GetHeaderTitle()
                    return GetBrandTitleText(Window.Name)
                end

                Items["Title"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Top"].Instance,
                    RichText = true,
                    TextColor3 = Library.Theme["Text"],
                    Text = GetHeaderTitle(),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 22, 0.5, 3),
                    AutomaticSize = Enum.AutomaticSize.XY,
                    ZIndex = 3
                }):AddToTheme({
                    TextColor3 = 'Text',
                    Text = GetHeaderTitle
                })

                Items["Title"].Instance.TextSize = Library.FontSize + 4
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["MainFrame"].Instance,
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Position = UDim2.new(0, 80, 0, 50),
                    Size = UDim2.new(1, -80, 1, -50),
                    BorderSizePixel = 0
                })

                Items["PageLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Side"].Instance,
                    Position = UDim2.new(0, -4, 0, 28),
                    Size = UDim2.new(0, 6, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["PageLiner"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["PageLiner"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.699999988079071,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})          
                
                Items["Search"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Top"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 100, 0, 30),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Color3.fromRGB(24, 26, 30)
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Search"].Instance
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Search"].Instance,
                    ImageColor3 = Library.Theme["Inactive Text"],
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "search-icon",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -8, 0.5, 0),
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Inactive Text'})
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Search"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    Size = UDim2.new(0, 0, 0, 14),
                    Position = UDim2.new(1, -38, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    AutomaticSize = Enum.AutomaticSize.X,
                    PlaceholderText = "Search.."
                }):AddToTheme({PlaceholderColor3 = 'Inactive Text', TextColor3 = 'Text'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Search"].Instance
                })                

                Window.Items = Items
            end

            local Debounce = false

            function Window:SetOpen(Bool)
                if Debounce then 
                    return 
                end

                Debounce = true 

                Window.IsOpen = Bool
                if Library.BackgroundButton then
                    Library.BackgroundButton.Instance.Visible = Bool and Library._InterfaceReady == true
                end

                Items["MainFrame"]:FadeDescendants(Bool, function()
                    Debounce = false
                end)

                for Index, Value in Library.OpenFrames do 
                    Value:SetOpen(false)
                end
            end

            function Window:Center()
                local AbsPos = Items["MainFrame"].Instance.AbsolutePosition
                Items["MainFrame"].Instance.AnchorPoint = Vector2.new(0, 0)
                task.wait()
                Items["MainFrame"].Instance.Position = UDim2.new(0, AbsPos.X, 0, AbsPos.Y + GuiInset)
            end

            function Window:UpdateAccent(Page)
                local PageObject = Page.Items["Inactive"].Instance
                
                local TabCenterY = PageObject.AbsolutePosition.Y + (PageObject.AbsoluteSize.Y / 2)
                local LocalY = TabCenterY - Items["MainFrame"].Instance.AbsolutePosition.Y

                Items["PageLiner"]:Tween({Position = UDim2.new(0, -4, 0, LocalY - 12)}, TweenInfo.new(0.65, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out))
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    if UserInputService:GetFocusedTextBox() then
                        return
                    end

                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window.SearchQuery = ""

            local Normalize = function(Text)
                return string.lower(tostring(Text or "")):gsub("%s+", "")
            end

            local GetSearchPage = function()
                local Page = Window.Current

                if Page and Page.Current then
                    return Page.Current
                end

                return Page
            end

            local CacheObjects = function(Holder)
                local FadeObjects = { }

                local Objects = Holder:GetDescendants()
                table.insert(Objects, Holder)

                for _, Object in Objects do
                    local Properties = Library:GetTweenProperty(Object)

                    if Properties then
                        if type(Properties) ~= "table" then
                            Properties = { Properties }
                        end

                        local Original = { }

                        for _, Property in Properties do
                            Original[Property] = Object[Property]
                        end

                        table.insert(FadeObjects, {
                            Object = Object,
                            Properties = Properties,
                            Original = Original
                        })
                    end
                end

                return FadeObjects
            end

            function Window:RegisterSearchItem(Data)
                Data = Data or {}

                local SearchItem = {
                    Name = Data.Name or Data.name or "",
                    Page = Data.Page or Data.page,
                    Instance = Data.Instance or Data.instance,
                    Holder = Data.Holder or Data.holder or Data.Instance or Data.instance,
                    OriginalSize = nil,
                    Visible = true,
                }

                if SearchItem.Holder then
                    SearchItem.OriginalSize = SearchItem.Holder.Size
                    SearchItem.FadeObjects = CacheObjects(SearchItem.Holder)
                end

                table.insert(Library.SearchItems, SearchItem)
                return SearchItem
            end

            function Window:RefreshSearch() -- gay as  hell
                local Query = Normalize(Window.SearchQuery)

                for Index, Item in Library.SearchItems do
                    if Item.Page ~= GetSearchPage() then
                        continue
                    end

                    local Holder = Item.Holder

                    if not Holder then
                        continue
                    end

                    local Matched = Query == "" or Normalize(Item.Name):find(Query, 1, true) ~= nil

                    if Matched and not Item.Visible then
                        Item.Visible = true
                        Item.SearchToken = (Item.SearchToken or 0) + 1

                        Holder.Visible = true
                        Holder.Size = UDim2.new(Item.OriginalSize.X.Scale, Item.OriginalSize.X.Offset, 0, 0)

                        for Index, Value in Item.FadeObjects do
                            local TweenData = { }

                            for _, Property in Value.Properties do
                                Value.Object[Property] = 1
                                TweenData[Property] = Value.Original[Property]
                            end

                            Library:Tween(TweenData, nil, Value.Object)
                        end

                        Library:Tween({Size = Item.OriginalSize}, nil, Holder)
                    elseif not Matched and Item.Visible then
                        Item.Visible = false
                        Item.SearchToken = (Item.SearchToken or 0) + 1

                        local Token = Item.SearchToken

                        for Index, Value in Item.FadeObjects do
                            local TweenData = { }

                            for _, Property in Value.Properties do
                                TweenData[Property] = 1
                            end

                            Library:Tween(TweenData, nil, Value.Object)
                        end

                        Library:Tween({Size = UDim2.new(Item.OriginalSize.X.Scale, Item.OriginalSize.X.Offset, 0, 0)}, nil, Holder)

                        task.delay(Library.Animation.Time + 0.03, function()
                            if Item.SearchToken == Token and not Item.Visible then
                                Holder.Visible = false
                            end
                        end)
                    end
                end
            end

            Items["Input"]:Connect("Changed", function(Property)
                if Property == "Text" then
                    Items["Search"]:Tween({Size = UDim2.new(0, Items["Input"].Instance.TextBounds.X + 50, 0, 30)})
                    Window.SearchQuery = Items["Input"].Instance.Text
                    Window:RefreshSearch()
                end
            end)

            Window:Center()
            return setmetatable(Window, Library)
        end

        Library.Page = function(Self, Params)
            Params = Params or { }

            local Page = {
                Icon = Params.Icon or Params.icon or "",

                Window = Self,
                Pages = { },
                Items = { },
                Active = false,
                Current = nil,
                Debounce = false
            }

            local Items = { } do 
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Window.Items["Pages"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 0.800000011920929,
                    Size = UDim2.new(0, 50, 0, 50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    TopLeftRadius = UDim.new(0, 10),
                    TopRightRadius = UDim.new(0, 10),
                    BottomRightRadius = UDim.new(0, 10),
                    BottomLeftRadius = UDim.new(0, 10)
                })
                
                Items["Inline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inactive"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 0.800000011920929,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(24, 26, 30)
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    TopLeftRadius = UDim.new(0, 10),
                    TopRightRadius = UDim.new(0, 10),
                    BottomRightRadius = UDim.new(0, 10),
                    BottomLeftRadius = UDim.new(0, 10)
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ImageColor3 = Library.Theme["Inactive Text"],
                    Size = UDim2.new(0, 24, 0, 24),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Inactive Text'})
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Icon"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})                

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Items["Columns"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Position = UDim2.new(0, 0, 0, 40),
                    Size = UDim2.new(1, 0, 1, -40),
                    BorderSizePixel = 0
                })                

                Items["SubPages"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -20, 0, 30),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubPages"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Page.Items = Items
            end

            if Page.Window._HideNewPages then
                Items["Inactive"].Instance.Visible = false
            end

            Items["Inactive"]:OnHover(function()
                if Page.Active then return end

                Items["Inactive"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Icon"]:Tween({ImageColor3 = Library.Theme.Text})
            end, function()
                if Page.Active then return end

                Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})
                Items["Inactive"]:Tween({BackgroundColor3 = Library.Theme["Tab"]})
            end)

            function Page:Turn()
                local Old = Page.Window.Current 

                if Old == Page then 
                    return 
                end

                if Old then 
                    Old.Items["Icon"]:ChangeItemTheme({ImageColor3 = "Inactive Text"})
                    Old.Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})

                    Old.Items["Glow"]:Tween({ImageTransparency = 1})
    
                    Old.Items["Inline"]:Tween({BackgroundTransparency = 0.6})

                    Old.Items["Inactive"]:Tween({BackgroundTransparency = 0.6})

                    Old.Items["Page"].Instance.Visible = false
                    Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance

                    Old.Active = false
                end

                Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                Items["Page"].Instance.Visible = true

                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                Items["Icon"]:Tween({ImageColor3 = Library.Theme.Accent})

                Items["Inactive"]:Tween({BackgroundTransparency = 0})
                Items["Inline"]:Tween({BackgroundTransparency = 0})

                Items["Glow"]:Tween({ImageTransparency = 0.7})

                Page.Window:UpdateAccent(Page)
                Page.Window.Current = Page
                Page.Active = true

                if Page.Window.RefreshSearch then
                    Page.Window:RefreshSearch()
                end
            end

            Items["Inline"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn()
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.SubPage = function(Self, Params)
            Params = Params or { }

            local Page = {
                Name = Params.Name or Params.name or "Subpage",

                Window = Self.Window,
                Page = Self,
                ColumnsData = { },
                Items = { },
                Active = false,
                Debounce = false
            }

            local Items = { } do 
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Page.Items["SubPages"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 50, 0, 30),
                    BackgroundTransparency = 0.6000000238418579,
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Items["Inline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inactive"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 0.6000000238418579,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(24, 26, 30)
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inline"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Page.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    PaddingRight = UDim.new(0, 10)
                })
                
                Items["PageLiner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -4, 0.5, 0),
                    Size = UDim2.new(0, 6, 0, -15),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["PageLiner"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["PageLiner"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})                  

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 0),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["MiddleColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["MiddleColumn"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 0),
                    PaddingLeft = UDim.new(0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["MiddleColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["MiddleColumn"]
                Page.ColumnsData[3] = Items["RightColumn"]

                Page.Items = Items
            end

            Items["Inactive"]:OnHover(function()
                if Page.Active then return end

                Items["Inactive"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Text"]:Tween({TextColor3 = Library.Theme.Text})
            end, function()
                if Page.Active then return end

                Items["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                Items["Inactive"]:Tween({BackgroundColor3 = Library.Theme["Tab"]})
            end)

            function Page:Turn()
                local Old = Page.Page.Current 

                if Old == Page then 
                    return 
                end

                if Old then 
                    Old.Items["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                    Old.Items["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"], Position = UDim2.new(0, 8, 0.5, 0)})

                    Old.Items["Glow"]:Tween({ImageTransparency = 1})
                    Old.Items["PageLiner"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 6, 0, -15)})
    
                    Old.Items["Inline"]:Tween({BackgroundTransparency = 0.6})

                    Old.Items["Inactive"]:Tween({BackgroundTransparency = 0.6})

                    Old.Items["Page"].Instance.Visible = false
                    Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance

                    Old.Active = false
                end

                Items["Page"].Instance.Parent = Page.Page.Items["Columns"].Instance
                Items["Page"].Instance.Visible = true

                Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                Items["Text"]:Tween({TextColor3 = Library.Theme.Text, Position = UDim2.new(0, 10, 0.5, 0)})

                Items["Inactive"]:Tween({BackgroundTransparency = 0})
                Items["Inline"]:Tween({BackgroundTransparency = 0})

                Items["Glow"]:Tween({ImageTransparency = 0.7})

                Items["PageLiner"]:Tween({BackgroundTransparency = 0, Size = UDim2.new(0, 6, 1, -15)})

                Page.Page.Current = Page
                Page.Active = true

                if Page.Window.RefreshSearch then
                    Page.Window:RefreshSearch()
                end
            end

            Items["Inline"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Page.Pages == 0 then 
                Page:Turn()
            end

            table.insert(Page.Page.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.IndividualPage = function(Self, Params)
            Params = Params or { }

            local Page = {
                Icon = Params.Icon or Params.icon or "",

                Window = Self,
                ColumnsData = { },
                Items = { },
                Active = false,
                Debounce = false
            }

            local Items = { } do 
                Items["Inactive"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Page.Window.Items["Pages"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 0.800000011920929,
                    Size = UDim2.new(0, 50, 0, 50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inactive"].Instance,
                    TopLeftRadius = UDim.new(0, 10),
                    TopRightRadius = UDim.new(0, 10),
                    BottomRightRadius = UDim.new(0, 10),
                    BottomLeftRadius = UDim.new(0, 10)
                })
                
                Items["Inline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inactive"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 0.800000011920929,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(24, 26, 30)
                }):AddToTheme({BackgroundColor3 = 'Tab'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    TopLeftRadius = UDim.new(0, 10),
                    TopRightRadius = UDim.new(0, 10),
                    BottomRightRadius = UDim.new(0, 10),
                    BottomLeftRadius = UDim.new(0, 10)
                })
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ImageColor3 = Library.Theme["Inactive Text"],
                    Size = UDim2.new(0, 24, 0, 24),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Inactive Text'})
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Icon"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})                

                Items["Page"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Library.UnusedHolder.Instance,
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Visible = false,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Items["LeftColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 0),
                    PaddingLeft = UDim.new(0, 10)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["LeftColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["MiddleColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["MiddleColumn"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 0),
                    PaddingLeft = UDim.new(0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["MiddleColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["RightColumn"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["Page"].Instance,
                    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.new(0, 0, 0, 0)
                })
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    PaddingTop = UDim.new(0, 10),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 0)
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["RightColumn"].Instance,
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Page.ColumnsData[1] = Items["LeftColumn"]
                Page.ColumnsData[2] = Items["MiddleColumn"]
                Page.ColumnsData[3] = Items["RightColumn"]

                Page.Items = Items
            end

            if Page.Window._HideNewPages then
                Items["Inactive"].Instance.Visible = false
            end

            Items["Inactive"]:OnHover(function()
                if Page.Active then return end

                Items["Inactive"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Icon"]:Tween({ImageColor3 = Library.Theme.Text})
            end, function()
                if Page.Active then return end

                Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})
                Items["Inactive"]:Tween({BackgroundColor3 = Library.Theme["Tab"]})
            end)

            function Page:Turn()
                local Old = Page.Window.Current 

                if Old == Page then 
                    return 
                end

                if Old then 
                    Old.Items["Icon"]:ChangeItemTheme({ImageColor3 = "Inactive Text"})
                    Old.Items["Icon"]:Tween({ImageColor3 = Library.Theme["Inactive Text"]})

                    Old.Items["Glow"]:Tween({ImageTransparency = 1})
    
                    Old.Items["Inline"]:Tween({BackgroundTransparency = 0.6})

                    Old.Items["Inactive"]:Tween({BackgroundTransparency = 0.6})

                    Old.Items["Page"].Instance.Visible = false
                    Old.Items["Page"].Instance.Parent = Library.UnusedHolder.Instance

                    Old.Active = false
                end

                Items["Page"].Instance.Parent = Page.Window.Items["Content"].Instance
                Items["Page"].Instance.Visible = true

                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                Items["Icon"]:Tween({ImageColor3 = Library.Theme.Accent})

                Items["Inactive"]:Tween({BackgroundTransparency = 0})
                Items["Inline"]:Tween({BackgroundTransparency = 0})

                Items["Glow"]:Tween({ImageTransparency = 0.7})

                Page.Window:UpdateAccent(Page)
                Page.Window.Current = Page
                Page.Active = true

                if Page.Window.RefreshSearch then
                    Page.Window:RefreshSearch()
                end
            end

            Items["Inline"]:Connect("MouseButton1Down", function()
                Page:Turn()
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn()
            end

            table.insert(Page.Window.Pages, Page)
            return setmetatable(Page, Library)
        end

        Library.Section = function(Self, Params)
            Params = Params or { } 

            local Section = {
                Name = Params.Name or Params.name or "Section",
                Icon = Params.Icon or Params.icon or "section-default-icon",
                Side = Params.Side or Params.side or 1,

                Window = Self.Window,
                Page = Self,
                Items = { },
            }

            local Items = { } do 
                Items["Section"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Size = UDim2.new(1, 0, 0, 55),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Section"].Instance
                })
                
                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Section"].Instance,
                    Size = UDim2.new(1, 0, 0, 55),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({BackgroundColor3 = 'Section'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Inline"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Section.Name,
                    Position = UDim2.new(0, 10, 0, 10),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["Liner"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    Size = UDim2.new(1, 0, 0, 6),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 3),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Section"]
                }):AddToTheme({BackgroundColor3 = 'Section'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Liner"].Instance,
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.322, 0.5375000238418579),
                    NumberSequenceKeypoint.new(1, 1)
                }
                })
                
                Items["Content"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 38),
                    Size = UDim2.new(1, -20, 0, 0),
                    BorderSizePixel = 0
                })
                
                Items["ContentLayout"] = Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["Content"].Instance,
                    Padding = UDim.new(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    Size = UDim2.new(0, 20, 0, 20),
                    AnchorPoint = Vector2.new(1, 0),
                    Image = Section.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -12, 0, 12),
                    ZIndex = 2,
                    BorderSizePixel = 0
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Icon"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.699999988079071,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})       
                
                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    PaddingBottom = UDim.new(0, 10)
                })                

                Items["Text"].Instance.TextSize = Library.FontSize + 2

                local function UpdateSectionHeight()
                    local ContentHeight = Items["ContentLayout"].Instance.AbsoluteContentSize.Y
                    local SectionHeight = math.max(55, 48 + ContentHeight)

                    Items["Content"].Instance.Size = UDim2.new(1, -20, 0, ContentHeight)
                    Items["Inline"].Instance.Size = UDim2.new(1, 0, 0, SectionHeight)
                    Items["Section"].Instance.Size = UDim2.new(1, 0, 0, SectionHeight)
                end

                Library:Connect(Items["ContentLayout"].Instance:GetPropertyChangedSignal("AbsoluteContentSize"), UpdateSectionHeight)
                task.defer(UpdateSectionHeight)

                Section.Items = Items
            end 

            return setmetatable(Section, Library)
        end

        Library.Divider = function(Self)
            local Divider = Library:Create("Frame", {
                Name = "\0",
                Parent = Self.Items["Content"].Instance,
                BackgroundColor3 = Library.Theme["Outline"],
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 0, 1)
            }):AddToTheme({BackgroundColor3 = "Outline"})

            return Divider
        end

        Library.Colorpicker = function(Self, Params)
            Params = Params or { }
            local Name = Params.Name or Params.name or Params.Text or Params.text or Params.Title or Params.title or "Color"
            local Label = Self:Label({Name = Name})
            return Label:Colorpicker(Params)
        end

        Library.Get = function(Self)
            return Self.Value
        end

        Library.Destroy = function(Self)
            local RootNames = {"Slider", "Label", "Textbox", "Dropdown", "Toggle", "Button"}
            for _, Name in RootNames do
                local Item = Self.Items and Self.Items[Name]
                if Item and Item.Instance then
                    Item.Instance:Destroy()
                    break
                end
            end

            if Self.Flag then
                SetFlags[Self.Flag] = nil
                Flags[Self.Flag] = nil
            end
        end

        Library.Toggle = function(Self, Params)
            Params = Params or { }

            local Toggle = {
                Name = Params.Name or Params.name or Params.Text or Params.text or "Toggle",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name or Params.Text or Params.text),
                Default = Params.Default or Params.default or false,
                Callback = Params.Callback or Params.callback or function() end,

                Window = Params.Window or Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Toggle.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Toggle"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    BorderSizePixel = 0
                })
                
                Items["IndicatorOutline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    Size = UDim2.new(0, 18, 0, 18),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["IndicatorOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Indicator"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["IndicatorOutline"].Instance,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Indicator"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Items["Check"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ImageColor3 = Color3.fromRGB(0, 0, 0),
                    ImageTransparency = 1,
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "toggle-checkmark",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Toggle"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Toggle.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 29, 0.5, -1),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Toggle"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    Padding = UDim.new(0, 6),
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            
                Toggle.Items = Items
            end

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then return end 
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                if Toggle.Value then return end 
                Items["Indicator"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Toggle:Set(Bool)
                Toggle.Value = Bool 

                if Bool then 
                    Items["Inline"]:Tween({BackgroundTransparency = 0, Size = UDim2.new(1, 0, 1, 0)})
                    Items["Check"]:Tween({ImageTransparency = 0})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme.Text})
                    Items["Glow"]:Tween({ImageTransparency = 0.7})
                else
                    Items["Inline"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0)})
                    Items["Check"]:Tween({ImageTransparency = 1})
                    Items["Text"]:ChangeItemTheme({TextColor3 = "Inactive Text"})
                    Items["Text"]:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                    Items["Glow"]:Tween({ImageTransparency = 1})
                end

                Flags[Toggle.Flag] = Bool
                Library:SafeCall(Toggle.Callback, Bool)
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or (Data.Transparency ~= nil and (1 - Data.Transparency)) or 1,

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Data.Text or Data.text or Toggle.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Toggle.Name),
                    Default = if Data.Default ~= nil then Data.Default else Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            if Toggle.Window and Toggle.Window ~= "" then
                Toggle.Window:RegisterSearchItem({
                    Name = Toggle.Name,
                    Page = Toggle.Page,
                    Holder = Items["Toggle"].Instance
                })
            end

            return setmetatable(Toggle, Library)
        end

        Library.Button = function(Self, Params)
            Params = Params or { }

            local Button = {
                Name = Params.Name or Params.name or Params.Text or Params.text or "Button",
                Callback = Params.Callback or Params.callback or function() end,

                Window = Params.Window or Self.Window,
                Page = Self.Page,
                Section = Self,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Button.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Button"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Parent.Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Items["RealButton"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Button"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealButton"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealButton"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Button.Name,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Inline"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Button"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Inline"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})

                Button.Items = Items
            end

            Items["RealButton"]:OnHover(function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealButton"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Button:Press()
                Items["Inline"]:Tween({BackgroundTransparency = 0, Size = UDim2.new(1, 0, 1, 0)})
                Items["Glow"]:Tween({ImageTransparency = 0.7})
                task.wait(0.15)
                Items["Inline"]:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)})
                Items["Glow"]:Tween({ImageTransparency = 1})
                
                Library:SafeCall(Button.Callback)
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            Items["RealButton"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            if Button.Window and Button.Window ~= "" then
                Button.Window:RegisterSearchItem({
                    Name = Button.Name,
                    Page = Button.Page,
                    Holder = Items["Button"].Instance
                })
            end

            return setmetatable(Button, Library)
        end

        Library.Slider = function(Self, Params)
            Params = Params or { }

            local Slider = {
                Name = Params.Name or Params.name or Params.Text or Params.text or "Slider",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name or Params.Text or Params.text),
                Default = Params.Default or Params.default or 0,
                Min = Params.Min or Params.min or 0,
                Max = Params.Max or Params.max or 100,
                Callback = Params.Callback or Params.callback or function() end,
                Decimals = Params.Decimals or Params.decimals or Params.Rounding or Params.rounding or 0,
                Suffix = Params.Suffix or Params.suffix or "",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = 0,
                Sliding = false,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Slider.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Slider"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 33),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealSliderOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealSliderOutline"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["RealSlider"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealSliderOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["Accent"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["RealSlider"].Instance,
                    Size = UDim2.new(0.5, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["Glow"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 0.699999988079071,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Glow"].Instance,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(111, 111, 111))
                }
                })
                
                Library:Create("UIGradient", {
                    Name = "\0",
                    Parent = Items["Accent"].Instance,
                    Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(111, 111, 111))
                }
                })
                
                Items["Dragger"] = Library:Create("Frame", {
                    Name = "\0",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Items["RealSlider"].Instance,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                    ZIndex = 2,
                    BorderSizePixel = 0
                })
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Dragger"].Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Slider"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "%50",
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})                

                Slider.Items = Items 
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealSlider"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Slider:Set(Value)
                Value = tonumber(Value)
                if not Value or Value ~= Value then
                    Value = Slider.Default
                end

                if not Value or Value ~= Value then
                    Value = Slider.Min
                end

                Slider.Value = Library:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Decimals)

                local Range = Slider.Max - Slider.Min
                local Percent = Range ~= 0 and math.clamp((Slider.Value - Slider.Min) / Range, 0, 1) or 0

                Items["Accent"]:Tween({Size = UDim2.new(Percent, 0, 1, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                Items["Value"].Instance.Text = string.format("%s%s", Slider.Value, Slider.Suffix)

                Items["Dragger"]:Tween({Position = UDim2.new(Percent, (12 / 2) - (Percent * 12), 0.5, 0)}, TweenInfo.new(Library.Animation.Time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))

                Flags[Slider.Flag] = Slider.Value
                Library:SafeCall(Slider.Callback, Slider.Value)
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:GetSize(Input)
                local AbsoluteSizeX = Items["RealSlider"].Instance.AbsoluteSize.X
                if AbsoluteSizeX <= 0 then
                    return Slider.Value
                end

                local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / AbsoluteSizeX
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                return Value
            end

            function Slider:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            local InputChanged 
            
            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local Value = Slider:GetSize(Input)

                    Slider:Set(Value)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local Value = Slider:GetSize(Input)

                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default)

            SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            if Slider.Window then
                Slider.Window:RegisterSearchItem({
                    Name = Slider.Name,
                    Page = Slider.Page,
                    Holder = Items["Slider"].Instance
                })
            end

            return setmetatable(Slider, Library)
        end

        Library.Dropdown = function(Self, Params)
            Params = Params or { }

            local Dropdown = {
                Name = Params.Name or Params.name or Params.Text or Params.text or "Dropdown",
                OptionItems = Params.Items or Params.items or Params.Values or Params.values or { },
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name or Params.Text or Params.text),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Multi = Params.Multi or Params.multi or false,
                MaxSize = Params.MaxSize or Params.maxSize or Params.MaxHeight or Params.maxHeight or 180,

                Window = Params.Window or Self.Window,
                Page = Self.Page,
                Section = Self,

                Value = { },
                Options = { },
                IsOpen = false,
                _OptionBatchDepth = 0,
                _OptionSizeDirty = false,
                _OptionCount = 0,
                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Dropdown.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Dropdown"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 48),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Dropdown.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["RealDropdownOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Dropdown"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealDropdownOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["RealDropdown"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdownOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Value"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["RealDropdown"].Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "...",
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0.5, 0),
                    Size = UDim2.new(1, -20, 0, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                }):AddToTheme({TextColor3 = 'Inactive Text'})
                
                Items["Icon"] = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = Items["RealDropdown"].Instance,
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "dropdown-arrow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -6, 0.5, 0),
                    Size = UDim2.new(0, 16, 0, 16),
                    BorderSizePixel = 0
                })                

                Items["OptionHolder"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Library.Holder.Instance,
                    Visible = false,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2.new(0, 199, 0, 0),
                    Position = UDim2.new(0, 1107, 0, 158),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})

                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    TopLeftRadius = UDim.new(0, 6),
                    TopRightRadius = UDim.new(0, 6),
                    BottomRightRadius = UDim.new(0, 6),
                    BottomLeftRadius = UDim.new(0, 6)
                })
                
                Library:Create("UIStroke", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = 'Outline'})

                Items["OptionsScroller"] = Library:Create("ScrollingFrame", {
                    Name = "\0",
                    Parent = Items["OptionHolder"].Instance,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 1, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Library.Theme["Inactive Text"],
                    ScrollBarImageTransparency = 1,
                    ScrollingDirection = Enum.ScrollingDirection.Y
                }):AddToTheme({ScrollBarImageColor3 = 'Inactive Text'})

                Library:Create("UIPadding", {
                    Name = "\0",
                    Parent = Items["OptionsScroller"].Instance,
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingRight = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 8)
                })

                Items["OptionsLayout"] = Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["OptionsScroller"].Instance,
                    Padding = UDim.new(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Dropdown.Items = Items 
            end

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["RealDropdown"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Dropdown:GetOptionContentHeight()
                return Items["OptionsLayout"].Instance.AbsoluteContentSize.Y + 16
            end

            function Dropdown:UpdateOptionHolderSize()
                local Scale = Library:GetScreenScale()
                local ContentHeight = Dropdown:GetOptionContentHeight()
                local Height = math.clamp(ContentHeight, 32, Dropdown.MaxSize)

                Items["OptionHolder"].Instance.Size = UDim2.new(0, Items["RealDropdown"].Instance.AbsoluteSize.X / Scale, 0, Height)
                Items["OptionsScroller"].Instance.ScrollBarImageTransparency = ContentHeight > Dropdown.MaxSize and 0.35 or 1
                Dropdown._OptionSizeDirty = false
            end

            function Dropdown:QueueOptionHolderSizeUpdate()
                Dropdown._OptionSizeDirty = true

                if Dropdown._OptionBatchDepth > 0 or not Dropdown.IsOpen then
                    return
                end

                Dropdown:UpdateOptionHolderSize()
            end

            function Dropdown:WithOptionBatch(Callback)
                Dropdown._OptionBatchDepth += 1

                local Success, Result = pcall(Callback)

                Dropdown._OptionBatchDepth -= 1

                if Dropdown._OptionBatchDepth == 0 and Dropdown._OptionSizeDirty then
                    Dropdown:UpdateOptionHolderSize()
                    if Dropdown.IsOpen then
                        Items["OptionHolder"].Instance.Position = Library:PopupPosition(Items["RealDropdown"].Instance, Items["OptionHolder"].Instance, 10)
                    end
                end

                if not Success then
                    error(Result, 2)
                end
            end

            Library:Connect(Items["OptionsLayout"].Instance:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                if Dropdown.IsOpen then
                    Dropdown:QueueOptionHolderSizeUpdate()

                    if Dropdown._OptionBatchDepth == 0 then
                        Items["OptionHolder"].Instance.Position = Library:PopupPosition(Items["RealDropdown"].Instance, Items["OptionHolder"].Instance, 10)
                    end
                end
            end)

            function Dropdown:Set(Value)
                if Dropdown.Multi then 
                    if type(Value) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Value

                    for Index, Value in Value do
                        local OptionData = Dropdown.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.IsSelected = true 
                        OptionData:ToggleState("Active")
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = table.concat(Value, ", ")
                else
                    if not Dropdown.Options[Value] then
                        return
                    end

                    local OptionData = Dropdown.Options[Value]

                    Dropdown.Value = Value

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.IsSelected = false 
                            Value:ToggleState("Inactive")
                        else
                            Value.IsSelected = true 
                            Value:ToggleState("Active")
                        end
                    end

                    Flags[Dropdown.Flag] = Value
                    Items["Value"].Instance.Text = Value
                end

                Library:SafeCall(Dropdown.Callback, Dropdown.Value)
            end

            function Dropdown:Add(Value)
                if Dropdown.Options[Value] then
                    return Dropdown.Options[Value]
                end

                Dropdown._OptionCount += 1

                local OptionButton = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["OptionsScroller"].Instance,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 15),
                    LayoutOrder = Dropdown._OptionCount,
                    BorderSizePixel = 0
                })
                
                local OptionAccent = Library:Create("Frame", {
                    Name = "\0",
                    Parent = OptionButton.Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -3, 0.5, 0),
                    Size = UDim2.new(0, 6, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                }):AddToTheme({BackgroundColor3 = 'Accent'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = OptionAccent.Instance,
                    TopLeftRadius = UDim.new(1, 0),
                    TopRightRadius = UDim.new(1, 0),
                    BottomRightRadius = UDim.new(1, 0),
                    BottomLeftRadius = UDim.new(1, 0)
                })
                
                Library:Create("Frame", {
                    Name = "\0",
                    Parent = OptionAccent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 3, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                local OptionGlow = Library:Create("ImageLabel", {
                    Name = "\0",
                    Parent = OptionAccent.Instance,
                    ImageColor3 = Library.Theme["Accent"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = 1,
                    Size = UDim2.new(1, 20, 1, 20),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Image = "ui-glow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 1, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
                }):AddToTheme({ImageColor3 = 'Accent'})
                
                local OptionText = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = OptionButton.Instance,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = Value,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Inactive Text'})

                local OptionData = {
                    Button = OptionButton,
                    Name = Value,
                    Text = OptionText,
                    Accent = OptionAccent,
                    Glow = OptionGlow,
                    IsSelected = false
                }

                OptionButton:OnHover(function()
                    if OptionData.IsSelected then return end

                    OptionText:Tween({TextColor3 = Library.Theme.Text})
                end, function()
                    if OptionData.IsSelected then return end

                    OptionText:Tween({TextColor3 = Library.Theme["Inactive Text"]})
                end)
                
                function OptionData:ToggleState(Value)
                    if Value == "Active" then
                        OptionData.Accent:Tween({BackgroundTransparency = 0, Size = UDim2.new(0, 6, 1, 0)})
                        OptionData.Glow:Tween({ImageTransparency = 0.7})
                        OptionData.Text:ChangeItemTheme({TextColor3 = "Text"})
                        OptionData.Text:Tween({TextColor3 = Library.Theme.Text, Position = UDim2.new(0, 14, 0.5, -1)})
                    else
                        OptionData.Accent:Tween({BackgroundTransparency = 1, Size = UDim2.new(0, 6, 0, 0)})
                        OptionData.Glow:Tween({ImageTransparency = 1})
                        OptionData.Text:ChangeItemTheme({TextColor3 = "Inactive Text"})
                        OptionData.Text:Tween({TextColor3 = Library.Theme["Inactive Text"], Position = UDim2.new(0, 0, 0.5, -1)})
                    end
                end

                function OptionData:Set()
                    OptionData.IsSelected = not OptionData.IsSelected

                    if Dropdown.Multi then 
                        local Index = table.find(Dropdown.Value, OptionData.Name)

                        if Index then 
                            table.remove(Dropdown.Value, Index)
                        else
                            table.insert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:ToggleState(Index and "Inactive" or "Active")

                        Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and table.concat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.IsSelected then 
                            Dropdown.Value = OptionData.Name
                            Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.IsSelected = true
                            OptionData:ToggleState("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.IsSelected = false 
                                    Value:ToggleState("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Flags[Dropdown.Flag] = nil

                            OptionData.IsSelected = false
                            OptionData:ToggleState("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                SetGuiTreeZIndex(OptionButton.Instance, Params.Parent and Library.ZIndexOrder.OptionHolder + 3 or Library.ZIndexOrder.OptionHolder)
                Dropdown.Options[OptionData.Name] = OptionData
                Dropdown:QueueOptionHolderSizeUpdate()
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button.Instance:Destroy()
                    Dropdown.Options[Option] = nil
                    Dropdown:QueueOptionHolderSizeUpdate()
                end
            end

            function Dropdown:Refresh(List)
                Dropdown:WithOptionBatch(function()
                    local Keep = {}

                    for Index, Value in List do 
                        Keep[Value] = true

                        local OptionData = Dropdown:Add(Value)
                        OptionData.Button.Instance.LayoutOrder = Index
                    end

                    for _, Value in Dropdown.Options do 
                        if not Keep[Value.Name] then
                            Dropdown:Remove(Value.Name)
                        end
                    end
                end)
            end

            function Dropdown:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool 
            end

            local OptionHolder = Items["OptionHolder"].Instance
            local RealDropdown = Items["RealDropdown"].Instance
            local OptionHolderZIndex = Params.Parent and Library.ZIndexOrder.OptionHolder + 3 or Library.ZIndexOrder.OptionHolder

            local IsSettings = Dropdown.Section and Dropdown.Section.IsSettings

            SetGuiTreeZIndex(OptionHolder, OptionHolderZIndex)

            function Dropdown:SetOpen(Bool)
                if Dropdown.IsOpen == Bool then
                    return 
                end

                Dropdown.IsOpen = Bool
                
                if Dropdown.IsOpen then 
                    Items["Icon"]:Tween({Rotation = -90})

                    Items["OptionHolder"].Instance.Visible = true
                    Dropdown:UpdateOptionHolderSize()
                    Items["OptionsScroller"].Instance.CanvasPosition = Vector2.zero
                    OptionHolder.Position = Library:PopupPosition(RealDropdown, OptionHolder, 0)
                    
                    Items["OptionHolder"]:Tween({Position = Library:PopupPosition(RealDropdown, OptionHolder, 10)})

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= IsSettings and not Params.Parent then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    Items["Icon"]:Tween({Rotation = 0})
                    
                    Items["OptionHolder"].Instance.Visible = false

                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end
                end
            end

            Items["OptionHolder"]:VisibleCheck()

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Dropdown.IsOpen and not Items["OptionHolder"]:IsMouseOverFrame() and not Items["RealDropdownOutline"]:IsMouseOverFrame() then
                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Dropdown:WithOptionBatch(function()
                for Index, Value in Dropdown.OptionItems do 
                    local OptionData = Dropdown:Add(Value)
                    OptionData.Button.Instance.LayoutOrder = Index
                end
            end)

            Dropdown:Set(Dropdown.Default)

            SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            if Dropdown.Window and Dropdown.Window ~= "" then
                Dropdown.Window:RegisterSearchItem({
                    Name = Dropdown.Name,
                    Page = Dropdown.Page,
                    Holder = Items["Dropdown"].Instance
                })
            end

            return setmetatable(Dropdown, Library)
        end

        Library.Label = function(Self, Params)
            Params = if type(Params) == "string" then {Name = Params} else Params or { }

            local Label = {
                Name = Params.Name or Params.name or Params.Text or Params.text or Params.Title or Params.title or "Label",

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,

                Items = { }
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Label.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Label"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 18),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Label"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Label.Name,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 0, 0.5, -1),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["SubElements"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Items["Label"].Instance,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X
                })
                
                Library:Create("UIListLayout", {
                    Name = "\0",
                    Parent = Items["SubElements"].Instance,
                    Padding = UDim.new(0, 6),
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Label.Items = Items 
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool 
            end

            function Label:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end,
                    Alpha = Data.Alpha or Data.alpha or (Data.Transparency ~= nil and (1 - Data.Transparency)) or 1,

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback,
                    Alpha = Colorpicker.Alpha
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Name = Data.Name or Data.name or Data.Text or Data.text or Label.Name,
                    Flag = Data.Flag or Data.flag or (Data.Name or Data.name or Label.Name),
                    Default = if Data.Default ~= nil then Data.Default else Data.default,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",

                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,
                }

                local NewKeybind, KeybindItems = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Name = Keybind.Name,
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Label:SetText(Label.Name)

            if Label.Window then
                Label.Window:RegisterSearchItem({
                    Name = Label.Name,
                    Page = Label.Page,
                    Holder = Items["Label"].Instance
                })
            end

            return setmetatable(Label, Library)
        end

        Library.Textbox = function(Self, Params)
            Params = Params or { }

            local Textbox = {
                Name = Params.Name or Params.name or Params.Text or Params.text or "Textbox",
                Flag = Params.Flag or Params.flag or (Params.Name or Params.name or Params.Text or Params.text),
                Default = Params.Default or Params.default or "",
                Callback = Params.Callback or Params.callback or function() end,
                Finished = Params.Finished or Params.finished or false,
                Placeholder = Params.Placeholder or Params.placeholder or "",
                Numeric = Params.Numeric or Params.numeric or false,

                Window = Self.Window,
                Page = Self.Page,
                Section = Self,
                Value = "",

                Items = { },
            }

            local Parent 

            if Params.Parent then 
                Parent = Params.Parent
            else
                Parent = Textbox.Section.Items["Content"]
            end

            local Items = { } do 
                Items["Textbox"] = Library:Create("Frame", {
                    Name = "\0",
                    Parent = Parent.Instance,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 48),
                    BorderSizePixel = 0
                })
                
                Items["Text"] = Library:Create("TextLabel", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Textbox"].Instance,
                    TextColor3 = Library.Theme["Text"],
                    Text = Textbox.Name,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY
                }):AddToTheme({TextColor3 = 'Text'})
                
                Items["BackgroundOutline"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Textbox"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    Size = UDim2.new(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                }):AddToTheme({BackgroundColor3 = 'Outline'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["BackgroundOutline"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Background"] = Library:Create("TextButton", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["BackgroundOutline"].Instance,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    Text = "",
                    ClipsDescendants = true,
                    AutoButtonColor = false,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                }):AddToTheme({BackgroundColor3 = 'Element'})
                
                Library:Create("UICorner", {
                    Name = "\0",
                    Parent = Items["Background"].Instance,
                    TopLeftRadius = UDim.new(0, 4),
                    TopRightRadius = UDim.new(0, 4),
                    BottomRightRadius = UDim.new(0, 4),
                    BottomLeftRadius = UDim.new(0, 4)
                })
                
                Items["Input"] = Library:Create("TextBox", {
                    Name = "\0",
                    FontFace = Library.Font,
                    TextSize = Library.FontSize,
                    Parent = Items["Background"].Instance,
                    AnchorPoint = Vector2.new(0, 0.5),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    PlaceholderText = Textbox.Placeholder,
                    Size = UDim2.new(1, -16, 0, 0),
                    TextColor3 = Library.Theme["Text"],
                    Text = "",
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 8, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y
                }):AddToTheme({TextColor3 = 'Text', PlaceholderColor3 = 'Inactive Text'})                

                Textbox.Items = Items
            end

            Items["Background"]:OnHover(function()
                Items["Background"]:Tween({BackgroundColor3 = Library.Theme["Hovered Element"]})
            end, function()
                Items["Background"]:Tween({BackgroundColor3 = Library.Theme.Element})
            end)

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:SetText(Text)
                Items["Text"].Instance.Text = tostring(Text)
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and string.len(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Flags[Textbox.Flag] = Value

                Library:SafeCall(Textbox.Callback, Value)
            end

            if Textbox.Finished then 
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Library:Connect(Items["Input"].Instance:GetPropertyChangedSignal("Text"), function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            Textbox:Set(Textbox.Default)

            SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            if Textbox.Window then
                Textbox.Window:RegisterSearchItem({
                    Name = Textbox.Name,
                    Page = Textbox.Page,
                    Holder = Items["Textbox"].Instance
                })
            end
            
            return setmetatable(Textbox, Library)
        end

        Library.Init = function(Self)
            local SettingsPage = Self:IndividualPage({Icon = "settings-page-icon"})
            SettingsPage.IsSettings = true
            Self.SettingsPage = SettingsPage
            SettingsPage.Items["Inactive"].Instance.LayoutOrder = 10000
        
            do
                local ConfigsSection = SettingsPage:Section({Name = "Profile", Side = 1, Icon = "profile-section-icon"})
        
                local ConfigName 
                local ConfigSelected 
                local ConfigsFolder = Library.Directory .. Library.Folders.Configs .. "/"
        
                local ConfigsDropdown = ConfigsSection:Dropdown({
                    Name = "Configs",
                    Flag = "ConfigsDropdown",
                    Padding = true,
                    Items = { },
                    Multi = false,
                    Callback = function(Value)
                        ConfigSelected = Value 
                    end
                })
        
                ConfigsSection:Textbox({
                    Name = "Config name",
                    Padding = true,
                    Flag = "ConfigName",
                    Placeholder = "Config name",
                    Callback = function(Value)
                        ConfigName = Value 
                    end
                })
        
                ConfigsSection:Button({
                    Name = "Create",
                    Padding = true,
                    Callback = function()
                        if ConfigName then 
                            if ConfigName == "" then 
                                return
                            end
        
                            writefile(ConfigsFolder .. ConfigName .. ".json", Library:GetConfig())
                            Library:GetConfigsList(ConfigsDropdown)
        
                            Library:Notification({
                                Name = "Succesfully created config",
                                Duration = 3,
                                Color = Color3.fromRGB(0, 255, 0)
                            })
                        end
                    end
                })
        
                ConfigsSection:Button({
                    Name = "Delete",
                    Padding = true,
                    Callback = function()
                        if ConfigSelected then 
                            if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                delfile(ConfigsFolder .. ConfigSelected .. ".json")
                                Library:GetConfigsList(ConfigsDropdown)
        
                                Library:Notification({
                                    Name = "Succesfully deleted config",
                                    Duration = 3,
                                    Color = Color3.fromRGB(0, 255, 0)
                                })
                            end
                        end
                    end
                })
        
                ConfigsSection:Button({
                    Name = "Load",
                    Padding = true,
                    Callback = function()
                        if ConfigSelected then 
                            if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                local ConfigContent = readfile(ConfigsFolder .. ConfigSelected .. ".json")
                                local Success, Error = Library:LoadConfig(ConfigContent)
        
                                if Success then 
                                    Library:Notification({
                                        Name = "Succesfully loaded config",
                                        Duration = 3,
                                        Color = Color3.fromRGB(0, 255, 0)
                                    })
                                else
                                    Library:Notification({
                                        Name = "Failed to load config: \n" .. Error,
                                        Duration = 3,
                                        Color = Color3.fromRGB(255, 0, 0)
                                    })
                                end
                            end
                        end
                    end
                })
        
                ConfigsSection:Button({
                    Name = "Save",
                    Padding = true,
                    Callback = function()
                        if ConfigSelected then
                            if isfile(ConfigsFolder .. ConfigSelected .. ".json") then
                                local Success, Error = pcall(function()
                                    writefile(ConfigsFolder .. ConfigSelected .. ".json", Library:GetConfig())
                                end)
        
                                if Success then 
                                    Library:Notification({
                                        Name = "Succesfully saved config",
                                        Duration = 3,
                                        Color = Color3.fromRGB(0, 255, 0)
                                    })
                                else
                                    Library:Notification({
                                        Name = "Failed to save config: \n" .. Error,
                                        Duration = 3,
                                        Color = Color3.fromRGB(255, 0, 0)
                                    })
                                end
                            end
                        end
                    end
                })
        
                ConfigsSection:Label({Name = "UI Bind", Padding = true}):Keybind({
                    Flag = "UIBind",
                    Mode = "Toggle",
                    Default = Enum.KeyCode.RightShift,
                    Callback = function(Value)
                        Library.MenuKeybind = Flags["UIBind"].Key
                    end
                })
        
                ConfigsSection:Button({
                    Name = "Unload",
                    Padding = true,
                    Callback = function()
                        Library:Exit()
                    end
                })
        
                Library:GetConfigsList(ConfigsDropdown)
        
                local ThemingSection = SettingsPage:Section({Name = "Theming", Side = 2, Icon = "theming-section-icon"}) do
                    for Index, Value in Library.Theme do 
                        ThemingSection:Label({Name = Index, Padding = true}):Colorpicker({
                            Flag = Index .. "Theme",
                            Default = Value,
                            Callback = function(Value)
                                Library.Theme[Index] = Value
                                Library:ChangeTheme(Index, Value)
                            end
                        })
                    end
                end
        
                local OtherSection = SettingsPage:Section({Name = "Other", Side = 3, Icon = "settings-other-animations-icon"}) do 
                    OtherSection:Button({
                        Name = "Set selected as autoload",
                        Padding = true,
                        Callback = function()
                            if ConfigSelected then
                                local ConfigContent = readfile(ConfigsFolder .. ConfigSelected .. ".json")
                                writefile(Library.Directory .. "/autoload.json", ConfigContent)
        
                                Library:Notification({
                                    Name = "Set config " .. ConfigSelected .. " as autoload",
                                    Duration = 3,
                                    Color = Color3.fromRGB(0, 255, 0)
                                })
                            end
                        end
                    })
        
                    OtherSection:Button({
                        Name = "Remove autoload",
                        Padding = true,
                        Callback = function()
                            writefile(Library.Directory .. "/autoload.json", "")
        
                            Library:Notification({
                                Name = "Removed autoload",
                                Duration = 3,
                                Color = Color3.fromRGB(0, 255, 0)
                            })
                        end
                    })

                    if Self.Watermark then
                        OtherSection:Toggle({
                            Name = "Watermark",
                            Flag = "watermark",
                            Default = false,
                            Callback = function(Value)
                                if Self.Watermark then
                                    Self.Watermark:SetVisibility(Value)
                                end
                            end
                        })
                    end
            
                    if Library.KeyList then
                        OtherSection:Toggle({
                            Name = "Keybind list",
                            Flag = "keybind list",
                            Default = false,
                            Callback = function(Value)
                                if Library.KeyList then
                                    Library.KeyList:SetVisibility(Value)
                                end
                            end
                        })
                    end
                end

                local AnimationsSection = SettingsPage:Section({Name = "Animations", Side = 3, Icon = "settings-other-animations-icon"}) do 
                    AnimationsSection:Slider({
                        Name = "Animation speed",
                        Flag = "Animation speed",
                        Default = Library.Animation.Time,
                        Min = 0,
                        Max = 2,
                        Decimals = 0.01,
                        Callback = function(Value)
                            Library.Animation.Time = Value
                        end
                    })

                    AnimationsSection:Dropdown({
                        Name = "Easing style",
                        Items = { "Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Expo", "Circ", "Elastic", "Back", "Bounce" },
                        Default = "Cubic",
                        Flag = "Easing style",
                        Callback = function(Value)
                            Library.Animation.Style = Value
                        end
                    })

                    AnimationsSection:Dropdown({
                        Name = "Easing direction",
                        Items = { "In", "Out", "InOut" },
                        Default = "Out",
                        Flag = "Easing direction",
                        Callback = function(Value)
                            Library.Animation.Direction = Value
                        end
                    })
                end
        
                local AutoloadContent = readfile(Library.Directory .. "/autoload.json")

                if AutoloadContent ~= "" then 
                    Library:LoadConfig(AutoloadContent)
                end
            end

            RunService.Heartbeat:Wait()
            RunService.Heartbeat:Wait()
            local RevealSnapshot = Library:PrepareInterfaceReveal(Self.Items and Self.Items["MainFrame"])
            Library:HideLoadingScreen(function()
                Library._InterfaceReady = true
                Library.Holder.Instance.Enabled = true
                if Library.BackgroundButton then
                    Library.BackgroundButton.Instance.Visible = Self.IsOpen
                end
                Library:PlayInterfaceReveal(RevealSnapshot)
                if Library._AssetDownloadPending then
                    Library._AssetDownloadPending = false
                    Library:ShowAssetDownloadStatus()
                end
            end)
        end
    end
end

getgenv().Library = Library

return Library
