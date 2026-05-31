local Trove = require(script.Parent.Parent.Packages.Trove)
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
