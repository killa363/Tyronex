if getgenv().Executed then 
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
