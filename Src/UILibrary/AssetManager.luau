local HttpService = cloneref(game:GetService("HttpService"))

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
