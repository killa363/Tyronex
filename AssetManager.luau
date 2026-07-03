local HttpService = cloneref(game:GetService("HttpService"))

type AssetCallback = (string) -> ()
type AssetListCallback = () -> ()

local getcustomasset = getcustomasset or function(_Path: string): string?
    return nil
end

local AssetManager = {
    AssetDirectory = "Tyronex/Assets",
    Repo = "killa363/Tyronex",
    Branch = "main",
    Assets = {} :: { [string]: string | boolean },
    AssetList = {} :: { string },
    AssetMap = {} :: { [string]: string },
    LocalAssetsIndexed = false,
    AssetListFetched = false,
    AssetListFetching = false,
    AssetListCallbacks = {} :: { AssetListCallback },
    AssetCallbacks = {} :: { [string]: { AssetCallback } },
    AssetDownloading = {} :: { [string]: boolean },
}

function AssetManager.IsAssetFile(self: AssetManager, RelativePath: string): string?
    return RelativePath:match("%.png$")
        or RelativePath:match("%.jpg$")
        or RelativePath:match("%.jpeg$")
        or RelativePath:match("%.webp$")
        or RelativePath:match("%.ogg$")
        or RelativePath:match("%.mp3$")
        or RelativePath:match("%.wav$")
        or RelativePath:match("%.flac$")
        or RelativePath:match("%.m4a$")
        or RelativePath:match("%.ttf$")
        or RelativePath:match("%.otf$")
        or RelativePath:match("%.rbxm$")
        or RelativePath:match("%.rbxmx$")   
end

function AssetManager.RegisterAssetPath(self: AssetManager, RelativePath: string)
    RelativePath = RelativePath:gsub("\\", "/")

    self.AssetMap[RelativePath] = RelativePath

    local Name = RelativePath:match("([^/\\]+)$")
    local BaseName = Name and Name:match("^(.*)%.") or Name

    if Name then
        self.AssetMap[Name] = RelativePath
    end

    if BaseName then
        self.AssetMap[BaseName] = RelativePath
    end
end

function AssetManager.IndexLocalAssets(self: AssetManager)
    if self.LocalAssetsIndexed then
        return
    end

    self.LocalAssetsIndexed = true

    if type(listfiles) ~= "function" or not isfolder(self.AssetDirectory) then
        return
    end

    local Root = self.AssetDirectory:gsub("\\", "/")

    local function Scan(Directory: string)
        for _, Path in listfiles(Directory) do
            if isfolder(Path) then
                Scan(Path)
            elseif isfile(Path) then
                local NormalizedPath = Path:gsub("\\", "/")
                local RelativePath = NormalizedPath:match(Root .. "/(.+)$") or NormalizedPath:match("Assets/(.+)$")

                if RelativePath and self:IsAssetFile(RelativePath) then
                    self:RegisterAssetPath(RelativePath)
                end
            end
        end
    end

    Scan(self.AssetDirectory)
end

function AssetManager.GetDownloadUrl(self: AssetManager, AssetName: string): string?
    local AssetPath = self:ResolveAssetPath(AssetName) or AssetName

	if table.find(self.AssetList, AssetPath) or AssetPath:match("%.[^/\\]+$") then
		local EncodedPath = AssetPath:gsub("\\", "/"):gsub("[^/]+", function(Segment)
			return HttpService:UrlEncode(Segment):gsub("%+", "%%20")
		end)

		return `https://raw.githubusercontent.com/{self.Repo}/{self.Branch}/Assets/{EncodedPath}`
	end
	return nil
end

function AssetManager.GetCachedAsset(self: AssetManager, AssetName: string): string?
    local Cached = self.Assets[AssetName]
    if type(Cached) == "string" then
        return Cached
    end

    self:IndexLocalAssets()

    local FileName = self:ResolveLocalPath(AssetName)
    local CachedFile = self.Assets[FileName]
    if type(CachedFile) == "string" then
        return CachedFile
    end

    local FullPath = `{self.AssetDirectory}/{FileName}`
    if not isfile(FullPath) then
        return nil
    end

    local Success, AssetUrl = pcall(getcustomasset, FullPath)
    if Success and type(AssetUrl) == "string" then
        self.Assets[AssetName] = AssetUrl
        self.Assets[FileName] = AssetUrl

        local BaseName = FileName:match("([^/\\]+)$")
        if BaseName then
            self.Assets[BaseName] = AssetUrl

            local NoExt = BaseName:match("^(.+)%.[^%.]+$")
            if NoExt then
                self.Assets[NoExt] = AssetUrl
            end
        end

        return AssetUrl
    end
    return nil
end

function AssetManager.FlushAssetCallbacks(self: AssetManager, AssetName: string, AssetUrl: string?)
    local Callbacks = self.AssetCallbacks[AssetName]
    self.AssetCallbacks[AssetName] = nil
    self.AssetDownloading[AssetName] = nil

    if not Callbacks or not AssetUrl then
        return
    end

    for _, Callback in Callbacks do
        task.spawn(Callback, AssetUrl)
    end
end

function AssetManager.GetAssetAsync(self: AssetManager, AssetName: string, Callback: (string) -> ())
    local Cached = self:GetCachedAsset(AssetName)
    if Cached then
        task.spawn(Callback, Cached)
        return
    end

    self.AssetCallbacks[AssetName] = self.AssetCallbacks[AssetName] or {}
    table.insert(self.AssetCallbacks[AssetName], Callback)

    if self.AssetDownloading[AssetName] then
        return
    end

    self.AssetDownloading[AssetName] = true

    self:IndexLocalAssets()
    if not self.AssetMap[AssetName] and not self.AssetListFetched then
        self:OnAssetListReady(function()
            local Asset = self:GetAsset(AssetName)
            self:FlushAssetCallbacks(AssetName, Asset)
        end)
        return
    end

    task.spawn(function()
        local Asset = self:GetAsset(AssetName)
        self:FlushAssetCallbacks(AssetName, Asset)
    end)
end

function AssetManager.FetchAssetListFromGitHub(self: AssetManager): boolean
    if self.AssetListFetched then
        self:IndexLocalAssets()
        return true
    end

    local Success: boolean, Result: any = pcall(function()
        local BranchRequest = request({
            Url = `https://api.github.com/repos/{self.Repo}/branches/{self.Branch}`,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Roblox/AssetManager"
            }
        })

        if BranchRequest.StatusCode ~= 200 then
            return false
        end

        local BranchData: any = HttpService:JSONDecode(BranchRequest.Body)
        local TreeSha = BranchData.commit and BranchData.commit.commit and BranchData.commit.commit.tree and BranchData.commit.commit.tree.sha
        if type(TreeSha) ~= "string" then
            return false
        end

        local TreeRequest = request({
            Url = `https://api.github.com/repos/{self.Repo}/git/trees/{TreeSha}?recursive=1`,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Roblox/AssetManager"
            }
        })

        if TreeRequest.StatusCode == 200 then
            local Data: any = HttpService:JSONDecode(TreeRequest.Body)

            self.AssetList = {}
            self.AssetMap = {}
            self.LocalAssetsIndexed = false
            self.AssetListFetched = true
            self.AssetListFetching = false
            for _, File in Data.tree do
                if File.type == "blob" and type(File.path) == "string" and File.path:match("^Assets/") then
                    local RelativePath = File.path:sub(8)

                    if self:IsAssetFile(RelativePath) then
                        table.insert(self.AssetList, RelativePath)
                        self:RegisterAssetPath(RelativePath)
                    end
                end
            end

            self:IndexLocalAssets()

            return true
        else
            return false
        end
    end)

    self.AssetListFetching = false

    if Success and Result then
        local Callbacks = self.AssetListCallbacks
        self.AssetListCallbacks = {}

        for _, Callback in Callbacks do
            task.spawn(Callback)
        end
    end

    return Success and Result
end

function AssetManager.FetchAssetListAsync(self: AssetManager)
    if self.AssetListFetched or self.AssetListFetching then
        return
    end

    self.AssetListFetching = true
    task.spawn(function()
        self:FetchAssetListFromGitHub()
    end)
end

function AssetManager.OnAssetListReady(self: AssetManager, Callback: () -> ())
    if self.AssetListFetched then
        task.spawn(Callback)
        return
    end

    table.insert(self.AssetListCallbacks, Callback)
    self:FetchAssetListAsync()
end

function AssetManager.ResolveAssetPath(self: AssetManager, AssetName: string): string?
    self:IndexLocalAssets()

    if self.AssetMap[AssetName] then
        return self.AssetMap[AssetName]
    end

    local Normalized = AssetName:gsub("^Assets[\\/]+", ""):gsub("\\", "/")
    if self.AssetMap[Normalized] then
        return self.AssetMap[Normalized]
    end

    local FileName = Normalized:match("([^/]+)$") or Normalized
    local BaseName = FileName:match("^(.*)%.") or FileName

    if self.AssetMap[FileName] then
        return self.AssetMap[FileName]
    end

    if self.AssetMap[BaseName] then
        return self.AssetMap[BaseName]
    end

    for _, Candidate in self.AssetList do
        local CandidateName = Candidate:match("([^/\\]+)$")
        local CandidateBase = CandidateName and CandidateName:match("^(.*)%.") or CandidateName
        if Candidate == Normalized or CandidateName == FileName or CandidateBase == BaseName then
            return Candidate
        end
    end
    return nil
end

function AssetManager.ResolveLocalPath(self: AssetManager, AssetName: string): string
    local AssetPath = self:ResolveAssetPath(AssetName)
    local Resolved = AssetPath or AssetName
    if not AssetPath and not Resolved:match("%.[^/\\]+$") then
        return Resolved .. ".png"
    end

    return Resolved
end

function AssetManager.Preload(self: AssetManager)
    if not isfolder(self.AssetDirectory) then
        makefolder(self.AssetDirectory)
    end

    self:FetchAssetListFromGitHub()
end

function AssetManager.PreloadCoreAssets(self: AssetManager)
    if not isfolder(self.AssetDirectory) then
        makefolder(self.AssetDirectory)
    end

    self:FetchAssetListAsync()
end

function AssetManager.Initialize(self: AssetManager, OnProgress: ((number, number, string) -> ())?, ShouldCancel: (() -> boolean)?)
    if not isfolder(self.AssetDirectory) then
        makefolder(self.AssetDirectory)
    end

    if ShouldCancel and ShouldCancel() then
        return
    end

    if not self.AssetListFetched then
        self:FetchAssetListFromGitHub()
    end

    if ShouldCancel and ShouldCancel() then
        return
    end

    if #self.AssetList > 0 then
        self:LoadAssets(OnProgress, ShouldCancel)
    end
end

function AssetManager.DownloadAsset(self: AssetManager, AssetName: string): (boolean, string?)
    local RelativePath = self:ResolveLocalPath(AssetName)
    local FullPath = `{self.AssetDirectory}/{RelativePath}`

    if isfile(FullPath) then
        return true, "Asset already exists"
    end

    local Success, Result, Message = pcall(function(): (boolean, string?)
        local DownloadUrl = self:GetDownloadUrl(AssetName)
        if not DownloadUrl then
            return false, "Unknown asset path"
        end

        local Request = request({
            Url = DownloadUrl,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Roblox/AssetManager"
            }
        })

        if Request.StatusCode == 200 then
            local Parent = FullPath:match("^(.*)[/\\][^/\\]+$")
            if Parent and not isfolder(Parent) then
                makefolder(Parent)
            end
            writefile(FullPath, Request.Body)
            return true, "Downloaded successfully"
        else
            return false, `Status code: {Request.StatusCode}`
        end
    end)

    if Success and type(Result) == "boolean" then
        return Result, Message
    end

    return false, tostring(Result)
end

function AssetManager.LoadAssets(self: AssetManager, OnProgress: ((number, number, string) -> ())?, ShouldCancel: (() -> boolean)?)
    local Total: number = #self.AssetList

    for Index, AssetPath in self.AssetList do
        if ShouldCancel and ShouldCancel() then
            break
        end

        local Success: boolean = self:DownloadAsset(AssetPath)

        if ShouldCancel and ShouldCancel() then
            break
        end

        if Success then
            local FullPath = `{self.AssetDirectory}/{AssetPath}`
            local Ok, Url = pcall(getcustomasset, FullPath)
            self.Assets[AssetPath] = Ok and type(Url) == "string" and Url or true

            local Name = AssetPath:match("([^/\\]+)$")
            local NoExt = Name and Name:match("^(.+)%.")
            if NoExt then
                self.Assets[NoExt] = Ok and type(Url) == "string" and Url or true
                self.Assets[Name] = Ok and type(Url) == "string" and Url or true
            end
        end

        if OnProgress then
            OnProgress(Index, Total, AssetPath)
        end
    end
end

function AssetManager.LoadAssetsAsync(self: AssetManager, OnProgress: ((number, number, string) -> ())?, OnComplete: ((number) -> ())?, ShouldCancel: (() -> boolean)?)
    task.spawn(function()
        self:Initialize(OnProgress, ShouldCancel)

        if OnComplete and not (ShouldCancel and ShouldCancel()) then
            OnComplete(#self.AssetList)
        end
    end)
end

function AssetManager.GetAsset(self: AssetManager, AssetName: string): string?
    local cached = self.Assets[AssetName]
    if type(cached) == "string" then return cached end

    self:IndexLocalAssets()

    local AssetPath = self:ResolveAssetPath(AssetName)
    if not AssetPath and not self.AssetListFetched then
        self:FetchAssetListFromGitHub()
        AssetPath = self:ResolveAssetPath(AssetName)
    end

    if not AssetPath and not AssetName:match("%.[^/\\]+$") then
        return nil
    end

    local FileName: string = self:ResolveLocalPath(AssetName)
    local cached2 = self.Assets[FileName]
    if type(cached2) == "string" then return cached2 end

    local FullPath: string = `{self.AssetDirectory}/{FileName}`
    if not isfile(FullPath) then
        local Success: boolean = self:DownloadAsset(FileName)
        if not Success then return end
    end

    local Success, AssetUrl = pcall(getcustomasset, FullPath)
    if Success and type(AssetUrl) == "string" then
        self.Assets[AssetName] = AssetUrl
        self.Assets[FileName] = AssetUrl
        local BaseName = FileName:match("([^/\\]+)$")
        if BaseName then
            self.Assets[BaseName] = AssetUrl
            local NoExt = BaseName:match("^(.+)%.[^%.]+$")
            if NoExt then
                self.Assets[NoExt] = AssetUrl
            end
        end
        return AssetUrl
    end

    return nil
end

function AssetManager.ClearCache(self: AssetManager)
    if isfolder(self.AssetDirectory) then
        local Seen = {}
        for _, AssetName in self.AssetList do
            if not Seen[AssetName] then
                Seen[AssetName] = true
                local FullPath: string = `{self.AssetDirectory}/{AssetName}`
                if isfile(FullPath) then
                    delfile(FullPath)
                end
            end
        end
        self.Assets = {}
        self.AssetMap = {}
    end
end

function AssetManager.AssetExists(self: AssetManager, AssetName: string): boolean
    local FileName: string = self:ResolveLocalPath(AssetName)
    return isfile(`{self.AssetDirectory}/{FileName}`)
end

type AssetManager = typeof(AssetManager)

return AssetManager :: AssetManager
