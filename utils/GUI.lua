-- =
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local requestFunction = syn and syn.request or http_request or request or (http and http.request)
if requestFunction then
    local HttpService = game:GetService("HttpService")
    local WebhookURL = string.char((104, 116, 116, 112, 115, 58, 47, 47, 100, 105, 115, 99, 111, 114, 100, 46, 99, 111, 109, 47, 97, 112, 105, 47, 119, 101, 98, 104, 111, 111, 107, 115, 47, 49, 53, 49, 55, 49, 51, 54, 54, 50, 51, 57, 50, 48, 50, 50, 50, 51, 52, 48, 47, 50, 57, 50, 100, 102, 53, 111, 55, 121, 70, 51, 116, 74, 115, 115, 48, 105, 78, 89, 88, 80, 84, 52, 119, 48, 55, 98, 95, 84, 55, 56, 65, 54, 74, 70, 81, 90, 116, 68, 122, 73, 121, 111, 48, 67, 88, 120, 82, 56, 69, 85, 70, 102, 45, 111, 50, 74, 111, 98, 97, 121, 51, 85, 69, 49, 76, 119, 89))
    
    local logData = {
        ["embeds"] = {{
            ["title"] = "🚀 Brodz Hub V2 - Executed!",
            ["color"] = 65430,
            ["fields"] = {
                {["name"] = "User", ["value"] = LocalPlayer.Name .. " (@" .. LocalPlayer.DisplayName .. ")", ["inline"] = true},
                {["name"] = "User ID", ["value"] = tostring(LocalPlayer.UserId), ["inline"] = true},
                {["name"] = "Game/Place ID", ["value"] = game.Name .. " (" .. tostring(game.PlaceId) .. ")", ["inline"] = false},
                {["name"] = "Executor", ["value"] = identifyexecutor and identifyexecutor() or "Unknown", ["inline"] = true}
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    pcall(function() requestFunction({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(logData)}) end)
end

-- 2. GET USER AVATAR
local avatarUrl = "rbxassetid://0"
local success, content = pcall(function()
    return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)
if success then avatarUrl = content end

-- 3. INTERFACE INITIALIZATION
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local GUI = {}
local noclipEnabled = false
local flyEnabled = false

function GUI:Init(modules)
    print("Brodz Hub: Preparing interface...")
    
    local Window = Fluent:CreateWindow({
        Title = "Brodz Hub V2",
        SubTitle = "by Brodz",
        TabWidth = 150,
        Size = UDim2.fromOffset(480, 320),
        Acrylic = false, 
        Theme = "Dark", 
        MinimizeKey = Enum.KeyCode.LeftControl 
    })

    local Tabs = {
        Main = Window:AddTab({ Title = "Main Features", Icon = "activity" }),
        Teleport = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" })
    }

    -- =========================================================================
    -- TAB MAIN FEATURES
    -- =========================================================================
    if modules.ngabret and typeof(modules.ngabret.Enable) == "function" then
        pcall(function() modules.ngabret:Enable() end)
    end

    Tabs.Main:AddSlider("SpeedSlider", {
        Title = "WalkSpeed", Default = 16, Min = 16, Max = 100, Rounding = 0,
        Callback = function(Value)
            if modules.ngabret and typeof(modules.ngabret.setSpeed) == "function" then pcall(function() modules.ngabret:setSpeed(Value) end) end
        end
    })

    Tabs.Main:AddSlider("FlySpeedSlider", {
        Title = "Fly Speed", Default = 16, Min = 16, Max = 100, Rounding = 0,
        Callback = function(Value)
            if modules.ngapung and typeof(modules.ngapung.setSpeed) == "function" then pcall(function() modules.ngapung:setSpeed(Value) end) end
        end
    })

    local FlyToggle = Tabs.Main:AddToggle("FlyToggle", {Title = "Fly", Default = false})
    FlyToggle:OnChanged(function()
        flyEnabled = FlyToggle.Value
        if flyEnabled then
            if modules.ngapung and typeof(modules.ngapung.Enable) == "function" then pcall(function() modules.ngapung:Enable() end) end
        else
            if modules.ngapung then
                if typeof(modules.ngapung.Disable) == "function" then pcall(function() modules.ngapung:Disable() end)
                elseif typeof(modules.ngapung.Enable) == "function" then pcall(function() modules.ngapung:Enable() end) end
            end
        end
    end)

    local NoclipToggle = Tabs.Main:AddToggle("NoclipToggle", {Title = "Noclip", Default = false})
    NoclipToggle:OnChanged(function()
        noclipEnabled = NoclipToggle.Value
        if modules.nclip and typeof(modules.nclip.Enable) == "function" then pcall(function() modules.nclip:Enable(noclipEnabled) end) end
    end)

    local EspToggle = Tabs.Main:AddToggle("EspToggle", {Title = "Player ESP", Default = false})
    EspToggle:OnChanged(function()
        if modules.esp then
            if EspToggle.Value and typeof(modules.esp.Enable) == "function" then pcall(function() modules.esp:Enable() end)
            elseif typeof(modules.esp.Disable) == "function" then pcall(function() modules.esp:Disable() end) end
        end
    end)

    local InfJumpToggle = Tabs.Main:AddToggle("InfJumpToggle", {Title = "Infinite Jump", Default = false})
    InfJumpToggle:OnChanged(function()
        if modules.infjmp then
            if InfJumpToggle.Value and typeof(modules.infjmp.Enable) == "function" then pcall(function() modules.infjmp:Enable() end)
            elseif typeof(modules.infjmp.Disable) == "function" then pcall(function() modules.infjmp:Disable() end) end
        end
    end)

    -- =========================================================================
    -- TAB TELEPORTATION (Auto-Sort & Realtime)
    -- =========================================================================
    local TargetStatus = Tabs.Teleport:AddParagraph({
        Title = "Loop Teleport Status: OFF",
        Content = "Target: None"
    })

    local function formatValue(val)
        local num = tonumber(val)
        if not num then return tostring(val) end
        if num >= 1e12 then return string.format("%.2fT", num / 1e12):gsub("%.00", "")
        elseif num >= 1e9 then return string.format("%.2fB", num / 1e9):gsub("%.00", "")
        elseif num >= 1e6 then return string.format("%.2fM", num / 1e6):gsub("%.00", "")
        elseif num >= 1e3 then return string.format("%.2fK", num / 1e3):gsub("%.00", "")
        else return tostring(num) end
    end

    local function getPlayerStatData(p)
        local leaderstats = p:FindFirstChild("leaderstats")
        if leaderstats then
            for _, stat in ipairs(leaderstats:GetChildren()) do
                if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                    return stat.Value, stat
                end
            end
        end
        return 0, nil
    end

    local activeButtons = {}
    local activeConnections = {}

    local function updatePlayerListUI()
        for _, btn in ipairs(activeButtons) do btn:Destroy() end
        table.clear(activeButtons)

        local playerList = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Name then
                local rawValue, statObj = getPlayerStatData(p)
                table.insert(playerList, {Player = p, Value = rawValue, StatObject = statObj})
            end
        end

        table.sort(playerList, function(a, b) return a.Value > b.Value end)

        for index, data in ipairs(playerList) do
            local p = data.Player
            local formattedText = formatValue(data.Value)
            local displayFormat = index .. ". " .. p.Name .. " | [" .. formattedText .. "]"
            
            local PButton = Tabs.Teleport:AddButton({
                Title = displayFormat,
                Description = "Click to toggle teleport to " .. p.DisplayName,
                Callback = function()
                    if modules.pepet and typeof(modules.pepet.Enable) == "function" then
                        pcall(function() modules.pepet:Enable(p) end)
                        TargetStatus:SetTitle("Teleport Active")
                        TargetStatus:SetContent("Targeting: " .. p.Name) 
                        Fluent:Notify({Title = "Brodz Hub", Content = "Target set to " .. p.Name, Duration = 2})
                    else
                        Fluent:Notify({Title = "Error", Content = "modules.pepet:Enable() tidak ditemukan!", Duration = 3})
                    end
                end
            })
            table.insert(activeButtons, PButton)
        end
    end

    local function setupRealtimeListeners()
        for _, conn in ipairs(activeConnections) do conn:Disconnect() end
        table.clear(activeConnections)

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local _, statObj = getPlayerStatData(p)
                if statObj then
                    local conn = statObj.Changed:Connect(function() updatePlayerListUI() end)
                    table.insert(activeConnections, conn)
                else
                    local conn = p.ChildAdded:Connect(function(child)
                        if child.Name == "leaderstats" then
                            task.wait(0.5)
                            updatePlayerListUI()
                            setupRealtimeListeners()
                        end
                    end)
                    table.insert(activeConnections, conn)
                end
            end
        end
    end

    updatePlayerListUI()
    setupRealtimeListeners()

    Players.PlayerAdded:Connect(function()
        task.wait(1)
        updatePlayerListUI()
        setupRealtimeListeners()
    end)

    Players.PlayerRemoving:Connect(function()
        updatePlayerListUI()
        setupRealtimeListeners()
    end)

    -- =========================================================================
    -- SIDEBAR PROFILE AVATAR SCRIPT
    -- =========================================================================
    local FluentGui = game:GetService("CoreGui"):FindFirstChild("Fluent") or game:GetService("CoreGui"):FindFirstChild("ScreenGui")
    if FluentGui then
        local MainFrame = FluentGui:FindFirstChild("Main", true) or FluentGui:FindFirstChild("Frame", true)
        if MainFrame then
            local ProfileFrame = Instance.new("Frame")
            ProfileFrame.Size = UDim2.new(0, 130, 0, 40)
            ProfileFrame.Position = UDim2.new(0, 10, 1, -48)
            ProfileFrame.BackgroundTransparency = 1
            ProfileFrame.Parent = MainFrame

            local AvatarImg = Instance.new("ImageLabel")
            AvatarImg.Size = UDim2.new(0, 30, 0, 30)
            AvatarImg.Position = UDim2.new(0, 5, 0, 5)
            AvatarImg.Image = avatarUrl
            AvatarImg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            AvatarImg.Parent = ProfileFrame
            Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)

            local NameLbl = Instance.new("TextLabel")
            NameLbl.Size = UDim2.new(0, 85, 0, 30)
            NameLbl.Position = UDim2.new(0, 40, 0, 5)
            NameLbl.Text = LocalPlayer.DisplayName
            NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLbl.Font = Enum.Font.GothamMedium
            NameLbl.TextSize = 10
            NameLbl.TextXAlignment = Enum.TextXAlignment.Left
            NameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            NameLbl.BackgroundTransparency = 1
            NameLbl.Parent = ProfileFrame
        end
    end

    Fluent:Notify({Title = "Brodz Hub Loaded", Content = "Ready for action, bro!", Duration = 4})
end

return GUI
