

-- ++++++++ WAX BUNDLED DATA BELOW ++++++++ --

-- Will be used later for getting flattened globals
local ImportGlobals

-- Holds direct closure data (defining this before the DOM tree for line debugging etc)
local ClosureBindings = {
    function()local wax,script,require=ImportGlobals(1)local ImportGlobals return (function(...)if getgenv().Executed then 
    if getgenv().ExecutedFunc then 
        getgenv().ExecutedFunc()
    end
    return 
end 
getgenv().Executed = true

local Trove = require(script.Packages.Trove)

local WaxShared = wax.shared

local MainTrove = Trove.new()

local AssetManager = require(script.UILibrary.AssetManager)
local UILibrary = require(script.UILibrary)
UILibrary:SetAssetManager(AssetManager)
WaxShared.UILibrary = UILibrary

local LoadingSettings = {
    Title = "Tyronex",
    Subtitle = "Welcome back!",
}

UILibrary:ShowLoadingScreen(LoadingSettings)

local Window = UILibrary:Window({
    Name    = LoadingSettings.Title,
    SubTitle = LoadingSettings.Subtitle,
    Logo    = UILibrary:GetAsset("default-logo"),
    FadeTime = 0.3,
})
WaxShared.Window = Window

local OriginalUnload = UILibrary.Unload
function UILibrary:Unload(...)
	getgenv().Executed = false
	MainTrove:Destroy()
	if OriginalUnload then
		return OriginalUnload(self, ...)
	end
	return nil
end

local function Tab(name, _icon)
    print("Do")
    return Window:Page({ Name = name, Columns = 2 })
end

local FeaturePages = {
    Combat  = Tab("Combat",  "swords"),
    Visuals = Tab("Visuals", "eye"),
    Exploit = Tab("Exploit", "zap"),
    Desyncs = Tab("Desyncs", "wifi-off"),
    Misc    = Tab("Misc",    "sliders-horizontal"),
}
WaxShared.FeaturePages = FeaturePages

for _, Module in script.Features:GetChildren() do 
	local Required = require(Module)
	if Required.Start then 
		task.spawn(Required.Start, Required, FeaturePages[Module.Name])
	end
	if Required.Trove then 
		MainTrove:Add(Required.Trove)
	end
end

UILibrary:Notify({
    Title    = "Script",
    Message  = "Script loaded!",
    Duration = 3,
})

getgenv().ExecutedFunc = function()
    UILibrary:Notify({
        Title    = "Script",
        Message  = "Already executed!",
        Duration = 1.5,
    })
end

end)() end,
    [3] = function()local wax,script,require=ImportGlobals(3)local ImportGlobals return (function(...)local Trove = require(script.Parent.Parent.Packages.Trove)
local UILibrary = require(script.Parent.Parent.UILibrary)

local Combat = {}

function Combat.Start(self: Combat, Page)
    self.Trove = Trove.new()

    local CombatSection = Page:Section({
        Name = "Combat",
        Icon = UILibrary:GetAsset("swords"),
    })

    CombatSection:AddToggle({ Text = "Silent Aim", Flag = "AimbotEnabled" })
    CombatSection:AddSlider({ Text = "Hit Chance", Flag = "HitChance", Min = 0, Max = 100, Default = 100, Rounding = 1, Suffix = "%" })
    CombatSection:AddToggle({ Text = "Force Hit", Flag = "ForcePenetration", Enabled = false })
    CombatSection:AddToggle({ Text = "Manipulation", Flag = "Manipulation", Enabled = false })
    CombatSection:AddColorPicker({ Text = "Manipulation Color", Flag = "ManipulationIndicatorColor", Default = Color3.fromRGB(255, 0, 0), Transparency = 0 })
    CombatSection:AddToggle({ Text = "Hit Scan (MAY LAG)", Flag = "HitScan", Enabled = false })
    CombatSection:AddColorPicker({ Title = "Hit Scan Color", Flag = "HitScanIndicatorColor", Default = Color3.fromRGB(233, 66, 245), Transparency = 0 })
    CombatSection:AddToggle({ Text = "Target Teammates", Flag = "TargetTeammates", Enabled = true })
    CombatSection:AddToggle({ Text = "Visible Check", Flag = "VisibleCheck", Enabled = false })
    CombatSection:AddColorPicker({ Title = "Visible Color", Flag = "VisibleIndicatorColor", Default = Color3.fromRGB(166, 147, 243), Transparency = 0 })
    CombatSection:AddToggle({ Text = "Down Check", Flag = "DownCheck", Enabled = true })
    CombatSection:AddToggle({ Text = "Indicators", Flag = "CombatIndicators", Enabled = true })
    CombatSection:AddToggle({ Text = "Autoshoot", Flag = "Autoshoot", Enabled = false })
    CombatSection:AddKeyPicker({ Text = "Autoshoot", Flag = "AutoshootKey", Mode = "Toggle", Default = Enum.KeyCode.T })
    CombatSection:AddDropdown({
        Text = "Target Parts",
        Flag = "TargetParts",
        Values = {
            "Head", "UpperTorso", "LowerTorso",
            "LeftUpperArm", "LeftLowerArm", "LeftHand",
            "RightUpperArm", "RightLowerArm", "RightHand",
            "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
            "RightUpperLeg", "RightLowerLeg", "RightFoot",
        },
        Default = "Head",
        Multi = true,
    })
    CombatSection:AddToggle({ Text = "Draw Fov", Flag = "FovEnabled", Enabled = false })
    CombatSection:AddColorPicker({ Title = "Fov Color", Flag = "FovColor", Default = Color3.fromRGB(166, 147, 243), Transparency = 4 })
    CombatSection:AddToggle({ Text = "Filled Fov", Flag = "FovFilled", Enabled = false })
    CombatSection:AddSlider({ Text = "Fill Transparency", Flag = "FovFillTransparency", Min = 0, Max = 1, Default = 0.3, Rounding = 0.01 })
    CombatSection:AddSlider({ Text = "Fov Size", Flag = "FovSize", Min = 0, Max = 500, Default = 200, Rounding = 1 })
    CombatSection:AddSlider({ Text = "Thickness", Flag = "FovThickness", Min = 1, Max = 5, Default = 2.5, Rounding = 0.1 })
    CombatSection:AddToggle({ Text = "Target HUD", Flag = "TargetHUD", Enabled = false })
    CombatSection:AddToggle({ Text = "Armor Viewer", Flag = "ArmorBar", Enabled = false })
    CombatSection:AddToggle({ Text = "Snapline", Flag = "Snapline", Enabled = false })
    CombatSection:AddColorPicker({ Title = "Snapline Color", Flag = "SnaplineColor", Default = Color3.fromRGB(166, 147, 243), Transparency = 0 })
    CombatSection:AddToggle({ Text = "Auto Peek", Flag = "AutoPeek", Enabled = false })
    CombatSection:AddKeyPicker({ Text = "Auto Peek Bind", Flag = "AutoPeekBind", Mode = "Toggle", Default = Enum.KeyCode.O })
    CombatSection:AddSlider({ Text = "Peek Distance", Flag = "AutoPeekDistance", Min = 2, Max = 30, Default = 25, Rounding = 1 })
    CombatSection:AddSlider({ Text = "Peek Delay", Flag = "AutoPeekDelay", Min = 0.25, Max = 0.75, Default = 0.5, Rounding = 0.01 })
    CombatSection:AddSlider({ Text = "Peek Attempts", Flag = "AutoPeekAttempts", Min = 1, Max = 6, Default = 3, Rounding = 1 })

    local GunModsSection = Page:Section({
        Name = "Gun Mods",
        Icon = UILibrary:GetAsset("settings"),
    })

    GunModsSection:AddToggle({ Text = "No Recoil", Flag = "NoRecoil", Enabled = false })
    GunModsSection:AddToggle({ Text = "No Spread", Flag = "NoSpread", Enabled = false })
    GunModsSection:AddToggle({ Text = "No Sway", Flag = "NoSway", Enabled = false })
    GunModsSection:AddToggle({ Text = "RPM", Flag = "RPM", Enabled = false })
    GunModsSection:AddSlider({ Text = "Multiplier", Flag = "RapidFireRate", Min = 1, Max = 1.5, Default = 1, Rounding = 0.1 })
    GunModsSection:AddToggle({ Text = "Auto Reload", Flag = "AutoReload" })
    GunModsSection:AddToggle({ Text = "Instant Equip", Flag = "FastEquip" })
    GunModsSection:AddToggle({ Text = "Instant Aim", Flag = "InstantAim" })
    GunModsSection:AddToggle({ Text = "Force Automatic", Flag = "ForceAuto" })
    GunModsSection:AddToggle({ Text = "Lower Melee Cooldown", Flag = "FastCooldown" })
    GunModsSection:AddToggle({ Text = "Instant Eoka", Flag = "InstantEoka", Enabled = false })
    GunModsSection:AddToggle({ Text = "Auto Bow", Flag = "AutoBow" })
    GunModsSection:AddToggle({ Text = "Instant Bow", Flag = "InstantBow" })
    GunModsSection:AddToggle({ Text = "Instant Bolt", Flag = "InstantBolt" })
    GunModsSection:AddToggle({ Text = "Instant Bullet", Flag = "InstantBullet" })
    GunModsSection:AddToggle({ Text = "Teleport to Bullet", Flag = "ShootOnTP", Enabled = false })
    GunModsSection:AddKeyPicker({ Text = "Teleport to Bullet Key", Flag = "TeleportKey", Mode = "Toggle", Default = Enum.KeyCode.T })
    GunModsSection:AddToggle({ Text = "Double Tap", Flag = "DoubleTap" })

    local CrosshairSection = Page:Section({
        Name = "Crosshair",
        Icon = UILibrary:GetAsset("crosshair"),
    })

    CrosshairSection:AddToggle({ Text = "Crosshair", Flag = "Crosshair" })
    CrosshairSection:AddToggle({ Text = "Crosshair Rotation", Flag = "RotateCrosshair", Default = true })
    CrosshairSection:AddToggle({ Text = "Sync with FOV Color", Flag = "SyncCrosshair" })
    CrosshairSection:AddColorPicker({ Title = "Independent Color", Flag = "IndependentColor", Default = Color3.fromRGB(166, 147, 243), Transparency = 0 })
    CrosshairSection:AddSlider({ Text = "Crosshair Width", Flag = "CrosshairWidth", Min = 1, Max = 3, Default = 3 })
    CrosshairSection:AddSlider({ Text = "Crosshair Length", Flag = "CrosshairLength", Min = 5, Max = 40, Default = 19 })
    CrosshairSection:AddSlider({ Text = "Crosshair Gap", Flag = "CrosshairGap", Min = 1, Max = 40, Default = 20 })
    CrosshairSection:AddSlider({ Text = "Crosshair Transparency 1", Flag = "CrosshairTransparency1", Min = 0, Max = 1, Default = 0 })
    CrosshairSection:AddSlider({ Text = "Crosshair Transparency 2", Flag = "CrosshairTransparency2", Min = 0, Max = 1, Default = 0 })
    CrosshairSection:AddSlider({ Text = "Crosshair Tween Speed", Flag = "CrosshairTweenSpeed", Min = 0, Max = 1, Default = 0.05 })
    CrosshairSection:AddToggle({ Text = "Lock To Target", Flag = "CrosshairLock" })
end

type Combat = typeof(Combat) & {
    Trove: typeof(Trove.new()),
}

return Combat :: Combat

end)() end,
    [4] = function()local wax,script,require=ImportGlobals(4)local ImportGlobals return (function(...)local Trove = require(script.Parent.Parent.Packages.Trove)
local UILibrary = require(script.Parent.Parent.UILibrary)

local Desyncs = {}

function Desyncs.Start(self: Desyncs, Page)
    self.Trove = Trove.new()

    local RaknetSection = Page:Section({
        Name = "Raknet",
        Icon = UILibrary:GetAsset("wifi"),
    })

    RaknetSection:AddToggle({
        Text = "Serverside Desync (RAKNET)",
        Flag = "RakHook",
        Enabled = false,
    })
    RaknetSection:AddKeyPicker({
        Text = "Serverside Desync",
        Flag = "RakHookKey",
        Mode = "Toggle",
        Default = Enum.KeyCode.U,
    })

    local CSyncsSection = Page:Section({
        Name = "CSyncs",
        Icon = UILibrary:GetAsset("refresh-cw"),
    })

    CSyncsSection:AddToggle({
        Text = "Evil Desync",
        Flag = "EvilDesync",
        Enabled = false,
    })
    CSyncsSection:AddKeyPicker({
        Text = "Evil Desync Bind",
        Flag = "EvilDesyncBind",
        Mode = "Toggle",
        Default = Enum.KeyCode.B,
    })
    CSyncsSection:AddSlider({
        Text = "Evil Strength",
        Flag = "EvilDesyncStrength",
        Min = 0.1,
        Max = 0.5,
        Default = 0.1,
        Rounding = 0.01,
    })
end

type Desyncs = typeof(Desyncs) & {
    Trove: typeof(Trove.new()),
}

return Desyncs :: Desyncs

end)() end,
    [5] = function()local wax,script,require=ImportGlobals(5)local ImportGlobals return (function(...)local Trove = require(script.Parent.Parent.Packages.Trove)
local UILibrary = require(script.Parent.Parent.UILibrary)

local Exploit = {}

function Exploit.Start(self: Exploit, Page)
    self.Trove = Trove.new()

    local MovementSection = Page:Section({
        Name = "Movement",
        Icon = UILibrary:GetAsset("move"),
    })

    MovementSection:AddToggle({ Text = "Infinite Fly", Flag = "InfiniteFly", Enabled = false })
    MovementSection:AddToggle({ Text = "No Fall Damage", Flag = "NoFall", Enabled = false })
    MovementSection:AddToggle({ Text = "Shoot while flying", Flag = "AlwaysGrounded", Enabled = false })
    MovementSection:AddToggle({ Text = "Speed", Flag = "SpeedEnabled", Enabled = false })
    MovementSection:AddKeyPicker({ Text = "Speed Bind", Flag = "SpeedBind", Mode = "Toggle" })
    MovementSection:AddSlider({ Text = "Speed Amount", Flag = "SpeedSpeed", Min = 16, Max = 30, Default = 16, Rounding = 1 })
    MovementSection:AddToggle({ Text = "Flight", Flag = "FlightEnabled", Enabled = false })
    MovementSection:AddKeyPicker({ Text = "Flight Bind", Flag = "FlightBind", Mode = "Toggle" })
    MovementSection:AddSlider({ Text = "Flight Speed", Flag = "FlightSpeed", Min = 1, Max = 20, Default = 10, Rounding = 1 })
    MovementSection:AddToggle({ Text = "Infinite Jump", Flag = "InfJump", Enabled = false })
    MovementSection:AddToggle({ Text = "Freecam", Flag = "Freecam", Enabled = false })
    MovementSection:AddKeyPicker({ Text = "Freecam Bind", Flag = "FreecamKeybind", Mode = "Toggle" })
    MovementSection:AddSlider({ Text = "Speed", Flag = "FreecamSpeed", Min = 1, Max = 100, Default = 10, Rounding = 1 })
    MovementSection:AddToggle({ Text = "Fast Fly", Flag = "FastFly", Enabled = false })
    MovementSection:AddKeyPicker({ Text = "Fast Fly Key", Flag = "FastFlyKey", Mode = "Toggle", Default = Enum.KeyCode.V })
    MovementSection:AddSlider({ Text = "Fast Fly Speed", Flag = "FastFlySpeed", Min = 10, Max = 200, Default = 60, Rounding = 1 })
    MovementSection:AddToggle({ Text = "Bunnyhop", Flag = "Bunnyhop", Enabled = false })
    MovementSection:AddToggle({ Text = "Noclip", Flag = "NoclipEnabled", Enabled = false })
    MovementSection:AddKeyPicker({ Text = "Noclip Bind", Flag = "NoclipKeybind", Mode = "Hold" })

    local ExploitsSection = Page:Section({
        Name = "Exploits",
        Icon = UILibrary:GetAsset("zap"),
    })

    ExploitsSection:AddToggle({ Text = "No Bob", Flag = "NoBob", Enabled = false })
    ExploitsSection:AddToggle({ Text = "Perfect Farm", Flag = "PerfectFarm", Enabled = false })
    ExploitsSection:AddToggle({ Text = "No Grounded", Flag = "NoGrounded", Enabled = false })
    ExploitsSection:AddToggle({ Text = "Silent Walk", Flag = "SilentWalk", Enabled = false })
    ExploitsSection:AddToggle({ Text = "Instant Loot", Flag = "InstantLoot", Enabled = false })
    ExploitsSection:AddToggle({ Text = "Instant Last Code", Flag = "InstantLastCode", Enabled = false })
    ExploitsSection:AddToggle({ Text = "BTR Teleport", Flag = "BTRTeleport", Enabled = false })
    ExploitsSection:AddKeyPicker({ Text = "Teleport Keybind", Flag = "BTRTeleportKey", Mode = "Hold", Default = Enum.KeyCode.X })
    ExploitsSection:AddToggle({ Text = "No damage & Sound Mini", Flag = "FlycopterSilent", Enabled = false })
    ExploitsSection:AddToggle({ Text = "Shoot in Mini", Flag = "ShootMini", Enabled = false })
    ExploitsSection:AddToggle({ Text = "Spoof Username", Flag = "SpoofUsername", Enabled = false })
    ExploitsSection:AddDropdown({
        Text = "Selected Username",
        Flag = "SpoofUsernameInput",
        Values = {
            "discord.gg/fallensurvival", "Prye4", "Lost_Test", "Derrek Lippe", "Blake Denis", "Bred The Pred",
            "Ultimate V3", "Retarded Paste", "neddleduck", "ChickenBagelz", "KittenBagelz",
        },
        Default = "None",
    })
    ExploitsSection:AddToggle({ Text = "Auto Upgrade", Flag = "AutoUpgrade", Default = false })
    ExploitsSection:AddDropdown({ Text = "Upgrade Material", Flag = "UpgradeMaterial", Values = { "Wood", "Stone", "Metal", "Steel" }, Default = "Metal" })
    ExploitsSection:AddSlider({ Text = "Upgrade Distance", Flag = "AutoUpgradeDistance", Min = 5, Max = 100, Default = 35 })
    ExploitsSection:AddToggle({ Text = "Xray", Flag = "xray", Default = false })
    ExploitsSection:AddKeyPicker({ Text = "Xray Keybind", Flag = "xray_keybind", Default = Enum.KeyCode.K, Mode = "Toggle" })
    ExploitsSection:AddSlider({ Text = "Xray Transparency", Flag = "xray_transparency", Min = 0, Max = 1, Default = 0.5, Rounding = 0.1 })
    ExploitsSection:AddToggle({ Text = "No Trap Damage", Flag = "NoTrapDamage" })
    ExploitsSection:AddToggle({ Text = "No Fire Damage", Flag = "NoFireDamage" })
    ExploitsSection:AddToggle({ Text = "No Trap Touch", Flag = "NoTrapTouch" })
end

type Exploit = typeof(Exploit) & {
    Trove: typeof(Trove.new()),
}

return Exploit :: Exploit

end)() end,
    [6] = function()local wax,script,require=ImportGlobals(6)local ImportGlobals return (function(...)local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local TeleportService = cloneref(game:GetService("TeleportService"))

local Trove = require(script.Parent.Parent.Packages.Trove)
local UILibrary = require(script.Parent.Parent.UILibrary)

local LocalPlayer = Players.LocalPlayer

local JOB_ID = game.JobId
local PLACE_ID = game.PlaceId

local RNG = Random.new()

local Rejoining = false 
local ServerHopping = false

local function Notify(Title: string, Message: string, Duration: number?)
	UILibrary:Notify({
		Title    = Title,
		Message  = Message,
		Duration = Duration or 3,
	})
end 

local Misc = {}

function Misc.Start(self: Misc, Page)
    self.Trove = Trove.new()

    local Section = Page:Section({
		Name = "Misc",
		Icon = UILibrary:GetAsset("settings"),
	})

	Section:CreateButton({
		Name = "Rejoin",
		Callback = function()
			self:Rejoin()
		end,
	}, "RejoinButton")

    Section:CreateButton({
		Name = "Server Hop",
		Callback = function()
			self:Serverhop()
		end,
	}, "ServerHopButton")
end

function Misc.Rejoin(self: Misc)
    if Rejoining then
        Notify("Misc", "Already rejoining...", 2)
        return
    end
    Rejoining = true
    Notify("Misc", "Rejoining server...", 3)
    TeleportService:TeleportToPlaceInstance(PLACE_ID, JOB_ID, LocalPlayer)
    Rejoining = false
end

function Misc.Serverhop(self: Misc)
    if ServerHopping then
        Notify("Misc", "Already server hopping...", 2)
        return
    end
    ServerHopping = true
    Notify("Misc", "Finding a new server...", 3)

    local Result = request({Url =`https://games.roblox.com/v1/games/{game.PlaceId}/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true`})

    local Success, Body = pcall(function()
        return HttpService:JSONDecode(Result.Body)
    end)

    if Success and Body and Body.data then
        local Servers = {}

        for _, Server in Body.data do
            if typeof(Server) == "table" and tonumber(Server.playing) and tonumber(Server.maxPlayers) and Server.playing < Server.maxPlayers and Server.id ~= JOB_ID then
                table.insert(Servers, 1, Server.id)
            end
        end

        if #Servers > 0 then
            Notify("Misc", `Found {#Servers} servers. Hopping now...`, 3)
            TeleportService:TeleportToPlaceInstance(PLACE_ID, Servers[RNG:NextInteger(1, #Servers)], LocalPlayer)
        else
            Notify("Misc", "No available servers found.", 3)
        end
    else
        Notify("Misc", "Failed to fetch server list.", 3)
    end

    ServerHopping = false
end

type Misc = typeof(Misc) & { 
    Trove: typeof(Trove.new()),
}

return Misc :: Misc

end)() end,
    [7] = function()local wax,script,require=ImportGlobals(7)local ImportGlobals return (function(...)local Trove = require(script.Parent.Parent.Packages.Trove)
local UILibrary = require(script.Parent.Parent.UILibrary)

local Visuals = {}

function Visuals.Start(self: Visuals, Page)
    self.Trove = Trove.new()

    -- ESP sub-page
    local ESPFeaturesSection = Page:Section({
        Name = "ESP - Features",
        Icon = UILibrary:GetAsset("eye"),
    })

    ESPFeaturesSection:AddToggle({ Text = "Enabled", Flag = "Esp Enabled", Default = false })
    ESPFeaturesSection:AddToggle({ Text = "Box", Default = false })
    ESPFeaturesSection:AddColorPicker({ Text = "High Contrast Box", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddColorPicker({ Text = "Low Contrast Box", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddToggle({ Text = "Box Fill", Default = false })
    ESPFeaturesSection:AddColorPicker({ Text = "High Contrast Fill", Flag = "High Contrast Fill", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddColorPicker({ Text = "Low Contrast Fill", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddToggle({ Text = "Box Glow", Default = false })
    ESPFeaturesSection:AddColorPicker({ Text = "High Contrast Glow", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddColorPicker({ Text = "Low Contrast Glow", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddToggle({ Text = "Healthbar", Default = false })
    ESPFeaturesSection:AddColorPicker({ Text = "High Health", Default = Color3.fromRGB(0, 255, 0), Transparency = 0.5 })
    ESPFeaturesSection:AddColorPicker({ Text = "Mid Health", Default = Color3.fromRGB(255, 165, 0), Transparency = 0.5 })
    ESPFeaturesSection:AddColorPicker({ Text = "Low Health", Default = Color3.fromRGB(255, 0, 0), Transparency = 0.5 })
    ESPFeaturesSection:AddToggle({ Text = "Healthbar Text", Default = false })
    ESPFeaturesSection:AddToggle({ Text = "Names", Default = false })
    ESPFeaturesSection:AddColorPicker({ Text = "Names Text Color", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddToggle({ Text = "Distance Text", Default = false })
    ESPFeaturesSection:AddColorPicker({ Text = "Distance Text Color", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddToggle({ Text = "Weapon Text", Default = false })
    ESPFeaturesSection:AddColorPicker({ Text = "Weapon Text Color", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddToggle({ Text = "Flags", Default = false })
    ESPFeaturesSection:AddColorPicker({ Text = "Flags Text Color", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddToggle({ Text = "Chams", Default = false })
    ESPFeaturesSection:AddColorPicker({ Text = "Chams Inside Color", Default = Color3.fromRGB(255, 255, 255), Transparency = 0.5 })
    ESPFeaturesSection:AddColorPicker({ Text = "Chams Outside Color", Default = Color3.fromRGB(255, 255, 255), Transparency = 0 })
    ESPFeaturesSection:AddSlider({ Text = "Max Distance", Flag = "EspMaxDistance", Min = 100, Max = 10000, Default = 2000, Rounding = 1 })

    local ESPOtherSection = Page:Section({
        Name = "ESP - Other",
        Icon = UILibrary:GetAsset("layers"),
    })

    ESPOtherSection:AddSlider({ Text = "Box Gradient Rotation", Min = -180, Max = 180, Rounding = 1, Default = 0, Suffix = "deg" })
    ESPOtherSection:AddSlider({ Text = "Box Fill Rotation", Min = -180, Max = 180, Rounding = 1, Default = 0, Suffix = "deg" })
    ESPOtherSection:AddSlider({ Text = "Box Glow Rotation", Min = -180, Max = 180, Rounding = 1, Default = 0, Suffix = "deg" })

    local ESPMiscSection = Page:Section({
        Name = "ESP - Misc",
        Icon = UILibrary:GetAsset("sliders-horizontal"),
    })

    ESPMiscSection:AddToggle({ Text = "Enabled", Flag = "MiscEnabledESP", Enabled = false })

    for _, Name in { "Stone", "Metal", "Phosphate", "Wool", "Animals", "Care Package", "Drops", "Body Bag", "Salvaged Flycopter", "Auto Turret", "Shotgun Turret" } do
        local MaxDistance = (Name == "Care Package" or Name == "Salvaged Flycopter") and 3000 or (Name == "Body Bag" and 1000 or 400)
        local DefaultDistance = (Name == "Care Package" or Name == "Salvaged Flycopter") and 3000 or 1000

        ESPMiscSection:AddToggle({ Text = Name, Flag = Name .. "Enabled", Enabled = false })
        ESPMiscSection:AddColorPicker({ Title = Name .. " Color", Flag = Name .. "Color", Default = Color3.fromRGB(255, 0, 0), Transparency = 0 })
        ESPMiscSection:AddSlider({ Text = "Max Distance", Flag = Name .. "MaxDistance", Min = 10, Max = MaxDistance, Default = DefaultDistance, Rounding = 1 })
    end

    -- Misc Visuals sub-page
    local CameraSection = Page:Section({
        Name = "Camera",
        Icon = UILibrary:GetAsset("video"),
    })

    CameraSection:AddToggle({ Text = "Field Of View", Flag = "FieldOfView", Enabled = false })
    CameraSection:AddSlider({ Text = "FOV", Flag = "FieldOfViewSlider", Min = 70, Max = 120, Default = 100, Rounding = 1 })
    CameraSection:AddToggle({ Text = "Zoom", Flag = "ZoomEnabled", Enabled = false })
    CameraSection:AddKeyPicker({ Text = "Zoom Key", Flag = "ZoomKeybind", Mode = "Hold", Default = Enum.KeyCode.C })
    CameraSection:AddSlider({ Text = "Zoom Amount", Flag = "ZoomAmount", Min = 20, Max = 100, Default = 40, Rounding = 1 })
    CameraSection:AddToggle({ Text = "Third Person", Flag = "ThirdPersonToggle" })
    CameraSection:AddSlider({ Text = "Third Person Distance", Flag = "ThirdPersonFlag", Default = 5, Min = 5, Max = 20 })
    CameraSection:AddKeyPicker({ Text = "Third Person Key", Flag = "ThirdPersonKey", Mode = "Toggle" })

    local GunVFXSection = Page:Section({
        Name = "Gun VFX",
        Icon = UILibrary:GetAsset("zap"),
    })

    GunVFXSection:AddSlider({ Text = "Speed", Flag = "SkinModelScrollSpeed", Min = 0.01, Max = 1, Default = 0.1, Rounding = 0.01 })
    GunVFXSection:AddToggle({ Text = "Custom Skin", Flag = "SkinModelEnabled" })
    GunVFXSection:AddDropdown({
        Text = "Skins",
        Flag = "SkinModelList",
        Values = { "Galaxy", "Universe", "Grooves", "Liquid", "Galaxy2", "Tunnel", "Osamason" },
        Default = "Galaxy",
    })
    GunVFXSection:AddToggle({ Text = "Gun Chams", Flag = "SkinModelGunEnable" })
    GunVFXSection:AddColorPicker({ Title = "Gun Color", Flag = "SkinModelGunColor", Default = Color3.fromRGB(166, 147, 243) })
    GunVFXSection:AddDropdown({ Text = "Gun Material", Flag = "SkinModelGunMaterial", Values = { "ForceField", "Neon", "Glass", "Ice", "Wood", "Plastic", "Metal" }, Default = "ForceField" })
    GunVFXSection:AddToggle({ Text = "Viewmodel Highlight", Flag = "HighlightViewmodel", Enabled = false })
    GunVFXSection:AddColorPicker({ Title = "Fill Color", Flag = "VMFillColor", Default = Color3.fromRGB(166, 147, 243), Transparency = 0.5 })
    GunVFXSection:AddColorPicker({ Title = "Outline Color", Flag = "VMOutlineColor", Default = Color3.fromRGB(166, 147, 243), Transparency = 0 })
    GunVFXSection:AddDropdown({
        Text = "Gun Texture",
        Flag = "SkinModelGunTexture",
        Values = { "Web", "Swirl", "Checkers", "CandyCane", "Dots", "Scanning", "Bubbles", "Player FF Texture", "Shield Forcefield", "Water", "America", "Rainbow", "Akatsuki", "None" },
        Default = "None",
    })
    GunVFXSection:AddToggle({ Text = "Arms Chams", Flag = "SkinModelPropEnable" })
    GunVFXSection:AddColorPicker({ Title = "Arms Color", Flag = "SkinModelsPropColor", Default = Color3.fromRGB(166, 147, 243) })
    GunVFXSection:AddDropdown({ Text = "Arms Material", Flag = "SkinModelPropMaterial", Values = { "ForceField", "Neon", "Glass", "Ice", "Wood", "Plastic", "Metal" }, Default = "ForceField" })
    GunVFXSection:AddDropdown({
        Text = "Arms Texture",
        Flag = "SkinModelPropTexture",
        Values = { "Web", "Swirl", "Checkers", "CandyCane", "Dots", "Scanning", "Bubbles", "Player FF Texture", "Shield Forcefield", "Water", "America", "Rainbow", "Akatsuki", "None" },
        Default = "None",
    })
    GunVFXSection:AddToggle({ Text = "Bullet Tracers", Flag = "BulletTracers" })
    GunVFXSection:AddDropdown({ Text = "Tracer Type", Flag = "TracerType", Values = { "Dark", "Lightning", "Water" }, Default = "Lightning" })
    GunVFXSection:AddColorPicker({ Title = "Tracer Color", Flag = "BulletTracersColor", Default = Color3.fromRGB(166, 147, 243) })
    GunVFXSection:AddSlider({ Text = "Tracer Duration", Flag = "BulletTracersDuration", Min = 0.1, Max = 5, Default = 5, Rounding = 0.1 })
    GunVFXSection:AddToggle({ Text = "Hit Sounds", Flag = "Hitsounds", Enabled = false })
    GunVFXSection:AddDropdown({ Text = "Hit Sound", Flag = "HitsoundSelect", Values = { "Bell", "Bubble", "Cod", "Neverlose", "Rust", "Skeet" }, Default = "Bell" })
    GunVFXSection:AddSlider({ Text = "Volume", Flag = "HitsoundVolume", Min = 0, Max = 2, Default = 0.5, Rounding = 0.1 })
    GunVFXSection:AddToggle({ Text = "Hit Notifications", Flag = "HitNotifications" })
    GunVFXSection:AddToggle({ Text = "Custom Hit Effects", Flag = "CustomHitEffects" })
    GunVFXSection:AddDropdown({ Text = "Hit Effect Type", Flag = "HitEffectType", Values = { "Spark", "SmokeRing", "particles.js" }, Default = "Spark" })
    GunVFXSection:AddColorPicker({ Title = "Hit Effect Color 1", Flag = "HitEffectColor1", Default = Color3.fromRGB(166, 147, 243) })
    GunVFXSection:AddColorPicker({ Title = "Hit Effect Color 2", Flag = "HitEffectColor2", Default = Color3.fromRGB(166, 147, 243) })
    GunVFXSection:AddLabel({ Text = "Too much of a offset may cause invalids." })
    GunVFXSection:AddToggle({ Text = "Viewmodel Position", Flag = "ViewmodelPosition", Enabled = false })
    GunVFXSection:AddSlider({ Text = "X pos", Flag = "ViewmodelPositionX", Min = -2, Max = 2, Default = 0, Rounding = 0.1 })
    GunVFXSection:AddSlider({ Text = "Y pos", Flag = "ViewmodelPositionY", Min = -2, Max = 2, Default = 0, Rounding = 0.1 })
    GunVFXSection:AddSlider({ Text = "Z pos", Flag = "ViewmodelPositionZ", Min = -2, Max = 2, Default = 0, Rounding = 0.1 })

    local LightingSection = Page:Section({
        Name = "Lighting",
        Icon = UILibrary:GetAsset("sun"),
    })

    LightingSection:AddToggle({ Text = "Cloud Density", Flag = "ChangeCloudDensity", Enabled = false })
    LightingSection:AddSlider({ Text = "Density", Flag = "CloudDensity", Min = 0, Max = 1, Default = 0.5, Rounding = 0.001 })
    LightingSection:AddToggle({ Text = "Cloud Cover", Flag = "ChangeCloudCover", Enabled = false })
    LightingSection:AddSlider({ Text = "Cover", Flag = "CloudCover", Min = 0, Max = 1, Default = 0.5, Rounding = 0.001 })
    LightingSection:AddToggle({ Text = "Cloud Color", Flag = "ChangeCloudColor", Enabled = false })
    LightingSection:AddColorPicker({ Title = "Cloud Color", Flag = "CloudColor", Default = Color3.fromRGB(166, 147, 243) })
    LightingSection:AddToggle({ Text = "No Fog", Flag = "NoFog", Enabled = false })
    LightingSection:AddToggle({ Text = "Fog Density", Flag = "ChangeFogDensity", Enabled = false })
    LightingSection:AddSlider({ Text = "Fog Density", Flag = "FogDensity", Min = 0, Max = 1, Default = 0.5, Rounding = 0.001 })
    LightingSection:AddToggle({ Text = "Fog Haze", Flag = "ChangeFogHaze", Enabled = false })
    LightingSection:AddSlider({ Text = "Haze", Flag = "FogHaze", Min = 0, Max = 1, Default = 0.5, Rounding = 0.001 })
    LightingSection:AddToggle({ Text = "Fog Glare", Flag = "ChangeFogGlare", Enabled = false })
    LightingSection:AddSlider({ Text = "Glare", Flag = "FogGlare", Min = 0, Max = 1, Default = 0.5, Rounding = 0.001 })
    LightingSection:AddToggle({ Text = "Fog Color", Flag = "ChangeFogColor", Enabled = false })
    LightingSection:AddColorPicker({ Title = "Fog Color", Flag = "FogColor" })
    LightingSection:AddToggle({ Text = "Fullbright", Flag = "Fullbright", Enabled = false })
    LightingSection:AddSlider({ Text = "Brightness", Flag = "Brightness", Min = 0, Max = 6, Default = 2, Rounding = 0.1 })
    LightingSection:AddToggle({ Text = "Ambient", Flag = "AmbienceEnabled", Enabled = false })
    LightingSection:AddColorPicker({ Title = "Ambient Color", Flag = "AmbienceColor", Default = Color3.fromRGB(166, 147, 243) })
    LightingSection:AddToggle({ Text = "Time Changer", Flag = "TimeChanger", Enabled = false })
    LightingSection:AddSlider({ Text = "Clock Time", Flag = "Time", Min = 0, Max = 24, Default = 12, Rounding = 0.1 })
    LightingSection:AddToggle({ Text = "Skybox", Flag = "UseSkybox", Enabled = false })
    LightingSection:AddDropdown({
        Text = "Skybox Preset",
        Flag = "SkyboxPreset",
        Options = { "Among Us", "Blaze", "Bright Pink", "Dark Night", "Desert", "Galaxy", "Oblivion Lost", "Redshift", "Setting Sun", "Space Wave2", "Turquoise Wave", "Vaporwave" },
        Default = "Galaxy",
    })
    LightingSection:AddToggle({ Text = "Sun Rays", Flag = "SunRaysEnabled", Enabled = false })
    LightingSection:AddSlider({ Text = "Sun Intensity", Flag = "SunIntensity", Min = 0, Max = 5, Default = 0.25, Rounding = 0.1 })
    LightingSection:AddSlider({ Text = "Sun Spread", Flag = "SunSpread", Min = 0, Max = 1, Default = 1, Rounding = 0.1 })
    LightingSection:AddToggle({ Text = "Bloom", Flag = "BloomEnabled", Enabled = false })
    LightingSection:AddSlider({ Text = "Bloom Intensity", Flag = "BloomIntensity", Min = 0, Max = 1, Default = 1, Rounding = 0.01 })
    LightingSection:AddSlider({ Text = "Bloom Size", Flag = "BloomSize", Min = 0, Max = 1000, Default = 1000, Rounding = 1 })
    LightingSection:AddSlider({ Text = "Bloom Threshold", Flag = "BloomThreshold", Min = 0, Max = 2, Default = 0.36, Rounding = 0.01 })
end

type Visuals = typeof(Visuals) & {
    Trove: typeof(Trove.new()),
}

return Visuals :: Visuals

end)() end,
    [9] = function()local wax,script,require=ImportGlobals(9)local ImportGlobals return (function(...)local secure_call do
    local LAYERS = 2 -- this is the minimum btw. stack-shape detectors can cook you here cuz a shallow/deep stack will throw nil as the source and just look sus if monitored
    -- additionally, all the layers come from one chunk and share the same one env, so passing a sanity check on this would detect it
    local TEMPLATE do -- fake frames
        local lines: {string} = { -- l = layer/forwarder
            "return function(__renv, __func, ...)",
            "\tsetfenv(0, __renv)", -- pass renv as param cuz we dont want getrenv reachable from the chunk/target's env
            `\tlocal function l{LAYERS}(...) return __func(...) end`,
        }
        for count = LAYERS - 1, 1, -1 do -- builds outward
            lines[#lines + 1] = `\tlocal function l{count}(...) return l{count + 1}(...) end`
        end
        lines[#lines + 1] = "\treturn l1(...)" -- chain kickoff
        lines[#lines + 1] = "end"
        TEMPLATE = table.concat(lines, "\n")
    end
    secure_call = function(func: (...any) -> ...any, mask: Instance, ...: any): ...any -- type __function__ = ( ...any ) -> ...any;
        -- MUSTHAVES: getthreadidentity, getrenv, setfenv, debug.getupvalues, debug.setupvalue, setthreadidentity
        assert(type(func) == "function", `invalid argument #1 to 'secure_call' (function expected, got {typeof(func)})`)
        assert(debug.info(func, "s") ~= "[C]", "invalid argument #1 to 'secure_call' (Luau closure expected, got C closure)") -- workaround in case the executor doesnt have iscclosure/islclosure
        assert(typeof(mask) == "Instance" and mask:IsA("LuaSourceContainer"), `invalid argument #2 to 'secure_call' (LuaSourceContainer expected, got {typeof(mask)})`)
        local level: number = getthreadidentity()
        local renv: {[any]: any} = getrenv()
        local path = mask:GetFullName()
        local ok, env = pcall(getsenv, mask)
        if not ok or type(env) ~= "table" then -- in case its dead
            env = setmetatable({ script = mask }, { __index = renv, __newindex = renv })
        end
        local loader, err = loadstring(TEMPLATE, `={path}`) -- impersonate chunkname-strip (idk if all executors have '=' as prefix but native luau does)
        -- assert(loader, `synthetic sentinel build failed: {err}`)
        setfenv(loader, env) -- inner function inherits this / every frame in the chain shares the env
        local sentinel = (loader :: (...any) -> ...any)()
        local snapshot: {any} = debug.getupvalues(func) -- if they check the owner/source at call time we would be DOOMED
        for index = 1, #snapshot do -- faster than ipairs
            local value = snapshot[index]
            if typeof(value) == "Instance" and value:IsA("LuaSourceContainer") then
                debug.setupvalue(func, index, mask)
            end
        end
        setthreadidentity(2) -- prevent capability probes (e.g., 'settings()')
        local co = coroutine.create(sentinel)
        local args = table.pack(renv, func, ...) -- aligns with sentinel sig
        local response
        while true do -- handler for co states: returned/errored/yielded
            local result = table.pack(coroutine.resume(co, unpack(args, 1, args.n)))
            if not result[1] then -- "ok"/success bool
                err = result[2]
                break
            end
            if coroutine.status(co) == "dead" then -- return results (response) as result[2..n]
                response = table.pack(unpack(result, 2, result.n))
                break
            end
            args = table.pack(coroutine.yield(unpack(result, 2, result.n))) -- yield outside of secure_call and to our caller
        end
        setthreadidentity(level)
        for index = 1, #snapshot do -- faster than ipairs
            debug.setupvalue(func, index, snapshot[index])
        end
        if err then error(err, 2) end -- shows up at the callers level in traceback
        return unpack(response, 1, response.n)
    end
end
return secure_call
end)() end,
    [11] = function()local wax,script,require=ImportGlobals(11)local ImportGlobals return (function(...)return require(script.Parent._Index["arxkdev_ezvisualz@0.0.6"]["ezvisualz"])

end)() end,
    [12] = function()local wax,script,require=ImportGlobals(12)local ImportGlobals return (function(...)local Promise = require(script.Parent._Index["howmanysmall_typed-promise@4.0.6"]["typed-promise"])

export type Promise = Promise.Promise

return Promise

end)() end,
    [13] = function()local wax,script,require=ImportGlobals(13)local ImportGlobals return (function(...)return require(script.Parent._Index["sleitnick_signal@2.0.3"]["signal"])

end)() end,
    [14] = function()local wax,script,require=ImportGlobals(14)local ImportGlobals return (function(...)return require(script.Parent._Index["sleitnick_trove@1.8.0"]["trove"])

end)() end,
    [17] = function()local wax,script,require=ImportGlobals(17)local ImportGlobals return (function(...)local Presets = script.Presets;

export type Effect<T...> = {
	UIInstance: GuiObject,
	EffectObjects: { Instance },
	SavedObjects: { Instance },
	Speed: number,
	Size: number,
	IsPaused: boolean,

	Pause: (self: Effect<T...>) -> nil,
	Resume: (self: Effect<T...>) -> nil,
	Destroy: (self: Effect<T...>) -> nil,
};

local Effect = {};
Effect.Gradient = require(script.Gradient);
Effect.Stroke = require(script.Stroke);
Effect.Dropshadow = require(script.Dropshadow);
Effect.Templates = require(script.GradientTemplates);

Effect.__index = Effect;
Effect.CurrentEffects = {};

local VisibleOrEnabledChart = {
	["GuiObject"] = "Visible",
	["ScreenGui"] = "Enabled",
	["BillboardGui"] = "Enabled",
	["SurfaceGui"] = "Enabled",
};

local function ValidateIsPreset(presetName: string): boolean
	return Presets:FindFirstChild(presetName) ~= nil;
end

function Effect.new<T...>(uiInstance: GuiObject, effectType: string, speed: number?, size: number?, saveInstanceObjects: boolean?, customColor: ColorSequence | Color3?, customTransparency: NumberSequence | number?, resumesOnVisible: boolean?): Effect<T...>
	assert(uiInstance, "UIInstance not provided");
	assert(effectType, "EffectType not provided");
	assert(uiInstance:IsA("GuiObject"), "UIInstance is not a GuiObject");
	assert(typeof(effectType) == "string", "effectType is not a string");
	assert(ValidateIsPreset(effectType), "effectType is not a valid preset");
	if (speed) then
		assert(typeof(speed) == "number", "speed is not a number");
	end;
	if (size) then
		assert(typeof(size) == "number", "size is not a number");
	end;
	if (customColor) then
		assert(typeof(customColor) == "ColorSequence" or typeof(customColor) == "Color3", "customColor is not a ColorSequence or Color3");
	end;
	if (customTransparency) then
		assert(typeof(customTransparency) == "NumberSequence" or typeof(customTransparency) == "number", "customTransparency is not a NumberSequence or number");
	end;

	local self = {};

	self.IsPaused = false;
	self.Diagnostic = "DIAGNOSTIC VALUE";
	self.UIInstance = uiInstance;
	self.ResumesOnShown = resumesOnVisible == nil and true or resumesOnVisible;
	self.EffectObjects = {};
	self.SavedObjects = {};
	self.Connections = {};
	self.Speed = speed or 0.007;
	self.Size = size or 1;

	-- Climb up the parent tree of the UIInstance and attach GetPropertyChangedSignal to the Visible property of each object
	-- If the Visible property changes to false, destroy the effect
	local function RecursiveAncestryChanged(Object: Instance)
		if (not Object) then
			return;
		end;

		-- If the object is a PlayerGui or Workspace, stop climbing
		if (Object:IsA("PlayerGui") or Object:IsA("Workspace")) then
			return;
		end;

		-- If the object is a ScreenGui, BillboardGui, or SurfaceGui, check if it's enabled
		local IsVisibleOrEnabled = VisibleOrEnabledChart[Object.ClassName];
		if (not IsVisibleOrEnabled) then
			RecursiveAncestryChanged(Object.Parent);
			return;
		end;

		table.insert(self.Connections, Object:GetPropertyChangedSignal(IsVisibleOrEnabled):Connect(function()
			self.IsPaused = not Object[IsVisibleOrEnabled];
			if (self.IsPaused) then
				self:Pause();
			else
				if (self.ResumesOnShown) then
					self:Resume();
				end;
			end;
		end));

		RecursiveAncestryChanged(Object.Parent);
	end;
	RecursiveAncestryChanged(uiInstance);

	if (saveInstanceObjects) then
		for _, Object in uiInstance:GetChildren() do
			if (Object:IsA("UIStroke") or Object:IsA("UIGradient")) then
				table.insert(self.SavedObjects, Object);
				Object.Parent = nil;
			end;
		end;
	end;

	local Preset = require(Presets:FindFirstChild(effectType));
	local Objects = Preset(uiInstance, self.Speed, self.Size, customColor, customTransparency);

	if (Objects["Connections"]) then
		for _, Connection in Objects["Connections"] do
			table.insert(self.Connections, Connection);
		end;
	end;
	if (Objects["Effects"]) then
		for _, ObjectEffect in Objects["Effects"] do
			table.insert(self.EffectObjects, ObjectEffect);
		end;
	end;

	self.Connection = uiInstance.AncestryChanged:Connect(function()
		if (not uiInstance:IsDescendantOf(game)) then
			self:Destroy();
		end;
	end);

	return setmetatable(self, Effect);
end

function Effect:Pause()
	-- print("Effect paused");
	for _, Object in self.EffectObjects do
		if (Object.Pause) then
			Object:Pause();
		end;
	end;
end

function Effect:Resume()
	-- print("Effect resumed");
	for _, Object in self.EffectObjects do
		if (Object.Resume) then
			Object:Resume();
		end;
	end;
end

function Effect:Destroy()
	for _, Object in self.SavedObjects do
		Object.Parent = self.UIInstance;
	end;
	for _, Connection in self.Connections do
		Connection:Disconnect();
	end;

	table.clear(self.SavedObjects);
	table.clear(self.Connections);

	for _, Object in self.EffectObjects do
		if (not Object.Destroy) then
			continue;
		end;
		Object:Destroy();
	end;

	self.Connection:Disconnect();
end

return table.freeze(Effect);

end)() end,
    [18] = function()local wax,script,require=ImportGlobals(18)local ImportGlobals return (function(...)local RunService = game:GetService("RunService");

export type Dropshadow<T...> = {
	UIInstance: GuiObject,
	Instance: GuiObject,
	IsPaused: boolean,
	Color: Color3,
	ColorTarget: Color3,
	ColorAcceleration: number,
	Transparency: number,
	TransparencyTarget: number,
	TransparencyAcceleration: number,
	Offset: Vector2,
	OffsetTarget: Vector2,
	OffsetAcceleration: number,
	Connection: RBXScriptConnection,
	IsText: boolean,

	Pause: (self: Dropshadow<T...>) -> nil,
	Resume: (self: Dropshadow<T...>) -> nil,
	SetOffset: (self: Dropshadow<T...>, offset: Vector2, acceleration: number) -> nil,
	SetTransparency: (self: Dropshadow<T...>, transparency: number, acceleration: number) -> nil,
	SetColor: (self: Dropshadow<T...>, color: Color3, acceleration: number) -> nil,
	Destroy: (self: Dropshadow<T...>) -> nil,
};

local Dropshadow = {};
Dropshadow.__index = Dropshadow;

function Dropshadow.new<T...>(uiInstance: GuiObject | UIStroke, color: Color3?, transparency: number?, offset: Vector2?): Dropshadow<T...>
	assert(uiInstance, "UIInstance not provided");
	assert(uiInstance:IsA("GuiObject") or uiInstance:IsA("UIStroke"), "UIInstance is not a GuiObject or UIStroke");
	if (color) then
		assert(typeof(color) == "Color3", "Color is not a Color3");
	end;
	if (transparency) then
		assert(typeof(transparency) == "number", "Transparency is not a number");
	end;
	if (offset) then
		assert(typeof(offset) == "Vector2", "Offset is not a Vector2");
	end;

	local self = {};

	self.UIInstance = uiInstance;
	self.Instance = uiInstance:Clone();
	self.IsPaused = false;

	self.Color = color or Color3.new();
	self.ColorTarget = color or Color3.new();
	self.ColorAcceleration = 1;
	self.Transparency = transparency or 0;
	self.TransparencyTarget = transparency or 0;
	self.TransparencyAcceleration = 1;
	self.Offset = offset or Vector2.new(-4, 4);
	self.OffsetTarget = offset or Vector2.new();
	self.OffsetAcceleration = 1;
	self.Connection = nil;
	self.IsText = false;

	self.Instance.Size = UDim2.new(1, 0, 1, 0);
	self.Instance:ClearAllChildren();

	self.Instance.Position = UDim2.new(0, self.Offset.X, 0, self.Offset.Y);

	if (uiInstance:IsA("TextLabel") or uiInstance:IsA("TextBox") or uiInstance:IsA("TextButton")) then
		self.Instance.TextColor3 = self.Color;
		self.IsText = true;
	end;

	self.Instance.Parent = self.UIInstance;

	self.Connection = RunService.Heartbeat:Connect(function(dt)
		if (self.IsPaused) then
			return;
		end;

		if (not self.UIInstance or self.UIInstance.Parent == nil) then
			self:Destroy();
			return;
		end;

		self.Color = self.Color:Lerp(self.ColorTarget, self.ColorAcceleration);
		self.Offset = self.Offset:Lerp(self.OffsetTarget, self.OffsetAcceleration);
		self.Transparency = self.Transparency + ((self.TransparencyTarget - self.Transparency) * self.TransparencyAcceleration);

		self.Instance.Position = UDim2.new(0, self.Offset.X, 0, self.Offset.Y);

		if (self.IsText) then
			self.Instance.Text = self.UIInstance.Text;
			self.Instance.TextTransparency = self.Transparency;
			self.Instance.TextColor3 = self.Color;
		end;

		self.Instance.ZIndex = self.UIInstance.ZIndex - 1;
	end);

	return setmetatable(self, Dropshadow);
end

function Dropshadow:SetOffset(offset: Vector2, acceleration: number)
	-- Accepts a Vector2 as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(offset) == "Vector2", "Offset isn't a Vector2");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.OffsetTarget = offset;
	self.OffsetAcceleration = math.clamp(acceleration, 0, 1);
end

function Dropshadow:SetTransparency(transparency: number, acceleration: number)
	-- Accepts a number as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(transparency) == "number", "Transparency isn't a number");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.TransparencyTarget = transparency;
	self.TransparencyAcceleration = math.clamp(acceleration, 0, 1);
end

function Dropshadow:SetColor(color: Color3, acceleration: number)
	-- Accepts a Color3 as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(color) == "Color3", "Color isn't a Color3");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.ColorTarget = color;
	self.ColorAcceleration = math.clamp(acceleration, 0, 1);
end

function Dropshadow:Pause()
	self.IsPaused = true;
end

function Dropshadow:Resume()
	self.IsPaused = false;
end

function Dropshadow:Destroy()
	self.Connection:Disconnect();
	if (self.Instance) then
		self.Instance:Destroy();
		self.Instance = nil;
	end;
end

return table.freeze(Dropshadow);
end)() end,
    [19] = function()local wax,script,require=ImportGlobals(19)local ImportGlobals return (function(...)local RunService = game:GetService("RunService");

type ColorSequenceKeypoints = typeof(ColorSequence.new(Color3.new()).Keypoints);
type NumberSequenceKeypoints = typeof(NumberSequence.new(0).Keypoints);
export type Gradient<T...> = {
	UIInstance: GuiObject,
	Instance: UIGradient,
	IsPaused: boolean,

	ColorSequence: ColorSequence,
	ColorSequenceTarget: ColorSequence,
	TrueColorSequence: ColorSequence?,
	ColorSequenceBlendRate: number,

	TransparencySequence: NumberSequence,
	TransparencySequenceTarget: NumberSequence,
	TrueTransparencySequence: NumberSequence?,
	TransparencySequenceBlendRate: number,

	Offset: number,
	OffsetTarget: number?,
	OffsetSpeed: number,
	OffsetSpeedTarget: number,
	OffsetAcceleration: number,

	TransparencyOffset: number,
	TransparencyOffsetTarget: number?,
	TransparencyOffsetSpeed: number,
	TransparencyOffsetSpeedTarget: number,
	TransparencyOffsetAcceleration: number,

	Rotation: number,
	RotationTarget: number?,
	RotationSpeed: number,
	RotationSpeedTarget: number,
	RotationAcceleration: number,

	Connection: RBXScriptConnection,
	IsText: boolean,

	Pause: (self: Gradient<T...>) -> nil,
	Resume: (self: Gradient<T...>) -> nil,
	SetColorSequence: (self: Gradient<T...>, sequence: ColorSequence, blendRate: number?) -> ColorSequence,
	SetOffset: (self: Gradient<T...>, offset: number, acceleration: number?) -> nil,
	SetOffsetSpeed: (self: Gradient<T...>, offset: number, acceleration: number?) -> nil,
	SetRotation: (self: Gradient<T...>, rotation: number, acceleration: number?) -> nil,
	SetRotationSpeed: (self: Gradient<T...>, rotation: number, acceleration: number?) -> nil,
	SetTransparencyOffset: (self: Gradient<T...>, offset: number, acceleration: number?) -> nil,
	SetTransparencyOffsetSpeed: (self: Gradient<T...>, offset: number, acceleration: number?) -> nil,
	SetTransparencySequence: (self: Gradient<T...>, transparency: number | NumberSequence, acceleration: number?) -> nil,
	EqualizeColorSequenceKeypoints: (self: Gradient<T...>) -> nil,
	EqualizeTransparencySequenceKeypoints: (self: Gradient<T...>) -> nil,
	CalculateTrueColorSequence: (self: Gradient<T...>) -> ColorSequence,
	CalculateTrueTransparencySequence: (self: Gradient<T...>) -> NumberSequence,
	Destroy: (self: Gradient<T...>) -> nil,
};

local function evalColorSequence(inputSequence: ColorSequenceKeypoints, time: number)
	local sequence = {};
	time += 1;

	for x = 0, 2 do
		for i = 1, #inputSequence do
			local datapoint = {Time = inputSequence[i].Time + x, Value = inputSequence[i].Value};
			table.insert(sequence, datapoint);
		end;
	end;

	-- Otherwise, step through each sequential pair of keypoints
	for i = 1, #sequence - 1 do
		local thisKeypoint = sequence[i];
		local nextKeypoint = sequence[i + 1];
		if (time >= thisKeypoint.Time and time < nextKeypoint.Time) then
			-- Calculate how far alpha lies between the points
			local alpha = (time - thisKeypoint.Time) / (nextKeypoint.Time - thisKeypoint.Time);
			-- Evaluate the real value between the points using alpha
			return Color3.new(
				(nextKeypoint.Value.R - thisKeypoint.Value.R) * alpha + thisKeypoint.Value.R,
				(nextKeypoint.Value.G - thisKeypoint.Value.G) * alpha + thisKeypoint.Value.G,
				(nextKeypoint.Value.B - thisKeypoint.Value.B) * alpha + thisKeypoint.Value.B
			);
		end;
	end;
end

local function evalNumberSequence(inputSequence: NumberSequenceKeypoints, time: number)
	local sequence = {};
	time += 1;

	for x = 0, 2 do
		for i = 1, #inputSequence do
			local datapoint = {Time = inputSequence[i].Time + x, Value = inputSequence[i].Value};
			table.insert(sequence, datapoint);
		end;
	end;

	-- Otherwise, step through each sequential pair of keypoints
	for i = 1, #sequence - 1 do
		local thisKeypoint = sequence[i];
		local nextKeypoint = sequence[i + 1];
		if (time >= thisKeypoint.Time and time < nextKeypoint.Time) then
			-- Calculate how far alpha lies between the points
			local alpha = (time - thisKeypoint.Time) / (nextKeypoint.Time - thisKeypoint.Time);
			-- Evaluate the real value between the points using alpha
			return thisKeypoint.Value + (nextKeypoint.Value - thisKeypoint.Value) * alpha;
		end;
	end;
end

local MAX_COLORSEQUENCE_KEYPOINTS = 19;
local MAX_NUMBERSEQUENCE_KEYPOINTS = 19;
local Gradient = {};
Gradient.__index = Gradient;

function Gradient.new<T...>(uiInstance: GuiObject | UIStroke, colorSequence: ColorSequence, transparencySequence: number | NumberSequence): Gradient<T...>
	assert(uiInstance, "UIInstance not provided");
	assert(uiInstance:IsA("GuiObject") or uiInstance:IsA("UIStroke"), "UIInstance is not a GuiObject or UIStroke");
	assert(colorSequence, "ColorSequence not provided");
	assert(transparencySequence, "TransparencySequence not provided")
	assert(typeof(colorSequence) == "ColorSequence", "ColorSequence is not a ColorSequence");
	assert(typeof(transparencySequence) == "number" or typeof(transparencySequence) == "NumberSequence", "TransparencySequence is not a number or NumberSequence");
	assert(#colorSequence.Keypoints <= MAX_COLORSEQUENCE_KEYPOINTS, "ColorSequence has too many keypoints");
	if (typeof(transparencySequence) == "NumberSequence") then
		assert(#transparencySequence.Keypoints <= MAX_NUMBERSEQUENCE_KEYPOINTS, "TransparencySequence has too many keypoints");
	end;

	local self = {};

	self.UIInstance = uiInstance;
	self.Instance = uiInstance:FindFirstChildWhichIsA("UIGradient") or Instance.new("UIGradient");
	self.IsPaused = false;

	self.ColorSequenceTarget = colorSequence;
	self.ColorSequence = colorSequence;
	self.TrueColorSequence = nil;
	self.ColorSequenceBlendRate = 1;

	self.TransparencySequenceTarget = nil;
	self.TransparencySequence = nil;
	self.TrueTransparencySequence = nil;
	self.TransparencySequenceBlendRate = 1;

	self.Offset = 0;
	self.OffsetTarget = nil;
	self.OffsetSpeed = 0;
	self.OffsetSpeedTarget = 0;
	self.OffsetAcceleration = 1;

	self.TransparencyOffset = 0;
	self.TransparencyOffsetTarget = nil;
	self.TransparencyOffsetSpeed = 0;
	self.TransparencyOffsetSpeedTarget = 0;
	self.TransparencyOffsetAcceleration = 1;

	self.Rotation = 0;
	self.RotationSpeed = 0;
	self.RotationSpeedTarget = 0;
	self.RotationAcceleration = 0;
	self.RotationTarget = nil;

	self.Connection = nil;
	self.IsText = false;

	if (typeof(transparencySequence) == "number") then
		self.TransparencySequenceTarget = NumberSequence.new({NumberSequenceKeypoint.new(0, transparencySequence), NumberSequenceKeypoint.new(1, transparencySequence)});
	elseif (typeof(transparencySequence) == "NumberSequence") then
		self.TransparencySequenceTarget = transparencySequence;
	else
		warn("Weird type of data?");
	end;

	self.TransparencySequence = self.TransparencySequenceTarget;

	if (uiInstance:IsA("TextLabel") or uiInstance:IsA("TextBox") or uiInstance:IsA("TextButton")) then
		self.IsText = true;
	end;

	self.Connection = RunService.Heartbeat:Connect(function(dt)
		if (self.IsPaused) then
			return;
		end;

		if (not self.UIInstance or self.UIInstance.Parent == nil) then
			self:Destroy();
			return;
		end;

		if (self.ColorSequenceBlendRate == 1) then
			self.ColorSequence = self.ColorSequenceTarget;
		else
			self:EqualizeColorSequenceKeypoints();
		end;

		if (self.TransparencySequenceBlendRate == 1) then
			self.TransparencySequence = self.TransparencySequenceTarget;
		end;

		if (self.OffsetTarget) then
			self.Offset = self.Offset + (self.OffsetTarget - self.Offset) * self.OffsetAcceleration;
		else
			self.OffsetSpeed = self.OffsetSpeed + (self.OffsetSpeedTarget - self.OffsetSpeed) * self.OffsetAcceleration * dt;
			self.Offset += self.OffsetSpeed * dt;
		end;

		if (self.TransparencyOffsetTarget) then
			self.TransparencyOffset = self.TransparencyOffset + (self.TransparencyOffsetTarget - self.TransparencyOffset) * self.TransparencyOffsetAcceleration;
		else
			self.TransparencyOffsetSpeed = self.TransparencyOffsetSpeed + (self.TransparencyOffsetSpeedTarget - self.TransparencyOffsetSpeed) * self.TransparencyOffsetAcceleration * dt;
			self.TransparencyOffset += self.TransparencyOffsetSpeed * dt;
		end;

		if (self.RotationTarget) then
			self.Rotation = self.Rotation + (self.RotationTarget - self.Rotation) * self.RotationAcceleration;
		else
			self.RotationSpeed = self.RotationSpeed + (self.RotationSpeedTarget - self.RotationSpeed) * self.RotationAcceleration * dt;
			self.Rotation += self.RotationSpeed * dt;
		end;

		self.Instance.Rotation = self.Rotation;
		self.Instance.Color = self:CalculateTrueColorSequence();
		self.Instance.Transparency = self:CalculateTrueTransparencySequence();
	end);

	self.Instance.Parent = self.UIInstance;
	return setmetatable(self, Gradient);
end

function Gradient:SetColorSequence(sequence: ColorSequence, blendRate: number?): ColorSequence
	assert(typeof(sequence) == "ColorSequence", "Sequence argument is nil or not a ColorSequence");

	self.ColorSequenceBlendRate = blendRate or 1;
	self.ColorSequenceTarget = sequence;

	return self.ColorSequenceTarget;
end

function Gradient:SetOffset(offset: number, acceleration: number?)
	-- Accepts a number as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(offset) == "number", "Offset isn't a number");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.OffsetTarget = offset;
	self.OffsetSpeed = 0;
	self.OffsetSpeedTarget = 0;
	self.OffsetAcceleration = math.clamp(acceleration, 0, 1);
end

function Gradient:SetOffsetSpeed(offset: number, acceleration: number?)
	-- Accepts a number as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(offset) == "number", "Offset isn't a number");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.OffsetSpeedTarget = offset;
	self.OffsetTarget = nil;
	self.OffsetAcceleration = math.clamp(acceleration, 0, 1);
end

function Gradient:SetRotation(rotation: number, acceleration: number?)
	-- Accepts a number as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(rotation) == "number", "Offset isn't a number");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.RotationTarget = rotation;
	self.RotationSpeed = 0;
	self.RotationSpeedTarget = 0;
	self.RotationAcceleration = math.clamp(acceleration, 0, 1);
end

function Gradient:SetRotationSpeed(rotation: number, acceleration: number?)
	-- Accepts a number as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(rotation) == "number", "Offset isn't a number");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.RotationSpeedTarget = rotation;
	self.RotationTarget = nil;
	self.RotationAcceleration = math.clamp(acceleration, 0, 1);
end

function Gradient:SetTransparencyOffset(offset: number, acceleration: number)
	-- Accepts a number as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(offset) == "number", "Offset isn't a number");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.TransparencyOffsetTarget = offset;
	self.TransparencyOffsetSpeed = 0;
	self.TransparencyOffsetSpeedTarget = 0;
	self.TransparencyOffsetAcceleration = math.clamp(acceleration, 0, 1);
end

function Gradient:SetTransparencyOffsetSpeed(offset: number, acceleration: number)
	-- Accepts a number as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(offset) == "number", "Offset isn't a number");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.TransparencyOffsetSpeedTarget = offset;
	self.TransparencyOffsetTarget = nil;
	self.TransparencyOffsetAcceleration = math.clamp(acceleration, 0, 1);
end

function Gradient:SetTransparencySequence(transparency: number | NumberSequence, acceleration: number?)
	-- Accepts a number or a NumberSequence as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(transparency, "Transparency is nil");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	if (typeof(transparency) == "number") then
		self.TransparencyTarget = NumberSequence.new({NumberSequenceKeypoint.new(0, transparency), NumberSequenceKeypoint.new(1, transparency)});
	elseif (typeof(transparency) == "NumberSequence") then
		self.TransparencyTarget = transparency;
	else
		warn("Weird type of data?");
	end;

	self.TransparencyAcceleration = math.clamp(acceleration, 0, 1);
end

function Gradient:EqualizeColorSequenceKeypoints()
	local keypointsA = self.ColorSequenceTarget.Keypoints;
	local keypointsB = self.ColorSequence.Keypoints;
	local newkeypoints = {};

	if (#keypointsA ~= #keypointsB) then
		for i, v in keypointsA do
			local new = ColorSequenceKeypoint.new(v.Time, evalColorSequence(keypointsB, v.Time));
			table.insert(newkeypoints, new);
		end;
	else
		for _, v in keypointsA do
			local sample = evalColorSequence(keypointsB, v.Time);
			local blend = sample:Lerp(v.Value, self.ColorSequenceBlendRate);
			local new = ColorSequenceKeypoint.new(v.Time, blend);
			table.insert(newkeypoints, new);
		end;
	end;

	self.ColorSequence = ColorSequence.new(newkeypoints);
end

function Gradient:EqualizeTransparencySequenceKeypoints()
	local keypointsA = self.TransparencySequenceTarget.Keypoints;
	local keypointsB = self.TransparencySequence.Keypoints;
	local newkeypoints = {};

	if (#keypointsA ~= #keypointsB) then
		for i, v in keypointsA do
			local new = NumberSequenceKeypoint.new(v.Time, evalNumberSequence(keypointsB, v.Time));
			table.insert(newkeypoints, new);
		end;
	else
		for _, v in keypointsA do
			local sample = evalNumberSequence(keypointsB, v.Time);
			local blend = sample:Lerp(v.Value, self.TransparencySequenceBlendRate);
			local new = NumberSequenceKeypoint.new(v.Time, blend);
			table.insert(newkeypoints, new);
		end;
	end;

	print(newkeypoints[1].Value, newkeypoints[2].Value, newkeypoints[3].Value, newkeypoints[4].Value, newkeypoints[5].Value)
	self.TransparencySequence = NumberSequence.new(newkeypoints);
end

function Gradient:CalculateTrueColorSequence()
	local temp = {};
	local lowestKeypointIndex = 5;
	local lowestTime = 100;

	for _, v in self.ColorSequence.Keypoints do
		local evaledTime = (v.Time + self.Offset);
		if (evaledTime > 1 or evaledTime < 0) then
			evaledTime = evaledTime % 1;
		end;
		local newKeypoint = ColorSequenceKeypoint.new(evaledTime, v.Value);
		if (newKeypoint.Time <= lowestTime) then
			temp[lowestKeypointIndex - 1] = newKeypoint;
			lowestKeypointIndex = lowestKeypointIndex - 1;
			lowestTime = newKeypoint.Time;
		else
			temp[#temp + 1] = newKeypoint;
		end;
	end;

	local keypoints = {};
	for i,v in temp do
		table.insert(keypoints, v);
	end;

	table.sort(keypoints, function(a, b)
		return a.Time < b.Time;
	end);

	if keypoints[1].Time ~= 0 then
		local newPoint = ColorSequenceKeypoint.new(0, evalColorSequence(keypoints, 0));
		table.insert(keypoints, 1, newPoint);
	end;

	if keypoints[#keypoints].Time ~= 1 then
		local newPoint = ColorSequenceKeypoint.new(1, evalColorSequence(keypoints, 1));
		table.insert(keypoints, newPoint);
	end;

	self.TrueColorSequence = ColorSequence.new(keypoints);
	return self.TrueColorSequence;
end

function Gradient:CalculateTrueTransparencySequence()
	if (#self.TransparencySequenceTarget.Keypoints == 2) then
		if (self.TransparencySequenceTarget.Keypoints[1].Value == self.TransparencySequenceTarget.Keypoints[2].Value) then
			self.TrueTransparencySequence = self.TransparencySequenceTarget;
			return self.TrueTransparencySequence;
		end;
	end;

	local temp = {};
	local lowestKeypointIndex = #self.TransparencySequence.Keypoints + 1;
	local lowestTime = math.huge;

	for _, v in self.TransparencySequence.Keypoints do
		local evaledTime = (v.Time + self.TransparencyOffset);
		if (evaledTime > 1 or evaledTime < 0) then
			evaledTime = evaledTime % 1;
		end;
		local newKeypoint = NumberSequenceKeypoint.new(evaledTime, v.Value);
		if (newKeypoint.Time <= lowestTime) then
			temp[lowestKeypointIndex - 1] = newKeypoint;
			lowestKeypointIndex = lowestKeypointIndex - 1;
			lowestTime = newKeypoint.Time;
		else
			temp[#temp + 1] = newKeypoint;
		end;
	end;

	local keypoints = {};
	for _, v in temp do
		table.insert(keypoints, v);
	end;

	table.sort(keypoints, function(a, b)
		return a.Time < b.Time;
	end)

	if (keypoints[1].Time ~= 0) then
		local newPoint = NumberSequenceKeypoint.new(0, evalNumberSequence(keypoints, 0));
		table.insert(keypoints, 1, newPoint);
	end;

	if (keypoints[#keypoints].Time ~= 1) then
		local value = evalNumberSequence(keypoints, 1);
		local newPoint = NumberSequenceKeypoint.new(1, value);
		table.insert(keypoints, newPoint);
	end;

	self.TrueTransparencySequence = NumberSequence.new(keypoints);
	return self.TrueTransparencySequence;
end

function Gradient:Pause()
	self.IsPaused = true;
end

function Gradient:Resume()
	self.IsPaused = false;
end

function Gradient:Destroy()
	self.Connection:Disconnect();
	if (self.Instance) then
		self.Instance:Destroy();
		self.Instance = nil;
	end;
end

return table.freeze(Gradient);
end)() end,
    [20] = function()local wax,script,require=ImportGlobals(20)local ImportGlobals return (function(...)local Modules = script:GetDescendants();
local SubModules = {};

for _, module in Modules do
    if (module.ClassName ~= "ModuleScript") then continue end;
    SubModules[module.Name] = require(module)();
end

return SubModules;

end)() end,
    [21] = function()local wax,script,require=ImportGlobals(21)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.9529411792755127, 0.3960784375667572, 0.6941176652908325)),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 0.6549019813537598, 0.8901960849761963)),
        ColorSequenceKeypoint.new(1, Color3.new(0.9529411792755127, 0.3960784375667572, 0.6941176652908325)),
    })
    Gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.09894459694623947, 0),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(0.8997361660003662, 0),
        NumberSequenceKeypoint.new(1, 0),
    })
    return Gradient;
end;
end)() end,
    [22] = function()local wax,script,require=ImportGlobals(22)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0, 0.062745101749897, 0.3529411852359772)),
        ColorSequenceKeypoint.new(0.0677083358168602, Color3.new(0.686274528503418, 0.7882353067398071, 0.8352941274642944)),
        ColorSequenceKeypoint.new(0.171875, Color3.new(0.8784313797950745, 0.9411764740943909, 1)),
        ColorSequenceKeypoint.new(0.3177083432674408, Color3.new(1, 0.7058823704719543, 1)),
        ColorSequenceKeypoint.new(0.4670138955116272, Color3.new(0.2666666805744171, 0, 0.49803921580314636)),
        ColorSequenceKeypoint.new(0.4982638955116272, Color3.new(0.019607843831181526, 0.003921568859368563, 0.03529411926865578)),
        ColorSequenceKeypoint.new(0.5034722089767456, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.71875, Color3.new(0.7058823704719543, 1, 0.9529411792755127)),
        ColorSequenceKeypoint.new(0.9409722089767456, Color3.new(0.15203255414962769, 0.6226686239242554, 0.6860832571983337)),
        ColorSequenceKeypoint.new(1, Color3.new(0, 0.062745101749897, 0.3529411852359772)),
    })
    return Gradient;
end
end)() end,
    [23] = function()local wax,script,require=ImportGlobals(23)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.6, 0, 0)),
        ColorSequenceKeypoint.new(0.125, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.2552083432674408, Color3.new(0.411764, 0, 0)),
        ColorSequenceKeypoint.new(0.3767361044883728, Color3.new(0.3, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.new(0.690196, 0, 0)),
        ColorSequenceKeypoint.new(0.6197916865348816, Color3.new(0.3, 0, 0)),
        ColorSequenceKeypoint.new(0.7378472089767456, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.8680555820465088, Color3.new(0.3, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(0.6, 0, 0))
    })
    return Gradient;
end
end)() end,
    [24] = function()local wax,script,require=ImportGlobals(24)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 0.917647, 0)),
        ColorSequenceKeypoint.new(0.1510416716337204, Color3.new(1, 0.917647, 0)),
        ColorSequenceKeypoint.new(0.3072916567325592, Color3.new(1, 0.6, 0)),
        ColorSequenceKeypoint.new(0.4965277910232544, Color3.new(0.545098, 0.368627, 0.035294)),
        ColorSequenceKeypoint.new(0.6649305820465088, Color3.new(1, 0.666666, 0)),
        ColorSequenceKeypoint.new(0.8385416865348816, Color3.new(0.678431, 0.490196, 0.113725)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 0.917647, 0)),
    });
    return Gradient;
end
end)() end,
    [25] = function()local wax,script,require=ImportGlobals(25)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.new(0.7098039388656616, 0.7215686440467834, 0.7372549176216125)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
    })
    Gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.09894459694623947, 0),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(0.8997361660003662, 0),
        NumberSequenceKeypoint.new(1, 0),
    })
    return Gradient;
end
end)() end,
    [26] = function()local wax,script,require=ImportGlobals(26)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.8352941274642944, 0.6823529601097107, 0.21960784494876862)),
        ColorSequenceKeypoint.new(0.220486119389534, Color3.new(0.8352941274642944, 0.6823529601097107, 0.21960784494876862)),
        ColorSequenceKeypoint.new(0.3680555522441864, Color3.new(0.7803921699523926, 0.5960784554481506, 0.0470588244497776)),
        ColorSequenceKeypoint.new(0.4982638955116272, Color3.new(0.8509804010391235, 0.6980392336845398, 0.0117647061124444)),
        ColorSequenceKeypoint.new(0.5034722089767456, Color3.new(1, 0.9254902005195618, 0.5058823823928833)),
        ColorSequenceKeypoint.new(0.6927083134651184, Color3.new(0.8352941274642944, 0.6823529601097107, 0.21960784494876862)),
        ColorSequenceKeypoint.new(0.7916666865348816, Color3.new(0.8352941274642944, 0.6823529601097107, 0.21960784494876862)),
        ColorSequenceKeypoint.new(1, Color3.new(0.8352941274642944, 0.6823529601097107, 0.21960784494876862)),
    })
    return Gradient;
end
end)() end,
    [27] = function()local wax,script,require=ImportGlobals(27)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0))
    });
    Gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.7, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    return Gradient;
end
end)() end,
    [28] = function()local wax,script,require=ImportGlobals(28)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(109, 210, 212)),
        ColorSequenceKeypoint.new(0.171875, Color3.new(0.8784313797950745, 0.9411764740943909, 1)),
        ColorSequenceKeypoint.new(0.3177083432674408, Color3.fromRGB(140, 208, 209)),
        ColorSequenceKeypoint.new(0.4670138955116272, Color3.fromRGB(109, 210, 212)),
        ColorSequenceKeypoint.new(0.4982638955116272, Color3.fromRGB(109, 210, 212)),
        ColorSequenceKeypoint.new(0.5034722089767456, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.71875, Color3.new(0.7058823704719543, 1, 0.9529411792755127)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(109, 210, 212)),
    })
    return Gradient;
end
end)() end,
    [29] = function()local wax,script,require=ImportGlobals(29)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.125, Color3.new(1, 0.7843137383460999, 0)),
        ColorSequenceKeypoint.new(0.2552083432674408, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.3767361044883728, Color3.new(1, 0.7843137383460999, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.6197916865348816, Color3.new(1, 0.7843137383460999, 0)),
        ColorSequenceKeypoint.new(0.7378472089767456, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.8680555820465088, Color3.new(1, 0.7843137383460999, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0)),
    });
    return Gradient;
end
end)() end,
    [30] = function()local wax,script,require=ImportGlobals(30)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        -- matrix colors
        ColorSequenceKeypoint.new(0, Color3.new(0.243137, 0.937254, 0.007843)),
        ColorSequenceKeypoint.new(0.015625, Color3.new(0.243137, 0.937254, 0.007843)),
        ColorSequenceKeypoint.new(0.1458333283662796, Color3.new(0.243137, 0.937254, 0.007843)),
        ColorSequenceKeypoint.new(0.2482638955116272, Color3.new(0.243137, 0.937254, 0.007843)),
        ColorSequenceKeypoint.new(0.3559027910232544, Color3.new(0.243137, 0.937254, 0.007843)),
        ColorSequenceKeypoint.new(0.4970000088214874, Color3.new(0.243137, 0.937254, 0.007843)),
        ColorSequenceKeypoint.new(0.503000020980835, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(0.647569477558136, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(0.7829861044883728, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(0.890625, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(0.9774305820465088, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
    })
    return Gradient;
end
end)() end,
    [31] = function()local wax,script,require=ImportGlobals(31)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0, 0.45098039507865906, 1)),
        ColorSequenceKeypoint.new(0.125, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.2552083432674408, Color3.new(0, 0.45098039507865906, 1)),
        ColorSequenceKeypoint.new(0.3767361044883728, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.new(0, 0.45098039507865906, 1)),
        ColorSequenceKeypoint.new(0.6197916865348816, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.7374784350395203, Color3.new(0, 0.45098039507865906, 1)),
        ColorSequenceKeypoint.new(0.8680555820465088, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(0, 0.45098039507865906, 1)),
    })
    return Gradient;
end
end)() end,
    [32] = function()local wax,script,require=ImportGlobals(32)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
        ColorSequenceKeypoint.new(0.1510416716337204, Color3.new(0.615686297416687, 0, 1)),
        ColorSequenceKeypoint.new(0.3072916567325592, Color3.new(0.06666667014360428, 0, 1)),
        ColorSequenceKeypoint.new(0.4965277910232544, Color3.new(0, 1, 1)),
        ColorSequenceKeypoint.new(0.6649305820465088, Color3.new(0.01568627543747425, 1, 0)),
        ColorSequenceKeypoint.new(0.8385416865348816, Color3.new(1, 1, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0)),
    });
    return Gradient;
end
end)() end,
    [33] = function()local wax,script,require=ImportGlobals(33)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(0.8352941274642944, 0.8352941274642944, 0.8352941274642944)),
        ColorSequenceKeypoint.new(0.284722238779068, Color3.new(0.7333333492279053, 0.7843137383460999, 0.8352941274642944)),
        ColorSequenceKeypoint.new(0.4982638955116272, Color3.new(0.3333333432674408, 0.3333333432674408, 0.43921568989753723)),
        ColorSequenceKeypoint.new(0.5034722089767456, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.7152777910232544, Color3.new(0.7333333492279053, 0.7843137383460999, 0.8352941274642944)),
        ColorSequenceKeypoint.new(1, Color3.new(0.8352941274642944, 0.8352941274642944, 0.8352941274642944)),
    })
    return Gradient;
end
end)() end,
    [34] = function()local wax,script,require=ImportGlobals(34)local ImportGlobals return (function(...)return function()
    local Gradient = Instance.new("UIGradient");
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.015625, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.1458333283662796, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.2482638955116272, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.3559027910232544, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.4970000088214874, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.503000020980835, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(0.647569477558136, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(0.7829861044883728, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(0.890625, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(0.9774305820465088, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
    })
    return Gradient;
end
end)() end,
    [35] = function()local wax,script,require=ImportGlobals(35)local ImportGlobals return (function(...)local Modules = script:GetDescendants();
local SubModules = {};

for _, module in Modules do
    if (module.ClassName ~= "ModuleScript") then continue end;
    SubModules[module.Name] = require(module);
end

return SubModules;

end)() end,
    [36] = function()local wax,script,require=ImportGlobals(36)local ImportGlobals return (function(...)local RunService = game:GetService("RunService");

local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Bubblegum.Color, 0);
    mainGradient:SetRotation(-90, 1);
    mainGradient:SetOffsetSpeed(speed, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Bubblegum.Color, 0);
    strokeGradient:SetRotation(-45, 1);
	strokeGradient:SetOffsetSpeed(speed * 0.9, 1);

	local Scale = size * 3;
	local Connection;
	Connection = RunService.Heartbeat:Connect(function()
		if (not mainStroke.Instance or mainStroke.Instance.Parent == nil) then
			Connection:Disconnect();
			return;
		end;

		local t = tick() * speed;
		local sizeMultiplier = 1 + Scale * math.sin(t);
		mainStroke:SetSize(size * sizeMultiplier, 0.055);
	end);

	return {
		Effects = { mainGradient, strokeGradient, mainStroke },
		Connections = { Connection }
	};
end
end)() end,
    [37] = function()local wax,script,require=ImportGlobals(37)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Chrome.Color, 0);
    mainGradient:SetRotation(-90, 1);
    mainGradient:SetOffsetSpeed(speed, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Chrome.Color, 0);
    strokeGradient:SetRotation(-89, 1);
    strokeGradient:SetOffsetSpeed(speed * 0.58, 1);
    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [38] = function()local wax,script,require=ImportGlobals(38)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Death.Color, 0);
    mainGradient:SetRotation(-90, 1);
    mainGradient:SetOffsetSpeed(speed, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Death.Color, 0);
    strokeGradient:SetOffsetSpeed(-speed - 0.001, 1);
    strokeGradient:SetRotation(-85, 1);
    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [39] = function()local wax,script,require=ImportGlobals(39)local ImportGlobals return (function(...)local RunService = game:GetService("RunService");

local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Fire.Color, 0);
    mainGradient:SetRotation(-75, 1);
    mainGradient:SetOffsetSpeed(speed, 1);

    local Rotation = 0;
	local Connection
	Connection = RunService.Heartbeat:Connect(function(dt)
		if (not mainGradient.Instance or mainGradient.Instance.Parent == nil) then
			Connection:Disconnect();
		end;
		Rotation = Rotation + speed * dt;
		mainGradient:SetRotation(Rotation, 1);
	end);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Fire.Color, 0);
    strokeGradient:SetRotation(75, 1);
    strokeGradient:SetOffsetSpeed(-speed, 1);

	return {
		Effects = { mainGradient, strokeGradient, mainStroke },
		Connections = { Connection }
	};
end
end)() end,
    [40] = function()local wax,script,require=ImportGlobals(40)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Ghost.Color, TextEffects.Templates.Ghost.Transparency);
    mainGradient:SetOffsetSpeed(speed, 1);
    mainGradient:SetTransparencyOffsetSpeed(speed * 0.9, 1);
    return {
        Effects = { mainGradient }
    };
end
end)() end,
    [41] = function()local wax,script,require=ImportGlobals(41)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Ghost.Color, TextEffects.Templates.Ghost.Transparency);
    mainGradient:SetOffsetSpeed(speed, 1);
    mainGradient:SetTransparencyOffsetSpeed(speed * 0.9, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Ghost.Color, TextEffects.Templates.Ghost.Transparency);
    strokeGradient:SetOffsetSpeed(-speed * 0.9, 1);
    strokeGradient:SetTransparencyOffsetSpeed(-speed * 0.9, 1);
    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [42] = function()local wax,script,require=ImportGlobals(42)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Gold.Color, 0);
    mainGradient:SetRotation(-75, 1);
    mainGradient:SetOffsetSpeed(speed, 1);
    return {
        Effects = { mainGradient }
    };
end
end)() end,
    [43] = function()local wax,script,require=ImportGlobals(43)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Gold.Color, 0);
    mainGradient:SetRotation(-75, 1);
    mainGradient:SetOffsetSpeed(speed, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Gold.Color, 0);
    strokeGradient:SetRotation(75, 1);
    strokeGradient:SetOffsetSpeed(-speed, 1);
    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [44] = function()local wax,script,require=ImportGlobals(44)local ImportGlobals return (function(...)local RunService = game:GetService("RunService");

local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Green.Color, TextEffects.Templates.Green.Transparency);
    local Rotation = 5;

	local Connection
	Connection = RunService.Heartbeat:Connect(function(dt)
		if (not mainStroke.Instance or mainStroke.Instance.Parent == nil) then
			Connection:Disconnect();
		end;
		Rotation = Rotation + speed * dt;
		strokeGradient:SetRotation(Rotation, 1);
	end);

	return {
		Effects = { strokeGradient, mainStroke },
		Connections = { Connection }
	};
end
end)() end,
    [45] = function()local wax,script,require=ImportGlobals(45)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Ice.Color, 0);
    mainGradient:SetRotation(-65, 1);
    mainGradient:SetOffsetSpeed(speed, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Ice.Color, 0);
    strokeGradient:SetRotation(-61, 1);
    strokeGradient:SetOffsetSpeed(speed * 0.23, 1);
    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [46] = function()local wax,script,require=ImportGlobals(46)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Lava.Color, 0);
    mainGradient:SetOffsetSpeed(speed, 1);
    return {
        Effects = { mainGradient }
    };
end
end)() end,
    [47] = function()local wax,script,require=ImportGlobals(47)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Lava.Color, 0);
    mainGradient:SetOffsetSpeed(speed, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Lava.Color, 0);
    strokeGradient:SetOffsetSpeed(-speed, 1);
    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [48] = function()local wax,script,require=ImportGlobals(48)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Matrix.Color, 0);
    mainGradient:SetOffsetSpeed(speed, 1);
    mainGradient:SetRotation(90, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);

    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Matrix.Color, 0);
    strokeGradient:SetOffset(0.5, 1);
    strokeGradient:SetRotation(90, 1);

    task.delay(0.1, function()
        strokeGradient:SetOffsetSpeed(speed, 1);
    end);

    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [49] = function()local wax,script,require=ImportGlobals(49)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Oceanic.Color, 0);
    mainGradient:SetOffsetSpeed(speed, 1);
    mainGradient:SetRotation(-75, 1);
    mainGradient:SetRotationSpeed(0.1, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Oceanic.Color, 0);
    strokeGradient:SetOffsetSpeed(-speed, 1);
    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [50] = function()local wax,script,require=ImportGlobals(50)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Rainbow.Color, 0);
    mainGradient:SetOffsetSpeed(speed, 1);
    return {
        Effects = { mainGradient }
    };
end
end)() end,
    [51] = function()local wax,script,require=ImportGlobals(51)local ImportGlobals return (function(...)local RunService = game:GetService("RunService");

local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Rainbow.Color, 0);
    local Rotation = 5;

	local Connection
	Connection = RunService.Heartbeat:Connect(function(dt)
		if (not mainStroke.Instance or mainStroke.Instance.Parent == nil) then
			Connection:Disconnect();
		end;
		Rotation = Rotation + speed * dt;
		strokeGradient:SetRotation(Rotation, 1);
	end);

	return {
		Effects = { strokeGradient, mainStroke },
		Connections = { Connection }
	};
end
end)() end,
    [52] = function()local wax,script,require=ImportGlobals(52)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Rainbow.Color, 0);
    mainGradient:SetOffsetSpeed(speed, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Rainbow.Color, 0);
    strokeGradient:SetOffsetSpeed(-speed, 1);
    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [53] = function()local wax,script,require=ImportGlobals(53)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

-- Making colors lighter
local function makeLighter(color: Color3, amount: number): Color3
    return color:Lerp(Color3.fromRGB(255, 255, 255), amount);
end

local function findColorFromObject(uiInstance: GuiObject): Color3
    local Data = {
        ["TextButton"] = "BackgroundColor3",
        ["TextLabel"] = "TextColor3",
        ["ImageLabel"] = "ImageColor3",
        ["ImageButton"] = "ImageColor3",
        ["Frame"] = "BackgroundColor3",
        ["ScrollingFrame"] = "BackgroundColor3",
        ["ViewportFrame"] = "BackgroundColor3",
    };

    local color = uiInstance[Data[uiInstance.ClassName]];
    if (color) then
        return color;
    end;

    -- If we can't find a color, we'll just use white
    return Color3.fromRGB(255, 255, 255);
end

return function(uiInstance: GuiObject, speed: number, size: number, customColor: Color3)
    customColor = customColor or findColorFromObject(uiInstance);

    -- We're not going to use a GradientTemplate because this requires us to do some things with the customColor
    local color1 = customColor;
    local color2 = makeLighter(customColor, 0.417505);
    local color3 = customColor;

    local colorSequenceForShine = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(0.5, color2),
        ColorSequenceKeypoint.new(1, color3)
    });

    local mainGradient = TextEffects.Gradient.new(uiInstance, colorSequenceForShine, 0);
    mainGradient:SetOffsetSpeed(speed * 0.6, 1);
    mainGradient:SetRotation(60, 1);
    return {
        Effects = { mainGradient }
    };
end

end)() end,
    [54] = function()local wax,script,require=ImportGlobals(54)local ImportGlobals return (function(...)local RunService = game:GetService("RunService");
local TextEffects = require(script.Parent.Parent);

-- Making colors lighter
local function makeLighter(color: Color3, amount: number): Color3
    return color:Lerp(Color3.fromRGB(255, 255, 255), amount);
end

local function findColorFromObject(uiInstance: GuiObject): Color3
    local Data = {
        ["TextButton"] = "BackgroundColor3",
        ["TextLabel"] = "TextColor3",
        ["ImageLabel"] = "ImageColor3",
        ["ImageButton"] = "ImageColor3",
        ["Frame"] = "BackgroundColor3",
        ["ScrollingFrame"] = "BackgroundColor3",
        ["ViewportFrame"] = "BackgroundColor3",
    };

    local color = uiInstance[Data[uiInstance.ClassName]];
    if (color) then
        return color;
    end;

    -- If we can't find a color, we'll just use white
    return Color3.fromRGB(255, 255, 255);
end

return function(uiInstance: GuiObject, speed: number, size: number, customColor: Color3)
    customColor = customColor or findColorFromObject(uiInstance);

    -- We're not going to use a GradientTemplate because this requires us to do some things with the customColor
    local color1 = customColor;
    local color2 = makeLighter(customColor, 0.6);
    local color3 = customColor;

    local colorSequenceForShine = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(0.5, color2),
        ColorSequenceKeypoint.new(1, color3)
	});
		
	local mainStroke = TextEffects.Stroke.new(uiInstance, size);
	local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, colorSequenceForShine, 0);
	local Rotation = 0.75;
	
	local Connection
	Connection = RunService.Heartbeat:Connect(function(dt)
		if (not mainStroke.Instance or mainStroke.Instance.Parent == nil) then
			Connection:Disconnect();
		end;
		
		Rotation = Rotation + speed * dt;
		strokeGradient:SetRotation(Rotation, 1);
	end);

	return {
		Effects = { strokeGradient, mainStroke },
		Connections = { Connection }
	};
end

end)() end,
    [55] = function()local wax,script,require=ImportGlobals(55)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Silver.Color, 0);
    mainGradient:SetRotation(-75, 1);
    mainGradient:SetOffsetSpeed(speed, 1);
    return {
        Effects = { mainGradient }
    };
end
end)() end,
    [56] = function()local wax,script,require=ImportGlobals(56)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Silver.Color, 0);
    mainGradient:SetRotation(-80, 1);
    mainGradient:SetOffsetSpeed(speed, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Silver.Color, 0);
    strokeGradient:SetRotation(-79, 1);
    strokeGradient:SetOffsetSpeed(speed * 0.56, 1);
    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [57] = function()local wax,script,require=ImportGlobals(57)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number, customColor: Color3)
    local colorSequence = ColorSequence.new({
        ColorSequenceKeypoint.new(0, customColor),
        ColorSequenceKeypoint.new(0.5, customColor),
        ColorSequenceKeypoint.new(1, customColor)
    });

    local transparencySequence = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.25, 1),
        NumberSequenceKeypoint.new(0.5, 1),
        NumberSequenceKeypoint.new(0.75, 1),
        NumberSequenceKeypoint.new(1, 0)
    });

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);
    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, colorSequence, transparencySequence);
    strokeGradient:SetOffsetSpeed(speed, 1);
    strokeGradient:SetTransparencyOffsetSpeed(speed * 0.9, 1);
    return {
        Effects = { strokeGradient, mainStroke }
    };
end
end)() end,
    [58] = function()local wax,script,require=ImportGlobals(58)local ImportGlobals return (function(...)local TextEffects = require(script.Parent.Parent);

return function(uiInstance: GuiObject, speed: number, size: number)
    local mainGradient = TextEffects.Gradient.new(uiInstance, TextEffects.Templates.Zebra.Color, 0);
    mainGradient:SetOffsetSpeed(speed, 1);
    mainGradient:SetRotation(90, 1);

    local mainStroke = TextEffects.Stroke.new(uiInstance, size);

    local strokeGradient = TextEffects.Gradient.new(mainStroke.Instance, TextEffects.Templates.Zebra.Color, 0);
    strokeGradient:SetOffset(0.5, 1);
    strokeGradient:SetRotation(90, 1);

    task.delay(0.1, function()
        strokeGradient:SetOffsetSpeed(speed, 1);
    end);

    return {
        Effects = { mainGradient, strokeGradient, mainStroke }
    };
end
end)() end,
    [59] = function()local wax,script,require=ImportGlobals(59)local ImportGlobals return (function(...)local RunService = game:GetService("RunService");

-- Fingeroo was here ( ͡° ͜ʖ ͡°)

export type Stroke<T...> = {
	UIInstance: GuiObject,
	Instance: UIStroke,
	IsPaused: boolean,
	Color: Color3,
	ColorTarget: Color3,
	ColorAcceleration: number,
	Transparency: number,
	TransparencyTarget: number,
	TransparencyAcceleration: number,
	Size: number,
	SizeTarget: number,
	SizeAcceleration: number,
	Connection: RBXScriptConnection,
	IsText: boolean,

	Pause: (self: Stroke<T...>) -> nil,
	Resume: (self: Stroke<T...>) -> nil,
	SetSize: (self: Stroke<T...>, size: number, acceleration: number) -> nil,
	SetTransparency: (self: Stroke<T...>, transparency: number, acceleration: number) -> nil,
	SetColor: (self: Stroke<T...>, color: Color3, acceleration: number) -> nil,
	Destroy: (self: Stroke<T...>) -> nil,
};

local Stroke = {};
Stroke.__index = Stroke;

function Stroke.new<T...>(uiInstance: GuiObject | UIStroke, size: number, color: Color3?, transparency: number?): Stroke<T...>
	assert(uiInstance, "UIInstance not provided");
	assert(uiInstance:IsA("GuiObject") or uiInstance:IsA("UIStroke"), "UIInstance is not a GuiObject or UIStroke");
	assert(size, "Size not provided");
	assert(typeof(size) == "number", "Size is not a number");
	if (color) then
		assert(typeof(color) == "Color3", "Color is not a Color3");
	end;
	if (transparency) then
		assert(typeof(transparency) == "number", "Transparency is not a number");
	end;

	local self = {};

	self.UIInstance = uiInstance;
	self.Instance = uiInstance:FindFirstChildWhichIsA("UIStroke") or Instance.new("UIStroke");
	self.Instance.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	self.IsPaused = false;

	self.Color = color or Color3.new(1, 1, 1);
	self.ColorTarget = color or Color3.new(1, 1, 1);
	self.ColorAcceleration = 1;

	self.Transparency = transparency or 0;
	self.TransparencyTarget = transparency or 0;
	self.TransparencyAcceleration = 1;

	self.Size = size;
	self.SizeTarget = size;
	self.SizeAcceleration = 1;
	self.Connection = nil;
	self.IsText = false;

	if (uiInstance:IsA("TextLabel") or uiInstance:IsA("TextBox") or uiInstance:IsA("TextButton")) then
		self.IsText = true;
	end;

	self.Instance.Parent = self.UIInstance;

	self.Connection = RunService.Heartbeat:Connect(function(dt)
		if (self.IsPaused) then
			return;
		end;

		if (not self.UIInstance or self.UIInstance.Parent == nil) then
			self:Destroy();
			return;
		end;

		self.Color = self.Color:Lerp(self.ColorTarget, self.ColorAcceleration * dt);
		self.Size = self.Size + ((self.SizeTarget - self.Size) * self.SizeAcceleration * dt);
		self.Transparency = self.Transparency + ((self.TransparencyTarget - self.Transparency) * self.TransparencyAcceleration * dt);

		self.Instance.Transparency = self.Transparency;
		self.Instance.Color = self.Color;
		self.Instance.Thickness = self.Size;
	end);

	return setmetatable(self, Stroke);
end

function Stroke:SetSize(size: number, acceleration: number)
	-- Accepts a Vector2 as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(size) == "number", "Size isn't a number");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.SizeTarget = size;
	self.SizeAcceleration = math.clamp(acceleration, 0, 1);
end

function Stroke:SetTransparency(transparency: number, acceleration: number)
	-- Accepts a number as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(transparency) == "number", "Transparency isn't a number");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.TransparencyTarget = transparency;
	self.TransparencyAcceleration = math.clamp(acceleration, 0, 1);
end

function Stroke:SetColor(color: Color3, acceleration: number)
	-- Accepts a Color3 as the first argument and a number as the second argument.
	-- Values below 0 or above 1 for the acceleration argument do not make sense.
	assert(typeof(color) == "Color3", "Color isn't a Color3");
	assert(typeof(acceleration) == "number", "Acceleration isn't a number");

	self.ColorTarget = color;
	self.ColorAcceleration = math.clamp(acceleration, 0, 1);
end

function Stroke:Pause()
	self.IsPaused = true;
end

function Stroke:Resume()
	self.IsPaused = false;
end

function Stroke:Destroy()
	self.Connection:Disconnect();
	if (self.Instance) then
		self.Instance:Destroy();
		self.Instance = nil;
	end;
end

return table.freeze(Stroke);
end)() end,
    [60] = function()local wax,script,require=ImportGlobals(60)local ImportGlobals return (function(...)return {
	package = {
		authors = {"Arxk (https://github.com/arxkdev)"},
		description = "ezVisualz is a powerful library designed to enhance the animation of UI elements using UIGradients. It provides a wide range of presets out of the box and offers an easy-to-use experience for creating captivating visual effects.",
		license = "MIT",
		name = "arxkdev/ezvisualz",
		realm = "shared",
		registry = "https://github.com/UpliftGames/wally-index",
		version = "0.0.6",
	},
}
end)() end,
    [62] = function()local wax,script,require=ImportGlobals(62)local ImportGlobals return (function(...)--[[
	An implementation of Promises similar to Promise/A+.
]]

local ERROR_NON_PROMISE_IN_LIST = "Non-promise value passed into %s at index %s"
local ERROR_NON_LIST = "Please pass a list of promises to %s"
local ERROR_NON_FUNCTION = "Please pass a handler function to %s!"
local MODE_KEY_METATABLE = { __mode = "k" }

local function isCallable(value)
	if type(value) == "function" then
		return true
	end

	if type(value) == "table" then
		local metatable = getmetatable(value)
		if metatable and type(rawget(metatable, "__call")) == "function" then
			return true
		end
	end

	return false
end

--[[
	Creates an enum dictionary with some metamethods to prevent common mistakes.
]]
local function makeEnum(enumName, members)
	local enum = {}

	for _, memberName in ipairs(members) do
		enum[memberName] = memberName
	end

	return setmetatable(enum, {
		__index = function(_, k)
			error(string.format("%s is not in %s!", k, enumName), 2)
		end,
		__newindex = function()
			error(string.format("Creating new members in %s is not allowed!", enumName), 2)
		end,
	})
end

--[=[
	An object to represent runtime errors that occur during execution.
	Promises that experience an error like this will be rejected with
	an instance of this object.

	@class Error
]=]
local Error
do
	Error = {
		Kind = makeEnum("Promise.Error.Kind", {
			"ExecutionError",
			"AlreadyCancelled",
			"NotResolvedInTime",
			"TimedOut",
		}),
	}
	Error.__index = Error

	function Error.new(options, parent)
		options = options or {}
		return setmetatable({
			error = tostring(options.error) or "[This error has no error text.]",
			trace = options.trace,
			context = options.context,
			kind = options.kind,
			parent = parent,
			createdTick = os.clock(),
			createdTrace = debug.traceback(),
		}, Error)
	end

	function Error.is(anything)
		if type(anything) == "table" then
			local metatable = getmetatable(anything)

			if type(metatable) == "table" then
				return rawget(anything, "error") ~= nil and type(rawget(metatable, "extend")) == "function"
			end
		end

		return false
	end

	function Error.isKind(anything, kind)
		assert(kind ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

		return Error.is(anything) and anything.kind == kind
	end

	function Error:extend(options)
		options = options or {}

		options.kind = options.kind or self.kind

		return Error.new(options, self)
	end

	function Error:getErrorChain()
		local runtimeErrors = { self }

		while runtimeErrors[#runtimeErrors].parent do
			table.insert(runtimeErrors, runtimeErrors[#runtimeErrors].parent)
		end

		return runtimeErrors
	end

	function Error:__tostring()
		local errorStrings = {
			string.format("-- Promise.Error(%s) --", self.kind or "?"),
		}

		for _, runtimeError in ipairs(self:getErrorChain()) do
			table.insert(
				errorStrings,
				table.concat({
					runtimeError.trace or runtimeError.error,
					runtimeError.context,
				}, "\n")
			)
		end

		return table.concat(errorStrings, "\n")
	end
end

--[[
	Packs a number of arguments into a table and returns its length.

	Used to cajole varargs without dropping sparse values.
]]
local function pack(...)
	return select("#", ...), { ... }
end

--[[
	Returns first value (success), and packs all following values.
]]
local function packResult(success, ...)
	return success, select("#", ...), { ... }
end

local function makeErrorHandler(traceback)
	assert(traceback ~= nil, "traceback is nil")

	return function(err)
		-- If the error object is already a table, forward it directly.
		-- Should we extend the error here and add our own trace?

		if type(err) == "table" then
			return err
		end

		return Error.new({
			error = err,
			kind = Error.Kind.ExecutionError,
			trace = debug.traceback(tostring(err), 2),
			context = "Promise created at:\n\n" .. traceback,
		})
	end
end

--[[
	Calls a Promise executor with error handling.
]]
local function runExecutor(traceback, callback, ...)
	return packResult(xpcall(callback, makeErrorHandler(traceback), ...))
end

--[[
	Creates a function that invokes a callback with correct error handling and
	resolution mechanisms.
]]
local function createAdvancer(traceback, callback, resolve, reject)
	return function(...)
		local ok, resultLength, result = runExecutor(traceback, callback, ...)

		if ok then
			resolve(unpack(result, 1, resultLength))
		else
			reject(result[1])
		end
	end
end

local function isEmpty(t)
	return next(t) == nil
end

--[=[
	An enum value used to represent the Promise's status.
	@interface Status
	@tag enum
	@within Promise
	.Started "Started" -- The Promise is executing, and not settled yet.
	.Resolved "Resolved" -- The Promise finished successfully.
	.Rejected "Rejected" -- The Promise was rejected.
	.Cancelled "Cancelled" -- The Promise was cancelled before it finished.
]=]
--[=[
	@prop Status Status
	@within Promise
	@readonly
	@tag enums
	A table containing all members of the `Status` enum, e.g., `Promise.Status.Resolved`.
]=]
--[=[
	A Promise is an object that represents a value that will exist in the future, but doesn't right now.
	Promises allow you to then attach callbacks that can run once the value becomes available (known as *resolving*),
	or if an error has occurred (known as *rejecting*).

	@class Promise
	@__index prototype
]=]
local Promise = {
	Error = Error,
	Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
	_getTime = os.clock,
	_timeEvent = game:GetService("RunService").Heartbeat,
	_unhandledRejectionCallbacks = {},
}
Promise.prototype = {}
Promise.__index = Promise.prototype

function Promise._new(traceback, callback, parent)
	if parent ~= nil and not Promise.is(parent) then
		error("Argument #2 to Promise.new must be a promise or nil", 2)
	end

	local self = {
		-- The executor thread.
		_thread = nil,

		-- Used to locate where a promise was created
		_source = traceback,

		_status = Promise.Status.Started,

		-- A table containing a list of all results, whether success or failure.
		-- Only valid if _status is set to something besides Started
		_values = nil,

		-- Lua doesn't like sparse arrays very much, so we explicitly store the
		-- length of _values to handle middle nils.
		_valuesLength = -1,

		-- Tracks if this Promise has no error observers..
		_unhandledRejection = true,

		-- Queues representing functions we should invoke when we update!
		_queuedResolve = {},
		_queuedReject = {},
		_queuedFinally = {},

		-- The function to run when/if this promise is cancelled.
		_cancellationHook = nil,

		-- The "parent" of this promise in a promise chain. Required for
		-- cancellation propagation upstream.
		_parent = parent,

		-- Consumers are Promises that have chained onto this one.
		-- We track them for cancellation propagation downstream.
		_consumers = setmetatable({}, MODE_KEY_METATABLE),
	}

	if parent and parent._status == Promise.Status.Started then
		parent._consumers[self] = true
	end

	setmetatable(self, Promise)

	local function resolve(...)
		self:_resolve(...)
	end

	local function reject(...)
		self:_reject(...)
	end

	local function onCancel(cancellationHook)
		if cancellationHook then
			if self._status == Promise.Status.Cancelled then
				cancellationHook()
			else
				self._cancellationHook = cancellationHook
			end
		end

		return self._status == Promise.Status.Cancelled
	end

	self._thread = coroutine.create(function()
		local ok, _, result = runExecutor(self._source, callback, resolve, reject, onCancel)

		if not ok then
			reject(result[1])
		end
	end)

	task.spawn(self._thread)

	return self
end

--[=[
	Construct a new Promise that will be resolved or rejected with the given callbacks.

	If you `resolve` with a Promise, it will be chained onto.

	You can safely yield within the executor function and it will not block the creating thread.

	```lua
	local myFunction()
		return Promise.new(function(resolve, reject, onCancel)
			wait(1)
			resolve("Hello world!")
		end)
	end

	myFunction():andThen(print)
	```

	You do not need to use `pcall` within a Promise. Errors that occur during execution will be caught and turned into a rejection automatically. If `error()` is called with a table, that table will be the rejection value. Otherwise, string errors will be converted into `Promise.Error(Promise.Error.Kind.ExecutionError)` objects for tracking debug information.

	You may register an optional cancellation hook by using the `onCancel` argument:

	* This should be used to abort any ongoing operations leading up to the promise being settled.
	* Call the `onCancel` function with a function callback as its only argument to set a hook which will in turn be called when/if the promise is cancelled.
	* `onCancel` returns `true` if the Promise was already cancelled when you called `onCancel`.
	* Calling `onCancel` with no argument will not override a previously set cancellation hook, but it will still return `true` if the Promise is currently cancelled.
	* You can set the cancellation hook at any time before resolving.
	* When a promise is cancelled, calls to `resolve` or `reject` will be ignored, regardless of if you set a cancellation hook or not.

	:::caution
	If the Promise is cancelled, the `executor` thread is closed with `coroutine.close` after the cancellation hook is called.

	You must perform any cleanup code in the cancellation hook: any time your executor yields, it **may never resume**.
	:::

	@param executor (resolve: (...: any) -> (), reject: (...: any) -> (), onCancel: (abortHandler?: () -> ()) -> boolean) -> ()
	@return Promise
]=]
function Promise.new(executor)
	return Promise._new(debug.traceback(nil, 2), executor)
end

function Promise:__tostring()
	return string.format("Promise(%s)", self._status)
end

--[=[
	The same as [Promise.new](/api/Promise#new), except execution begins after the next `Heartbeat` event.

	This is a spiritual replacement for `spawn`, but it does not suffer from the same [issues](https://eryn.io/gist/3db84579866c099cdd5bb2ff37947cec) as `spawn`.

	```lua
	local function waitForChild(instance, childName, timeout)
	  return Promise.defer(function(resolve, reject)
		local child = instance:WaitForChild(childName, timeout)

		;(child and resolve or reject)(child)
	  end)
	end
	```

	@param executor (resolve: (...: any) -> (), reject: (...: any) -> (), onCancel: (abortHandler?: () -> ()) -> boolean) -> ()
	@return Promise
]=]
function Promise.defer(executor)
	local traceback = debug.traceback(nil, 2)
	local promise
	promise = Promise._new(traceback, function(resolve, reject, onCancel)
		local connection
		connection = Promise._timeEvent:Connect(function()
			connection:Disconnect()
			local ok, _, result = runExecutor(traceback, executor, resolve, reject, onCancel)

			if not ok then
				reject(result[1])
			end
		end)
	end)

	return promise
end

-- Backwards compatibility
Promise.async = Promise.defer

--[=[
	Creates an immediately resolved Promise with the given value.

	```lua
	-- Example using Promise.resolve to deliver cached values:
	function getSomething(name)
		if cache[name] then
			return Promise.resolve(cache[name])
		else
			return Promise.new(function(resolve, reject)
				local thing = getTheThing()
				cache[name] = thing

				resolve(thing)
			end)
		end
	end
	```

	@param ... any
	@return Promise<...any>
]=]
function Promise.resolve(...)
	local length, values = pack(...)
	return Promise._new(debug.traceback(nil, 2), function(resolve)
		resolve(unpack(values, 1, length))
	end)
end

--[=[
	Creates an immediately rejected Promise with the given value.

	:::caution
	Something needs to consume this rejection (i.e. `:catch()` it), otherwise it will emit an unhandled Promise rejection warning on the next frame. Thus, you should not create and store rejected Promises for later use. Only create them on-demand as needed.
	:::

	@param ... any
	@return Promise<...any>
]=]
function Promise.reject(...)
	local length, values = pack(...)
	return Promise._new(debug.traceback(nil, 2), function(_, reject)
		reject(unpack(values, 1, length))
	end)
end

--[[
	Runs a non-promise-returning function as a Promise with the
  given arguments.
]]
function Promise._try(traceback, callback, ...)
	local valuesLength, values = pack(...)

	return Promise._new(traceback, function(resolve)
		resolve(callback(unpack(values, 1, valuesLength)))
	end)
end

--[=[
	Begins a Promise chain, calling a function and returning a Promise resolving with its return value. If the function errors, the returned Promise will be rejected with the error. You can safely yield within the Promise.try callback.

	:::info
	`Promise.try` is similar to [Promise.promisify](#promisify), except the callback is invoked immediately instead of returning a new function.
	:::

	```lua
	Promise.try(function()
		return math.random(1, 2) == 1 and "ok" or error("Oh an error!")
	end)
		:andThen(function(text)
			print(text)
		end)
		:catch(function(err)
			warn("Something went wrong")
		end)
	```

	@param callback (...: T...) -> ...any
	@param ... T... -- Additional arguments passed to `callback`
	@return Promise
]=]
function Promise.try(callback, ...)
	return Promise._try(debug.traceback(nil, 2), callback, ...)
end

--[[
	Returns a new promise that:
		* is resolved when all input promises resolve
		* is rejected if ANY input promises reject
]]
function Promise._all(traceback, promises, amount)
	if type(promises) ~= "table" then
		error(string.format(ERROR_NON_LIST, "Promise.all"), 3)
	end

	-- We need to check that each value is a promise here so that we can produce
	-- a proper error rather than a rejected promise with our error.
	for i, promise in pairs(promises) do
		if not Promise.is(promise) then
			error(string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.all", tostring(i)), 3)
		end
	end

	-- If there are no values then return an already resolved promise.
	if #promises == 0 or amount == 0 then
		return Promise.resolve({})
	end

	return Promise._new(traceback, function(resolve, reject, onCancel)
		-- An array to contain our resolved values from the given promises.
		local resolvedValues = {}
		local newPromises = {}

		-- Keep a count of resolved promises because just checking the resolved
		-- values length wouldn't account for promises that resolve with nil.
		local resolvedCount = 0
		local rejectedCount = 0
		local done = false

		local function cancel()
			for _, promise in ipairs(newPromises) do
				promise:cancel()
			end
		end

		-- Called when a single value is resolved and resolves if all are done.
		local function resolveOne(i, ...)
			if done then
				return
			end

			resolvedCount = resolvedCount + 1

			if amount == nil then
				resolvedValues[i] = ...
			else
				resolvedValues[resolvedCount] = ...
			end

			if resolvedCount >= (amount or #promises) then
				done = true
				resolve(resolvedValues)
				cancel()
			end
		end

		onCancel(cancel)

		-- We can assume the values inside `promises` are all promises since we
		-- checked above.
		for i, promise in ipairs(promises) do
			newPromises[i] = promise:andThen(function(...)
				resolveOne(i, ...)
			end, function(...)
				rejectedCount = rejectedCount + 1

				if amount == nil or #promises - rejectedCount < amount then
					cancel()
					done = true

					reject(...)
				end
			end)
		end

		if done then
			cancel()
		end
	end)
end

--[=[
	Accepts an array of Promises and returns a new promise that:
	* is resolved after all input promises resolve.
	* is rejected if *any* input promises reject.

	:::info
	Only the first return value from each promise will be present in the resulting array.
	:::

	After any input Promise rejects, all other input Promises that are still pending will be cancelled if they have no other consumers.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.all(promises)
	```

	@param promises {Promise<T>}
	@return Promise<{T}>
]=]
function Promise.all(promises)
	return Promise._all(debug.traceback(nil, 2), promises)
end

--[=[
	Folds an array of values or promises into a single value. The array is traversed sequentially.

	The reducer function can return a promise or value directly. Each iteration receives the resolved value from the previous, and the first receives your defined initial value.

	The folding will stop at the first rejection encountered.
	```lua
	local basket = {"blueberry", "melon", "pear", "melon"}
	Promise.fold(basket, function(cost, fruit)
		if fruit == "blueberry" then
			return cost -- blueberries are free!
		else
			-- call a function that returns a promise with the fruit price
			return fetchPrice(fruit):andThen(function(fruitCost)
				return cost + fruitCost
			end)
		end
	end, 0)
	```

	@since v3.1.0
	@param list {T | Promise<T>}
	@param reducer (accumulator: U, value: T, index: number) -> U | Promise<U>
	@param initialValue U
]=]
function Promise.fold(list, reducer, initialValue)
	assert(type(list) == "table", "Bad argument #1 to Promise.fold: must be a table")
	assert(isCallable(reducer), "Bad argument #2 to Promise.fold: must be a function")

	local accumulator = Promise.resolve(initialValue)
	return Promise.each(list, function(resolvedElement, i)
		accumulator = accumulator:andThen(function(previousValueResolved)
			return reducer(previousValueResolved, resolvedElement, i)
		end)
	end):andThen(function()
		return accumulator
	end)
end

--[=[
	Accepts an array of Promises and returns a Promise that is resolved as soon as `count` Promises are resolved from the input array. The resolved array values are in the order that the Promises resolved in. When this Promise resolves, all other pending Promises are cancelled if they have no other consumers.

	`count` 0 results in an empty array. The resultant array will never have more than `count` elements.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.some(promises, 2) -- Only resolves with first 2 promises to resolve
	```

	@param promises {Promise<T>}
	@param count number
	@return Promise<{T}>
]=]
function Promise.some(promises, count)
	assert(type(count) == "number", "Bad argument #2 to Promise.some: must be a number")

	return Promise._all(debug.traceback(nil, 2), promises, count)
end

--[=[
	Accepts an array of Promises and returns a Promise that is resolved as soon as *any* of the input Promises resolves. It will reject only if *all* input Promises reject. As soon as one Promises resolves, all other pending Promises are cancelled if they have no other consumers.

	Resolves directly with the value of the first resolved Promise. This is essentially [[Promise.some]] with `1` count, except the Promise resolves with the value directly instead of an array with one element.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.any(promises) -- Resolves with first value to resolve (only rejects if all 3 rejected)
	```

	@param promises {Promise<T>}
	@return Promise<T>
]=]
function Promise.any(promises)
	return Promise._all(debug.traceback(nil, 2), promises, 1):andThen(function(values)
		return values[1]
	end)
end

--[=[
	Accepts an array of Promises and returns a new Promise that resolves with an array of in-place Statuses when all input Promises have settled. This is equivalent to mapping `promise:finally` over the array of Promises.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.allSettled(promises)
	```

	@param promises {Promise<T>}
	@return Promise<{Status}>
]=]
function Promise.allSettled(promises)
	if type(promises) ~= "table" then
		error(string.format(ERROR_NON_LIST, "Promise.allSettled"), 2)
	end

	-- We need to check that each value is a promise here so that we can produce
	-- a proper error rather than a rejected promise with our error.
	for i, promise in pairs(promises) do
		if not Promise.is(promise) then
			error(string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.allSettled", tostring(i)), 2)
		end
	end

	-- If there are no values then return an already resolved promise.
	if #promises == 0 then
		return Promise.resolve({})
	end

	return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
		-- An array to contain our resolved values from the given promises.
		local fates = {}
		local newPromises = {}

		-- Keep a count of resolved promises because just checking the resolved
		-- values length wouldn't account for promises that resolve with nil.
		local finishedCount = 0

		-- Called when a single value is resolved and resolves if all are done.
		local function resolveOne(i, ...)
			finishedCount = finishedCount + 1

			fates[i] = ...

			if finishedCount >= #promises then
				resolve(fates)
			end
		end

		onCancel(function()
			for _, promise in ipairs(newPromises) do
				promise:cancel()
			end
		end)

		-- We can assume the values inside `promises` are all promises since we
		-- checked above.
		for i, promise in ipairs(promises) do
			newPromises[i] = promise:finally(function(...)
				resolveOne(i, ...)
			end)
		end
	end)
end

--[=[
	Accepts an array of Promises and returns a new promise that is resolved or rejected as soon as any Promise in the array resolves or rejects.

	:::warning
	If the first Promise to settle from the array settles with a rejection, the resulting Promise from `race` will reject.

	If you instead want to tolerate rejections, and only care about at least one Promise resolving, you should use [Promise.any](#any) or [Promise.some](#some) instead.
	:::

	All other Promises that don't win the race will be cancelled if they have no other consumers.

	```lua
	local promises = {
		returnsAPromise("example 1"),
		returnsAPromise("example 2"),
		returnsAPromise("example 3"),
	}

	return Promise.race(promises) -- Only returns 1st value to resolve or reject
	```

	@param promises {Promise<T>}
	@return Promise<T>
]=]
function Promise.race(promises)
	assert(type(promises) == "table", string.format(ERROR_NON_LIST, "Promise.race"))

	for i, promise in pairs(promises) do
		assert(Promise.is(promise), string.format(ERROR_NON_PROMISE_IN_LIST, "Promise.race", tostring(i)))
	end

	return Promise._new(debug.traceback(nil, 2), function(resolve, reject, onCancel)
		local newPromises = {}
		local finished = false

		local function cancel()
			for _, promise in ipairs(newPromises) do
				promise:cancel()
			end
		end

		local function finalize(callback)
			return function(...)
				cancel()
				finished = true
				return callback(...)
			end
		end

		if onCancel(finalize(reject)) then
			return
		end

		for i, promise in ipairs(promises) do
			newPromises[i] = promise:andThen(finalize(resolve), finalize(reject))
		end

		if finished then
			cancel()
		end
	end)
end

--[=[
	Iterates serially over the given an array of values, calling the predicate callback on each value before continuing.

	If the predicate returns a Promise, we wait for that Promise to resolve before moving on to the next item
	in the array.

	:::info
	`Promise.each` is similar to `Promise.all`, except the Promises are ran in order instead of all at once.

	But because Promises are eager, by the time they are created, they're already running. Thus, we need a way to defer creation of each Promise until a later time.

	The predicate function exists as a way for us to operate on our data instead of creating a new closure for each Promise. If you would prefer, you can pass in an array of functions, and in the predicate, call the function and return its return value.
	:::

	```lua
	Promise.each({
		"foo",
		"bar",
		"baz",
		"qux"
	}, function(value, index)
		return Promise.delay(1):andThen(function()
		print(("%d) Got %s!"):format(index, value))
		end)
	end)

	--[[
		(1 second passes)
		> 1) Got foo!
		(1 second passes)
		> 2) Got bar!
		(1 second passes)
		> 3) Got baz!
		(1 second passes)
		> 4) Got qux!
	]]
	```

	If the Promise a predicate returns rejects, the Promise from `Promise.each` is also rejected with the same value.

	If the array of values contains a Promise, when we get to that point in the list, we wait for the Promise to resolve before calling the predicate with the value.

	If a Promise in the array of values is already Rejected when `Promise.each` is called, `Promise.each` rejects with that value immediately (the predicate callback will never be called even once). If a Promise in the list is already Cancelled when `Promise.each` is called, `Promise.each` rejects with `Promise.Error(Promise.Error.Kind.AlreadyCancelled`). If a Promise in the array of values is Started at first, but later rejects, `Promise.each` will reject with that value and iteration will not continue once iteration encounters that value.

	Returns a Promise containing an array of the returned/resolved values from the predicate for each item in the array of values.

	If this Promise returned from `Promise.each` rejects or is cancelled for any reason, the following are true:
	- Iteration will not continue.
	- Any Promises within the array of values will now be cancelled if they have no other consumers.
	- The Promise returned from the currently active predicate will be cancelled if it hasn't resolved yet.

	@since 3.0.0
	@param list {T | Promise<T>}
	@param predicate (value: T, index: number) -> U | Promise<U>
	@return Promise<{U}>
]=]
function Promise.each(list, predicate)
	assert(type(list) == "table", string.format(ERROR_NON_LIST, "Promise.each"))
	assert(isCallable(predicate), string.format(ERROR_NON_FUNCTION, "Promise.each"))

	return Promise._new(debug.traceback(nil, 2), function(resolve, reject, onCancel)
		local results = {}
		local promisesToCancel = {}

		local cancelled = false

		local function cancel()
			for _, promiseToCancel in ipairs(promisesToCancel) do
				promiseToCancel:cancel()
			end
		end

		onCancel(function()
			cancelled = true

			cancel()
		end)

		-- We need to preprocess the list of values and look for Promises.
		-- If we find some, we must register our andThen calls now, so that those Promises have a consumer
		-- from us registered. If we don't do this, those Promises might get cancelled by something else
		-- before we get to them in the series because it's not possible to tell that we plan to use it
		-- unless we indicate it here.

		local preprocessedList = {}

		for index, value in ipairs(list) do
			if Promise.is(value) then
				if value:getStatus() == Promise.Status.Cancelled then
					cancel()
					return reject(Error.new({
						error = "Promise is cancelled",
						kind = Error.Kind.AlreadyCancelled,
						context = string.format(
							"The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s",
							index,
							value._source
						),
					}))
				elseif value:getStatus() == Promise.Status.Rejected then
					cancel()
					return reject(select(2, value:await()))
				end

				-- Chain a new Promise from this one so we only cancel ours
				local ourPromise = value:andThen(function(...)
					return ...
				end)

				table.insert(promisesToCancel, ourPromise)
				preprocessedList[index] = ourPromise
			else
				preprocessedList[index] = value
			end
		end

		for index, value in ipairs(preprocessedList) do
			if Promise.is(value) then
				local success
				success, value = value:await()

				if not success then
					cancel()
					return reject(value)
				end
			end

			if cancelled then
				return
			end

			local predicatePromise = Promise.resolve(predicate(value, index))

			table.insert(promisesToCancel, predicatePromise)

			local success, result = predicatePromise:await()

			if not success then
				cancel()
				return reject(result)
			end

			results[index] = result
		end

		resolve(results)
	end)
end

--[=[
	Checks whether the given object is a Promise via duck typing. This only checks if the object is a table and has an `andThen` method.

	@param object any
	@return boolean -- `true` if the given `object` is a Promise.
]=]
function Promise.is(object)
	if type(object) ~= "table" then
		return false
	end

	local objectMetatable = getmetatable(object)

	if objectMetatable == Promise then
		-- The Promise came from this library.
		return true
	elseif objectMetatable == nil then
		-- No metatable, but we should still chain onto tables with andThen methods
		return isCallable(object.andThen)
	elseif
		type(objectMetatable) == "table"
		and type(rawget(objectMetatable, "__index")) == "table"
		and isCallable(rawget(rawget(objectMetatable, "__index"), "andThen"))
	then
		-- Maybe this came from a different or older Promise library.
		return true
	end

	return false
end

--[=[
	Wraps a function that yields into one that returns a Promise.

	Any errors that occur while executing the function will be turned into rejections.

	:::info
	`Promise.promisify` is similar to [Promise.try](#try), except the callback is returned as a callable function instead of being invoked immediately.
	:::

	```lua
	local sleep = Promise.promisify(wait)

	sleep(1):andThen(print)
	```

	```lua
	local isPlayerInGroup = Promise.promisify(function(player, groupId)
		return player:IsInGroup(groupId)
	end)
	```

	@param callback (...: any) -> ...any
	@return (...: any) -> Promise
]=]
function Promise.promisify(callback)
	return function(...)
		return Promise._try(debug.traceback(nil, 2), callback, ...)
	end
end

--[=[
	Returns a Promise that resolves after `seconds` seconds have passed. The Promise resolves with the actual amount of time that was waited.

	This function is **not** a wrapper around `wait`. `Promise.delay` uses a custom scheduler which provides more accurate timing. As an optimization, cancelling this Promise instantly removes the task from the scheduler.

	:::warning
	Passing `NaN`, infinity, or a number less than 1/60 is equivalent to passing 1/60.
	:::

	```lua
		Promise.delay(5):andThenCall(print, "This prints after 5 seconds")
	```

	@function delay
	@within Promise
	@param seconds number
	@return Promise<number>
]=]
do
	-- uses a sorted doubly linked list (queue) to achieve O(1) remove operations and O(n) for insert

	-- the initial node in the linked list
	local first
	local connection

	function Promise.delay(seconds)
		assert(type(seconds) == "number", "Bad argument #1 to Promise.delay, must be a number.")
		-- If seconds is -INF, INF, NaN, or less than 1 / 60, assume seconds is 1 / 60.
		-- This mirrors the behavior of wait()
		if not (seconds >= 1 / 60) or seconds == math.huge then
			seconds = 1 / 60
		end

		return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
			local startTime = Promise._getTime()
			local endTime = startTime + seconds

			local node = {
				resolve = resolve,
				startTime = startTime,
				endTime = endTime,
			}

			if connection == nil then -- first is nil when connection is nil
				first = node
				connection = Promise._timeEvent:Connect(function()
					local threadStart = Promise._getTime()

					while first ~= nil and first.endTime < threadStart do
						local current = first
						first = current.next

						if first == nil then
							connection:Disconnect()
							connection = nil
						else
							first.previous = nil
						end

						current.resolve(Promise._getTime() - current.startTime)
					end
				end)
			else -- first is non-nil
				if first.endTime < endTime then -- if `node` should be placed after `first`
					-- we will insert `node` between `current` and `next`
					-- (i.e. after `current` if `next` is nil)
					local current = first
					local next = current.next

					while next ~= nil and next.endTime < endTime do
						current = next
						next = current.next
					end

					-- `current` must be non-nil, but `next` could be `nil` (i.e. last item in list)
					current.next = node
					node.previous = current

					if next ~= nil then
						node.next = next
						next.previous = node
					end
				else
					-- set `node` to `first`
					node.next = first
					first.previous = node
					first = node
				end
			end

			onCancel(function()
				-- remove node from queue
				local next = node.next

				if first == node then
					if next == nil then -- if `node` is the first and last
						connection:Disconnect()
						connection = nil
					else -- if `node` is `first` and not the last
						next.previous = nil
					end
					first = next
				else
					local previous = node.previous
					-- since `node` is not `first`, then we know `previous` is non-nil
					previous.next = next

					if next ~= nil then
						next.previous = previous
					end
				end
			end)
		end)
	end
end

--[=[
	Returns a new Promise that resolves if the chained Promise resolves within `seconds` seconds, or rejects if execution time exceeds `seconds`. The chained Promise will be cancelled if the timeout is reached.

	Rejects with `rejectionValue` if it is non-nil. If a `rejectionValue` is not given, it will reject with a `Promise.Error(Promise.Error.Kind.TimedOut)`. This can be checked with [[Error.isKind]].

	```lua
	getSomething():timeout(5):andThen(function(something)
		-- got something and it only took at max 5 seconds
	end):catch(function(e)
		-- Either getting something failed or the time was exceeded.

		if Promise.Error.isKind(e, Promise.Error.Kind.TimedOut) then
			warn("Operation timed out!")
		else
			warn("Operation encountered an error!")
		end
	end)
	```

	Sugar for:

	```lua
	Promise.race({
		Promise.delay(seconds):andThen(function()
			return Promise.reject(
				rejectionValue == nil
				and Promise.Error.new({ kind = Promise.Error.Kind.TimedOut })
				or rejectionValue
			)
		end),
		promise
	})
	```

	@param seconds number
	@param rejectionValue? any -- The value to reject with if the timeout is reached
	@return Promise
]=]
function Promise.prototype:timeout(seconds, rejectionValue)
	local traceback = debug.traceback(nil, 2)

	return Promise.race({
		Promise.delay(seconds):andThen(function()
			return Promise.reject(rejectionValue == nil and Error.new({
				kind = Error.Kind.TimedOut,
				error = "Timed out",
				context = string.format(
					"Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s",
					seconds,
					traceback
				),
			}) or rejectionValue)
		end),
		self,
	})
end

--[=[
	Returns the current Promise status.

	@return Status
]=]
function Promise.prototype:getStatus()
	return self._status
end

--[[
	Creates a new promise that receives the result of this promise.

	The given callbacks are invoked depending on that result.
]]
function Promise.prototype:_andThen(traceback, successHandler, failureHandler)
	self._unhandledRejection = false

	-- If we are already cancelled, we return a cancelled Promise
	if self._status == Promise.Status.Cancelled then
		local promise = Promise.new(function() end)
		promise:cancel()

		return promise
	end

	-- Create a new promise to follow this part of the chain
	return Promise._new(traceback, function(resolve, reject, onCancel)
		-- Our default callbacks just pass values onto the next promise.
		-- This lets success and failure cascade correctly!

		local successCallback = resolve
		if successHandler then
			successCallback = createAdvancer(traceback, successHandler, resolve, reject)
		end

		local failureCallback = reject
		if failureHandler then
			failureCallback = createAdvancer(traceback, failureHandler, resolve, reject)
		end

		if self._status == Promise.Status.Started then
			-- If we haven't resolved yet, put ourselves into the queue
			table.insert(self._queuedResolve, successCallback)
			table.insert(self._queuedReject, failureCallback)

			onCancel(function()
				-- These are guaranteed to exist because the cancellation handler is guaranteed to only
				-- be called at most once
				if self._status == Promise.Status.Started then
					table.remove(self._queuedResolve, table.find(self._queuedResolve, successCallback))
					table.remove(self._queuedReject, table.find(self._queuedReject, failureCallback))
				end
			end)
		elseif self._status == Promise.Status.Resolved then
			-- This promise has already resolved! Trigger success immediately.
			successCallback(unpack(self._values, 1, self._valuesLength))
		elseif self._status == Promise.Status.Rejected then
			-- This promise died a terrible death! Trigger failure immediately.
			failureCallback(unpack(self._values, 1, self._valuesLength))
		end
	end, self)
end

--[=[
	Chains onto an existing Promise and returns a new Promise.

	:::warning
	Within the failure handler, you should never assume that the rejection value is a string. Some rejections within the Promise library are represented by [[Error]] objects. If you want to treat it as a string for debugging, you should call `tostring` on it first.
	:::

	You can return a Promise from the success or failure handler and it will be chained onto.

	Calling `andThen` on a cancelled Promise returns a cancelled Promise.

	:::tip
	If the Promise returned by `andThen` is cancelled, `successHandler` and `failureHandler` will not run.

	To run code no matter what, use [Promise:finally].
	:::

	@param successHandler (...: any) -> ...any
	@param failureHandler? (...: any) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:andThen(successHandler, failureHandler)
	assert(successHandler == nil or isCallable(successHandler), string.format(ERROR_NON_FUNCTION, "Promise:andThen"))
	assert(failureHandler == nil or isCallable(failureHandler), string.format(ERROR_NON_FUNCTION, "Promise:andThen"))

	return self:_andThen(debug.traceback(nil, 2), successHandler, failureHandler)
end

--[=[
	Shorthand for `Promise:andThen(nil, failureHandler)`.

	Returns a Promise that resolves if the `failureHandler` worked without encountering an additional error.

	:::warning
	Within the failure handler, you should never assume that the rejection value is a string. Some rejections within the Promise library are represented by [[Error]] objects. If you want to treat it as a string for debugging, you should call `tostring` on it first.
	:::

	Calling `catch` on a cancelled Promise returns a cancelled Promise.

	:::tip
	If the Promise returned by `catch` is cancelled,  `failureHandler` will not run.

	To run code no matter what, use [Promise:finally].
	:::

	@param failureHandler (...: any) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:catch(failureHandler)
	assert(failureHandler == nil or isCallable(failureHandler), string.format(ERROR_NON_FUNCTION, "Promise:catch"))
	return self:_andThen(debug.traceback(nil, 2), nil, failureHandler)
end

--[=[
	Similar to [Promise.andThen](#andThen), except the return value is the same as the value passed to the handler. In other words, you can insert a `:tap` into a Promise chain without affecting the value that downstream Promises receive.

	```lua
		getTheValue()
		:tap(print)
		:andThen(function(theValue)
			print("Got", theValue, "even though print returns nil!")
		end)
	```

	If you return a Promise from the tap handler callback, its value will be discarded but `tap` will still wait until it resolves before passing the original value through.

	@param tapHandler (...: any) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:tap(tapHandler)
	assert(isCallable(tapHandler), string.format(ERROR_NON_FUNCTION, "Promise:tap"))
	return self:_andThen(debug.traceback(nil, 2), function(...)
		local callbackReturn = tapHandler(...)

		if Promise.is(callbackReturn) then
			local length, values = pack(...)
			return callbackReturn:andThen(function()
				return unpack(values, 1, length)
			end)
		end

		return ...
	end)
end

--[=[
	Attaches an `andThen` handler to this Promise that calls the given callback with the predefined arguments. The resolved value is discarded.

	```lua
		promise:andThenCall(someFunction, "some", "arguments")
	```

	This is sugar for

	```lua
		promise:andThen(function()
		return someFunction("some", "arguments")
		end)
	```

	@param callback (...: any) -> any
	@param ...? any -- Additional arguments which will be passed to `callback`
	@return Promise
]=]
function Promise.prototype:andThenCall(callback, ...)
	assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, "Promise:andThenCall"))
	local length, values = pack(...)
	return self:_andThen(debug.traceback(nil, 2), function()
		return callback(unpack(values, 1, length))
	end)
end

--[=[
	Attaches an `andThen` handler to this Promise that discards the resolved value and returns the given value from it.

	```lua
		promise:andThenReturn("some", "values")
	```

	This is sugar for

	```lua
		promise:andThen(function()
			return "some", "values"
		end)
	```

	:::caution
	Promises are eager, so if you pass a Promise to `andThenReturn`, it will begin executing before `andThenReturn` is reached in the chain. Likewise, if you pass a Promise created from [[Promise.reject]] into `andThenReturn`, it's possible that this will trigger the unhandled rejection warning. If you need to return a Promise, it's usually best practice to use [[Promise.andThen]].
	:::

	@param ... any -- Values to return from the function
	@return Promise
]=]
function Promise.prototype:andThenReturn(...)
	local length, values = pack(...)
	return self:_andThen(debug.traceback(nil, 2), function()
		return unpack(values, 1, length)
	end)
end

--[=[
	Cancels this promise, preventing the promise from resolving or rejecting. Does not do anything if the promise is already settled.

	Cancellations will propagate upwards and downwards through chained promises.

	Promises will only be cancelled if all of their consumers are also cancelled. This is to say that if you call `andThen` twice on the same promise, and you cancel only one of the child promises, it will not cancel the parent promise until the other child promise is also cancelled.

	```lua
		promise:cancel()
	```
]=]
function Promise.prototype:cancel()
	if self._status ~= Promise.Status.Started then
		return
	end

	self._status = Promise.Status.Cancelled

	if self._cancellationHook then
		self._cancellationHook()
	end

	coroutine.close(self._thread)

	if self._parent then
		self._parent:_consumerCancelled(self)
	end

	for child in pairs(self._consumers) do
		child:cancel()
	end

	self:_finalize()
end

--[[
	Used to decrease the number of consumers by 1, and if there are no more,
	cancel this promise.
]]
function Promise.prototype:_consumerCancelled(consumer)
	if self._status ~= Promise.Status.Started then
		return
	end

	self._consumers[consumer] = nil

	if next(self._consumers) == nil then
		self:cancel()
	end
end

--[[
	Used to set a handler for when the promise resolves, rejects, or is
	cancelled.
]]
function Promise.prototype:_finally(traceback, finallyHandler)
	self._unhandledRejection = false

	local promise = Promise._new(traceback, function(resolve, reject, onCancel)
		local handlerPromise

		onCancel(function()
			-- The finally Promise is not a proper consumer of self. We don't care about the resolved value.
			-- All we care about is running at the end. Therefore, if self has no other consumers, it's safe to
			-- cancel. We don't need to hold out cancelling just because there's a finally handler.
			self:_consumerCancelled(self)

			if handlerPromise then
				handlerPromise:cancel()
			end
		end)

		local finallyCallback = resolve
		if finallyHandler then
			finallyCallback = function(...)
				local callbackReturn = finallyHandler(...)

				if Promise.is(callbackReturn) then
					handlerPromise = callbackReturn

					callbackReturn
						:finally(function(status)
							if status ~= Promise.Status.Rejected then
								resolve(self)
							end
						end)
						:catch(function(...)
							reject(...)
						end)
				else
					resolve(self)
				end
			end
		end

		if self._status == Promise.Status.Started then
			-- The promise is not settled, so queue this.
			table.insert(self._queuedFinally, finallyCallback)
		else
			-- The promise already settled or was cancelled, run the callback now.
			finallyCallback(self._status)
		end
	end)

	return promise
end

--[=[
	Set a handler that will be called regardless of the promise's fate. The handler is called when the promise is
	resolved, rejected, *or* cancelled.

	Returns a new Promise that:
	- resolves with the same values that this Promise resolves with.
	- rejects with the same values that this Promise rejects with.
	- is cancelled if this Promise is cancelled.

	If the value you return from the handler is a Promise:
	- We wait for the Promise to resolve, but we ultimately discard the resolved value.
	- If the returned Promise rejects, the Promise returned from `finally` will reject with the rejected value from the
	*returned* promise.
	- If the `finally` Promise is cancelled, and you returned a Promise from the handler, we cancel that Promise too.

	Otherwise, the return value from the `finally` handler is entirely discarded.

	:::note Cancellation
	As of Promise v4, `Promise:finally` does not count as a consumer of the parent Promise for cancellation purposes.
	This means that if all of a Promise's consumers are cancelled and the only remaining callbacks are finally handlers,
	the Promise is cancelled and the finally callbacks run then and there.

	Cancellation still propagates through the `finally` Promise though: if you cancel the `finally` Promise, it can cancel
	its parent Promise if it had no other consumers. Likewise, if the parent Promise is cancelled, the `finally` Promise
	will also be cancelled.
	:::

	```lua
	local thing = createSomething()

	doSomethingWith(thing)
		:andThen(function()
			print("It worked!")
			-- do something..
		end)
		:catch(function()
			warn("Oh no it failed!")
		end)
		:finally(function()
			-- either way, destroy thing

			thing:Destroy()
		end)

	```

	@param finallyHandler (status: Status) -> ...any
	@return Promise<...any>
]=]
function Promise.prototype:finally(finallyHandler)
	assert(finallyHandler == nil or isCallable(finallyHandler), string.format(ERROR_NON_FUNCTION, "Promise:finally"))
	return self:_finally(debug.traceback(nil, 2), finallyHandler)
end

--[=[
	Same as `andThenCall`, except for `finally`.

	Attaches a `finally` handler to this Promise that calls the given callback with the predefined arguments.

	@param callback (...: any) -> any
	@param ...? any -- Additional arguments which will be passed to `callback`
	@return Promise
]=]
function Promise.prototype:finallyCall(callback, ...)
	assert(isCallable(callback), string.format(ERROR_NON_FUNCTION, "Promise:finallyCall"))
	local length, values = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return callback(unpack(values, 1, length))
	end)
end

--[=[
	Attaches a `finally` handler to this Promise that discards the resolved value and returns the given value from it.

	```lua
		promise:finallyReturn("some", "values")
	```

	This is sugar for

	```lua
		promise:finally(function()
			return "some", "values"
		end)
	```

	@param ... any -- Values to return from the function
	@return Promise
]=]
function Promise.prototype:finallyReturn(...)
	local length, values = pack(...)
	return self:_finally(debug.traceback(nil, 2), function()
		return unpack(values, 1, length)
	end)
end

--[=[
	Yields the current thread until the given Promise completes. Returns the Promise's status, followed by the values that the promise resolved or rejected with.

	@yields
	@return Status -- The Status representing the fate of the Promise
	@return ...any -- The values the Promise resolved or rejected with.
]=]
function Promise.prototype:awaitStatus()
	self._unhandledRejection = false

	if self._status == Promise.Status.Started then
		local thread = coroutine.running()

		self
			:finally(function()
				task.spawn(thread)
			end)
			-- The finally promise can propagate rejections, so we attach a catch handler to prevent the unhandled
			-- rejection warning from appearing
			:catch(
				function() end
			)

		coroutine.yield()
	end

	if self._status == Promise.Status.Resolved then
		return self._status, unpack(self._values, 1, self._valuesLength)
	elseif self._status == Promise.Status.Rejected then
		return self._status, unpack(self._values, 1, self._valuesLength)
	end

	return self._status
end

local function awaitHelper(status, ...)
	return status == Promise.Status.Resolved, ...
end

--[=[
	Yields the current thread until the given Promise completes. Returns true if the Promise resolved, followed by the values that the promise resolved or rejected with.

	:::caution
	If the Promise gets cancelled, this function will return `false`, which is indistinguishable from a rejection. If you need to differentiate, you should use [[Promise.awaitStatus]] instead.
	:::

	```lua
		local worked, value = getTheValue():await()

	if worked then
		print("got", value)
	else
		warn("it failed")
	end
	```

	@yields
	@return boolean -- `true` if the Promise successfully resolved
	@return ...any -- The values the Promise resolved or rejected with.
]=]
function Promise.prototype:await()
	return awaitHelper(self:awaitStatus())
end

local function expectHelper(status, ...)
	if status ~= Promise.Status.Resolved then
		error((...) == nil and "Expected Promise rejected with no value." or (...), 3)
	end

	return ...
end

--[=[
	Yields the current thread until the given Promise completes. Returns the values that the promise resolved with.

	```lua
	local worked = pcall(function()
		print("got", getTheValue():expect())
	end)

	if not worked then
		warn("it failed")
	end
	```

	This is essentially sugar for:

	```lua
	select(2, assert(promise:await()))
	```

	**Errors** if the Promise rejects or gets cancelled.

	@error any -- Errors with the rejection value if this Promise rejects or gets cancelled.
	@yields
	@return ...any -- The values the Promise resolved with.
]=]
function Promise.prototype:expect()
	return expectHelper(self:awaitStatus())
end

-- Backwards compatibility
Promise.prototype.awaitValue = Promise.prototype.expect

--[[
	Intended for use in tests.

	Similar to await(), but instead of yielding if the promise is unresolved,
	_unwrap will throw. This indicates an assumption that a promise has
	resolved.
]]
function Promise.prototype:_unwrap()
	if self._status == Promise.Status.Started then
		error("Promise has not resolved or rejected.", 2)
	end

	local success = self._status == Promise.Status.Resolved

	return success, unpack(self._values, 1, self._valuesLength)
end

function Promise.prototype:_resolve(...)
	if self._status ~= Promise.Status.Started then
		if Promise.is((...)) then
			(...):_consumerCancelled(self)
		end
		return
	end

	-- If the resolved value was a Promise, we chain onto it!
	if Promise.is((...)) then
		-- Without this warning, arguments sometimes mysteriously disappear
		if select("#", ...) > 1 then
			local message = string.format(
				"When returning a Promise from andThen, extra arguments are " .. "discarded! See:\n\n%s",
				self._source
			)
			warn(message)
		end

		local chainedPromise = ...

		local promise = chainedPromise:andThen(function(...)
			self:_resolve(...)
		end, function(...)
			local maybeRuntimeError = chainedPromise._values[1]

			-- Backwards compatibility < v2
			if chainedPromise._error then
				maybeRuntimeError = Error.new({
					error = chainedPromise._error,
					kind = Error.Kind.ExecutionError,
					context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
				})
			end

			if Error.isKind(maybeRuntimeError, Error.Kind.ExecutionError) then
				return self:_reject(maybeRuntimeError:extend({
					error = "This Promise was chained to a Promise that errored.",
					trace = "",
					context = string.format(
						"The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n",
						self._source
					),
				}))
			end

			self:_reject(...)
		end)

		if promise._status == Promise.Status.Cancelled then
			self:cancel()
		elseif promise._status == Promise.Status.Started then
			-- Adopt ourselves into promise for cancellation propagation.
			self._parent = promise
			promise._consumers[self] = true
		end

		return
	end

	self._status = Promise.Status.Resolved
	self._valuesLength, self._values = pack(...)

	-- We assume that these callbacks will not throw errors.
	for _, callback in ipairs(self._queuedResolve) do
		coroutine.wrap(callback)(...)
	end

	self:_finalize()
end

function Promise.prototype:_reject(...)
	if self._status ~= Promise.Status.Started then
		return
	end

	self._status = Promise.Status.Rejected
	self._valuesLength, self._values = pack(...)

	-- If there are any rejection handlers, call those!
	if not isEmpty(self._queuedReject) then
		-- We assume that these callbacks will not throw errors.
		for _, callback in ipairs(self._queuedReject) do
			coroutine.wrap(callback)(...)
		end
	else
		-- At this point, no one was able to observe the error.
		-- An error handler might still be attached if the error occurred
		-- synchronously. We'll wait one tick, and if there are still no
		-- observers, then we should put a message in the console.

		local err = tostring((...))

		coroutine.wrap(function()
			Promise._timeEvent:Wait()

			-- Someone observed the error, hooray!
			if not self._unhandledRejection then
				return
			end

			-- Build a reasonable message
			local message = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", err, self._source)

			for _, callback in ipairs(Promise._unhandledRejectionCallbacks) do
				task.spawn(callback, self, unpack(self._values, 1, self._valuesLength))
			end

			if Promise.TEST then
				-- Don't spam output when we're running tests.
				return
			end

			warn(message)
		end)()
	end

	self:_finalize()
end

--[[
	Calls any :finally handlers. We need this to be a separate method and
	queue because we must call all of the finally callbacks upon a success,
	failure, *and* cancellation.
]]
function Promise.prototype:_finalize()
	for _, callback in ipairs(self._queuedFinally) do
		-- Purposefully not passing values to callbacks here, as it could be the
		-- resolved values, or rejected errors. If the developer needs the values,
		-- they should use :andThen or :catch explicitly.
		coroutine.wrap(callback)(self._status)
	end

	self._queuedFinally = nil
	self._queuedReject = nil
	self._queuedResolve = nil

	-- Clear references to other Promises to allow gc
	if not Promise.TEST then
		self._parent = nil
		self._consumers = nil
	end

	task.defer(coroutine.close, self._thread)
end

--[=[
	Chains a Promise from this one that is resolved if this Promise is already resolved, and rejected if it is not resolved at the time of calling `:now()`. This can be used to ensure your `andThen` handler occurs on the same frame as the root Promise execution.

	```lua
	doSomething()
		:now()
		:andThen(function(value)
			print("Got", value, "synchronously.")
		end)
	```

	If this Promise is still running, Rejected, or Cancelled, the Promise returned from `:now()` will reject with the `rejectionValue` if passed, otherwise with a `Promise.Error(Promise.Error.Kind.NotResolvedInTime)`. This can be checked with [[Error.isKind]].

	@param rejectionValue? any -- The value to reject with if the Promise isn't resolved
	@return Promise
]=]
function Promise.prototype:now(rejectionValue)
	local traceback = debug.traceback(nil, 2)
	if self._status == Promise.Status.Resolved then
		return self:_andThen(traceback, function(...)
			return ...
		end)
	else
		return Promise.reject(rejectionValue == nil and Error.new({
			kind = Error.Kind.NotResolvedInTime,
			error = "This Promise was not resolved in time for :now()",
			context = ":now() was called at:\n\n" .. traceback,
		}) or rejectionValue)
	end
end

--[=[
	Repeatedly calls a Promise-returning function up to `times` number of times, until the returned Promise resolves.

	If the amount of retries is exceeded, the function will return the latest rejected Promise.

	```lua
	local function canFail(a, b, c)
		return Promise.new(function(resolve, reject)
			-- do something that can fail

			local failed, thing = doSomethingThatCanFail(a, b, c)

			if failed then
				reject("it failed")
			else
				resolve(thing)
			end
		end)
	end

	local MAX_RETRIES = 10
	local value = Promise.retry(canFail, MAX_RETRIES, "foo", "bar", "baz") -- args to send to canFail
	```

	@since 3.0.0
	@param callback (...: P) -> Promise<T>
	@param times number
	@param ...? P
	@return Promise<T>
]=]
function Promise.retry(callback, times, ...)
	assert(isCallable(callback), "Parameter #1 to Promise.retry must be a function")
	assert(type(times) == "number", "Parameter #2 to Promise.retry must be a number")

	local args, length = { ... }, select("#", ...)

	return Promise.resolve(callback(...)):catch(function(...)
		if times > 0 then
			return Promise.retry(callback, times - 1, unpack(args, 1, length))
		else
			return Promise.reject(...)
		end
	end)
end

--[=[
	Repeatedly calls a Promise-returning function up to `times` number of times, waiting `seconds` seconds between each
	retry, until the returned Promise resolves.

	If the amount of retries is exceeded, the function will return the latest rejected Promise.

	@since v3.2.0
	@param callback (...: P) -> Promise<T>
	@param times number
	@param seconds number
	@param ...? P
	@return Promise<T>
]=]
function Promise.retryWithDelay(callback, times, seconds, ...)
	assert(isCallable(callback), "Parameter #1 to Promise.retry must be a function")
	assert(type(times) == "number", "Parameter #2 (times) to Promise.retry must be a number")
	assert(type(seconds) == "number", "Parameter #3 (seconds) to Promise.retry must be a number")

	local args, length = { ... }, select("#", ...)

	return Promise.resolve(callback(...)):catch(function(...)
		if times > 0 then
			Promise.delay(seconds):await()

			return Promise.retryWithDelay(callback, times - 1, seconds, unpack(args, 1, length))
		else
			return Promise.reject(...)
		end
	end)
end

--[=[
	Converts an event into a Promise which resolves the next time the event fires.

	The optional `predicate` callback, if passed, will receive the event arguments and should return `true` or `false`, based on if this fired event should resolve the Promise or not. If `true`, the Promise resolves. If `false`, nothing happens and the predicate will be rerun the next time the event fires.

	The Promise will resolve with the event arguments.

	:::tip
	This function will work given any object with a `Connect` method. This includes all Roblox events.
	:::

	```lua
	-- Creates a Promise which only resolves when `somePart` is touched
	-- by a part named `"Something specific"`.
	return Promise.fromEvent(somePart.Touched, function(part)
		return part.Name == "Something specific"
	end)
	```

	@since 3.0.0
	@param event Event -- Any object with a `Connect` method. This includes all Roblox events.
	@param predicate? (...: P) -> boolean -- A function which determines if the Promise should resolve with the given value, or wait for the next event to check again.
	@return Promise<P>
]=]
function Promise.fromEvent(event, predicate)
	predicate = predicate or function()
		return true
	end

	return Promise._new(debug.traceback(nil, 2), function(resolve, _, onCancel)
		local connection
		local shouldDisconnect = false

		local function disconnect()
			connection:Disconnect()
			connection = nil
		end

		-- We use shouldDisconnect because if the callback given to Connect is called before
		-- Connect returns, connection will still be nil. This happens with events that queue up
		-- events when there's nothing connected, such as RemoteEvents

		connection = event:Connect(function(...)
			local callbackValue = predicate(...)

			if callbackValue == true then
				resolve(...)

				if connection then
					disconnect()
				else
					shouldDisconnect = true
				end
			elseif type(callbackValue) ~= "boolean" then
				error("Promise.fromEvent predicate should always return a boolean")
			end
		end)

		if shouldDisconnect and connection then
			return disconnect()
		end

		onCancel(disconnect)
	end)
end

--[=[
	Registers a callback that runs when an unhandled rejection happens. An unhandled rejection happens when a Promise
	is rejected, and the rejection is not observed with `:catch`.

	The callback is called with the actual promise that rejected, followed by the rejection values.

	@since v3.2.0
	@param callback (promise: Promise, ...: any) -- A callback that runs when an unhandled rejection happens.
	@return () -> () -- Function that unregisters the `callback` when called
]=]
function Promise.onUnhandledRejection(callback)
	table.insert(Promise._unhandledRejectionCallbacks, callback)

	return function()
		local index = table.find(Promise._unhandledRejectionCallbacks, callback)

		if index then
			table.remove(Promise._unhandledRejectionCallbacks, index)
		end
	end
end

return Promise

end)() end,
    [63] = function()local wax,script,require=ImportGlobals(63)local ImportGlobals return (function(...)return function()
	local Promise = require(script.Parent)
	Promise.TEST = true

	local timeEvent = Instance.new("BindableEvent")
	Promise._timeEvent = timeEvent.Event

	local advanceTime
	do
		local injectedPromiseTime = 0

		Promise._getTime = function()
			return injectedPromiseTime
		end

		function advanceTime(delta)
			delta = delta or (1 / 60)

			injectedPromiseTime = injectedPromiseTime + delta
			timeEvent:Fire(delta)
		end
	end

	local function pack(...)
		local len = select("#", ...)

		return len, { ... }
	end

	describe("Promise.Status", function()
		it("should error if indexing nil value", function()
			expect(function()
				local _ = Promise.Status.wrong
			end).to.throw()
		end)
	end)

	describe("Unhandled rejection signal", function()
		it("should call unhandled rejection callbacks", function()
			local badPromise = Promise.new(function(_resolve, reject)
				reject(1, 2)
			end)

			local callCount = 0

			local function callback(promise, rejectionA, rejectionB)
				callCount += 1

				expect(promise).to.equal(badPromise)
				expect(rejectionA).to.equal(1)
				expect(rejectionB).to.equal(2)
			end

			local unregister = Promise.onUnhandledRejection(callback)

			advanceTime()

			expect(callCount).to.equal(1)

			unregister()

			Promise.new(function(_resolve, reject)
				reject(3, 4)
			end)

			advanceTime()

			expect(callCount).to.equal(1)
		end)
	end)

	describe("Promise.new", function()
		it("should instantiate with a callback", function()
			local promise = Promise.new(function() end)

			expect(promise).to.be.ok()
		end)

		it("should invoke the given callback with resolve and reject", function()
			local callCount = 0
			local resolveArg
			local rejectArg

			local promise = Promise.new(function(resolve, reject)
				callCount = callCount + 1
				resolveArg = resolve
				rejectArg = reject
			end)

			expect(promise).to.be.ok()

			expect(callCount).to.equal(1)
			expect(resolveArg).to.be.a("function")
			expect(rejectArg).to.be.a("function")
			expect(promise:getStatus()).to.equal(Promise.Status.Started)
		end)

		it("should resolve promises on resolve()", function()
			local callCount = 0

			local promise = Promise.new(function(resolve)
				callCount = callCount + 1
				resolve()
			end)

			expect(promise).to.be.ok()
			expect(callCount).to.equal(1)
			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
		end)

		it("should reject promises on reject()", function()
			local callCount = 0

			local promise = Promise.new(function(resolve, reject)
				callCount = callCount + 1
				reject()
			end)

			expect(promise).to.be.ok()
			expect(callCount).to.equal(1)
			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
		end)

		it("should reject on error in callback", function()
			local callCount = 0

			local promise = Promise.new(function()
				callCount = callCount + 1
				error("hahah")
			end)

			expect(promise).to.be.ok()
			expect(callCount).to.equal(1)
			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(tostring(promise._values[1]):find("hahah")).to.be.ok()

			-- Loosely check for the pieces of the stack trace we expect
			expect(tostring(promise._values[1]):find("init.spec")).to.be.ok()
			expect(tostring(promise._values[1]):find("runExecutor")).to.be.ok()
		end)

		it("should work with C functions", function()
			expect(function()
				Promise.new(tick):andThen(tick)
			end).to.never.throw()
		end)

		it("should have a nice tostring", function()
			expect(tostring(Promise.resolve()):gmatch("Promise(Resolved)")).to.be.ok()
		end)

		it("should allow yielding", function()
			local bindable = Instance.new("BindableEvent")
			local promise = Promise.new(function(resolve)
				bindable.Event:Wait()
				resolve(5)
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			bindable:Fire()
			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1]).to.equal(5)
		end)

		it("should preserve stack traces of resolve-chained promises", function()
			local function nestedCall(text)
				error(text)
			end

			local promise = Promise.new(function(resolve)
				resolve(Promise.new(function()
					nestedCall("sample text")
				end))
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)

			local trace = tostring(promise._values[1])
			expect(trace:find("sample text")).to.be.ok()
			expect(trace:find("nestedCall")).to.be.ok()
			expect(trace:find("runExecutor")).to.be.ok()
			expect(trace:find("runPlanNode")).to.be.ok()
			expect(
				trace:find("...Rejected because it was chained to the following Promise, which encountered an error:")
			).to.be.ok()
		end)

		it("should report errors from Promises with _error (< v2)", function()
			local oldPromise = Promise.reject()
			oldPromise._error = "Sample error"

			local newPromise = Promise.resolve():andThenReturn(oldPromise)

			expect(newPromise:getStatus()).to.equal(Promise.Status.Rejected)

			local trace = tostring(newPromise._values[1])
			expect(trace:find("Sample error")).to.be.ok()
			expect(
				trace:find("...Rejected because it was chained to the following Promise, which encountered an error:")
			).to.be.ok()
			expect(trace:find("%[No stack trace available")).to.be.ok()
		end)

		it("should allow callable tables", function()
			local promise = Promise.new(setmetatable({}, {
				__call = function(_, resolve)
					resolve(1)
				end,
			}))

			local called = false
			promise:andThen(setmetatable({}, {
				__call = function(_, var)
					expect(var).to.equal(1)
					called = true
				end,
			}))

			expect(called).to.equal(true)
		end)

		itSKIP("should close the thread after resolve", function()
			local count = 0
			Promise.new(function(resolve)
				count += 1
				resolve()
				Promise.delay(1):await()
				count += 1
			end)

			task.wait(1)

			expect(count).to.equal(1)
		end)
	end)

	describe("Promise.defer", function()
		it("should execute after the time event", function()
			local callCount = 0
			local promise = Promise.defer(function(resolve, reject, onCancel, nothing)
				expect(type(resolve)).to.equal("function")
				expect(type(reject)).to.equal("function")
				expect(type(onCancel)).to.equal("function")
				expect(type(nothing)).to.equal("nil")

				callCount = callCount + 1

				resolve("foo")
			end)

			expect(callCount).to.equal(0)
			expect(promise:getStatus()).to.equal(Promise.Status.Started)

			advanceTime()
			expect(callCount).to.equal(1)
			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)

			advanceTime()
			expect(callCount).to.equal(1)
		end)
	end)

	describe("Promise.delay", function()
		it("should schedule promise resolution", function()
			local promise = Promise.delay(1)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)

			advanceTime()
			expect(promise:getStatus()).to.equal(Promise.Status.Started)

			advanceTime(1)
			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
		end)

		it("should allow for delays to be cancelled", function()
			local promise = Promise.delay(2)

			Promise.delay(1):andThen(function()
				promise:cancel()
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			advanceTime()
			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			advanceTime(1)
			expect(promise:getStatus()).to.equal(Promise.Status.Cancelled)
			advanceTime(1)
		end)
	end)

	describe("Promise.resolve", function()
		it("should immediately resolve with a value", function()
			local promise = Promise.resolve(5, 6)

			expect(promise).to.be.ok()
			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1]).to.equal(5)
			expect(promise._values[2]).to.equal(6)
		end)

		it("should chain onto passed promises", function()
			local promise = Promise.resolve(Promise.new(function(_, reject)
				reject(7)
			end))

			expect(promise).to.be.ok()
			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(promise._values[1]).to.equal(7)
		end)
	end)

	describe("Promise.reject", function()
		it("should immediately reject with a value", function()
			local promise = Promise.reject(6, 7)

			expect(promise).to.be.ok()
			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(promise._values[1]).to.equal(6)
			expect(promise._values[2]).to.equal(7)
		end)

		it("should pass a promise as-is as an error", function()
			local innerPromise = Promise.new(function(resolve)
				resolve(6)
			end)

			local promise = Promise.reject(innerPromise)

			expect(promise).to.be.ok()
			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(promise._values[1]).to.equal(innerPromise)
		end)
	end)

	describe("Promise:andThen", function()
		it("should allow yielding", function()
			local bindable = Instance.new("BindableEvent")
			local promise = Promise.resolve():andThen(function()
				bindable.Event:Wait()
				return 5
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			bindable:Fire()
			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1]).to.equal(5)
		end)

		it("should run andThens on a new thread", function()
			local bindable = Instance.new("BindableEvent")

			local resolve
			local parentPromise = Promise.new(function(_resolve)
				resolve = _resolve
			end)

			local deadlockedPromise = parentPromise:andThen(function()
				bindable.Event:Wait()
				return 5
			end)

			local successfulPromise = parentPromise:andThen(function()
				return "foo"
			end)

			expect(parentPromise:getStatus()).to.equal(Promise.Status.Started)
			resolve()
			expect(successfulPromise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(successfulPromise._values[1]).to.equal("foo")
			expect(deadlockedPromise:getStatus()).to.equal(Promise.Status.Started)
		end)

		it("should chain onto resolved promises", function()
			local args
			local argsLength
			local callCount = 0
			local badCallCount = 0

			local promise = Promise.resolve(5)

			local chained = promise:andThen(function(...)
				argsLength, args = pack(...)
				callCount = callCount + 1
			end, function()
				badCallCount = badCallCount + 1
			end)

			expect(badCallCount).to.equal(0)

			expect(callCount).to.equal(1)
			expect(argsLength).to.equal(1)
			expect(args[1]).to.equal(5)

			expect(promise).to.be.ok()
			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1]).to.equal(5)

			expect(chained).to.be.ok()
			expect(chained).never.to.equal(promise)
			expect(chained:getStatus()).to.equal(Promise.Status.Resolved)
			expect(#chained._values).to.equal(0)
		end)

		it("should chain onto rejected promises", function()
			local args
			local argsLength
			local callCount = 0
			local badCallCount = 0

			local promise = Promise.reject(5)

			local chained = promise:andThen(function(...)
				badCallCount = badCallCount + 1
			end, function(...)
				argsLength, args = pack(...)
				callCount = callCount + 1
			end)

			expect(badCallCount).to.equal(0)

			expect(callCount).to.equal(1)
			expect(argsLength).to.equal(1)
			expect(args[1]).to.equal(5)

			expect(promise).to.be.ok()
			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(promise._values[1]).to.equal(5)

			expect(chained).to.be.ok()
			expect(chained).never.to.equal(promise)
			expect(chained:getStatus()).to.equal(Promise.Status.Resolved)
			expect(#chained._values).to.equal(0)
		end)

		it("should reject on error in callback", function()
			local callCount = 0

			local promise = Promise.resolve(1):andThen(function()
				callCount = callCount + 1
				error("hahah")
			end)

			expect(promise).to.be.ok()
			expect(callCount).to.equal(1)
			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(tostring(promise._values[1]):find("hahah")).to.be.ok()

			-- Loosely check for the pieces of the stack trace we expect
			expect(tostring(promise._values[1]):find("init.spec")).to.be.ok()
			expect(tostring(promise._values[1]):find("runExecutor")).to.be.ok()
		end)

		it("should chain onto asynchronously resolved promises", function()
			local args
			local argsLength
			local callCount = 0
			local badCallCount = 0

			local startResolution
			local promise = Promise.new(function(resolve)
				startResolution = resolve
			end)

			local chained = promise:andThen(function(...)
				args = { ... }
				argsLength = select("#", ...)
				callCount = callCount + 1
			end, function()
				badCallCount = badCallCount + 1
			end)

			expect(callCount).to.equal(0)
			expect(badCallCount).to.equal(0)

			startResolution(6)

			expect(badCallCount).to.equal(0)

			expect(callCount).to.equal(1)
			expect(argsLength).to.equal(1)
			expect(args[1]).to.equal(6)

			expect(promise).to.be.ok()
			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1]).to.equal(6)

			expect(chained).to.be.ok()
			expect(chained).never.to.equal(promise)
			expect(chained:getStatus()).to.equal(Promise.Status.Resolved)
			expect(#chained._values).to.equal(0)
		end)

		it("should chain onto asynchronously rejected promises", function()
			local args
			local argsLength
			local callCount = 0
			local badCallCount = 0

			local startResolution
			local promise = Promise.new(function(_, reject)
				startResolution = reject
			end)

			local chained = promise:andThen(function()
				badCallCount = badCallCount + 1
			end, function(...)
				args = { ... }
				argsLength = select("#", ...)
				callCount = callCount + 1
			end)

			expect(callCount).to.equal(0)
			expect(badCallCount).to.equal(0)

			startResolution(6)

			expect(badCallCount).to.equal(0)

			expect(callCount).to.equal(1)
			expect(argsLength).to.equal(1)
			expect(args[1]).to.equal(6)

			expect(promise).to.be.ok()
			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(promise._values[1]).to.equal(6)

			expect(chained).to.be.ok()
			expect(chained).never.to.equal(promise)
			expect(chained:getStatus()).to.equal(Promise.Status.Resolved)
			expect(#chained._values).to.equal(0)
		end)

		it("should propagate errors through multiple levels", function()
			local x, y, z
			Promise.new(function(resolve, reject)
				reject(1, 2, 3)
			end):andThen(function() end):catch(function(a, b, c)
				x, y, z = a, b, c
			end)

			expect(x).to.equal(1)
			expect(y).to.equal(2)
			expect(z).to.equal(3)
		end)

		it("should not call queued callbacks from a cancelled sub-promise", function()
			local resolve
			local count = 0

			local root = Promise.new(function(r)
				resolve = r
			end)

			root:andThen(function()
				count += 1
			end)

			root
				:andThen(function()
					count += 1
				end)
				:cancel()

			resolve("foo")

			expect(count).to.equal(1)
		end)
	end)

	describe("Promise:cancel", function()
		it("should mark promises as cancelled and not resolve or reject them", function()
			local callCount = 0
			local finallyCallCount = 0
			local promise = Promise.new(function() end)
				:andThen(function()
					callCount = callCount + 1
				end)
				:finally(function()
					finallyCallCount = finallyCallCount + 1
				end)

			promise:cancel()
			promise:cancel() -- Twice to check call counts

			expect(callCount).to.equal(0)
			expect(finallyCallCount).to.equal(1)
			expect(promise:getStatus()).to.equal(Promise.Status.Cancelled)
		end)

		it("should call the cancellation hook once", function()
			local callCount = 0

			local promise = Promise.new(function(resolve, reject, onCancel)
				onCancel(function()
					callCount = callCount + 1
				end)
			end)

			promise:cancel()
			promise:cancel() -- Twice to check call count

			expect(callCount).to.equal(1)
		end)

		it("should propagate cancellations", function()
			local promise = Promise.new(function() end)

			local consumer1 = promise:andThen()
			local consumer2 = promise:andThen()

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			expect(consumer1:getStatus()).to.equal(Promise.Status.Started)
			expect(consumer2:getStatus()).to.equal(Promise.Status.Started)

			consumer1:cancel()

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			expect(consumer1:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(consumer2:getStatus()).to.equal(Promise.Status.Started)

			consumer2:cancel()

			expect(promise:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(consumer1:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(consumer2:getStatus()).to.equal(Promise.Status.Cancelled)
		end)

		it("should affect downstream promises", function()
			local promise = Promise.new(function() end)
			local consumer = promise:andThen()

			promise:cancel()

			expect(consumer:getStatus()).to.equal(Promise.Status.Cancelled)
		end)

		it("should track consumers", function()
			local pending = Promise.new(function() end)
			local p0 = Promise.resolve()
			local p1 = p0:andThen(function()
				return pending
			end)
			local p2 = Promise.new(function(resolve)
				resolve(p1)
			end)
			local p3 = p2:andThen(function() end)

			expect(p1._parent).to.never.equal(p0)
			expect(p2._parent).to.never.equal(p1)
			expect(p2._consumers[p3]).to.be.ok()
			expect(p3._parent).to.equal(p2)
		end)

		it("should cancel resolved pending promises", function()
			local p1 = Promise.new(function() end)

			local p2 = Promise.new(function(resolve)
				resolve(p1)
			end):finally(function() end)

			p2:cancel()

			expect(p1._status).to.equal(Promise.Status.Cancelled)
			expect(p2._status).to.equal(Promise.Status.Cancelled)
		end)

		it("should close the promise thread", function()
			local count = 0
			local promise = Promise.new(function()
				count += 1
				Promise.delay(1):await()
				count += 1
			end)

			promise:cancel()
			advanceTime(2)

			expect(count).to.equal(1)
		end)
	end)

	describe("Promise:finally", function()
		it("should be called upon resolve, reject, or cancel", function()
			local callCount = 0

			local function finally()
				callCount = callCount + 1
			end

			-- Resolved promise
			Promise.new(function(resolve, reject)
				resolve()
			end):finally(finally)

			-- Chained promise
			Promise.resolve():andThen(function() end):finally(finally):finally(finally)

			-- Rejected promise
			Promise.reject():finally(finally)

			local cancelledPromise = Promise.new(function() end):finally(finally)
			cancelledPromise:cancel()

			expect(callCount).to.equal(5)
		end)

		it("should not forward return values", function()
			local value

			Promise.resolve(2)
				:finally(function()
					return 1
				end)
				:andThen(function(v)
					value = v
				end)

			expect(value).to.equal(2)
		end)

		it("should not consume rejections", function()
			local catchRan = false
			local thenRan = false
			Promise.reject(5)
				:finally(function()
					return 42
				end)
				:andThen(function()
					thenRan = true
				end)
				:catch(function(value)
					catchRan = true
					expect(value).to.equal(5)
				end)

			expect(catchRan).to.equal(true)
			expect(thenRan).to.equal(false)
		end)

		it("should wait for returned promises", function()
			local resolve
			local promise = Promise.reject("foo"):finally(function()
				return Promise.new(function(r)
					resolve = r
				end)
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)

			resolve()

			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			local _, value = promise:_unwrap()
			expect(value).to.equal("foo")
		end)

		it("should reject with a returned rejected promise's value", function()
			local reject
			local promise = Promise.reject("foo"):finally(function()
				return Promise.new(function(_, r)
					reject = r
				end)
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)

			reject("bar")

			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			local _, value = promise:_unwrap()
			expect(value).to.equal("bar")
		end)

		it("should reject when handler errors", function()
			local errorValue = {}
			local promise = Promise.reject("bar"):finally(function()
				error(errorValue)
			end)

			local ok, value = promise:_unwrap()

			expect(ok).to.equal(false)
			expect(value).to.equal(errorValue)
		end)

		it("should not prevent cancellation", function()
			local promise = Promise.new(function() end)

			local finallyRan = false
			promise:finally(function()
				finallyRan = true
			end)

			local consumer = promise:andThen(function() end)

			consumer:cancel()

			expect(promise:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(finallyRan).to.equal(true)
		end)

		it("should propagate cancellation downwards", function()
			local finallyRan = false
			local andThenRan = false
			local root = Promise.new(function() end)

			local consumer = root:finally(function()
				finallyRan = true
			end)

			root:cancel()

			expect(root:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(consumer:getStatus()).to.equal(Promise.Status.Cancelled)

			expect(finallyRan).to.equal(true)
			expect(andThenRan).to.equal(false)
		end)

		it("should propagate cancellation upwards", function()
			local finallyRan = false
			local andThenRan = false
			local root = Promise.new(function() end)

			local consumer = root:finally(function()
				finallyRan = true
			end)

			consumer:cancel()

			expect(root:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(consumer:getStatus()).to.equal(Promise.Status.Cancelled)

			expect(finallyRan).to.equal(true)
			expect(andThenRan).to.equal(false)
		end)

		it("should cancel returned promise if cancelled", function()
			local internal = Promise.new(function() end)

			local promise = Promise.resolve():finally(function()
				return internal
			end)

			promise:cancel()

			expect(internal:getStatus()).to.equal(Promise.Status.Cancelled)
		end)
	end)

	describe("Promise.all", function()
		it("should error if given something other than a table", function()
			expect(function()
				Promise.all(1)
			end).to.throw()
		end)

		it("should resolve instantly with an empty table if given no promises", function()
			local promise = Promise.all({})
			local success, value = promise:_unwrap()

			expect(success).to.equal(true)
			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(value).to.be.a("table")
			expect(next(value)).to.equal(nil)
		end)

		it("should error if given non-promise values", function()
			expect(function()
				Promise.all({ {}, {}, {} })
			end).to.throw()
		end)

		it("should wait for all promises to be resolved and return their values", function()
			local resolveFunctions = {}

			local testValuesLength, testValues = pack(1, "A string", nil, false)

			local promises = {}

			for i = 1, testValuesLength do
				promises[i] = Promise.new(function(resolve)
					resolveFunctions[i] = { resolve, testValues[i] }
				end)
			end

			local combinedPromise = Promise.all(promises)

			for _, resolve in ipairs(resolveFunctions) do
				expect(combinedPromise:getStatus()).to.equal(Promise.Status.Started)
				resolve[1](resolve[2])
			end

			local resultLength, result = pack(combinedPromise:_unwrap())
			local success, resolved = unpack(result, 1, resultLength)

			expect(resultLength).to.equal(2)
			expect(success).to.equal(true)
			expect(resolved).to.be.a("table")
			expect(#resolved).to.equal(#promises)

			for i = 1, testValuesLength do
				expect(resolved[i]).to.equal(testValues[i])
			end
		end)

		it("should reject if any individual promise rejected", function()
			local rejectA
			local resolveB

			local a = Promise.new(function(_, reject)
				rejectA = reject
			end)

			local b = Promise.new(function(resolve)
				resolveB = resolve
			end)

			local combinedPromise = Promise.all({ a, b })

			expect(combinedPromise:getStatus()).to.equal(Promise.Status.Started)

			rejectA("baz", "qux")
			resolveB("foo", "bar")

			local resultLength, result = pack(combinedPromise:_unwrap())
			local success, first, second = unpack(result, 1, resultLength)

			expect(resultLength).to.equal(3)
			expect(success).to.equal(false)
			expect(first).to.equal("baz")
			expect(second).to.equal("qux")
			expect(b:getStatus()).to.equal(Promise.Status.Cancelled)
		end)

		it("should not resolve if resolved after rejecting", function()
			local rejectA
			local resolveB

			local a = Promise.new(function(_, reject)
				rejectA = reject
			end)

			local b = Promise.new(function(resolve)
				resolveB = resolve
			end)

			local combinedPromise = Promise.all({ a, b })

			expect(combinedPromise:getStatus()).to.equal(Promise.Status.Started)

			rejectA("baz", "qux")
			resolveB("foo", "bar")

			local resultLength, result = pack(combinedPromise:_unwrap())
			local success, first, second = unpack(result, 1, resultLength)

			expect(resultLength).to.equal(3)
			expect(success).to.equal(false)
			expect(first).to.equal("baz")
			expect(second).to.equal("qux")
		end)

		it("should only reject once", function()
			local rejectA
			local rejectB

			local a = Promise.new(function(_, reject)
				rejectA = reject
			end)

			local b = Promise.new(function(_, reject)
				rejectB = reject
			end)

			local combinedPromise = Promise.all({ a, b })

			expect(combinedPromise:getStatus()).to.equal(Promise.Status.Started)

			rejectA("foo", "bar")

			expect(combinedPromise:getStatus()).to.equal(Promise.Status.Rejected)

			rejectB("baz", "qux")

			local resultLength, result = pack(combinedPromise:_unwrap())
			local success, first, second = unpack(result, 1, resultLength)

			expect(resultLength).to.equal(3)
			expect(success).to.equal(false)
			expect(first).to.equal("foo")
			expect(second).to.equal("bar")
		end)

		it("should error if a non-array table is passed in", function()
			local ok, err = pcall(function()
				Promise.all(Promise.new(function() end))
			end)

			expect(ok).to.be.ok()
			expect(err:find("Non%-promise")).to.be.ok()
		end)

		it("should cancel pending promises if one rejects", function()
			local p = Promise.new(function() end)
			expect(Promise.all({
				Promise.resolve(),
				Promise.reject(),
				p,
			}):getStatus()).to.equal(Promise.Status.Rejected)
			expect(p:getStatus()).to.equal(Promise.Status.Cancelled)
		end)

		it("should cancel promises if it is cancelled", function()
			local p = Promise.new(function() end)
			p:andThen(function() end)

			local promises = {
				Promise.new(function() end),
				Promise.new(function() end),
				p,
			}

			Promise.all(promises):cancel()

			expect(promises[1]:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(promises[2]:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(promises[3]:getStatus()).to.equal(Promise.Status.Started)
		end)
	end)

	describe("Promise.fold", function()
		it("should return the initial value in a promise when the list is empty", function()
			local initialValue = {}
			local result = Promise.fold({}, function()
				error("should not be called")
			end, initialValue)

			expect(Promise.is(result)).to.equal(true)
			expect(result:getStatus()).to.equal(Promise.Status.Resolved)
			expect(result:expect()).to.equal(initialValue)
		end)

		it("should accept promises in the list", function()
			local resolve

			local sum = Promise.fold({ Promise.new(function(r)
				resolve = r
			end), 2, 3 }, function(sum, element)
				return sum + element
			end, 0)

			resolve(1)

			expect(Promise.is(sum)).to.equal(true)
			expect(sum:getStatus()).to.equal(Promise.Status.Resolved)
			expect(sum:expect()).to.equal(6)
		end)

		it("should always return a promise even if the list or reducer don't use them", function()
			local sum = Promise.fold({ 1, 2, 3 }, function(sum, element, index)
				if index == 2 then
					return Promise.delay(1):andThenReturn(sum + element)
				else
					return sum + element
				end
			end, 0)
			expect(Promise.is(sum)).to.equal(true)
			expect(sum:getStatus()).to.equal(Promise.Status.Started)
			advanceTime(2)
			expect(sum:getStatus()).to.equal(Promise.Status.Resolved)
			expect(sum:expect()).to.equal(6)
		end)

		it("should return the first rejected promise", function()
			local errorMessage = "foo"
			local sum = Promise.fold({ 1, 2, 3 }, function(sum, element, index)
				if index == 2 then
					return Promise.reject(errorMessage)
				else
					return sum + element
				end
			end, 0)
			expect(Promise.is(sum)).to.equal(true)
			local status, rejection = sum:awaitStatus()
			expect(status).to.equal(Promise.Status.Rejected)
			expect(rejection).to.equal(errorMessage)
		end)

		it("should return the first canceled promise", function()
			local secondPromise
			local sum = Promise.fold({ 1, 2, 3 }, function(sum, element, index)
				if index == 1 then
					return sum + element
				elseif index == 2 then
					secondPromise = Promise.delay(1):andThenReturn(sum + element)
					return secondPromise
				else
					error("this should not run if the promise is cancelled")
				end
			end, 0)
			expect(Promise.is(sum)).to.equal(true)
			expect(sum:getStatus()).to.equal(Promise.Status.Started)
			secondPromise:cancel()
			expect(sum:getStatus()).to.equal(Promise.Status.Cancelled)
		end)
	end)

	describe("Promise.race", function()
		it("should resolve with the first settled value", function()
			local promise = Promise.race({
				Promise.resolve(1),
				Promise.resolve(2),
			}):andThen(function(value)
				expect(value).to.equal(1)
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
		end)

		it("should cancel other promises", function()
			local promise = Promise.new(function() end)
			promise:andThen(function() end)
			local promises = {
				promise,
				Promise.new(function() end),
				Promise.new(function(resolve)
					resolve(2)
				end),
			}

			local promise = Promise.race(promises)

			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1]).to.equal(2)
			expect(promises[1]:getStatus()).to.equal(Promise.Status.Started)
			expect(promises[2]:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(promises[3]:getStatus()).to.equal(Promise.Status.Resolved)

			local p = Promise.new(function() end)
			expect(Promise.race({
				Promise.reject(),
				Promise.resolve(),
				p,
			}):getStatus()).to.equal(Promise.Status.Rejected)
			expect(p:getStatus()).to.equal(Promise.Status.Cancelled)
		end)

		it("should error if a non-array table is passed in", function()
			local ok, err = pcall(function()
				Promise.race(Promise.new(function() end))
			end)

			expect(ok).to.be.ok()
			expect(err:find("Non%-promise")).to.be.ok()
		end)

		it("should cancel promises if it is cancelled", function()
			local p = Promise.new(function() end)
			p:andThen(function() end)

			local promises = {
				Promise.new(function() end),
				Promise.new(function() end),
				p,
			}

			Promise.race(promises):cancel()

			expect(promises[1]:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(promises[2]:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(promises[3]:getStatus()).to.equal(Promise.Status.Started)
		end)
	end)

	describe("Promise.promisify", function()
		it("should wrap functions", function()
			local function test(n)
				return n + 1
			end

			local promisified = Promise.promisify(test)
			local promise = promisified(1)
			local success, result = promise:_unwrap()

			expect(success).to.equal(true)
			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(result).to.equal(2)
		end)

		it("should catch errors after a yield", function()
			local bindable = Instance.new("BindableEvent")
			local test = Promise.promisify(function()
				bindable.Event:Wait()
				error("errortext")
			end)

			local promise = test()

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			bindable:Fire()
			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(tostring(promise._values[1]):find("errortext")).to.be.ok()
		end)
	end)

	describe("Promise.tap", function()
		it("should thread through values", function()
			local first, second

			Promise.resolve(1)
				:andThen(function(v)
					return v + 1
				end)
				:tap(function(v)
					first = v
					return v + 1
				end)
				:andThen(function(v)
					second = v
				end)

			expect(first).to.equal(2)
			expect(second).to.equal(2)
		end)

		it("should chain onto promises", function()
			local resolveInner, finalValue

			local promise = Promise.resolve(1)
				:tap(function()
					return Promise.new(function(resolve)
						resolveInner = resolve
					end)
				end)
				:andThen(function(v)
					finalValue = v
				end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			expect(finalValue).to.never.be.ok()

			resolveInner(1)

			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(finalValue).to.equal(1)
		end)
	end)

	describe("Promise.try", function()
		it("should catch synchronous errors", function()
			local errorText
			Promise.try(function()
				error("errortext")
			end):catch(function(e)
				errorText = tostring(e)
			end)

			expect(errorText:find("errortext")).to.be.ok()
		end)

		it("should reject with error objects", function()
			local object = {}
			local success, value = Promise.try(function()
				error(object)
			end):_unwrap()

			expect(success).to.equal(false)
			expect(value).to.equal(object)
		end)

		it("should catch asynchronous errors", function()
			local bindable = Instance.new("BindableEvent")
			local promise = Promise.try(function()
				bindable.Event:Wait()
				error("errortext")
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			bindable:Fire()
			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(tostring(promise._values[1]):find("errortext")).to.be.ok()
		end)
	end)

	describe("Promise:andThenReturn", function()
		it("should return the given values", function()
			local value1, value2

			Promise.resolve():andThenReturn(1, 2):andThen(function(one, two)
				value1 = one
				value2 = two
			end)

			expect(value1).to.equal(1)
			expect(value2).to.equal(2)
		end)
	end)

	describe("Promise:andThenCall", function()
		it("should call the given function with arguments", function()
			local value1, value2
			Promise.resolve():andThenCall(function(a, b)
				value1 = a
				value2 = b
			end, 3, 4)

			expect(value1).to.equal(3)
			expect(value2).to.equal(4)
		end)
	end)

	describe("Promise.some", function()
		it("should resolve once the goal is reached", function()
			local p = Promise.some({
				Promise.resolve(1),
				Promise.reject(),
				Promise.resolve(2),
			}, 2)
			expect(p:getStatus()).to.equal(Promise.Status.Resolved)
			expect(p._values[1][1]).to.equal(1)
			expect(p._values[1][2]).to.equal(2)
		end)

		it("should error if the goal can't be reached", function()
			expect(Promise.some({
				Promise.resolve(),
				Promise.reject(),
			}, 2):getStatus()).to.equal(Promise.Status.Rejected)

			local reject
			local p = Promise.some({
				Promise.resolve(),
				Promise.new(function(_, r)
					reject = r
				end),
			}, 2)

			expect(p:getStatus()).to.equal(Promise.Status.Started)
			reject("foo")
			expect(p:getStatus()).to.equal(Promise.Status.Rejected)
			expect(p._values[1]).to.equal("foo")
		end)

		it("should cancel pending Promises once the goal is reached", function()
			local resolve
			local pending1 = Promise.new(function() end)
			local pending2 = Promise.new(function(r)
				resolve = r
			end)

			local some = Promise.some({
				pending1,
				pending2,
				Promise.resolve(),
			}, 2)

			expect(some:getStatus()).to.equal(Promise.Status.Started)
			expect(pending1:getStatus()).to.equal(Promise.Status.Started)
			expect(pending2:getStatus()).to.equal(Promise.Status.Started)

			resolve()

			expect(some:getStatus()).to.equal(Promise.Status.Resolved)
			expect(pending1:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(pending2:getStatus()).to.equal(Promise.Status.Resolved)
		end)

		it("should error if passed a non-number", function()
			expect(function()
				Promise.some({}, "non-number")
			end).to.throw()
		end)

		it("should return an empty array if amount is 0", function()
			local p = Promise.some({
				Promise.resolve(2),
			}, 0)

			expect(p:getStatus()).to.equal(Promise.Status.Resolved)
			expect(#p._values[1]).to.equal(0)
		end)

		it("should not return extra values", function()
			local p = Promise.some({
				Promise.resolve(1),
				Promise.resolve(2),
				Promise.resolve(3),
				Promise.resolve(4),
			}, 2)

			expect(p:getStatus()).to.equal(Promise.Status.Resolved)
			expect(#p._values[1]).to.equal(2)
			expect(p._values[1][1]).to.equal(1)
			expect(p._values[1][2]).to.equal(2)
		end)

		it("should cancel promises if it is cancelled", function()
			local p = Promise.new(function() end)
			p:andThen(function() end)

			local promises = {
				Promise.new(function() end),
				Promise.new(function() end),
				p,
			}

			Promise.some(promises, 3):cancel()

			expect(promises[1]:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(promises[2]:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(promises[3]:getStatus()).to.equal(Promise.Status.Started)
		end)

		describe("Promise.any", function()
			it("should return the value directly", function()
				local p = Promise.any({
					Promise.reject(),
					Promise.reject(),
					Promise.resolve(1),
				})

				expect(p:getStatus()).to.equal(Promise.Status.Resolved)
				expect(p._values[1]).to.equal(1)
			end)

			it("should error if all are rejected", function()
				expect(Promise.any({
					Promise.reject(),
					Promise.reject(),
					Promise.reject(),
				}):getStatus()).to.equal(Promise.Status.Rejected)
			end)
		end)
	end)

	describe("Promise.allSettled", function()
		it("should resolve with an array of PromiseStatuses", function()
			local reject
			local p = Promise.allSettled({
				Promise.resolve(),
				Promise.reject(),
				Promise.resolve(),
				Promise.new(function(_, r)
					reject = r
				end),
			})

			expect(p:getStatus()).to.equal(Promise.Status.Started)
			reject()
			expect(p:getStatus()).to.equal(Promise.Status.Resolved)
			expect(p._values[1][1]).to.equal(Promise.Status.Resolved)
			expect(p._values[1][2]).to.equal(Promise.Status.Rejected)
			expect(p._values[1][3]).to.equal(Promise.Status.Resolved)
			expect(p._values[1][4]).to.equal(Promise.Status.Rejected)
		end)

		it("should cancel promises if it is cancelled", function()
			local p = Promise.new(function() end)
			p:andThen(function() end)

			local promises = {
				Promise.new(function() end),
				Promise.new(function() end),
				p,
			}

			Promise.allSettled(promises):cancel()

			expect(promises[1]:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(promises[2]:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(promises[3]:getStatus()).to.equal(Promise.Status.Started)
		end)
	end)

	describe("Promise:await", function()
		it("should return the correct values", function()
			local promise = Promise.resolve(5, 6, nil, 7)

			local a, b, c, d, e = promise:await()

			expect(a).to.equal(true)
			expect(b).to.equal(5)
			expect(c).to.equal(6)
			expect(d).to.equal(nil)
			expect(e).to.equal(7)
		end)

		it("should work if yielding is needed", function()
			local ran = false
			task.spawn(function()
				local _, actualTime = Promise.delay(1):await()
				expect(type(actualTime)).to.equal("number")
				ran = true
			end)

			advanceTime(2)
			expect(ran).to.equal(true)
		end)
	end)

	describe("Promise:expect", function()
		it("should throw the correct values", function()
			local rejectionValue = {}
			local promise = Promise.reject(rejectionValue)

			local success, value = pcall(function()
				promise:expect()
			end)

			expect(success).to.equal(false)
			expect(value).to.equal(rejectionValue)
		end)
	end)

	describe("Promise:now", function()
		it("should resolve if the Promise is resolved", function()
			local success, value = Promise.resolve("foo"):now():_unwrap()

			expect(success).to.equal(true)
			expect(value).to.equal("foo")
		end)

		it("should reject if the Promise is not resolved", function()
			local success, value = Promise.new(function() end):now():_unwrap()

			expect(success).to.equal(false)
			expect(Promise.Error.isKind(value, "NotResolvedInTime")).to.equal(true)
		end)

		it("should reject with a custom rejection value", function()
			local success, value = Promise.new(function() end):now("foo"):_unwrap()

			expect(success).to.equal(false)
			expect(value).to.equal("foo")
		end)
	end)

	describe("Promise.each", function()
		it("should iterate", function()
			local ok, result = Promise.each({
				"foo",
				"bar",
				"baz",
				"qux",
			}, function(...)
				return { ... }
			end):_unwrap()

			expect(ok).to.equal(true)
			expect(result[1][1]).to.equal("foo")
			expect(result[1][2]).to.equal(1)
			expect(result[2][1]).to.equal("bar")
			expect(result[2][2]).to.equal(2)
			expect(result[3][1]).to.equal("baz")
			expect(result[3][2]).to.equal(3)
			expect(result[4][1]).to.equal("qux")
			expect(result[4][2]).to.equal(4)
		end)

		it("should iterate serially", function()
			local resolves = {}
			local callCounts = {}

			local promise = Promise.each({
				"foo",
				"bar",
				"baz",
			}, function(value, index)
				callCounts[index] = (callCounts[index] or 0) + 1

				return Promise.new(function(resolve)
					table.insert(resolves, function()
						resolve(value:upper())
					end)
				end)
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			expect(#resolves).to.equal(1)
			expect(callCounts[1]).to.equal(1)
			expect(callCounts[2]).to.never.be.ok()

			table.remove(resolves, 1)()

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			expect(#resolves).to.equal(1)
			expect(callCounts[1]).to.equal(1)
			expect(callCounts[2]).to.equal(1)
			expect(callCounts[3]).to.never.be.ok()

			table.remove(resolves, 1)()

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			expect(callCounts[1]).to.equal(1)
			expect(callCounts[2]).to.equal(1)
			expect(callCounts[3]).to.equal(1)

			table.remove(resolves, 1)()

			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(type(promise._values[1])).to.equal("table")
			expect(type(promise._values[2])).to.equal("nil")

			local result = promise._values[1]

			expect(result[1]).to.equal("FOO")
			expect(result[2]).to.equal("BAR")
			expect(result[3]).to.equal("BAZ")
		end)

		it("should reject with the value if the predicate promise rejects", function()
			local promise = Promise.each({ 1, 2, 3 }, function()
				return Promise.reject("foobar")
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(promise._values[1]).to.equal("foobar")
		end)

		it("should allow Promises to be in the list and wait when it gets to them", function()
			local innerResolve
			local innerPromise = Promise.new(function(resolve)
				innerResolve = resolve
			end)

			local promise = Promise.each({
				innerPromise,
			}, function(value)
				return value * 2
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)

			innerResolve(2)

			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1][1]).to.equal(4)
		end)

		it("should reject with the value if a Promise from the list rejects", function()
			local called = false
			local promise = Promise.each({ 1, 2, Promise.reject("foobar") }, function(value)
				called = true
				return "never"
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(promise._values[1]).to.equal("foobar")
			expect(called).to.equal(false)
		end)

		it("should reject immediately if there's a cancelled Promise in the list initially", function()
			local cancelled = Promise.new(function() end)
			cancelled:cancel()

			local called = false
			local promise = Promise.each({ 1, 2, cancelled }, function()
				called = true
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(called).to.equal(false)
			expect(promise._values[1].kind).to.equal(Promise.Error.Kind.AlreadyCancelled)
		end)

		it("should stop iteration if Promise.each is cancelled", function()
			local callCounts = {}

			local promise = Promise.each({
				"foo",
				"bar",
				"baz",
			}, function(value, index)
				callCounts[index] = (callCounts[index] or 0) + 1

				return Promise.new(function() end)
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)
			expect(callCounts[1]).to.equal(1)
			expect(callCounts[2]).to.never.be.ok()

			promise:cancel()

			expect(promise:getStatus()).to.equal(Promise.Status.Cancelled)
			expect(callCounts[1]).to.equal(1)
			expect(callCounts[2]).to.never.be.ok()
		end)

		it("should cancel the Promise returned from the predicate if Promise.each is cancelled", function()
			local innerPromise

			local promise = Promise.each({
				"foo",
				"bar",
				"baz",
			}, function(value, index)
				innerPromise = Promise.new(function() end)
				return innerPromise
			end)

			promise:cancel()

			expect(innerPromise:getStatus()).to.equal(Promise.Status.Cancelled)
		end)

		it("should cancel Promises in the list if Promise.each is cancelled", function()
			local innerPromise = Promise.new(function() end)

			local promise = Promise.each({ innerPromise }, function() end)

			promise:cancel()

			expect(innerPromise:getStatus()).to.equal(Promise.Status.Cancelled)
		end)
	end)

	describe("Promise.retry", function()
		it("should retry N times", function()
			local counter = 0

			local promise = Promise.retry(function(parameter)
				expect(parameter).to.equal("foo")

				counter = counter + 1

				if counter == 5 then
					return Promise.resolve("ok")
				end

				return Promise.reject("fail")
			end, 5, "foo")

			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1]).to.equal("ok")
		end)

		it("should reject if threshold is exceeded", function()
			local promise = Promise.retry(function()
				return Promise.reject("fail")
			end, 5)

			expect(promise:getStatus()).to.equal(Promise.Status.Rejected)
			expect(promise._values[1]).to.equal("fail")
		end)
	end)

	describe("Promise.retryWithDelay", function()
		it("should retry after a delay", function()
			local counter = 0

			local promise = Promise.retryWithDelay(function(parameter)
				expect(parameter).to.equal("foo")

				counter = counter + 1

				if counter == 3 then
					return Promise.resolve("ok")
				end

				return Promise.reject("fail")
			end, 3, 10, "foo")

			expect(counter).to.equal(1)

			advanceTime(11)

			expect(counter).to.equal(2)

			advanceTime(11)

			expect(counter).to.equal(3)

			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1]).to.equal("ok")
		end)
	end)

	describe("Promise.fromEvent", function()
		it("should convert a Promise into an event", function()
			local event = Instance.new("BindableEvent")

			local promise = Promise.fromEvent(event.Event)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)

			event:Fire("foo")

			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1]).to.equal("foo")
		end)

		it("should convert a Promise into an event with the predicate", function()
			local event = Instance.new("BindableEvent")

			local promise = Promise.fromEvent(event.Event, function(param)
				return param == "foo"
			end)

			expect(promise:getStatus()).to.equal(Promise.Status.Started)

			event:Fire("bar")

			expect(promise:getStatus()).to.equal(Promise.Status.Started)

			event:Fire("foo")

			expect(promise:getStatus()).to.equal(Promise.Status.Resolved)
			expect(promise._values[1]).to.equal("foo")
		end)
	end)

	describe("Promise.is", function()
		it("should work with current version", function()
			local promise = Promise.resolve(1)

			expect(Promise.is(promise)).to.equal(true)
		end)

		it("should work with any object with an andThen", function()
			local obj = {
				andThen = function()
					return 1
				end,
			}

			expect(Promise.is(obj)).to.equal(true)
		end)

		it("should work with older promises", function()
			local OldPromise = {}
			OldPromise.prototype = {}
			OldPromise.__index = OldPromise.prototype

			function OldPromise.prototype:andThen() end

			local oldPromise = setmetatable({}, OldPromise)

			expect(Promise.is(oldPromise)).to.equal(true)
		end)
	end)
end

end)() end,
    [65] = function()local wax,script,require=ImportGlobals(65)local ImportGlobals return (function(...)return require(script.Parent.Parent["evaera_promise@4.0.0"]["promise"])

end)() end,
    [66] = function()local wax,script,require=ImportGlobals(66)local ImportGlobals return (function(...)--!optimize 2
--!strict
-- Partial types for Promise

local Promise = require(script.Parent.Promise) :: any

export type Status = "Started" | "Resolved" | "Rejected" | "Cancelled"
export type ErrorKind = "ExecutionError" | "AlreadyCancelled" | "NotResolvedInTime" | "TimedOut"

type ErrorStaticAndShared = {
	Kind: {
		ExecutionError: "ExecutionError",
		AlreadyCancelled: "AlreadyCancelled",
		NotResolvedInTime: "NotResolvedInTime",
		TimedOut: "TimedOut",
	},
}
type ErrorOptions = {
	error: string,
	trace: string?,
	context: string?,
	kind: ErrorKind,
}

export type Error = typeof(setmetatable({} :: ErrorStaticAndShared & {
	error: string,
	trace: string?,
	context: string?,
	kind: ErrorKind,
	parent: Error?,
	createdTick: number,
	createdTrace: string,

	extend: (self: Error, options: ErrorOptions?) -> Error,
	getErrorChain: (self: Error) -> {Error},
}, {} :: {__tostring: (self: Error) -> string}))
type ErrorStatic = ErrorStaticAndShared & {
	new: (options: ErrorOptions?, parent: Error?) -> Error,
	is: (anything: any) -> boolean,
	isKind: (anything: any, kind: ErrorKind) -> boolean,
}

export type Promise = {
	andThen: (
		self: Promise,
		successHandler: (...any) -> ...any,
		failureHandler: ((...any) -> ...any)?
	) -> Promise,
	andThenCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> any,
	andThenReturn: (self: Promise, ...any) -> Promise,

	await: (self: Promise) -> (boolean, ...any),
	awaitStatus: (self: Promise) -> (Status, ...any),

	cancel: (self: Promise) -> (),
	catch: (self: Promise, failureHandler: (...any) -> ...any) -> Promise,
	expect: (self: Promise) -> ...any,

	finally: (self: Promise, finallyHandler: (status: Status) -> ...any) -> Promise,
	finallyCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> Promise,
	finallyReturn: (self: Promise, ...any) -> Promise,

	getStatus: (self: Promise) -> Status,
	now: (self: Promise, rejectionValue: any?) -> Promise,
	tap: (self: Promise, tapHandler: (...any) -> ...any) -> Promise,
	timeout: (self: Promise, seconds: number, rejectionValue: any?) -> Promise,
}

export type TypedPromise<T...> = {
	andThen: (self: Promise, successHandler: (T...) -> ...any, failureHandler: ((...any) -> ...any)?) -> Promise,
	andThenCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> Promise,
	andThenReturn: (self: Promise, ...any) -> Promise,

	await: (self: Promise) -> (boolean, T...),
	awaitStatus: (self: Promise) -> (Status, T...),

	cancel: (self: Promise) -> (),
	catch: (self: Promise, failureHandler: (...any) -> ...any) -> Promise,
	expect: (self: Promise) -> T...,

	finally: (self: Promise, finallyHandler: (status: Status) -> ...any) -> Promise,
	finallyCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> Promise,
	finallyReturn: (self: Promise, ...any) -> Promise,

	getStatus: (self: Promise) -> Status,
	now: (self: Promise, rejectionValue: any?) -> Promise,
	tap: (self: Promise, tapHandler: (T...) -> ...any) -> Promise,
	timeout: (self: Promise, seconds: number, rejectionValue: any?) -> TypedPromise<T...>,
}

type Signal<T...> = {
	Connect: (self: Signal<T...>, callback: (T...) -> ...any) -> SignalConnection,
	[any]: any,
} | RBXScriptSignal<T...>

type SignalConnection = {
	Disconnect: (self: SignalConnection) -> ...any,
	[any]: any,
} | RBXScriptConnection

export type PromiseStatic = {
	Error: ErrorStatic,
	Status: {
		Started: "Started",
		Resolved: "Resolved",
		Rejected: "Rejected",
		Cancelled: "Cancelled",
	},

	all: <T>(promises: {TypedPromise<T>}) -> TypedPromise<{T}>,
	allSettled: <T>(promise: {TypedPromise<T>}) -> TypedPromise<{Status}>,
	any: <T>(promise: {TypedPromise<T>}) -> TypedPromise<T>,
	defer: <TReturn...>(
		executor: (
			resolve: (TReturn...) -> (),
			reject: (...any) -> (),
			onCancel: (abortHandler: (() -> ())?) -> boolean
		) -> ()
	) -> TypedPromise<TReturn...>,
	delay: (seconds: number) -> TypedPromise<number>,
	each: <T, TReturn>(
		list: {T | TypedPromise<T>},
		predicate: (value: T, index: number) -> TReturn | TypedPromise<TReturn>
	) -> TypedPromise<{TReturn}>,
	fold: <T, TReturn>(
		list: {T | TypedPromise<T>},
		reducer: (accumulator: TReturn, value: T, index: number) -> TReturn | TypedPromise<TReturn>
	) -> TypedPromise<TReturn>,
	fromEvent: <TReturn...>(
		event: Signal<TReturn...>,
		predicate: ((TReturn...) -> boolean)?
	) -> TypedPromise<TReturn...>,
	is: (object: any) -> boolean,
	new: <TReturn...>(
		executor: (
			resolve: (TReturn...) -> (),
			reject: (...any) -> (),
			onCancel: (abortHandler: (() -> ())?) -> boolean
		) -> ()
	) -> TypedPromise<TReturn...>,
	onUnhandledRejection: (callback: (promise: TypedPromise<any>, ...any) -> ()) -> () -> (),
	promisify: <TArgs..., TReturn...>(callback: (TArgs...) -> TReturn...) -> (TArgs...) -> TypedPromise<TReturn...>,
	race: <T>(promises: {TypedPromise<T>}) -> TypedPromise<T>,
	reject: (...any) -> TypedPromise<...any>,
	resolve: <TReturn...>(TReturn...) -> TypedPromise<TReturn...>,
	retry: <TArgs..., TReturn...>(
		callback: (TArgs...) -> TypedPromise<TReturn...>,
		times: number,
		TArgs...
	) -> TypedPromise<TReturn...>,
	retryWithDelay: <TArgs..., TReturn...>(
		callback: (TArgs...) -> TypedPromise<TReturn...>,
		times: number,
		seconds: number,
		TArgs...
	) -> TypedPromise<TReturn...>,
	some: <T>(promise: {TypedPromise<T>}, count: number) -> TypedPromise<{T}>,
	try: <TArgs..., TReturn...>(callback: (TArgs...) -> TReturn..., TArgs...) -> TypedPromise<TReturn...>,
}

return Promise :: PromiseStatic

end)() end,
    [68] = function()local wax,script,require=ImportGlobals(68)local ImportGlobals return (function(...)-- -----------------------------------------------------------------------------
--               Batched Yield-Safe Signal Implementation                     --
-- This is a Signal class which has effectively identical behavior to a       --
-- normal RBXScriptSignal, with the only difference being a couple extra      --
-- stack frames at the bottom of the stack trace when an error is thrown.     --
-- This implementation caches runner coroutines, so the ability to yield in   --
-- the signal handlers comes at minimal extra cost over a naive signal        --
-- implementation that either always or never spawns a thread.                --
--                                                                            --
-- License:                                                                   --
--   Licensed under the MIT license.                                          --
--                                                                            --
-- Authors:                                                                   --
--   stravant - July 31st, 2021 - Created the file.                           --
--   sleitnick - August 3rd, 2021 - Modified for Knit.                        --
-- -----------------------------------------------------------------------------

-- Signal types
export type Connection = {
	Disconnect: (self: Connection) -> (),
	Destroy: (self: Connection) -> (),
	Connected: boolean,
}

export type Signal<T...> = {
	Fire: (self: Signal<T...>, T...) -> (),
	FireDeferred: (self: Signal<T...>, T...) -> (),
	Connect: (self: Signal<T...>, fn: (T...) -> ()) -> Connection,
	Once: (self: Signal<T...>, fn: (T...) -> ()) -> Connection,
	DisconnectAll: (self: Signal<T...>) -> (),
	GetConnections: (self: Signal<T...>) -> { Connection },
	Destroy: (self: Signal<T...>) -> (),
	Wait: (self: Signal<T...>) -> T...,
}

-- The currently idle thread to run the next handler on
local freeRunnerThread = nil

-- Function which acquires the currently idle handler runner thread, runs the
-- function fn on it, and then releases the thread, returning it to being the
-- currently idle one.
-- If there was a currently idle runner thread already, that's okay, that old
-- one will just get thrown and eventually GCed.
local function acquireRunnerThreadAndCallEventHandler(fn, ...)
	local acquiredRunnerThread = freeRunnerThread
	freeRunnerThread = nil
	fn(...)
	-- The handler finished running, this runner thread is free again.
	freeRunnerThread = acquiredRunnerThread
end

-- Coroutine runner that we create coroutines of. The coroutine can be
-- repeatedly resumed with functions to run followed by the argument to run
-- them with.
local function runEventHandlerInFreeThread(...)
	acquireRunnerThreadAndCallEventHandler(...)
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

--[=[
	@within Signal
	@interface SignalConnection
	.Connected boolean
	.Disconnect (SignalConnection) -> ()

	Represents a connection to a signal.
	```lua
	local connection = signal:Connect(function() end)
	print(connection.Connected) --> true
	connection:Disconnect()
	print(connection.Connected) --> false
	```
]=]

-- Connection class
local Connection = {}
Connection.__index = Connection

function Connection:Disconnect()
	if not self.Connected then
		return
	end
	self.Connected = false

	-- Unhook the node, but DON'T clear it. That way any fire calls that are
	-- currently sitting on this node will be able to iterate forwards off of
	-- it, but any subsequent fire calls will not hit it, and it will be GCed
	-- when no more fire calls are sitting on it.
	if self._signal._handlerListHead == self then
		self._signal._handlerListHead = self._next
	else
		local prev = self._signal._handlerListHead
		while prev and prev._next ~= self do
			prev = prev._next
		end
		if prev then
			prev._next = self._next
		end
	end
end

Connection.Destroy = Connection.Disconnect

-- Make Connection strict
setmetatable(Connection, {
	__index = function(_tb, key)
		error(("Attempt to get Connection::%s (not a valid member)"):format(tostring(key)), 2)
	end,
	__newindex = function(_tb, key, _value)
		error(("Attempt to set Connection::%s (not a valid member)"):format(tostring(key)), 2)
	end,
})

--[=[
	@within Signal
	@type ConnectionFn (...any) -> ()

	A function connected to a signal.
]=]

--[=[
	@class Signal

	A Signal is a data structure that allows events to be dispatched
	and observed.

	This implementation is a direct copy of the de facto standard, [GoodSignal](https://devforum.roblox.com/t/lua-signal-class-comparison-optimal-goodsignal-class/1387063),
	with some added methods and typings.

	For example:
	```lua
	local signal = Signal.new()

	-- Subscribe to a signal:
	signal:Connect(function(msg)
		print("Got message:", msg)
	end)

	-- Dispatch an event:
	signal:Fire("Hello world!")
	```
]=]
local Signal = {}
Signal.__index = Signal

--[=[
	Constructs a new Signal

	@return Signal
]=]
function Signal.new<T...>(): Signal<T...>
	local self = setmetatable({
		_handlerListHead = false,
		_proxyHandler = nil,
		_yieldedThreads = nil,
	}, Signal)

	return self
end

--[=[
	Constructs a new Signal that wraps around an RBXScriptSignal.

	@param rbxScriptSignal RBXScriptSignal -- Existing RBXScriptSignal to wrap
	@return Signal

	For example:
	```lua
	local signal = Signal.Wrap(workspace.ChildAdded)
	signal:Connect(function(part) print(part.Name .. " added") end)
	Instance.new("Part").Parent = workspace
	```
]=]
function Signal.Wrap<T...>(rbxScriptSignal: RBXScriptSignal): Signal<T...>
	assert(
		typeof(rbxScriptSignal) == "RBXScriptSignal",
		"Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(rbxScriptSignal)
	)

	local signal = Signal.new()
	signal._proxyHandler = rbxScriptSignal:Connect(function(...)
		signal:Fire(...)
	end)

	return signal
end

--[=[
	Checks if the given object is a Signal.

	@param obj any -- Object to check
	@return boolean -- `true` if the object is a Signal.
]=]
function Signal.Is(obj: any): boolean
	return type(obj) == "table" and getmetatable(obj) == Signal
end

--[=[
	@param fn ConnectionFn
	@return SignalConnection

	Connects a function to the signal, which will be called anytime the signal is fired.
	```lua
	signal:Connect(function(msg, num)
		print(msg, num)
	end)

	signal:Fire("Hello", 25)
	```
]=]
function Signal:Connect(fn)
	local connection = setmetatable({
		Connected = true,
		_signal = self,
		_fn = fn,
		_next = false,
	}, Connection)

	if self._handlerListHead then
		connection._next = self._handlerListHead
		self._handlerListHead = connection
	else
		self._handlerListHead = connection
	end

	return connection
end

--[=[
	@deprecated v1.3.0 -- Use `Signal:Once` instead.
	@param fn ConnectionFn
	@return SignalConnection
]=]
function Signal:ConnectOnce(fn)
	return self:Once(fn)
end

--[=[
	@param fn ConnectionFn
	@return SignalConnection

	Connects a function to the signal, which will be called the next time the signal fires. Once
	the connection is triggered, it will disconnect itself.
	```lua
	signal:Once(function(msg, num)
		print(msg, num)
	end)

	signal:Fire("Hello", 25)
	signal:Fire("This message will not go through", 10)
	```
]=]
function Signal:Once(fn)
	local connection
	local done = false

	connection = self:Connect(function(...)
		if done then
			return
		end

		done = true
		connection:Disconnect()
		fn(...)
	end)

	return connection
end

function Signal:GetConnections()
	local items = {}

	local item = self._handlerListHead
	while item do
		table.insert(items, item)
		item = item._next
	end

	return items
end

-- Disconnect all handlers. Since we use a linked list it suffices to clear the
-- reference to the head handler.
--[=[
	Disconnects all connections from the signal.
	```lua
	signal:DisconnectAll()
	```
]=]
function Signal:DisconnectAll()
	local item = self._handlerListHead
	while item do
		item.Connected = false
		item = item._next
	end
	self._handlerListHead = false

	local yieldedThreads = rawget(self, "_yieldedThreads")
	if yieldedThreads then
		for thread in yieldedThreads do
			if coroutine.status(thread) == "suspended" then
				warn(debug.traceback(thread, "signal disconnected; yielded thread cancelled", 2))
				task.cancel(thread)
			end
		end
		table.clear(self._yieldedThreads)
	end
end

-- Signal:Fire(...) implemented by running the handler functions on the
-- coRunnerThread, and any time the resulting thread yielded without returning
-- to us, that means that it yielded to the Roblox scheduler and has been taken
-- over by Roblox scheduling, meaning we have to make a new coroutine runner.
--[=[
	@param ... any

	Fire the signal, which will call all of the connected functions with the given arguments.
	```lua
	signal:Fire("Hello")

	-- Any number of arguments can be fired:
	signal:Fire("Hello", 32, {Test = "Test"}, true)
	```
]=]
function Signal:Fire(...)
	local item = self._handlerListHead
	while item do
		if item.Connected then
			if not freeRunnerThread then
				freeRunnerThread = coroutine.create(runEventHandlerInFreeThread)
			end
			task.spawn(freeRunnerThread, item._fn, ...)
		end
		item = item._next
	end
end

--[=[
	@param ... any

	Same as `Fire`, but uses `task.defer` internally & doesn't take advantage of thread reuse.
	```lua
	signal:FireDeferred("Hello")
	```
]=]
function Signal:FireDeferred(...)
	local item = self._handlerListHead
	while item do
		local conn = item
		task.defer(function(...)
			if conn.Connected then
				conn._fn(...)
			end
		end, ...)
		item = item._next
	end
end

--[=[
	@return ... any
	@yields

	Yields the current thread until the signal is fired, and returns the arguments fired from the signal.
	Yielding the current thread is not always desirable. If the desire is to only capture the next event
	fired, using `Once` might be a better solution.
	```lua
	task.spawn(function()
		local msg, num = signal:Wait()
		print(msg, num) --> "Hello", 32
	end)
	signal:Fire("Hello", 32)
	```
]=]
function Signal:Wait()
	local yieldedThreads = rawget(self, "_yieldedThreads")
	if not yieldedThreads then
		yieldedThreads = {}
		rawset(self, "_yieldedThreads", yieldedThreads)
	end

	local thread = coroutine.running()
	yieldedThreads[thread] = true

	self:Once(function(...)
		yieldedThreads[thread] = nil

		if coroutine.status(thread) == "suspended" then
			task.spawn(thread, ...)
		end
	end)

	return coroutine.yield()
end

--[=[
	Cleans up the signal.

	Technically, this is only necessary if the signal is created using
	`Signal.Wrap`. Connections should be properly GC'd once the signal
	is no longer referenced anywhere. However, it is still good practice
	to include ways to strictly clean up resources. Calling `Destroy`
	on a signal will also disconnect all connections immediately.
	```lua
	signal:Destroy()
	```
]=]
function Signal:Destroy()
	self:DisconnectAll()

	local proxyHandler = rawget(self, "_proxyHandler")
	if proxyHandler then
		proxyHandler:Disconnect()
	end
end

-- Make signal strict
setmetatable(Signal, {
	__index = function(_tb, key)
		error(("Attempt to get Signal::%s (not a valid member)"):format(tostring(key)), 2)
	end,
	__newindex = function(_tb, key, _value)
		error(("Attempt to set Signal::%s (not a valid member)"):format(tostring(key)), 2)
	end,
})

return table.freeze({
	new = Signal.new,
	Wrap = Signal.Wrap,
	Is = Signal.Is,
})

end)() end,
    [69] = function()local wax,script,require=ImportGlobals(69)local ImportGlobals return (function(...)local ServerScriptService = game:GetService("ServerScriptService")

local Test = require(ServerScriptService.TestRunner.Test)

local function AwaitCondition(predicate: () -> boolean, timeout: number?)
	local start = os.clock()
	timeout = (timeout or 10)
	while true do
		if predicate() then
			return true
		end
		if (os.clock() - start) > timeout then
			return false
		end
		task.wait()
	end
end

return function(ctx: Test.TestContext)
	local Signal = require(script.Parent)

	local signal

	local function NumConns(sig)
		sig = sig or signal
		return #sig:GetConnections()
	end

	ctx:BeforeEach(function()
		signal = Signal.new()
	end)

	ctx:AfterEach(function()
		signal:Destroy()
	end)

	ctx:Describe("Constructor", function()
		ctx:Test("should create a new signal and fire it", function()
			ctx:Expect(Signal.Is(signal)):ToBe(true)
			task.defer(function()
				signal:Fire(10, 20)
			end)
			local n1, n2 = signal:Wait()
			ctx:Expect(n1):ToBe(10)
			ctx:Expect(n2):ToBe(20)
		end)

		ctx:Test("should create a proxy signal and connect to it", function()
			local signalWrap = Signal.Wrap(game:GetService("RunService").Heartbeat)
			ctx:Expect(Signal.Is(signalWrap)):ToBe(true)
			local fired = false
			signalWrap:Connect(function()
				fired = true
			end)
			ctx:Expect(AwaitCondition(function()
				return fired
			end, 2)):ToBe(true)
			signalWrap:Destroy()
		end)
	end)

	ctx:Describe("FireDeferred", function()
		ctx:Test("should be able to fire primitive argument", function()
			local send = 10
			local value
			signal:Connect(function(v)
				value = v
			end)
			signal:FireDeferred(send)
			ctx:Expect(AwaitCondition(function()
				return (send == value)
			end, 1)):ToBe(true)
		end)

		ctx:Test("should be able to fire a reference based argument", function()
			local send = { 10, 20 }
			local value
			signal:Connect(function(v)
				value = v
			end)
			signal:FireDeferred(send)
			ctx:Expect(AwaitCondition(function()
				return (send == value)
			end, 1)):ToBe(true)
		end)
	end)

	ctx:Describe("Fire", function()
		ctx:Test("should be able to fire primitive argument", function()
			local send = 10
			local value
			signal:Connect(function(v)
				value = v
			end)
			signal:Fire(send)
			ctx:Expect(value):ToBe(send)
		end)

		ctx:Test("should be able to fire a reference based argument", function()
			local send = { 10, 20 }
			local value
			signal:Connect(function(v)
				value = v
			end)
			signal:Fire(send)
			ctx:Expect(value):ToBe(send)
		end)
	end)

	ctx:Describe("ConnectOnce", function()
		ctx:Test("should only capture first fire", function()
			local value
			local c = signal:ConnectOnce(function(v)
				value = v
			end)
			ctx:Expect(c.Connected):ToBe(true)
			signal:Fire(10)
			ctx:Expect(c.Connected):ToBe(false)
			signal:Fire(20)
			ctx:Expect(value):ToBe(10)
		end)
	end)

	ctx:Describe("Wait", function()
		ctx:Test("should be able to wait for a signal to fire", function()
			task.defer(function()
				signal:Fire(10, 20, 30)
			end)
			local n1, n2, n3 = signal:Wait()
			ctx:Expect(n1):ToBe(10)
			ctx:Expect(n2):ToBe(20)
			ctx:Expect(n3):ToBe(30)
		end)
	end)

	ctx:Describe("DisconnectAll", function()
		ctx:Test("should disconnect all connections", function()
			signal:Connect(function() end)
			signal:Connect(function() end)
			ctx:Expect(NumConns()):ToBe(2)
			signal:DisconnectAll()
			ctx:Expect(NumConns()):ToBe(0)
		end)
	end)

	ctx:Describe("Disconnect", function()
		ctx:Test("should disconnect connection", function()
			local con = signal:Connect(function() end)
			ctx:Expect(NumConns()):ToBe(1)
			con:Disconnect()
			ctx:Expect(NumConns()):ToBe(0)
		end)

		ctx:Test("should still work if connections disconnected while firing", function()
			local a = 0
			local c
			signal:Connect(function()
				a += 1
			end)
			c = signal:Connect(function()
				c:Disconnect()
				a += 1
			end)
			signal:Connect(function()
				a += 1
			end)
			signal:Fire()
			ctx:Expect(a):ToBe(3)
		end)

		ctx:Test("should still work if connections disconnected while firing deferred", function()
			local a = 0
			local c
			signal:Connect(function()
				a += 1
			end)
			c = signal:Connect(function()
				c:Disconnect()
				a += 1
			end)
			signal:Connect(function()
				a += 1
			end)
			signal:FireDeferred()
			ctx:Expect(AwaitCondition(function()
				return a == 3
			end)):ToBe(true)
		end)
	end)
end

end)() end,
    [70] = function()local wax,script,require=ImportGlobals(70)local ImportGlobals return (function(...)return {
	package = {
		authors = {"Stephen Leitnick"},
		description = "Signal class",
		exclude = {"node_modules", "package.json", "**/*.ts"},
		license = "MIT",
		name = "sleitnick/signal",
		realm = "shared",
		registry = "https://github.com/UpliftGames/wally-index",
		version = "2.0.3",
	},
}
end)() end,
    [72] = function()local wax,script,require=ImportGlobals(72)local ImportGlobals return (function(...)--!strict

local RunService = game:GetService("RunService")

export type Trove = {
	Extend: (self: Trove) -> Trove,
	Clone: <T>(self: Trove, instance: T & Instance) -> T,
	Construct: <T, A...>(self: Trove, class: Constructable<T, A...>, A...) -> T,
	Connect: (
		self: Trove,
		signal: SignalLike | SignalLikeMetatable | RBXScriptSignal,
		fn: (...any) -> ...any
	) -> ConnectionLike | ConnectionLikeMetatable,
	BindToRenderStep: (self: Trove, name: string, priority: number, fn: (dt: number) -> ()) -> (),
	AddPromise: <T>(self: Trove, promise: (T & PromiseLike) | (T & PromiseLikeMetatable)) -> T,
	Add: <T>(self: Trove, object: T & Trackable, cleanupMethod: string?) -> T,
	Remove: <T>(self: Trove, object: T & Trackable) -> boolean,
	Pop: <T>(self: Trove, object: T & Trackable) -> boolean,
	Clean: (self: Trove) -> (),
	WrapClean: (self: Trove) -> () -> (),
	AttachToInstance: (self: Trove, instance: Instance) -> RBXScriptConnection,
	Destroy: (self: Trove) -> (),
}

type TroveInternal = Trove & {
	_objects: { any },
	_cleaning: boolean,
	_findAndRemoveFromObjects: (self: TroveInternal, object: any, cleanup: boolean) -> boolean,
	_cleanupObject: (self: TroveInternal, object: any, cleanupMethod: string?) -> (),
}

--[=[
	@within Trove
	@type Trackable Instance | RBXScriptConnection | ConnectionLike | ConnectLikeMetatable | PromiseLike | PromiseLikeMetatable | thread | ((...any) -> ...any) | Destroyable | DestroyableMetatable | DestroyableLowercase | DestroyableLowercaseMetatable | Disconnectable | DisconnectableMetatable | DisconnectableLowercase | DisconnectableLowercaseMetatable | SignalLike | SignalLikeMetatable
	Represents all trackable objects by Trove.
]=]
export type Trackable =
	| Instance
	| RBXScriptConnection
	| ConnectionLike
	| ConnectionLikeMetatable
	| PromiseLike
	| PromiseLikeMetatable
	| thread
	| ((...any) -> ...any)
	| Destroyable
	| DestroyableMetatable
	| DestroyableLowercase
	| DestroyableLowercaseMetatable
	| Disconnectable
	| DisconectableMetatable
	| DisconnectableLowercase
	| DisconnectableLowercaseMetatable
	| SignalLike
	| SignalLikeMetatable

--[=[
	@within Trove
	@interface ConnectionLike
	.Connected boolean
	.Disconnect (self) -> ()
]=]
type ConnectionLike = {
	Connected: boolean,
	Disconnect: (self: ConnectionLike) -> (),
}

--[=[
	@within Trove
	@interface ConnectionLikeMetatable
	.Connected boolean
	.Disconnect (self) -> ()
	@tag Metatable
]=]
type ConnectionLikeMetatable = typeof(setmetatable(
	{},
	{} :: { Connected: boolean, Disconnect: (self: ConnectionLikeMetatable) -> () }
))

--[=[
	@within Trove
	@interface SignalLike
	.Connect (self, callback: (...any) -> ...any) -> ConnectionLike
	.Once (self, callback: (...any) -> ...any) -> ConnectionLike
]=]
type SignalLike = {
	Connect: (self: SignalLike, callback: (...any) -> ...any) -> ConnectionLike | ConnectionLikeMetatable,
	Once: (self: SignalLike, callback: (...any) -> ...any) -> ConnectionLike | ConnectionLikeMetatable,
}

--[=[
	@within Trove
	@interface SignalLikeMetatable
	.Connect (self, callback: (...any) -> ...any) -> ConnectionLike
	.Once (self, callback: (...any) -> ...any) -> ConnectionLike
	@tag Metatable
]=]
type SignalLikeMetatable = typeof(setmetatable(
	{},
	{} :: {
		Connect: (self: SignalLikeMetatable, callback: (...any) -> ...any) -> ConnectionLike | ConnectionLikeMetatable,
		Once: (self: SignalLikeMetatable, callback: (...any) -> ...any) -> ConnectionLike | ConnectionLikeMetatable,
	}
))

--[=[
	@within Trove
	@interface PromiseLike
	.getStatus (self) -> string
	.finally (self, callback: (...any) -> ...any) -> PromiseLike
	.cancel (self) -> ()
]=]
type PromiseLike = {
	getStatus: (self: PromiseLike) -> string,
	finally: (self: PromiseLike, callback: (...any) -> ...any) -> PromiseLike | PromiseLikeMetatable,
	cancel: (self: PromiseLike) -> (),
}

--[=[
	@within Trove
	@interface PromiseLikeMetatable
	.getStatus (self) -> string
	.finally (self, callback: (...any) -> ...any) -> PromiseLike
	.cancel (self) -> ()
	@tag Metatable
]=]
type PromiseLikeMetatable = typeof(setmetatable(
	{},
	{} :: {
		getStatus: (self: any) -> string,
		finally: (self: PromiseLikeMetatable, callback: (...any) -> ...any) -> PromiseLike | PromiseLikeMetatable,
		cancel: (self: PromiseLikeMetatable) -> (),
	}
))

--[=[
	@within Trove
	@type Constructable { new: (A...) -> T } | (A...) -> T
]=]
type Constructable<T, A...> = { new: (A...) -> T } | (A...) -> T

--[=[
	@within Trove
	@interface Destroyable
	.Destroy (self) -> ()
]=]
type Destroyable = {
	Destroy: (self: Destroyable) -> (),
}

--[=[
	@within Trove
	@interface DestroyableMetatable
	.Destroy (self) -> ()
	@tag Metatable
]=]
type DestroyableMetatable = typeof(setmetatable({}, {} :: { Destroy: (self: DestroyableMetatable) -> () }))

--[=[
	@within Trove
	@interface DestroyableLowercase
	.destroy (self) -> ()
]=]
type DestroyableLowercase = {
	destroy: (self: DestroyableLowercase) -> (),
}

--[=[
	@within Trove
	@interface DestroyableLowercaseMetatable
	.destroy (self) -> ()
	@tag Metatable
]=]
type DestroyableLowercaseMetatable = typeof(setmetatable(
	{},
	{} :: { destroy: (self: DestroyableLowercaseMetatable) -> () }
))

--[=[
	@within Trove
	@interface Disconnectable
	.Disconnect (self) -> ()
]=]
type Disconnectable = {
	Disconnect: (self: Disconnectable) -> (),
}

--[=[
	@within Trove
	@interface DisconectableMetatable
	.Disconnect (self) -> ()
	@tag Metatable
]=]
type DisconectableMetatable = typeof(setmetatable({}, {} :: { Disconnect: (self: DisconectableMetatable) -> () }))

--[=[
	@within Trove
	@interface DisconnectableLowercase
	.disconnect (self) -> ()
]=]
type DisconnectableLowercase = {
	disconnect: (self: DisconnectableLowercase) -> (),
}

--[=[
	@within Trove
	@interface DisconnectableLowercaseMetatable
	.disconnect (self) -> ()
	@tag Metatable
]=]
type DisconnectableLowercaseMetatable = typeof(setmetatable(
	{},
	{} :: { disconnect: (self: DisconnectableLowercaseMetatable) -> () }
))

local FN_MARKER = newproxy()
local THREAD_MARKER = newproxy()
local GENERIC_OBJECT_CLEANUP_METHODS = table.freeze({ "Destroy", "Disconnect", "destroy", "disconnect" })

local function getObjectCleanupFunction(object: any, cleanupMethod: string?)
	local t = typeof(object)

	if t == "function" then
		return FN_MARKER
	elseif t == "thread" then
		return THREAD_MARKER
	end

	if cleanupMethod then
		return cleanupMethod
	end

	if t == "Instance" then
		return "Destroy"
	elseif t == "RBXScriptConnection" then
		return "Disconnect"
	elseif t == "table" then
		for _, genericCleanupMethod in GENERIC_OBJECT_CLEANUP_METHODS do
			if typeof(object[genericCleanupMethod]) == "function" then
				return genericCleanupMethod
			end
		end
	end

	error(`failed to get cleanup function for object {t}: {object}`, 3)
end

local function assertPromiseLike(object: any)
	if
		typeof(object) ~= "table"
		or typeof(object.getStatus) ~= "function"
		or typeof(object.finally) ~= "function"
		or typeof(object.cancel) ~= "function"
	then
		error("did not receive a promise as an argument", 3)
	end
end

local function assertSignalLike(object: any)
	if
		typeof(object) ~= "RBXScriptSignal"
		and (typeof(object) ~= "table" or typeof(object.Connect) ~= "function" or typeof(object.Once) ~= "function")
	then
		error("did not receive a signal as an argument", 3)
	end
end

--[=[
	@class Trove
	A Trove is helpful for tracking any sort of object during
	runtime that needs to get cleaned up at some point.
]=]
local Trove = {}
Trove.__index = Trove

--[=[
	@return Trove
	Constructs a Trove object.

	```lua
	local trove = Trove.new()
	```
]=]
function Trove.new(): Trove
	local self = setmetatable({}, Trove)

	self._objects = {}
	self._cleaning = false

	return (self :: any) :: Trove
end

--[=[
	@method Add
	@within Trove
	@param object any -- Object to track
	@param cleanupMethod string? -- Optional cleanup name override
	@return object: any
	Adds an object to the trove. Once the trove is cleaned or
	destroyed, the object will also be cleaned up.

	The following types are accepted (e.g. `typeof(object)`):

	| Type | Cleanup |
	| ---- | ------- |
	| `Instance` | `object:Destroy()` |
	| `RBXScriptConnection` | `object:Disconnect()` |
	| `function` | `object()` |
	| `thread` | `task.cancel(object)` |
	| `table` | `object:Destroy()` _or_ `object:Disconnect()` _or_ `object:destroy()` _or_ `object:disconnect()` |
	| `table` with `cleanupMethod` | `object:<cleanupMethod>()` |

	Returns the object added.

	```lua
	-- Add a part to the trove, then destroy the trove,
	-- which will also destroy the part:
	local part = Instance.new("Part")
	trove:Add(part)
	trove:Destroy()

	-- Add a function to the trove:
	trove:Add(function()
		print("Cleanup!")
	end)
	trove:Destroy()

	-- Standard cleanup from table:
	local tbl = {}
	function tbl:Destroy()
		print("Cleanup")
	end
	trove:Add(tbl)

	-- Custom cleanup from table:
	local tbl = {}
	function tbl:DoSomething()
		print("Do something on cleanup")
	end
	trove:Add(tbl, "DoSomething")
	```
]=]
function Trove.Add(self: TroveInternal, object: Trackable, cleanupMethod: string?): any
	if self._cleaning then
		error("cannot call trove:Add() while cleaning", 2)
	end

	local cleanup = getObjectCleanupFunction(object, cleanupMethod)
	table.insert(self._objects, { object, cleanup })

	return object
end

--[=[
	@method Clone
	@within Trove
	@return Instance
	Clones the given instance and adds it to the trove. Shorthand for
	`trove:Add(instance:Clone())`.

	```lua
	local clonedPart = trove:Clone(somePart)
	```
]=]
function Trove.Clone(self: TroveInternal, instance: Instance): Instance
	if self._cleaning then
		error("cannot call trove:Clone() while cleaning", 2)
	end

	return self:Add(instance:Clone())
end

--[=[
	@method Construct
	@within Trove
	@param class { new(Args...) -> T } | (Args...) -> T
	@param ... Args...
	@return T
	Constructs a new object from either the
	table or function given.

	If a table is given, the table's `new`
	function will be called with the given
	arguments.

	If a function is given, the function will
	be called with the given arguments.

	The result from either of the two options
	will be added to the trove.

	This is shorthand for `trove:Add(SomeClass.new(...))`
	and `trove:Add(SomeFunction(...))`.

	```lua
	local Signal = require(somewhere.Signal)

	-- All of these are identical:
	local s = trove:Construct(Signal)
	local s = trove:Construct(Signal.new)
	local s = trove:Construct(function() return Signal.new() end)
	local s = trove:Add(Signal.new())

	-- Even Roblox instances can be created:
	local part = trove:Construct(Instance, "Part")
	```
]=]
function Trove.Construct<T, A...>(self: TroveInternal, class: Constructable<T, A...>, ...: A...)
	if self._cleaning then
		error("Cannot call trove:Construct() while cleaning", 2)
	end

	local object = nil
	local t = type(class)
	if t == "table" then
		object = (class :: any).new(...)
	elseif t == "function" then
		object = (class :: any)(...)
	end

	return self:Add(object)
end

--[=[
	@method Connect
	@within Trove
	@param signal RBXScriptSignal
	@param fn (...: any) -> ()
	@return RBXScriptConnection
	Connects the function to the signal, adds the connection
	to the trove, and then returns the connection.

	This is shorthand for `trove:Add(signal:Connect(fn))`.

	```lua
	trove:Connect(workspace.ChildAdded, function(instance)
		print(instance.Name .. " added to workspace")
	end)
	```
]=]
function Trove.Connect(
	self: TroveInternal,
	signal: SignalLike | SignalLikeMetatable | RBXScriptSignal,
	fn: (...any) -> ...any
)
	if self._cleaning then
		error("Cannot call trove:Connect() while cleaning", 2)
	end
	assertSignalLike(signal)

	local confirmedSignal = signal :: SignalLike

	return self:Add(confirmedSignal:Connect(fn))
end

--[=[
	@method Once
	@within Trove
	@param signal RBXScriptSignal
	@param fn (...: any) -> ()
	@return RBXScriptConnection
	Connects the function to the signal using the `Once`
	method, adds the connection to the trove, and then
	returns the connection.

	This is shorthand for `trove:Add(signal:Once(fn))`.

	```lua
	trove:Connect(workspace.ChildAdded, function(instance)
		print(instance.Name .. " added to workspace")
	end)
	```
]=]
function Trove.Once(
	self: TroveInternal,
	signal: SignalLike | SignalLikeMetatable | RBXScriptSignal,
	fn: (...any) -> ...any
)
	if self._cleaning then
		error("Cannot call trove:Connect() while cleaning", 2)
	end
	assertSignalLike(signal)

	local confirmedSignal = signal :: SignalLike

	local conn
	conn = confirmedSignal:Once(function(...)
		fn(...)
		self:Pop(conn)
	end)

	return self:Add(conn)
end

--[=[
	@method BindToRenderStep
	@within Trove
	@param name string
	@param priority number
	@param fn (dt: number) -> ()
	Calls `RunService:BindToRenderStep` and registers a function in the
	trove that will call `RunService:UnbindFromRenderStep` on cleanup.

	```lua
	trove:BindToRenderStep("Test", Enum.RenderPriority.Last.Value, function(dt)
		-- Do something
	end)
	```
]=]
function Trove.BindToRenderStep(self: TroveInternal, name: string, priority: number, fn: (dt: number) -> ())
	if self._cleaning then
		error("cannot call trove:BindToRenderStep() while cleaning", 2)
	end

	RunService:BindToRenderStep(name, priority, fn)

	self:Add(function()
		RunService:UnbindFromRenderStep(name)
	end)
end

--[=[
	@method AddPromise
	@within Trove
	@param promise Promise
	@return Promise
	Gives the promise to the trove, which will cancel the promise if the trove is cleaned up or if the promise
	is removed. The exact promise is returned, thus allowing chaining.

	```lua
	trove:AddPromise(doSomethingThatReturnsAPromise())
		:andThen(function()
			print("Done")
		end)
	-- Will cancel the above promise (assuming it didn't resolve immediately)
	trove:Clean()

	local p = trove:AddPromise(doSomethingThatReturnsAPromise())
	-- Will also cancel the promise
	trove:Remove(p)
	```

	:::caution Promise v4 Only
	This is only compatible with the [roblox-lua-promise](https://eryn.io/roblox-lua-promise/) library, version 4.
	:::
]=]
function Trove.AddPromise(self: TroveInternal, promise: PromiseLike | PromiseLikeMetatable)
	if self._cleaning then
		error("cannot call trove:AddPromise() while cleaning", 2)
	end
	assertPromiseLike(promise)
	local confirmedPromise = promise :: PromiseLike

	if confirmedPromise:getStatus() == "Started" then
		confirmedPromise:finally(function()
			if self._cleaning then
				return
			end
			self:_findAndRemoveFromObjects(confirmedPromise, false)
		end)

		self:Add(confirmedPromise, "cancel")
	end

	return confirmedPromise
end

--[=[
	@method Remove
	@within Trove
	@param object any
	Removes the object from the Trove and cleans it up. To remove without
	cleaning, use the `Pop` method instead.

	```lua
	local part = Instance.new("Part")
	trove:Add(part)
	trove:Remove(part) -- Part is destroyed
	```
]=]
function Trove.Remove(self: TroveInternal, object: Trackable): boolean
	if self._cleaning then
		error("cannot call trove:Remove() while cleaning", 2)
	end

	return self:_findAndRemoveFromObjects(object, true)
end

--[=[
	@method Pop
	@within Trove
	@param object any
	Removes the object from the Trove, but does _not_ clean it up. To
	clean up the object on removal, use the `Remove` method instead.

	```lua
	local part = Instance.new("Part")
	trove:Add(part)
	trove:Pop(part)
	trove:Clean() -- Part is NOT destroyed
	```
]=]
function Trove.Pop(self: TroveInternal, object: Trackable): boolean
	if self._cleaning then
		error("cannot call trove:Pop() while cleaning", 2)
	end

	return self:_findAndRemoveFromObjects(object, false)
end

--[=[
	@method Extend
	@within Trove
	@return Trove
	Creates and adds another trove to itself. This is just shorthand
	for `trove:Construct(Trove)`. This is useful for contexts where
	the trove object is present, but the class itself isn't.

	:::note
	This does _not_ clone the trove. In other words, the objects in the
	trove are not given to the new constructed trove. This is simply to
	construct a new Trove and add it as an object to track.
	:::

	```lua
	local trove = Trove.new()
	local subTrove = trove:Extend()

	trove:Clean() -- Cleans up the subTrove too
	```
]=]
function Trove.Extend(self: TroveInternal)
	if self._cleaning then
		error("cannot call trove:Extend() while cleaning", 2)
	end

	return self:Construct(Trove)
end

--[=[
	@method Clean
	@within Trove
	Cleans up all objects in the trove. This is
	similar to calling `Remove` on each object
	within the trove. The ordering of the objects
	removed is _not_ guaranteed.

	```lua
	trove:Clean()
	```
]=]
function Trove.Clean(self: TroveInternal)
	if self._cleaning then
		return
	end

	self._cleaning = true

	for _, obj in self._objects do
		self:_cleanupObject(obj[1], obj[2])
	end

	table.clear(self._objects)
	self._cleaning = false
end

--[=[
	@method WrapClean
	@within Trove
	Returns a function that wraps the trove's `Clean()`
	method. Calling the returned function will clean up
	the trove.

	This is often useful in contexts where functions
	are the primary mode for cleaning up an environment,
	such as in many "observer" patterns.

	```lua
	local cleanup = trove:WrapClean()

	-- Sometime later...
	cleanup()
	```

	```lua
	-- Common observer pattern example:
	someObserver(function()
		local trove = Trove.new()
		-- Foo
		return trove:WrapClean()
	end)
	```
]=]
function Trove.WrapClean(self: TroveInternal)
	return function()
		self:Clean()
	end
end

function Trove._findAndRemoveFromObjects(self: TroveInternal, object: any, cleanup: boolean): boolean
	local objects = self._objects

	for i, obj in objects do
		if obj[1] == object then
			local n = #objects
			objects[i] = objects[n]
			objects[n] = nil

			if cleanup then
				self:_cleanupObject(obj[1], obj[2])
			end

			return true
		end
	end

	return false
end

function Trove._cleanupObject(_self: TroveInternal, object: any, cleanupMethod: string?)
	if cleanupMethod == FN_MARKER then
		task.spawn(object)
	elseif cleanupMethod == THREAD_MARKER then
		pcall(task.cancel, object)
	else
		object[cleanupMethod](object)
	end
end

--[=[
	@method AttachToInstance
	@within Trove
	@param instance Instance
	@return RBXScriptConnection
	Attaches the trove to a Roblox instance. Once this
	instance is removed from the game (parent or ancestor's
	parent set to `nil`), the trove will automatically
	clean up.

	This inverses the ownership of the Trove object, and should
	only be used when necessary. In other words, the attached
	instance dictates when the trove is cleaned up, rather than
	the trove dictating the cleanup of the instance.

	:::caution
	Will throw an error if `instance` is not a descendant
	of the game hierarchy.
	:::

	```lua
	trove:AttachToInstance(somePart)
	trove:Add(function()
		print("Cleaned")
	end)

	-- Destroying the part will cause the trove to clean up, thus "Cleaned" printed:
	somePart:Destroy()
	```
]=]
function Trove.AttachToInstance(self: TroveInternal, instance: Instance)
	if self._cleaning then
		error("cannot call trove:AttachToInstance() while cleaning", 2)
	elseif not instance:IsDescendantOf(game) then
		error("instance is not a descendant of the game hierarchy", 2)
	end

	return self:Connect(instance.Destroying, function()
		self:Destroy()
	end)
end

--[=[
	@method Destroy
	@within Trove
	Alias for `trove:Clean()`.

	```lua
	trove:Destroy()
	```
]=]
function Trove.Destroy(self: TroveInternal)
	self:Clean()
end

return {
	new = Trove.new,
}

end)() end,
    [75] = function()local wax,script,require=ImportGlobals(75)local ImportGlobals return (function(...)-- made by samet (joestar._3 on discord)
-- https://discord.gg/VhvTd5HV8d
-- example at bottom

if getgenv().Library then
    getgenv().Library:Unload()
end

local Library do 
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local MathClamp = math.clamp
    local MathFloor = math.floor

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLen = string.len
    local StringSub = string.sub

    local InstanceNew = Instance.new

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.Z), 

        Flags = { },

        Tween = {
            Time = 0.4,
            Style = Enum.EasingStyle.Quint,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "esdeeeeee",
            Configs = "esdeeeeee/Configs",
            Assets = "esdeeeeee/Assets",
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,

        Font = nil
    }

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

    local Themes = {
        ["Preset"] = {
            ["Background"] = FromRGB(16, 18, 18),
            ["Inline"] = FromRGB(21, 24, 24),
            ["Element"] = FromRGB(30, 34, 34),
            ["Accent"] = FromRGB(255, 255, 255),
            ["Border"] = FromRGB(30, 34, 34),
            ["Border 2"] = FromRGB(56, 62, 62)
        }
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    Library.Theme = TableClone(Themes["Preset"])

    -- Folders
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 

            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            local Parent
            for Property, Value in NewItem.Properties do
                if Property == "Parent" then
                    Parent = Value
                else
                    NewItem.Instance[Property] = Value
                end
            end
            if Parent then
                NewItem.Instance.Parent = Parent
            end

            return NewItem
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
            end

            local InputChanged

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
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

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            local ResizeButton = Instances:Create("ImageButton", {
				Parent = Gui,
                Image = Library:GetAsset("move") or "",
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 8, 0, 8),
				Position = UDim2New(1, -4, 1, -4),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
                ZIndex = 5,
				AutoButtonColor = false,
                Visible = true,
			})  ResizeButton:AddToTheme({ImageColor3 = "Accent"})

            local InputChanged

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then

                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)

                    if InputChanged then 
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Resizing = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

                        Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                        Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

                        Tween:Create(Gui, TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Delta}, true)
                    end
                end
            end)

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then 
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(`{Library.Folders.Fonts}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Folders.Fonts}/{Name}.font`), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end

        Library.Font = CustomFont:New("InterSemiBold", "Regular", "Normal", {
            Id = "Inter",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf"
        })
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Size = UDim2New(0, 0, 1, 0),
        BorderColor3 = FromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    
    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        Padding = UDimNew(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    Instances:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        PaddingTop = UDimNew(0, 12),
        PaddingBottom = UDimNew(0, 12),
        PaddingRight = UDimNew(0, 12),
        PaddingLeft = UDimNew(0, 12)
    })

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil 
        getgenv().Library = nil
    end

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
	end

    Library.GetConfig = function(self)
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

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
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

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(Library.Folders.Configs, Library.Folders.Directory .. "/", "")

        for Index, Value in listfiles(Library.Folders.Configs) do
            local FileName = StringGSub(Value, Library.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end

    Library.CompareVectors = function(self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end

    Library.IsClipped = function(self, Object, Column)
        local Parent = Column
        
        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize

        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize 

        return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
    end

    do
        Library.CreateColorpicker = function(self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Color = FromRGB(0, 0, 0),
                HexValue = "000000",

                Flag = Data.Flag,

                IsOpen = false
            }

            local Items = { } do
                Items["ColorpickerButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 14, 0, 14),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(164, 229, 255)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = FromRGB(56, 62, 62),
                    Thickness = 1.5
                }):AddToTheme({Color = "Border 2"})
                
                Instances:Create("UICorner", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Items["ColorpickerWindow"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    Position = UDim2New(0, 115, 0, 102),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 183, 0, 201),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 18)
                })  Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 6, 0, 6),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -12, 1, -12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UIStroke", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Palette"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "-,",
                    AutoButtonColor = false,
                    Position = UDim2New(0, 6, 0, 6),
                    Size = UDim2New(1, -12, 1, -40),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(164, 229, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["Saturation"] = Instances:Create("ImageLabel", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = Library:GetAsset("color-picker") or "",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Saturation"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Value"] = Instances:Create("ImageLabel", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 2, 1, 0),
                    Image = Library:GetAsset("shadow") or "",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, -1, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["PaletteDragger"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 3, 0, 3),
                    Position = UDim2New(0, 5, 0, 5),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(120, 120, 120),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                
                Items["Hue"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 6, 1, -6),
                    Size = UDim2New(1, -12, 0, 18),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Instances:Create("UIGradient", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
                })
                
                Items["HueDragger"] = Instances:Create("Frame", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 2, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})                
            end

            local Debounce = false
            local RenderStepped  

            function Colorpicker:Get()
                return Colorpicker.Color
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 

                if Colorpicker.IsOpen then 
                    Items["ColorpickerWindow"].Instance.Visible = true
                    Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X + 18, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y - 25)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if not Data.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker 
                else
                    if Library.OpenFrames[Colorpicker] then 
                        Library.OpenFrames[Colorpicker] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if not Value.ClassName:find("UI") then 
                        Value.ZIndex = Colorpicker.IsOpen and 4 or 1
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                    task.wait(0.2)
                    Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Colorpicker:Update()
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = FromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Library.Flags[Colorpicker.Flag] = {
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                }

                Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.98)
                local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.98)

                Items["PaletteDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 1)

                Colorpicker.Hue = ValueX

                local SlideX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 0.995)

                Items["HueDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 0)})
                Colorpicker:Update()
            end

            local ColorpickerInited = false
            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = FromRGB(Color[1], Color[2], Color[3])
                    Alpha = Color[4]
                elseif type(Color) == "string" then
                    Color = FromHex(Color)
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  

                local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.98)
                local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.98)
                local HuePositionX = MathClamp(Colorpicker.Hue, 0, 0.99)

                if ColorpickerInited then
                    Items["PaletteDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
                    Items["HueDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(HuePositionX, 0, 0, 0)})
                else
                    Items["PaletteDragger"].Instance.Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)
                    Items["HueDragger"].Instance.Position = UDim2New(HuePositionX, 0, 0, 0)
                    ColorpickerInited = true
                end
                Colorpicker:Update()
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
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
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
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

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Colorpicker.IsOpen then
                        if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                            return
                        end

                        Colorpicker:SetOpen(false)
                    end
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
                end
            end)

            Items["ColorpickerButton"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Colorpicker.IsOpen then
                    Colorpicker.IsOpen = not Library:IsClipped(Items["ColorpickerButton"].Instance, Data.Section.Items["Section"].Instance.Parent)
                    Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default)
            end

            Library.SetFlags[Colorpicker.Flag] = function(Color, Alpha)
                Colorpicker:Set(Color, Alpha)
            end

            return Colorpicker, Items 
        end

        Library.CreateKeybind = function(self, Data)
            local Keybind = {
                Flag = Data.Flag,

                Key = "",
                Value = "",
                Mode = "",
                Toggled = false,

                Picking = false,
                IsOpen = false
            }

            local Items = { } do
                Items["KeyButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "-",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["KeyButton"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 4),
                    PaddingLeft = UDimNew(0, 5)
                })                

                Items["KeybindWindow"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    Position = UDim2New(0, 231, 0, 102),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 67, 0, 92),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 18)
                })  Items["KeybindWindow"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 6, 0, 6),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -12, 1, -12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UIStroke", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Toggle",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 4)
                })
                
                Items["Hold"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Hold",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Always"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Always",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })                
            end

            local Modes = {
                ["Always"] = Items["Always"],
                ["Hold"] = Items["Hold"],
                ["Toggle"] = Items["Toggle"]
            }

            local Debounce = false
            local RenderStepped 

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Keybind.IsOpen = Bool

                Debounce = true 

                if Keybind.IsOpen then 
                    Items["KeybindWindow"].Instance.Visible = true
                    Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["KeybindWindow"].Instance.Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X + 18, 0, Items["KeyButton"].Instance.AbsolutePosition.Y - 25)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if not Data.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["KeybindWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if not Value.ClassName:find("UI") then 
                        Value.ZIndex = Keybind.IsOpen and 2 or 1
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                    task.wait(0.2)
                    Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Keybind:SetMode(Mode)
                for Index, Value in Modes do 
                    if Index == Mode then
                        Value:Tween(nil, {TextColor3 = FromRGB(255, 255, 255)})
                    else
                        Value:Tween(nil, {TextColor3 = FromRGB(100, 100, 100)})
                    end
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            function Keybind:Get()
                return Keybind.Key, Keybind.Mode, Keybind.Toggled
            end

            function Keybind:Set(Key)
                if StringFind(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                    local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode("Toggle")
                    end

                    local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                end

                Keybind.Picking = false
            end

            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 

                Items["KeyButton"].Instance.Text = "."
                Library:Thread(function()
                    local Count = 1

                    while true do 
                        if not Keybind.Picking then 
                            break
                        end

                        if Count == 4 then
                            Count = 1
                        end

                        Items["KeyButton"].Instance.Text = Count == 1 and "." or Count == 2 and ".." or Count == 3 and "..."
                        Count += 1
                        task.wait(0.35)
                    end
                end)

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

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            Items["KeyButton"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Keybind.IsOpen then
                    Keybind.IsOpen = not Library:IsClipped(Items["KeybindWindow"].Instance, Data.Section.Items["Section"].Instance.Parent)
                    Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                end
            end)

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Toggle"
                Keybind:SetMode("Toggle")
            end)

            Items["Hold"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Hold"
                Keybind:SetMode("Hold")
            end)

            Items["Always"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Always"
                Keybind:SetMode("Always")
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Keybind.Value == "None" then
                    return
                end

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

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Keybind.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                        return
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Keybind.Value == "None" then
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

            if Data.Default then 
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end

            Library.SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

        Library.Notification = function(self, Name, Duration, Icon)
            local Items = { } do 
                Items["Notification"] = Instances:Create("Frame", {
                    Parent = Library.NotifHolder.Instance,
                    Name = "\0",
                    Size = UDim2New(0, 0, 0, 30),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(16, 18, 18)
                })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["UIStroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })  Items["UIStroke"]:AddToTheme({Color = "Border"})
                
                Instances:Create("UIPadding", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                
                if Icon then
                    Items["Icon"] = Instances:Create("ImageLabel", {
                        Parent = Items["Notification"].Instance,
                        Name = "\0",
                        ImageColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0, 0.5),
                        Image = (type(Icon) == "string" and not Icon:find("^%d+$") and Library:GetAsset(Icon)) or ("rbxassetid://" .. tostring(Icon)),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 0, 0.5, 0),
                        Size = UDim2New(0, 16, 0, 16),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                end
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, Icon and 24 or 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  
            end

            local Size = Items["Notification"].Instance.AbsoluteSize

            for Index, Value in Items do 
                if Value.Instance:IsA("Frame") then
                    Value.Instance.BackgroundTransparency = 1
                elseif Value.Instance:IsA("TextLabel") then 
                    Value.Instance.TextTransparency = 1
                elseif Value.Instance:IsA("ImageLabel") then 
                    Value.Instance.ImageTransparency = 1
                elseif Value.Instance:IsA("UIStroke") then
                    Value.Instance.Transparency = 1
                end
            end 
            
            task.wait(0.3)

            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.Y

            Library:Thread(function()
                for Index, Value in Items do 
                    if Value.Instance:IsA("Frame") then
                        Value:Tween(nil, {BackgroundTransparency = 0})
                    elseif Value.Instance:IsA("TextLabel") then 
                        Value:Tween(nil, {TextTransparency = 0})
                    elseif Value.Instance:IsA("ImageLabel") then 
                        Value:Tween(nil, {ImageTransparency = 0.5})
                    elseif Value.Instance:IsA("UIStroke") then
                        Value:Tween(nil, {Transparency = 0})
                    end
                end

                Items["Notification"]:Tween(nil, {Size = UDim2New(0, Size.X, 0, Size.Y)})

                task.delay(Duration, function()
                    for Index, Value in Items do 
                        if Value.Instance:IsA("Frame") then
                            Value:Tween(nil, {BackgroundTransparency = 1})
                        elseif Value.Instance:IsA("TextLabel") then 
                            Value:Tween(nil, {TextTransparency = 1})
                        elseif Value.Instance:IsA("ImageLabel") then 
                            Value:Tween(nil, {ImageTransparency = 1})
                        elseif Value.Instance:IsA("UIStroke") then
                            Value:Tween(nil, {Transparency = 1})
                        end
                    end

                    Items["Notification"]:Tween(nil, {Size = UDim2New(0, 0, 0, 0)})
                    task.wait(0.5)
                    Items["Notification"]:Clean()
                end)
            end)
        end

        Library.Window = function(self, Data)
            local StartTime = tick()
            Data = Data or { }

            local Window = {
                Name = Data.Name or Data.name or "",
                SubTitle = Data.SubTitle or Data.subtitle or "",
                ExpiresIn = Data.ExpiresIn or Data.expiresin or "",
                Logo = Data.Logo or Data.logo or nil,
                
                Pages = { },
                Items = { },
                IsOpen = false
            }

            local Items = { } do
                local FirstLetterOfName = StringSub(Window.Name, 1, 1)
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 798, 0, 599),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 18)
                })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2New(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y), Vector2New(9999, 9999))
                
                Instances:Create("UICorner", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Side"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 215, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Title"] = Instances:Create("Frame", {
                    Parent = Items["Side"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 6, 0, 6),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -12, 0, 60),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Title"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 12, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 40, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Window.Logo and FromRGB(0, 0, 0) or FromRGB(207, 207, 207),
                    BackgroundTransparency = Window.Logo and 1 or 0
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Transparency = Window.Logo and 1 or 0
                }):AddToTheme({Color = "Border"})
                
                if Window.Logo then
                    -- Logo image
                    Items["LogoImage"] = Instances:Create("ImageLabel", {
                        Parent = Items["Title"].Instance,
                        Name = "\0",
                        Image = Window.Logo,
                        ImageColor3 = FromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 12, 0.5, 0),
                        Size = UDim2New(0, 40, 0, 40),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        ScaleType = Enum.ScaleType.Fit,
                    })
                    Items["Text"] = Instances:Create("TextLabel", {
                        Parent = Items["Background"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = "",
                        AnchorPoint = Vector2New(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0.5, 0, 0.5, 0),
                        Size = UDim2New(1, -10, 1, -10),
                        BorderSizePixel = 0,
                        TextSize = 22,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                else
                    Items["Text"] = Instances:Create("TextLabel", {
                        Parent = Items["Background"].Instance,
                        Name = "\0",
                        FontFace = Library.Font,
                        TextColor3 = FromRGB(0, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = FirstLetterOfName,
                        AnchorPoint = Vector2New(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0.5, 0, 0.5, 0),
                        Size = UDim2New(1, -10, 1, -10),
                        BorderSizePixel = 0,
                        TextSize = 22,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                end
                
                Items["RealTitle"] = Instances:Create("TextLabel", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Window.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 65, 0, 14),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    Visible = Window.Name ~= ""
                })  
                
                Items["Game"] = Instances:Create("TextLabel", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Visible = Window.SubTitle ~= "",
                    Text = Window.SubTitle,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 65, 0, 30),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Pages"] = Instances:Create("Frame", {
                    Parent = Items["Side"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 75),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, -80),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 8)
                })                

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 220, 0, 6),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -226, 1, -12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Content"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})          
                
                Items["Bottom_"] = Instances:Create("Frame", {
                    Parent = Items["Side"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 6, 1, -6),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -12, 0, 45),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Bottom_"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Bottom_"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Bottom_"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["SubExpires"] = Instances:Create("TextLabel", {
                    Parent = Items["Bottom_"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = "Sub expires in "..Window.ExpiresIn,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0, 8),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["SessionDuration"] = Instances:Create("TextLabel", {
                    Parent = Items["Bottom_"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Session duration: ",
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0, 23),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })                

                Library:Thread(function()
                    while task.wait(1) do
                        local SecondsPassed = MathFloor(tick() - StartTime)
                        local MinutesPassed = MathFloor(SecondsPassed / 60)

                        if MinutesPassed > 0 then
                            SecondsPassed = SecondsPassed - MinutesPassed * 60
                        end

                        Items["SessionDuration"].Instance.Text = "Session duration: "..MinutesPassed..":"..SecondsPassed
                    end
                end)

                Window.Items = Items
            end
            
            local Debounce = false

            function Window:SetCenter()
                local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
                task.wait()
                Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)

                Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
            end

            function Window:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Window.IsOpen = Bool

                Debounce = true 

                if Window.IsOpen then 
                    Items["MainFrame"].Instance.Visible = true 
                end

                local Descendants = Items["MainFrame"].Instance:GetDescendants()
                TableInsert(Descendants, Items["MainFrame"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["MainFrame"].Instance.Visible = Window.IsOpen
                end)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:SetCenter()
            -- Keep window hidden until all tabs, sections, and their deferred parents complete.
            -- Sections use task.defer to parent themselves (queued after this window defer).
            -- By double-deferring, the window reveal happens AFTER all section defers have run.
            Items["MainFrame"].Instance.Visible = false
            Window.IsOpen = false
            task.defer(function()
                task.defer(function()
                    Window.IsOpen = true
                    Items["MainFrame"].Instance.Visible = true
                end)
            end)
            return setmetatable(Window, Library)
        end

        Library.Page = function(self, Data)
            Data = Data or { }
            local _t0 = tick()
            warn("[Page] START", Data.Name or Data.name or "?")

            local Page = {
                Window = self,

                Name = Data.Name or Data.name or "Page",
                Icon = Data.Icon or Data.icon or Library:GetAsset("default-page-icon") or "",
                Columns = Data.Columns or Data.columns or 2,

                Items = { },
                SubPages = { },
                Active = false,
                _DefaultSubPage = nil,
            }
            warn("[Page] table built", tick() - _t0)

            -- Resolve icon name via asset manager if it's a plain name string
            if type(Page.Icon) == "string" and Page.Icon ~= "" and not Page.Icon:match("^rbxasset") and Page.Icon:find("^%d+$") == nil then
                local _ti = tick()
                Page.Icon = Library:GetAsset(Page.Icon) or Page.Icon
                warn("[Page] GetAsset icon took", tick() - _ti, "->", Page.Icon)
            end
            warn("[Page] icon resolved", tick() - _t0)

            local Items = { } do
                local _ts = tick()
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["Pages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 200, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Inline"})
                warn("[Page] Inactive button", tick() - _ts)
                
                _ts = tick()
                Items["UIStroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    Transparency = 1,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })  Items["UIStroke"]:AddToTheme({Color = "Border"})
                warn("[Page] UIStroke", tick() - _ts)
                
                _ts = tick()
                Instances:Create("UICorner", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                warn("[Page] UICorner", tick() - _ts)
                
                _ts = tick()
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = (type(Page.Icon) == "string" and not Page.Icon:find("^%d+$") and Library:GetAsset(Page.Icon)) or (Page.Icon ~= "" and "rbxassetid://" .. tostring(Page.Icon)) or "",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                warn("[Page] Icon ImageLabel", tick() - _ts)
                
                _ts = tick()
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Page.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 38, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                warn("[Page] Text label", tick() - _ts)
                                
                _ts = tick()
                Items["Page"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                warn("[Page] Page frame", tick() - _ts)
                
                _ts = tick()
                Items["PageName"] = Instances:Create("TextLabel", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Page.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 15, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 18,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                warn("[Page] PageName label", tick() - _ts)
                
                _ts = tick()
                Items["SubPages"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 0, 0, 30),
                    Position = UDim2New(0, 13, 0, 42),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(16, 18, 18)
                })  Items["SubPages"]:AddToTheme({BackgroundColor3 = "Background"})
                warn("[Page] SubPages frame", tick() - _ts)
                
                _ts = tick()
                Instances:Create("UIPadding", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 2),
                    PaddingBottom = UDimNew(0, 2),
                    PaddingRight = UDimNew(0, 2),
                    PaddingLeft = UDimNew(0, 2)
                })
                warn("[Page] UIPadding SubPages", tick() - _ts)
                
                _ts = tick()
                Instances:Create("UIListLayout", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 2),
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                warn("[Page] UIListLayout SubPages", tick() - _ts)

                _ts = tick()
                Instances:Create("UICorner", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                warn("[Page] UICorner SubPages", tick() - _ts)

                _ts = tick()
                Items["Columns"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -20, 1, -82),
                    Position = UDim2New(0, 10, 0, 75),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BackgroundTransparency = 1
                })
                warn("[Page] Columns frame", tick() - _ts)

                Page.Items = Items
            end
            warn("[Page] DONE total", tick() - _t0)

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end

                Page.Active = Bool 
                
                Debounce = true
                Items["Page"].Instance.Visible = Bool 
                Items["Page"].Instance.Parent = Bool and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance

                if Page.Active then
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0})
                    Items["Icon"]:Tween(nil, {ImageColor3 = FromRGB(200, 200, 200)})
                    Items["Text"]:Tween(nil, {TextColor3 = FromRGB(200, 200, 200)})
                    Items["UIStroke"]:Tween(nil, {Transparency = 0})
                else
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1})
                    Items["Icon"]:Tween(nil, {ImageColor3 = FromRGB(100, 100, 100)})
                    Items["Text"]:Tween(nil, {TextColor3 = FromRGB(100, 100, 100)})
                    Items["UIStroke"]:Tween(nil, {Transparency = 1})
                end

                Debounce = false
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Category = function(self, Name)
            local Items = { } do
                Items["Category"] = Instances:Create("TextLabel", {
                    Parent = self.Items["Pages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })                
            end

            return Items
        end

        Library.Pages.SubPage = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "SubPage",
                Columns = Data.Columns or Data.columns or 2,

                Items = { },
                ColumnsData = { },
                Active = false
            }

            local Items = { } do 
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Page.Items["SubPages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = Page.Name,
                    AutoButtonColor = false,
                    Size = UDim2New(0, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Element"})
                 
                Instances:Create("UIPadding", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })                

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill
                })
            
                for Index = 1, Page.Columns do 
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        ScrollBarImageColor3 = FromRGB(0, 0, 0),
                        Active = true,
                        BorderColor3 = FromRGB(0, 0, 0),
                        ScrollBarThickness = 0,
                        BackgroundTransparency = 1,
                        Size = UDim2New(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        CanvasSize = UDim2New(0, 0, 0, 0),
                    })

                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Name = "\0",
                        Padding = UDimNew(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalAlignment = Enum.HorizontalAlignment.Left,
                        VerticalAlignment = Enum.VerticalAlignment.Top,
                    })
                    
                    if Index == 1 then
                        Instances:Create("UIPadding", {
                            Parent = NewColumn.Instance,
                            Name = "\0",
                            PaddingTop = UDimNew(0, 3),
                            PaddingBottom = UDimNew(0, 3),
                            PaddingRight = UDimNew(0, 8),
                            PaddingLeft = UDimNew(0, 3)
                        })                
                    elseif Index == 2 then
                        Instances:Create("UIPadding", {
                            Parent = NewColumn.Instance,
                            Name = "\0",
                            PaddingTop = UDimNew(0, 3),
                            PaddingBottom = UDimNew(0, 3),
                            PaddingRight = UDimNew(0, 20),
                            PaddingLeft = UDimNew(0, 8)
                        })
                    end

                    Page.ColumnsData[Index] = NewColumn
                end
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end

                Page.Active = Bool 
                
                Debounce = true
                Items["Page"].Instance.Visible = Bool 
                Items["Page"].Instance.Parent = Bool and Page.Page.Items["Columns"].Instance or Library.UnusedHolder.Instance

                if Page.Active then
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0, TextTransparency = 0})
                else
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1, TextTransparency = 0.5})
                end

                Debounce = false
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Page.SubPages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Page.SubPages == 0 then 
                Page:Turn(true)
            end

            -- Hide the tab button and strip for auto-generated default subpages
            if Page.Name == "__default" then
                Items["Inactive"].Instance.Visible = false
                Items["Inactive"].Instance.Size = UDim2New(0, 0, 0, 0)
                -- Also hide the parent SubPages strip (it's still takes up space otherwise)
                if Page.Page and Page.Page.Items and Page.Page.Items["SubPages"] then
                    Page.Page.Items["SubPages"].Instance.Visible = false
                    Page.Page.Items["SubPages"].Instance.Size = UDim2New(0, 0, 0, 0)
                end
                -- Move Columns frame up to remove the gap left by the hidden strip
                if Page.Page and Page.Page.Items and Page.Page.Items["Columns"] then
                    Page.Page.Items["Columns"].Instance.Position = UDim2New(0, 10, 0, 15)
                    Page.Page.Items["Columns"].Instance.Size = UDim2New(1, -20, 1, -20)
                end
            end

            TableInsert(Page.Page.SubPages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            -- If this is a top-level Page (no ColumnsData), auto-create/reuse a hidden default SubPage
            if not self.ColumnsData then
                if not self._DefaultSubPage then
                    self._DefaultSubPage = Library.Pages.SubPage(self, {
                        Name = "__default",
                        Columns = self.Columns or 2,
                    })
                end
                return Library.Pages.Section(self._DefaultSubPage, Data)
            end

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",
                Icon = Data.Icon or Data.icon or "",
                Side = Data.Side or Data.side or 1,

                Items = { }
            }

            -- Resolve icon name via asset manager if it's a plain name string
            if type(Section.Icon) == "string" and Section.Icon ~= "" and not Section.Icon:match("^rbxasset") and Section.Icon:find("^%d+$") == nil then
                Section.Icon = Library:GetAsset(Section.Icon) or Section.Icon
            end

            local TargetColumn = Section.Page.ColumnsData[Section.Side].Instance
            local Items = { } do
                Items["Section"] = Instances:Create("Frame", {
                    Parent = nil,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 25),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = (type(Section.Icon) == "string" and not Section.Icon:find("^%d+$") and Library:GetAsset(Section.Icon)) or (Section.Icon ~= "" and "rbxassetid://" .. tostring(Section.Icon)) or "",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 12, 0, 12),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 12)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 35, 0, 12),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 12, 0, 42),
                    Size = UDim2New(1, -24, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Section.Items = Items
            end

            -- Defer parenting the section to the column so all elements inside it
            -- are added first (synchronously), then the whole section attaches at once.
            -- This eliminates per-element layout recalculation during construction.
            task.defer(function()
                Items["Section"].Instance.Parent = TargetColumn
            end)

            return setmetatable(Section, Library.Sections)
        end

        Library.Sections.Toggle = function(self, Data)
            Data = Data or { }

            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,

                Value = false
            }

            local Items = { } do 
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Toggle.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 16),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Toggle.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 14, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(30, 33, 33)
                })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UIStroke", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = FromRGB(56, 62, 62),
                    Thickness = 2
                }):AddToTheme({Color = "Border 2"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Items["CheckImage"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = Library:GetAsset("checkmark") or "",
                    ImageTransparency = 1,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(1, -4, 1, -4),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -25, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            end

            function Toggle:Get()
                return Toggle.Value 
            end

            local ToggleInited = false
            function Toggle:Set(Value, SkipCallback)
                Toggle.Value = Value 
                Library.Flags[Toggle.Flag] = Value 

                if ToggleInited then
                    if Toggle.Value then 
                        Items["Inline"]:Tween(nil,  {BackgroundTransparency = 0})
                        Items["CheckImage"]:Tween(nil, {ImageTransparency = 0})
                        Items["Text"]:Tween(nil, {TextColor3 = FromRGB(255, 255, 255)})
                    else
                        Items["Inline"]:Tween(nil,  {BackgroundTransparency = 1})
                        Items["CheckImage"]:Tween(nil, {ImageTransparency = 1})
                        Items["Text"]:Tween(nil, {TextColor3 = FromRGB(100, 100, 100)})
                    end
                else
                    -- First call (init): set visuals instantly, no tween
                    if Toggle.Value then
                        Items["Inline"].Instance.BackgroundTransparency = 0
                        Items["CheckImage"].Instance.ImageTransparency = 0
                        Items["Text"].Instance.TextColor3 = FromRGB(255, 255, 255)
                    else
                        Items["Inline"].Instance.BackgroundTransparency = 1
                        Items["CheckImage"].Instance.ImageTransparency = 1
                        Items["Text"].Instance.TextColor3 = FromRGB(100, 100, 100)
                    end
                    ToggleInited = true
                end

                if Toggle.Callback and not SkipCallback then 
                    Library:SafeCall(Toggle.Callback, Toggle.Value)
                end
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind = Library:CreateKeybind({
                    Parent = Items["SubElements"],
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

            Toggle:Set(Toggle.Default, true)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle 
        end

        Library.Sections.Button = function(self, Data)
            Data = Data or { }

            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name,
                Callback = Data.Callback or Data.callback or function() end
            }

            local Items = { } do
                Items["Button"] = Instances:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = FromRGB(56, 62, 62),
                    Thickness = 2
                }):AddToTheme({Color = "Border 2"})
                
                Instances:Create("UIPadding", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 1)
                })                
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:Press()
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent, TextColor3 = FromRGB(0, 0, 0)})

                task.wait(0.1)

                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element, TextColor3 = FromRGB(255, 255, 255)})

                Library:SafeCall(Button.Callback)
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            Data = Data or { }

            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Min = Data.Min or Data.min or 0,
                Max = Data.Max or Data.max or 100,
                Callback = Data.Callback or Data.callback or function() end,
                Default = Data.Default or Data.default or 0,
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Decimals = Data.Decimals or Data.decimals or 1,
                Suffix = Data.Suffix or Data.suffix or "",

                Value = 0,
                Sliding = false
            }

            local Items = { } do 
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 5),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0.4000000059604645, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Circle"] = Instances:Create("Frame", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 5, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 8, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Circle"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(180, 180, 180)), RGBSequenceKeypoint(1, FromRGB(255, 255, 255))}
                })                
            end

            function Slider:Get()
                return Slider.Value
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            local SliderInited = false
            function Slider:Set(Value)
                Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
                Library.Flags[Slider.Flag] = Slider.Value

                local targetSize = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), -2, 1, 0)
                if SliderInited then
                    Items["Accent"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize})
                else
                    Items["Accent"].Instance.Size = targetSize
                    SliderInited = true
                end
                Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)

                if Slider.Callback then
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            local InputChanged
            local InputChanged2

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

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

            Items["Circle"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)

                    if InputChanged2 or InputChanged then
                        return 
                    end

                    InputChanged2 = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged2:Disconnect()
                            InputChanged2 = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default) 

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider 
        end

        Library.Sections.Dropdown = function(self, Data)
            Data = Data or { }

            local Dropdown = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Dropdown",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Items = Data.Items or Data.items or { },
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Multi = Data.Multi or Data.multi or false,

                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do 
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    Size = UDim2New(0, 80, 0, 25),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "...",
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(1, -6, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 6, 0.5, 0),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = Library:GetAsset("dropdown-arrow") or "",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -5, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["OptionHolder"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0),
                    Position = UDim2New(1, 0, 0.5, 0),
                    Size = UDim2New(0, 80, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UIStroke", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["Holder"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.XY,
                    ScrollBarThickness = 2,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })  Items["Holder"]:AddToTheme({ScrollBarImageColor3 = "Accent"})
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Instances:Create("UIPadding", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 4)
                })                
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local Debounce = false
            local RenderStepped

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true 

                if Dropdown.IsOpen then 
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["OptionHolder"].Instance.Position = UDim2New(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y - 25)
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, 0)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Dropdown and not Dropdown.Section.IsSettings then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["OptionHolder"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if not Value.ClassName:find("UI") then 
                        Value.ZIndex = Dropdown.IsOpen and 3 or 1
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                    task.wait(0.2)
                    Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Dropdown:Set(Option)
                if Dropdown.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end

                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Dropdown.Callback then   
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Option,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  OptionButton:AddToTheme({BackgroundColor3 = "Accent"})

                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Selected = false
                }
                
                function OptionData:Toggle(Value)
                    if Value == "Active" then
                        OptionData.Button:Tween(nil, {BackgroundTransparency = 0, TextColor3 = FromRGB(0, 0, 0)})
                    else
                        OptionData.Button:Tween(nil, {BackgroundTransparency = 1, TextColor3 = FromRGB(100, 100, 100)})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Dropdown.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button:Clean()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.IsOpen then
                        if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                            return
                        end

                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Dropdown.IsOpen then
                    Dropdown.IsOpen = not Library:IsClipped(Items["OptionHolder"].Instance, Dropdown.Section.Items["Section"].Instance.Parent)
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                end
            end)

            for Index, Value in Dropdown.Items do 
                Dropdown:Add(Value)
            end

            if Dropdown.Default then 
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown
        end

        Library.Sections.Label = function(self, Name)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Name or "Label"
            }

            local Items = { } do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 17),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })      
            end

            function Label:SetText(Text)
               Text = tostring(Text)
               Items["Label"].Instance.Text = Text 
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end
 
            return Label
        end

        Library.Sections.Textbox = function(self, Data)
            Data = Data or { }

            local Textbox = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
                Numeric = Data.Numeric or Data.numeric or false,
                Finished = Data.Finished or Data.finished or false,

                Value = ""
            }

            local Items = { } do 
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    CursorPosition = -1,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Size = UDim2New(1, 0, 1, 0),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    PlaceholderColor3 = FromRGB(100, 100, 100),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["Input"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = FromRGB(56, 62, 62),
                    Thickness = 2
                }):AddToTheme({Color = "Border 2"})
                
                Instances:Create("UIPadding", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 8)
                })                 
            end

            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end

            if Textbox.Finished then 
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Items["Input"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Textbox.Default then
                Textbox:Set(Textbox.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox 
        end
    end

    Library.CreateSettingsPage = function(self, Window)
        local SettingsPage = Window:Page({Name = "Settings", Icon = Library:GetAsset("settings") or ""}) do 
            local ConfigsSubPage = SettingsPage:SubPage({Name = "Configs"})
            local ThemingSubPage = SettingsPage:SubPage({Name = "Theming"})
            local SettingsSubPage = SettingsPage:SubPage({Name = "Settings"})

            do -- Configs
                local ConfigsSection = ConfigsSubPage:Section({Name = "Configs", Side = 1, Icon = Library:GetAsset("settings-configs") or ""})

                local ConfigName = ""
                local ConfigSelected

                local ConfigsList = ConfigsSection:Dropdown({
                    Name = "Configs", 
                    Flag = "ConfigsList", 
                    Items = { }, 
                    Multi = false,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })

                ConfigsSection:Textbox({ 
                    Default = "", 
                    Flag = "ConfigName", 
                    Placeholder = "Config name", 
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })

                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                    if ConfigName and ConfigName ~= "" then
                        if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                            writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                            Library:RefreshConfigsList(ConfigsList)
                        else
                            return
                        end
                    end
                end})

                ConfigsSection:Button({
                    Name = "Delete", 
                    Callback = function()
                    if ConfigSelected then
                        Library:DeleteConfig(ConfigSelected)
                        Library:RefreshConfigsList(ConfigsList)
                    end
                end})

                ConfigsSection:Button({
                    Name = "Load", 
                    Callback = function()
                    if ConfigSelected then
                        Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))
                    end
                end})

                ConfigsSection:Button({
                    Name = "Save", 
                    Callback = function()
                    if ConfigName and ConfigName ~= "" then
                        writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                        Library:RefreshConfigsList(ConfigsList)
                    end
                end})

                ConfigsSection:Button({
                    Name = "Refresh", 
                    Callback = function()
                    Library:RefreshConfigsList(ConfigsList)
                end})

                Library:RefreshConfigsList(ConfigsList)               
            end

            do -- Theming
                local ThemingSection = ThemingSubPage:Section({Name = "Theming", Icon = Library:GetAsset("settings-theming") or "", Side = 1})
                for Index, Value in Library.Theme do 
                    ThemingSection:Label(Index):Colorpicker({
                        Flag = Index.."Theme",
                        Default = Value,
                        Callback = function(Value)
                            Library.Theme[Index] = Value
                            Library:ChangeTheme(Index, Value)
                        end
                    })
                end
            end

            do -- Settings
                local SettingsSection = SettingsSubPage:Section({Name = "Settings", Icon = Library:GetAsset("settings") or "", Side = 1})     
                
                SettingsSection:Button({
                    Name = "Unload",
                    Callback = function()
                        Library:Unload()
                    end
                })
                
                SettingsSection:Label("Menu Keybind"):Keybind({
                    Name = "Menu Keybind",
                    Flag = "MenuKeybind",
                    Default = Library.MenuKeybind,
                    Mode = "Toggle",
                    Callback = function()
                        Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                    end
                })

                SettingsSection:Slider({
                    Name = "Tween Speed",
                    Default = 0.3,
                    Flag = "Tween Speed",
                    Decimals = 0.01,
                    Suffix = "s",
                    Max = 10,
                    Min = 0,
                    Callback = function(Value)
                        Library.Tween.Time = Value
                    end
                })

                SettingsSection:Dropdown({
                    Name = "Tween Style",
                    Flag = "Tween style",
                    Items = { "Linear", "Quad", "Quart", "Back", "Bounce", "Circular", "Cubic", "Elastic", "Exponential", "Sine", "Quint" },
                    Default = "Quart",
                    Callback = function(Value)
                        if not Value then Value = "Quint" end
                        Library.Tween.Style = Enum.EasingStyle[Value]
                    end
                })

                SettingsSection:Dropdown({
                    Name = "Tween Direction",
                    Flag = "Tween direction",
                    Items = { "In", "Out", "InOut" },
                    Default = "Out",
                    Callback = function(Value)
                        if not Value then Value = "Out" end
                        Library.Tween.Direction = Enum.EasingDirection[Value]
                    end
                })
            end
        end
    end
end

-- ============================================================
-- Asset Manager & Compatibility Layer
-- ============================================================

local _AssetManager = nil

local function displayName(Data, Fallback)
    Data = Data or {}
    return Data.Name or Data.name or Data.Text or Data.text or Data.Title or Data.title or Fallback
end

function Library:SetAssetManager(AM)
    _AssetManager = AM
end

local _AssetCache = {}
function Library:GetAsset(Name)
    if not _AssetManager or not Name then return nil end
    if _AssetCache[Name] ~= nil then return _AssetCache[Name] end
    local result = _AssetManager:GetAsset(Name)
    _AssetCache[Name] = result
    return result
end

function Library:GetImage(Name)
    local map = {
        Saturation = "color-picker",
        Value      = "shadow",
        Hue        = "color-picker",
        Checkers   = "checkmark",
        Scrollbar  = "scrollbar",
    }
    return self:GetAsset(map[Name] or Name)
end

-- ShowLoadingScreen — preserved from scoot library, styled to match new theme
function Library:ShowLoadingScreen(Settings)
    Settings = Settings or {}

    local TweenService = game:GetService("TweenService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local Parent = gethui and gethui() or CoreGui

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "\0"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = Parent

    local Backdrop = Instance.new("Frame")
    Backdrop.Size = UDim2.fromScale(1, 1)
    Backdrop.BackgroundColor3 = self.Theme["Background"] or Color3.fromRGB(16, 18, 18)
    Backdrop.BackgroundTransparency = 1
    Backdrop.BorderSizePixel = 0
    Backdrop.Parent = ScreenGui

    local Panel = Instance.new("Frame")
    Panel.AnchorPoint = Vector2.new(0.5, 0.5)
    Panel.Position = UDim2.fromScale(0.5, 0.5)
    Panel.Size = UDim2.new(0, 360, 0, 142)
    Panel.BackgroundColor3 = self.Theme["Inline"] or Color3.fromRGB(21, 24, 24)
    Panel.BackgroundTransparency = 1
    Panel.BorderSizePixel = 0
    Panel.Parent = ScreenGui

    Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 7)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = self.Theme["Border 2"] or Color3.fromRGB(56, 62, 62)
    Stroke.Thickness = 1.5
    Stroke.Parent = Panel

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(1, 0, 0, 2)
    Accent.BackgroundColor3 = self.Theme["Accent"] or Color3.fromRGB(255, 255, 255)
    Accent.BackgroundTransparency = 1
    Accent.BorderSizePixel = 0
    Accent.Parent = Panel

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 18)
    Padding.PaddingRight = UDim.new(0, 18)
    Padding.PaddingTop = UDim.new(0, 18)
    Padding.PaddingBottom = UDim.new(0, 16)
    Padding.Parent = Panel

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.FontFace = self.Font
    Title.Text = Settings.Title or "Loading"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Size = UDim2.new(1, 0, 0, 18)
    Title.Parent = Panel

    local Subtitle = Instance.new("TextLabel")
    Subtitle.BackgroundTransparency = 1
    Subtitle.FontFace = self.Font
    Subtitle.Text = Settings.Subtitle or "Preparing assets..."
    Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    Subtitle.TextSize = 12
    Subtitle.TextTransparency = 1
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.TextTruncate = Enum.TextTruncate.AtEnd
    Subtitle.Position = UDim2.new(0, 0, 0, 25)
    Subtitle.Size = UDim2.new(1, 0, 0, 16)
    Subtitle.Parent = Panel

    local Track = Instance.new("Frame")
    Track.BackgroundColor3 = self.Theme["Element"] or Color3.fromRGB(30, 34, 34)
    Track.BorderSizePixel = 0
    Track.Position = UDim2.new(0, 0, 0, 64)
    Track.Size = UDim2.new(1, 0, 0, 5)
    Track.Parent = Panel
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.BackgroundColor3 = self.Theme["Accent"] or Color3.fromRGB(255, 255, 255)
    Fill.BorderSizePixel = 0
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.Parent = Track
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Count = Instance.new("TextLabel")
    Count.BackgroundTransparency = 1
    Count.FontFace = self.Font
    Count.Text = "0 / ?"
    Count.TextColor3 = Color3.fromRGB(120, 120, 120)
    Count.TextSize = 11
    Count.TextTransparency = 1
    Count.TextXAlignment = Enum.TextXAlignment.Right
    Count.Position = UDim2.new(0, 0, 1, -18)
    Count.Size = UDim2.new(1, 0, 0, 14)
    Count.Parent = Panel

    local FadeIn = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Backdrop, FadeIn, { BackgroundTransparency = 0.35 }):Play()
    TweenService:Create(Panel, FadeIn, { BackgroundTransparency = 0 }):Play()
    TweenService:Create(Accent, FadeIn, { BackgroundTransparency = 0 }):Play()
    TweenService:Create(Title, FadeIn, { TextTransparency = 0 }):Play()
    TweenService:Create(Subtitle, FadeIn, { TextTransparency = 0.3 }):Play()
    TweenService:Create(Count, FadeIn, { TextTransparency = 0.4 }):Play()

    local ProgressTween = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    if _AssetManager then
        _AssetManager:Initialize(function(Current, Total, AssetName)
            local Progress = Current / math.max(Total, 1)
            TweenService:Create(Fill, ProgressTween, { Size = UDim2.new(Progress, 0, 1, 0) }):Play()
            Subtitle.Text = AssetName
            Count.Text = Current .. " / " .. Total
        end)
    end

    TweenService:Create(Fill, ProgressTween, { Size = UDim2.new(1, 0, 1, 0) }):Play()
    Subtitle.Text = "Completed"
    task.wait(0.3)

    local FadeOut = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _, Item in ScreenGui:GetDescendants() do
        if Item:IsA("Frame") then
            TweenService:Create(Item, FadeOut, { BackgroundTransparency = 1 }):Play()
        elseif Item:IsA("TextLabel") then
            TweenService:Create(Item, FadeOut, { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
        end
    end

    local Done = TweenService:Create(Backdrop, FadeOut, { BackgroundTransparency = 1 })
    Done.Completed:Connect(function() ScreenGui:Destroy() end)
    Done:Play()
end

-- Notify wrapper (scoot-style API used by init.client.luau and features)
function Library:Notify(Data)
    Data = Data or {}
    local Msg = Data.Message or Data.Description or ""
    local Title = Data.Title or ""
    local Text = (Title ~= "" and Msg ~= "") and (Title .. ": " .. Msg) or (Title ~= "" and Title or Msg)
    if Text == "" then Text = "Notification" end
    self:Notification(Text, Data.Duration or 3, Data.Icon or nil)
end

-- CreateWindow / CreateTab compat
function Library:CreateWindow(Data)
    Data = Data or {}
    return self:Window({
        Name = Data.Name or Data.name or "Window",
        SubTitle = Data.SubTitle or Data.subtitle,
        ExpiresIn = Data.ExpiresIn or Data.expiresin,
    })
end

function Library:CreateTab(Data)
    return self:Page(Data)
end

-- Section-level compatibility wrappers (used by feature files)
function Library.Sections:AddToggle(Data)
    Data = Data or {}
    return self:Toggle({
        Name = displayName(Data, "Toggle"),
        Flag = Data.Flag or Data.flag,
        Default = Data.Default ~= nil and Data.Default or (Data.Enabled ~= nil and Data.Enabled or (Data.default or false)),
        Callback = Data.Callback or Data.callback,
    })
end

function Library.Sections:AddSlider(Data)
    Data = Data or {}
    return self:Slider({
        Name = displayName(Data, "Slider"),
        Flag = Data.Flag or Data.flag,
        Default = Data.Default or Data.default or 0,
        Min = Data.Min or Data.min or 0,
        Max = Data.Max or Data.max or 100,
        Decimals = Data.Rounding or Data.Decimals or Data.decimals or 1,
        Suffix = Data.Suffix or Data.suffix or "",
        Callback = Data.Callback or Data.callback,
    })
end

function Library.Sections:AddDropdown(Data)
    Data = Data or {}
    return self:Dropdown({
        Name = displayName(Data, "Dropdown"),
        Flag = Data.Flag or Data.flag,
        Default = Data.Default or Data.default,
        Items = Data.Values or Data.Options or Data.Items or Data.options or Data.items or {},
        Multi = Data.Multi or Data.multi or false,
        Callback = Data.Callback or Data.callback,
    })
end

function Library.Sections:AddColorPicker(Data)
    Data = Data or {}
    -- Wrap in a Label with a Colorpicker attached
    local lbl = self:Label(displayName(Data, "Color"))
    if lbl and lbl.Colorpicker then
        return lbl:Colorpicker({
            Flag = Data.Flag or Data.flag,
            Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
            Callback = Data.Callback or Data.callback,
        })
    end
    return lbl
end

function Library.Sections:AddKeyPicker(Data)
    Data = Data or {}
    local lbl = self:Label(displayName(Data, "Keybind"))
    if lbl and lbl.Keybind then
        return lbl:Keybind({
            Flag = Data.Flag or Data.flag,
            Default = Data.Default or Data.default or Enum.KeyCode.E,
            Mode = Data.Mode or Data.mode or "Toggle",
            Callback = Data.Callback or Data.callback,
        })
    end
    return lbl
end

function Library.Sections:AddTextbox(Data)
    Data = Data or {}
    return self:Textbox({
        Flag = Data.Flag or Data.flag,
        Default = Data.Default or Data.default or "",
        Placeholder = Data.Placeholder or Data.placeholder or "...",
        Numeric = Data.Numeric or Data.numeric or false,
        Finished = Data.Finished or Data.finished or false,
        Callback = Data.Callback or Data.callback,
    })
end

function Library.Sections:AddLabel(Data)
    Data = Data or {}
    return self:Label(displayName(Data, "Label"))
end

function Library.Sections:CreateButton(Data)
    Data = Data or {}
    return self:Button({
        Name = displayName(Data, "Button"),
        Callback = Data.Callback or Data.callback or function() end,
    })
end



getgenv().Library = Library
return Library

end)() end,
    [77] = function()local wax,script,require=ImportGlobals(77)local ImportGlobals return (function(...)-- should only be used in **unobfuscated scripts!**
-- will also perform basic runtime validation on script arguments

local assert = assert
local type = type
local getfenv = getfenv
local getgenv = getgenv
local setfenv = setfenv

local env: any = if getgenv then getgenv() else getfenv()

env.LPH_ENCNUM = function(toEncrypt, ...)
    assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
    return toEncrypt
end
env.LPH_NUMENC = env.LPH_ENCNUM

env.LPH_ENCSTR = function(toEncrypt, ...)
    assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
    return toEncrypt
end
env.LPH_STRENC = env.LPH_ENCSTR

env.LPH_ENCFUNC = function(toEncrypt, encKey, decKey, ...)
    -- not checking decKey value since this shim is meant to be used without obfuscation/whitelisting
    assert(type(toEncrypt) == "function" and type(encKey) == "string" and #{...} == 0, "LPH_ENCFUNC accepts a constant function, constant string, and string variable as arguments.")
    return toEncrypt
end
env.LPH_FUNCENC = env.LPH_ENCFUNC

env.LPH_JIT = function(f, ...)
    assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
    return f
end
env.LPH_JIT_MAX = env.LPH_JIT

env.LPH_NO_VIRTUALIZE = function(f, ...)
    assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
    return f
end

env.LPH_NO_UPVALUES = function(f, ...)
    assert(type(setfenv) == "function", "LPH_NO_UPVALUES can only be used on Lua versions with getfenv & setfenv")
    assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")

    local runtimeEnv = getrenv()
    return setfenv(
        env.LPH_NO_VIRTUALIZE(function(...)
            return (getfenv() :: any).func(...)
        end),
        setmetatable(
            {
                func = f
            },
            {
                __index = runtimeEnv,
                __newindex = runtimeEnv
            }
        )
    )
end

env.LPH_CRASH = function(...)
    assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
    while true do end
end

return {}
end)() end,
    [73] = function()local wax,script,require=ImportGlobals(73)local ImportGlobals return (function(...)local ServerScriptService = game:GetService("ServerScriptService")

local Test = require(ServerScriptService.TestRunner.Test)

return function(ctx: Test.TestContext)
	local Trove = require(script.Parent)

	ctx:Describe("Trove", function()
		local trove

		ctx:BeforeEach(function()
			trove = Trove.new()
		end)

		ctx:AfterEach(function()
			if trove then
				trove:Destroy()
				trove = nil
			end
		end)

		ctx:Test("should add and clean up roblox instance", function()
			local part = Instance.new("Part")
			part.Parent = workspace
			trove:Add(part)
			trove:Destroy()
			ctx:Expect(part.Parent):ToBeNil()
		end)

		ctx:Test("should add and clean up roblox connection", function()
			local connection = workspace.Changed:Connect(function() end)
			trove:Add(connection)
			trove:Destroy()
			ctx:Expect(connection.Connected):ToBe(false)
		end)

		ctx:Test("should add and clean up a table with a destroy method", function()
			local tbl = { Destroyed = false }
			function tbl:Destroy()
				self.Destroyed = true
			end
			trove:Add(tbl)
			trove:Destroy()
			ctx:Expect(tbl.Destroyed):ToBe(true)
		end)

		ctx:Test("should add and clean up a table with a disconnect method", function()
			local tbl = { Connected = true }
			function tbl:Disconnect()
				self.Connected = false
			end
			trove:Add(tbl)
			trove:Destroy()
			ctx:Expect(tbl.Connected):ToBe(false)
		end)

		ctx:Test("should add and clean up a function", function()
			local fired = false
			trove:Add(function()
				fired = true
			end)
			trove:Destroy()
			ctx:Expect(fired):ToBe(true)
		end)

		ctx:Test("should allow a custom cleanup method", function()
			local tbl = { Cleaned = false }
			function tbl:Cleanup()
				self.Cleaned = true
			end
			trove:Add(tbl, "Cleanup")
			trove:Destroy()
			ctx:Expect(tbl.Cleaned):ToBe(true)
		end)

		ctx:Test("should return the object passed to add", function()
			local part = Instance.new("Part")
			local part2 = trove:Add(part)
			ctx:Expect(part):ToBe(part2)
			trove:Destroy()
		end)

		ctx:Test("should fail to add object without proper cleanup method", function()
			local tbl = {}
			ctx:Expect(function()
				trove:Add(tbl)
			end):ToThrow()
		end)

		ctx:Test("should construct an object and add it", function()
			local class = {}
			class.__index = class
			function class.new(msg)
				local self = setmetatable({}, class)
				self._msg = msg
				self._destroyed = false
				return self
			end
			function class:Destroy()
				self._destroyed = true
			end
			local msg = "abc"
			local obj = trove:Construct(class, msg)
			ctx:Expect(typeof(obj)):ToBe("table")
			ctx:Expect(getmetatable(obj)):ToBe(class)
			ctx:Expect(obj._msg):ToBe(msg)
			ctx:Expect(obj._destroyed):ToBe(false)
			trove:Destroy()
			ctx:Expect(obj._destroyed):ToBe(true)
		end)

		ctx:Test("should connect to a signal", function()
			local connection = trove:Connect(workspace.Changed, function() end)
			ctx:Expect(typeof(connection)):ToBe("RBXScriptConnection")
			ctx:Expect(connection.Connected):ToBe(true)
			trove:Destroy()
			ctx:Expect(connection.Connected):ToBe(false)
		end)

		ctx:Test("should remove an object", function()
			local connection = trove:Connect(workspace.Changed, function() end)
			ctx:Expect(trove:Remove(connection)):ToBe(true)
			ctx:Expect(connection.Connected):ToBe(false)
		end)

		ctx:Test("should not remove an object not in the trove", function()
			local connection = workspace.Changed:Connect(function() end)
			ctx:Expect(trove:Remove(connection)):ToBe(false)
			ctx:Expect(connection.Connected):ToBe(true)
			connection:Disconnect()
		end)

		ctx:Test("should attach to instance", function()
			local part = Instance.new("Part")
			part.Parent = workspace
			local connection = trove:AttachToInstance(part)
			ctx:Expect(connection.Connected):ToBe(true)
			part:Destroy()
			ctx:Expect(connection.Connected):ToBe(false)
		end)

		ctx:Test("should fail to attach to instance not in hierarchy", function()
			local part = Instance.new("Part")
			ctx:Expect(function()
				trove:AttachToInstance(part)
			end):ToThrow()
		end)

		ctx:Test("should extend itself", function()
			local subTrove = trove:Extend()
			local called = false
			subTrove:Add(function()
				called = true
			end)
			ctx:Expect(typeof(subTrove)):ToBe("table")
			ctx:Expect(getmetatable(subTrove)):ToBe(getmetatable(trove))
			trove:Clean()
			ctx:Expect(called):ToBe(true)
		end)

		ctx:Test("should clone an instance", function()
			local name = "TroveCloneTest"
			local p1 = trove:Construct(Instance.new, "Part")
			p1.Name = name
			local p2 = trove:Clone(p1)
			ctx:Expect(typeof(p2)):ToBe("Instance")
			ctx:Expect(p2):Not():ToBe(p1)
			ctx:Expect(p2.Name):ToBe(name)
			ctx:Expect(p1.Name):ToBe(p2.Name)
		end)

		ctx:Test("should clean up a thread", function()
			local co = coroutine.create(function() end)
			trove:Add(co)
			ctx:Expect(coroutine.status(co)):ToBe("suspended")
			trove:Clean()
			ctx:Expect(coroutine.status(co)):ToBe("dead")
		end)

		ctx:Test("should not allow objects added during cleanup", function()
			local added = false
			trove:Add(function()
				trove:Add(function() end)
				added = true
			end)
			trove:Clean()

			ctx:Expect(added):ToBe(false)
		end)

		ctx:Test("should not allow objects to be removed during cleanup", function()
			local f = function() end
			local removed = false
			trove:Add(f)
			trove:Add(function()
				trove:Remove(f)
				removed = true
			end)

			ctx:Expect(removed):ToBe(false)
		end)
	end)
end

end)() end,
    [76] = function()local wax,script,require=ImportGlobals(76)local ImportGlobals return (function(...)local HttpService = cloneref(game:GetService("HttpService"))

local getcustomasset = getcustomasset or function() end

local AssetManager = {
    AssetDirectory = "Tyronex/Assets",
    Repo = "killa363/Tyronex",
    Branch = "main",
    Assets = {},
    AssetList = {},
    FallbackAssets = {
        ["saturation.png"] = "https://raw.githubusercontent.com/sametexe001/images/main/saturation.png",
        ["value.png"] = "https://raw.githubusercontent.com/sametexe001/images/main/value.png",
        ["hue.png"] = "https://raw.githubusercontent.com/sametexe001/images/main/horizontalhue.png",
        ["checkers.png"] = "https://raw.githubusercontent.com/sametexe001/images/main/checkers.png",
    }
}

function AssetManager:FetchAssetListFromGitHub(): boolean
    local Success: boolean, Result: any = pcall(function()
        local Request = request({
            Url = `https://api.github.com/repos/{self.Repo}/contents/Assets?ref={self.Branch}`,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Roblox/AssetManager"
            }
        })

        if Request.StatusCode == 200 then
            local Data: any = HttpService:JSONDecode(Request.Body)
            
            self.AssetList = {}
            for _, File in Data do
                if File.type == "file" and File.name:match("%.png$") then
                    table.insert(self.AssetList, File.name)
                end
            end

            for AssetName in self.FallbackAssets do
                if not table.find(self.AssetList, AssetName) then
                    table.insert(self.AssetList, AssetName)
                end
            end
            
            return true
        else
            return false
        end
    end)
    
    return Success and Result
end

function AssetManager:Initialize(OnProgress)
    if not isfolder(self.AssetDirectory) then
        makefolder(self.AssetDirectory)
    end
    
    local FetchSuccess: boolean = self:FetchAssetListFromGitHub()
    
    if FetchSuccess and #self.AssetList > 0 then
        self:LoadAssets(OnProgress)
    end
end

function AssetManager:DownloadAsset(AssetName: string): boolean
    local FullPath = `{self.AssetDirectory}/{AssetName}`

    if isfile(FullPath) then
        return true, "Asset already exists"
    end

    local Success, Result = pcall(function()
        local Request = request({
            Url = self.FallbackAssets[AssetName] or `https://raw.githubusercontent.com/{self.Repo}/{self.Branch}/Assets/{AssetName}`,
            Method = "GET",
        })

        if Request.StatusCode == 200 then
            writefile(FullPath, Request.Body)
            return true, "Downloaded successfully"
        else
            return false, `Status code: {Request.StatusCode}`
        end
    end)

    return Success and Result
end

function AssetManager:LoadAssets(OnProgress)
    local Total: number = #self.AssetList

    for Index, AssetName in self.AssetList do
        local Success: boolean = self:DownloadAsset(AssetName)

        if Success then
            local FullPath = `{self.AssetDirectory}/{AssetName}`
            local Ok, Url = pcall(getcustomasset, FullPath)
            self.Assets[AssetName] = Ok and Url or true
            -- also cache without extension so GetAsset("swords") hits the cache
            local NoExt = AssetName:match("^(.+)%.png$")
            if NoExt then
                self.Assets[NoExt] = Ok and Url or true
            end
        end

        if OnProgress then
            OnProgress(Index, Total, AssetName)
        end
    end
end

function AssetManager:GetAsset(AssetName: string): string?
    -- return cached URL directly if LoadAssets already resolved it
    local cached = self.Assets[AssetName]
    if type(cached) == "string" then return cached end

    local FileName: string = AssetName:match("%.png$") and AssetName or `{AssetName}.png`
    local cached2 = self.Assets[FileName]
    if type(cached2) == "string" then return cached2 end

    local FullPath: string = `{self.AssetDirectory}/{FileName}`
    print(FullPath)
    if not isfile(FullPath) then
        print("Nah")
        local Success: boolean = self:DownloadAsset(FileName)
        if not Success then return end
    end
    print("Do")
    local Success: boolean, AssetUrl: string = pcall(getcustomasset, FullPath)
    if Success then
        self.Assets[AssetName] = AssetUrl
        self.Assets[FileName] = AssetUrl
        return AssetUrl
    end

    return nil
end

function AssetManager:ClearCache()
    if isfolder(self.AssetDirectory) then
        for AssetName: string in self.Assets do
            local FullPath: string = `{self.AssetDirectory}/{AssetName}`
            if isfile(FullPath) then
                delfile(FullPath)
            end
        end
        self.Assets = {}
    end
end

function AssetManager:AssetExists(AssetName: string): boolean
    return isfile(`{self.AssetDirectory}/{AssetName}`)
end

return AssetManager

end)() end,
    [74] = function()local wax,script,require=ImportGlobals(74)local ImportGlobals return (function(...)return {
	package = {
		authors = {"Stephen Leitnick"},
		description = "Trove class for tracking and cleaning up objects",
		license = "MIT",
		name = "sleitnick/trove",
		realm = "shared",
		registry = "https://github.com/UpliftGames/wally-index",
		version = "1.8.0",
	},
}
end)() end
} -- [RefId] = Closure

-- Holds the actual DOM data
local ObjectTree = {
    {
        1,
        4,
        {
            "Tyronex"
        },
        {
            {
                2,
                1,
                {
                    "Features"
                },
                {
                    {
                        4,
                        2,
                        {
                            "Desyncs"
                        }
                    },
                    {
                        6,
                        2,
                        {
                            "Misc"
                        }
                    },
                    {
                        7,
                        2,
                        {
                            "Visuals"
                        }
                    },
                    {
                        5,
                        2,
                        {
                            "Exploit"
                        }
                    },
                    {
                        3,
                        2,
                        {
                            "Combat"
                        }
                    }
                }
            },
            {
                75,
                2,
                {
                    "UILibrary"
                },
                {
                    {
                        76,
                        2,
                        {
                            "AssetManager"
                        }
                    }
                }
            },
            {
                10,
                1,
                {
                    "Packages"
                },
                {
                    {
                        14,
                        2,
                        {
                            "Trove"
                        }
                    },
                    {
                        15,
                        1,
                        {
                            "_Index"
                        },
                        {
                            {
                                64,
                                1,
                                {
                                    "howmanysmall_typed-promise@4.0.6"
                                },
                                {
                                    {
                                        66,
                                        2,
                                        {
                                            "typed-promise"
                                        }
                                    },
                                    {
                                        65,
                                        2,
                                        {
                                            "Promise"
                                        }
                                    }
                                }
                            },
                            {
                                67,
                                1,
                                {
                                    "sleitnick_signal@2.0.3"
                                },
                                {
                                    {
                                        68,
                                        2,
                                        {
                                            "signal"
                                        },
                                        {
                                            {
                                                70,
                                                2,
                                                {
                                                    "wally"
                                                }
                                            },
                                            {
                                                69,
                                                2,
                                                {
                                                    "init.test"
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                61,
                                1,
                                {
                                    "evaera_promise@4.0.0"
                                },
                                {
                                    {
                                        62,
                                        2,
                                        {
                                            "promise"
                                        },
                                        {
                                            {
                                                63,
                                                2,
                                                {
                                                    "init.spec"
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                16,
                                1,
                                {
                                    "arxkdev_ezvisualz@0.0.6"
                                },
                                {
                                    {
                                        17,
                                        2,
                                        {
                                            "ezvisualz"
                                        },
                                        {
                                            {
                                                59,
                                                2,
                                                {
                                                    "Stroke"
                                                }
                                            },
                                            {
                                                20,
                                                2,
                                                {
                                                    "GradientTemplates"
                                                },
                                                {
                                                    {
                                                        22,
                                                        2,
                                                        {
                                                            "Chrome"
                                                        }
                                                    },
                                                    {
                                                        23,
                                                        2,
                                                        {
                                                            "Death"
                                                        }
                                                    },
                                                    {
                                                        25,
                                                        2,
                                                        {
                                                            "Ghost"
                                                        }
                                                    },
                                                    {
                                                        29,
                                                        2,
                                                        {
                                                            "Lava"
                                                        }
                                                    },
                                                    {
                                                        33,
                                                        2,
                                                        {
                                                            "Silver"
                                                        }
                                                    },
                                                    {
                                                        32,
                                                        2,
                                                        {
                                                            "Rainbow"
                                                        }
                                                    },
                                                    {
                                                        31,
                                                        2,
                                                        {
                                                            "Oceanic"
                                                        }
                                                    },
                                                    {
                                                        27,
                                                        2,
                                                        {
                                                            "Green"
                                                        }
                                                    },
                                                    {
                                                        30,
                                                        2,
                                                        {
                                                            "Matrix"
                                                        }
                                                    },
                                                    {
                                                        24,
                                                        2,
                                                        {
                                                            "Fire"
                                                        }
                                                    },
                                                    {
                                                        34,
                                                        2,
                                                        {
                                                            "Zebra"
                                                        }
                                                    },
                                                    {
                                                        21,
                                                        2,
                                                        {
                                                            "Bubblegum"
                                                        }
                                                    },
                                                    {
                                                        28,
                                                        2,
                                                        {
                                                            "Ice"
                                                        }
                                                    },
                                                    {
                                                        26,
                                                        2,
                                                        {
                                                            "Gold"
                                                        }
                                                    }
                                                }
                                            },
                                            {
                                                19,
                                                2,
                                                {
                                                    "Gradient"
                                                }
                                            },
                                            {
                                                18,
                                                2,
                                                {
                                                    "Dropshadow"
                                                }
                                            },
                                            {
                                                35,
                                                2,
                                                {
                                                    "Presets"
                                                },
                                                {
                                                    {
                                                        38,
                                                        2,
                                                        {
                                                            "DeathStroke"
                                                        }
                                                    },
                                                    {
                                                        53,
                                                        2,
                                                        {
                                                            "Shine"
                                                        }
                                                    },
                                                    {
                                                        55,
                                                        2,
                                                        {
                                                            "Silver"
                                                        }
                                                    },
                                                    {
                                                        52,
                                                        2,
                                                        {
                                                            "RainbowStroke"
                                                        }
                                                    },
                                                    {
                                                        44,
                                                        2,
                                                        {
                                                            "GreenOutline"
                                                        }
                                                    },
                                                    {
                                                        39,
                                                        2,
                                                        {
                                                            "FireStroke"
                                                        }
                                                    },
                                                    {
                                                        42,
                                                        2,
                                                        {
                                                            "Gold"
                                                        }
                                                    },
                                                    {
                                                        48,
                                                        2,
                                                        {
                                                            "Matrix"
                                                        }
                                                    },
                                                    {
                                                        46,
                                                        2,
                                                        {
                                                            "Lava"
                                                        }
                                                    },
                                                    {
                                                        49,
                                                        2,
                                                        {
                                                            "OceanicStroke"
                                                        }
                                                    },
                                                    {
                                                        47,
                                                        2,
                                                        {
                                                            "LavaStroke"
                                                        }
                                                    },
                                                    {
                                                        37,
                                                        2,
                                                        {
                                                            "ChromeStroke"
                                                        }
                                                    },
                                                    {
                                                        58,
                                                        2,
                                                        {
                                                            "Zebra"
                                                        }
                                                    },
                                                    {
                                                        57,
                                                        2,
                                                        {
                                                            "WaveStroke"
                                                        }
                                                    },
                                                    {
                                                        51,
                                                        2,
                                                        {
                                                            "RainbowOutline"
                                                        }
                                                    },
                                                    {
                                                        56,
                                                        2,
                                                        {
                                                            "SilverStroke"
                                                        }
                                                    },
                                                    {
                                                        43,
                                                        2,
                                                        {
                                                            "GoldStroke"
                                                        }
                                                    },
                                                    {
                                                        45,
                                                        2,
                                                        {
                                                            "IceStroke"
                                                        }
                                                    },
                                                    {
                                                        36,
                                                        2,
                                                        {
                                                            "Bubblegum"
                                                        }
                                                    },
                                                    {
                                                        50,
                                                        2,
                                                        {
                                                            "Rainbow"
                                                        }
                                                    },
                                                    {
                                                        40,
                                                        2,
                                                        {
                                                            "Ghost"
                                                        }
                                                    },
                                                    {
                                                        54,
                                                        2,
                                                        {
                                                            "ShineOutline"
                                                        }
                                                    },
                                                    {
                                                        41,
                                                        2,
                                                        {
                                                            "GhostStroke"
                                                        }
                                                    }
                                                }
                                            },
                                            {
                                                60,
                                                2,
                                                {
                                                    "wally"
                                                }
                                            }
                                        }
                                    }
                                }
                            },
                            {
                                71,
                                1,
                                {
                                    "sleitnick_trove@1.8.0"
                                },
                                {
                                    {
                                        72,
                                        2,
                                        {
                                            "trove"
                                        },
                                        {
                                            {
                                                74,
                                                2,
                                                {
                                                    "wally"
                                                }
                                            },
                                            {
                                                73,
                                                2,
                                                {
                                                    "init.test"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    },
                    {
                        11,
                        2,
                        {
                            "EzVisualz"
                        }
                    },
                    {
                        12,
                        2,
                        {
                            "Promise"
                        }
                    },
                    {
                        13,
                        2,
                        {
                            "Signal"
                        }
                    }
                }
            },
            {
                77,
                2,
                {
                    "luraphsdk"
                }
            },
            {
                8,
                1,
                {
                    "Modules"
                },
                {
                    {
                        9,
                        2,
                        {
                            "SafeCall"
                        }
                    }
                }
            }
        }
    }
}

-- Line offsets for debugging (only included when minifyTables is false)
local LineOffsets = {
    8,
    [3] = 91,
    [4] = 196,
    [5] = 254,
    [6] = 330,
    [7] = 434,
    [9] = 617,
    [11] = 682,
    [12] = 685,
    [13] = 692,
    [14] = 695,
    [17] = 698,
    [18] = 872,
    [19] = 1020,
    [20] = 1499,
    [21] = 1510,
    [22] = 1527,
    [23] = 1544,
    [24] = 1560,
    [25] = 1574,
    [26] = 1591,
    [27] = 1606,
    [28] = 1621,
    [29] = 1636,
    [30] = 1652,
    [31] = 1672,
    [32] = 1688,
    [33] = 1702,
    [34] = 1715,
    [35] = 1734,
    [36] = 1745,
    [37] = 1778,
    [38] = 1794,
    [39] = 1810,
    [40] = 1840,
    [41] = 1851,
    [42] = 1867,
    [43] = 1878,
    [44] = 1894,
    [45] = 1918,
    [46] = 1934,
    [47] = 1944,
    [48] = 1958,
    [49] = 1980,
    [50] = 1996,
    [51] = 2006,
    [52] = 2030,
    [53] = 2044,
    [54] = 2094,
    [55] = 2157,
    [56] = 2168,
    [57] = 2184,
    [58] = 2210,
    [59] = 2232,
    [60] = 2372,
    [62] = 2384,
    [63] = 4454,
    [65] = 6300,
    [66] = 6303,
    [68] = 6466,
    [69] = 6900,
    [70] = 7092,
    [72] = 7105,
    [73] = 12383,
    [74] = 12746,
    [75] = 7894,
    [76] = 12588,
    [77] = 12314
}

-- Misc AOT variable imports
local WaxVersion = "0.4.1"
local EnvName = "Fallen"

-- ++++++++ RUNTIME IMPL BELOW ++++++++ --

-- Localizing certain libraries and built-ins for runtime efficiency
local string, task, setmetatable, error, next, table, unpack, coroutine, script, type, require, pcall, tostring, tonumber, _VERSION =
      string, task, setmetatable, error, next, table, unpack, coroutine, script, type, require, pcall, tostring, tonumber, _VERSION

local table_insert = table.insert
local table_remove = table.remove
local table_freeze = table.freeze or function(t) return t end -- lol

local coroutine_wrap = coroutine.wrap

local string_sub = string.sub
local string_match = string.match
local string_gmatch = string.gmatch

-- The Lune runtime has its own `task` impl, but it must be imported by its builtin
-- module path, "@lune/task"
if _VERSION and string_sub(_VERSION, 1, 4) == "Lune" then
    local RequireSuccess, LuneTaskLib = pcall(require, "@lune/task")
    if RequireSuccess and LuneTaskLib then
        task = LuneTaskLib
    end
end

local task_defer = task and task.defer

-- If we're not running on the Roblox engine, we won't have a `task` global
local Defer = task_defer or function(f, ...)
    coroutine_wrap(f)(...)
end

-- ClassName "IDs"
local ClassNameIdBindings = {
    [1] = "Folder",
    [2] = "ModuleScript",
    [3] = "Script",
    [4] = "LocalScript",
    [5] = "StringValue",
}

local RefBindings = {} -- [RefId] = RealObject

local ScriptClosures = {}
local ScriptClosureRefIds = {} -- [ScriptClosure] = RefId
local StoredModuleValues = {}
local ScriptsToRun = {}

-- wax.shared __index/__newindex
local SharedEnvironment = {}

-- We're creating 'fake' instance refs soley for traversal of the DOM for require() compatibility
-- It's meant to be as lazy as possible
local RefChildren = {} -- [Ref] = {ChildrenRef, ...}

-- Implemented instance methods
local InstanceMethods = {
    GetFullName = { {}, function(self)
        local Path = self.Name
        local ObjectPointer = self.Parent

        while ObjectPointer do
            Path = ObjectPointer.Name .. "." .. Path

            -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
            ObjectPointer = ObjectPointer.Parent
        end

        return Path
    end},

    GetChildren = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)
        end

        return ReturnArray
    end},

    GetDescendants = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)

            for _, Descendant in next, Child:GetDescendants() do
                table_insert(ReturnArray, Descendant)
            end
        end

        return ReturnArray
    end},

    FindFirstChild = { {"string", "boolean?"}, function(self, name, recursive)
        local Children = RefChildren[self]

        for Child in next, Children do
            if Child.Name == name then
                return Child
            end
        end

        if recursive then
            for Child in next, Children do
                -- Yeah, Roblox follows this behavior- instead of searching the entire base of a
                -- ref first, the engine uses a direct recursive call
                return Child:FindFirstChild(name, true)
            end
        end
    end},

    FindFirstAncestor = { {"string"}, function(self, name)
        local RefPointer = self.Parent
        while RefPointer do
            if RefPointer.Name == name then
                return RefPointer
            end

            RefPointer = RefPointer.Parent
        end
    end},

    -- Just to implement for traversal usage
    WaitForChild = { {"string", "number?"}, function(self, name)
        return self:FindFirstChild(name)
    end},
}

-- "Proxies" to instance methods, with err checks etc
local InstanceMethodProxies = {}
for MethodName, MethodObject in next, InstanceMethods do
    local Types = MethodObject[1]
    local Method = MethodObject[2]

    local EvaluatedTypeInfo = {}
    for ArgIndex, TypeInfo in next, Types do
        local ExpectedType, IsOptional = string_match(TypeInfo, "^([^%?]+)(%??)")
        EvaluatedTypeInfo[ArgIndex] = {ExpectedType, IsOptional}
    end

    InstanceMethodProxies[MethodName] = function(self, ...)
        if not RefChildren[self] then
            error("Expected ':' not '.' calling member function " .. MethodName, 2)
        end

        local Args = {...}
        for ArgIndex, TypeInfo in next, EvaluatedTypeInfo do
            local RealArg = Args[ArgIndex]
            local RealArgType = type(RealArg)
            local ExpectedType, IsOptional = TypeInfo[1], TypeInfo[2]

            if RealArg == nil and not IsOptional then
                error("Argument " .. RealArg .. " missing or nil", 3)
            end

            if ExpectedType ~= "any" and RealArgType ~= ExpectedType and not (RealArgType == "nil" and IsOptional) then
                error("Argument " .. ArgIndex .. " expects type \"" .. ExpectedType .. "\", got \"" .. RealArgType .. "\"", 2)
            end
        end

        return Method(self, ...)
    end
end

local function CreateRef(className, name, parent)
    -- `name` and `parent` can also be set later by the init script if they're absent

    -- Extras
    local StringValue_Value

    -- Will be set to RefChildren later aswell
    local Children = setmetatable({}, {__mode = "k"})

    -- Err funcs
    local function InvalidMember(member)
        error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 3)
    end
    local function ReadOnlyProperty(property)
        error("Unable to assign (virtual) property " .. property .. ". Property is read only", 3)
    end

    local Ref = {}
    local RefMetatable = {}

    RefMetatable.__metatable = false

    RefMetatable.__index = function(_, index)
        if index == "ClassName" then -- First check "properties"
            return className
        elseif index == "Name" then
            return name
        elseif index == "Parent" then
            return parent
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            return StringValue_Value
        else -- Lastly, check "methods"
            local InstanceMethod = InstanceMethodProxies[index]

            if InstanceMethod then
                return InstanceMethod
            end
        end

        -- Next we'll look thru child refs
        for Child in next, Children do
            if Child.Name == index then
                return Child
            end
        end

        -- At this point, no member was found; this is the same err format as Roblox
        InvalidMember(index)
    end

    RefMetatable.__newindex = function(_, index, value)
        -- __newindex is only for props fyi
        if index == "ClassName" then
            ReadOnlyProperty(index)
        elseif index == "Name" then
            name = value
        elseif index == "Parent" then
            -- We'll just ignore the process if it's trying to set itself
            if value == Ref then
                return
            end

            if parent ~= nil then
                -- Remove this ref from the CURRENT parent
                RefChildren[parent][Ref] = nil
            end

            parent = value

            if value ~= nil then
                -- And NOW we're setting the new parent
                RefChildren[value][Ref] = true
            end
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            StringValue_Value = value
        else
            -- Same err as __index when no member is found
            InvalidMember(index)
        end
    end

    RefMetatable.__tostring = function()
        return name
    end

    setmetatable(Ref, RefMetatable)

    RefChildren[Ref] = Children

    if parent ~= nil then
        RefChildren[parent][Ref] = true
    end

    return Ref
end

-- Create real ref DOM from object tree
local function CreateRefFromObject(object, parent)
    local RefId = object[1]
    local ClassNameId = object[2]
    local Properties = object[3] -- Optional
    local Children = object[4] -- Optional

    local ClassName = ClassNameIdBindings[ClassNameId]

    local Name = Properties and table_remove(Properties, 1) or ClassName

    local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
    RefBindings[RefId] = Ref

    if Properties then
        for PropertyName, PropertyValue in next, Properties do
            Ref[PropertyName] = PropertyValue
        end
    end

    if Children then
        for _, ChildObject in next, Children do
            CreateRefFromObject(ChildObject, Ref)
        end
    end

    return Ref
end

local RealObjectRoot = CreateRef("Folder", "[" .. EnvName .. "]")
for _, Object in next, ObjectTree do
    CreateRefFromObject(Object, RealObjectRoot)
end

-- Now we'll set script closure refs and check if they should be ran as a BaseScript
for RefId, Closure in next, ClosureBindings do
    local Ref = RefBindings[RefId]

    ScriptClosures[Ref] = Closure
    ScriptClosureRefIds[Ref] = RefId

    local ClassName = Ref.ClassName
    if ClassName == "LocalScript" or ClassName == "Script" then
        table_insert(ScriptsToRun, Ref)
    end
end

local function LoadScript(scriptRef)
    local ScriptClassName = scriptRef.ClassName

    -- First we'll check for a cached module value (packed into a tbl)
    local StoredModuleValue = StoredModuleValues[scriptRef]
    if StoredModuleValue and ScriptClassName == "ModuleScript" then
        return unpack(StoredModuleValue)
    end

    local Closure = ScriptClosures[scriptRef]

    local function FormatError(originalErrorMessage)
        originalErrorMessage = tostring(originalErrorMessage)

        local VirtualFullName = scriptRef:GetFullName()

        -- Check for vanilla/Roblox format
        local OriginalErrorLine, BaseErrorMessage = string_match(originalErrorMessage, "[^:]+:(%d+): (.+)")

        if not OriginalErrorLine or not LineOffsets then
            return VirtualFullName .. ":*: " .. (BaseErrorMessage or originalErrorMessage)
        end

        OriginalErrorLine = tonumber(OriginalErrorLine)

        local RefId = ScriptClosureRefIds[scriptRef]
        local LineOffset = LineOffsets[RefId]

        local RealErrorLine = OriginalErrorLine - LineOffset + 1
        if RealErrorLine < 0 then
            RealErrorLine = "?"
        end

        return VirtualFullName .. ":" .. RealErrorLine .. ": " .. BaseErrorMessage
    end

    -- If it's a BaseScript, we'll just run it directly!
    if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
        local RunSuccess, ErrorMessage = xpcall(Closure, function(msg)
            return msg
        end)
        if not RunSuccess then
            error(FormatError(ErrorMessage), 0)
        end
    else
        local PCallReturn = {xpcall(Closure, function(msg)
            return msg
        end)}

        local RunSuccess = table_remove(PCallReturn, 1)
        if not RunSuccess then
            local ErrorMessage = table_remove(PCallReturn, 1)
            error(FormatError(ErrorMessage), 0)
        end

        StoredModuleValues[scriptRef] = PCallReturn
        return unpack(PCallReturn)
    end
end

-- We'll assign the actual func from the top of this output for flattening user globals at runtime
-- Returns (in a tuple order): wax, script, require
function ImportGlobals(refId)
    local ScriptRef = RefBindings[refId]

    local function RealCall(f, ...)
        local PCallReturn = {xpcall(f, function(msg)
            return debug.traceback(msg, 2)
        end, ...)}

        local CallSuccess = table_remove(PCallReturn, 1)
        if not CallSuccess then
            error(PCallReturn[1], 3)
        end

        return unpack(PCallReturn)
    end

    -- `wax.shared` index
    local WaxShared = table_freeze(setmetatable({}, {
        __index = SharedEnvironment,
        __newindex = function(_, index, value)
            SharedEnvironment[index] = value
        end,
        __len = function()
            return #SharedEnvironment
        end,
        __iter = function()
            return next, SharedEnvironment
        end,
    }))

    local Global_wax = table_freeze({
        -- From AOT variable imports
        version = WaxVersion,
        envname = EnvName,

        shared = WaxShared,

        -- "Real" globals instead of the env set ones
        script = script,
        require = require,
    })

    local Global_script = ScriptRef

    local function Global_require(module, ...)
        local ModuleArgType = type(module)

        local ErrorNonModuleScript = "Attempted to call require with a non-ModuleScript"
        local ErrorSelfRequire = "Attempted to call require with self"

        if ModuleArgType == "table" and RefChildren[module]  then
            if module.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif module == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(module)
        elseif ModuleArgType == "string" and string_sub(module, 1, 1) ~= "@" then
            -- The control flow on this SUCKS

            if #module == 0 then
                error("Attempted to call require with empty string", 2)
            end

            local CurrentRefPointer = ScriptRef

            if string_sub(module, 1, 1) == "/" then
                CurrentRefPointer = RealObjectRoot
            elseif string_sub(module, 1, 2) == "./" then
                module = string_sub(module, 3)
            end

            local PreviousPathMatch
            for PathMatch in string_gmatch(module, "([^/]*)/?") do
                local RealIndex = PathMatch
                if PathMatch == ".." then
                    RealIndex = "Parent"
                end

                -- Don't advance dir if it's just another "/" either
                if RealIndex ~= "" then
                    local ResultRef = CurrentRefPointer:FindFirstChild(RealIndex)
                    if not ResultRef then
                        local CurrentRefParent = CurrentRefPointer.Parent
                        if CurrentRefParent then
                            ResultRef = CurrentRefParent:FindFirstChild(RealIndex)
                        end
                    end

                    if ResultRef then
                        CurrentRefPointer = ResultRef
                    elseif PathMatch ~= PreviousPathMatch and PathMatch ~= "init" and PathMatch ~= "init.server" and PathMatch ~= "init.client" then
                        error("Virtual script path \"" .. module .. "\" not found", 2)
                    end
                end

                -- For possible checks next cycle
                PreviousPathMatch = PathMatch
            end

            if CurrentRefPointer.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif CurrentRefPointer == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(CurrentRefPointer)
        end

        return RealCall(require, module, ...)
    end

    -- Now, return flattened globals ready for direct runtime exec
    return Global_wax, Global_script, Global_require
end

for _, ScriptRef in next, ScriptsToRun do
    Defer(LoadScript, ScriptRef)
end
