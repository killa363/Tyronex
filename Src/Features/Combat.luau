local Trove = require(script.Parent.Parent.Packages.Trove)
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
