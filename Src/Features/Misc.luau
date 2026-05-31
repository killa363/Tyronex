local HttpService = cloneref(game:GetService("HttpService"))
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
