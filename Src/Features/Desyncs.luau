local Trove = require(script.Parent.Parent.Packages.Trove)
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
