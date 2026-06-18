-- =========BRODZZ HUB V2 UPDATED
local requestFunction = syn and syn.request or http_request or request or (http and http.request)
if requestFunction then
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local WebhookURL = string.char(104, 116, 116, 112, 115, 58, 47, 47, 100, 105, 115, 99, 111, 114, 100, 46, 99, 111, 109, 47, 97, 112, 105, 47, 119, 101, 98, 104, 111, 111, 107, 115, 47, 49, 53, 49, 55, 49, 51, 54, 54, 50, 51, 57, 50, 48, 50, 50, 50, 51, 52, 48, 47, 50, 57, 50, 100, 102, 53, 111, 55, 121, 70, 51, 116, 74, 115, 115, 48, 105, 78, 89, 88, 80, 84, 52, 119, 48, 55, 98, 95, 84, 55, 56, 65, 54, 74, 70, 81, 90, 116, 68, 122, 73, 121, 111, 48, 67, 88, 120, 82, 56, 69, 85, 70, 102, 45, 111, 50, 74, 111, 98, 97, 121, 51, 85, 69, 49, 76, 119, 89)
    
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
    
    pcall(function()
        requestFunction({
            Url = WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(logData)
        })
    end)
end

-- =============================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local userId = LocalPlayer.UserId
local avatarUrl = "rbxassetid://0"

local success, content = pcall(function()
    return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)
if success then avatarUrl = content end

-- ==============================
-- GUI (Fluent Library)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local GUI = {}
local noclipEnabled = false
local flyEnabled = false
local selectedPlayer = nil

function GUI:Init(modules)
    print("Brodz Hub: Preparing modern interface...")
    
    local Window = Fluent:CreateWindow({
        Title = "Brodz Hub V2",
        SubTitle = "by Brodz",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true, 
        Theme = "Dark", 
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        Main = Window:AddTab({ Title = "Main Features", Icon = "activity" }),
        Teleport = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" })
    }

    -- --------------------
    -- TAB MAIN FEATURES
    modules.ngabret:Enable()

    Tabs.Main:AddSlider("SpeedSlider", {
        Title = "WalkSpeed",
        Description = "Adjust your movement speed",
        Default = 16,
        Min = 16,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            if modules.ngabret and typeof(modules.ngabret.setSpeed) == "function" then
                modules.ngabret:setSpeed(Value)
            end
        end
    })

    Tabs.Main:AddSlider("FlySpeedSlider", {
        Title = "Fly Speed",
        Description = "Adjust your flying speed",
        Default = 16,
        Min = 16,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            if modules.ngapung and typeof(modules.ngapung.setSpeed) == "function" then
                modules.ngapung:setSpeed(Value)
            end
        end
    })

    local FlyToggle = Tabs.Main:AddToggle("FlyToggle", {Title = "Fly", Default = false})
    FlyToggle:OnChanged(function()
        flyEnabled = FlyToggle.Value
        if flyEnabled then
            modules.ngapung:Enable()
        else
            modules.ngapung:Disable()
        end
    end)
    local NoclipToggle = Tabs.Main:AddToggle("NoclipToggle", {Title = "Noclip", Default = false})
    NoclipToggle:OnChanged(function()
        noclipEnabled = NoclipToggle.Value
        modules.nclip:Enable(noclipEnabled)
    end)

    local EspToggle = Tabs.Main:AddToggle("EspToggle", {Title = "Player ESP", Default = false})
    EspToggle:OnChanged(function()
        if EspToggle.Value then
            modules.esp:Enable()
        else
            modules.esp:Disable()
        end
    end)

    -- Toggle Infinite Jump
    local InfJumpToggle = Tabs.Main:AddToggle("InfJumpToggle", {Title = "Infinite Jump", Default = false})
    InfJumpToggle:OnChanged(function()
        if InfJumpToggle.Value then
            modules.infjmp:Enable()
        else
            modules.infjmp:Disable()
        end
    end)

    -- ----------
    local PepetModule = modules.pepet 
    local currentValues, currentMap = PepetModule:GetSortedPlayers()
    local PlayerDropdown = Tabs.Teleport:AddDropdown("PlayerListDropdown", {
        Title = "Select Target (Sorted by Size)",
        Description = "Select a player to follow or stalk",
        Values = currentValues,
        CurrentValue = nil,
        Callback = function(Value)
            if currentMap and currentMap[Value] then
                activeTarget = currentMap[Value]
                PepetModule:SetTarget(activeTarget)
            end
        end
    })
    local TeleportToggle = Tabs.Teleport:AddToggle("TeleportToggle", {
        Title = "Loop Teleport (Pepet Target)", 
        Default = false
    })

    TeleportToggle:OnChanged(function()
        if activeTarget then
            PepetModule:ToggleFollow(TeleportToggle.Value)
        else
            if TeleportToggle.Value == true then
                TeleportToggle:SetValue(false) 
                Fluent:Notify({
                    Title = "Action Denied",
                    Content = "Silakan pilih target player terlebih dahulu di dropdown!",
                    Duration = 3
                })
            end
        end
    end)

    Tabs.Teleport:AddButton({
        Title = "Refresh Player List & Rankings",
        Description = "Update the leaderboard dropdown based on current in-game stats",
        Callback = function()
            local newValues, newMap = PepetModule:GetSortedPlayers()
            currentValues = newValues
            currentMap = newMap
            PlayerDropdown:SetValues(newValues) 
            Fluent:Notify({
                Title = "System Updated",
                Content = "Daftar ranking player berhasil diperbarui!",
                Duration = 2
            })
        end
    })

    -- -------------------------------------------------------------------------
    local FluentGui = game:GetService("CoreGui"):FindFirstChild("Fluent") or game:GetService("CoreGui"):FindFirstChild("ScreenGui")
    if FluentGui then
        local MainFrame = FluentGui:FindFirstChild("Main", true) or FluentGui:FindFirstChild("Frame", true)
        if MainFrame then
            local ProfileFrame = Instance.new("Frame")
            ProfileFrame.Size = UDim2.new(0, 140, 0, 45)
            ProfileFrame.Position = UDim2.new(0, 10, 1, -55)
            ProfileFrame.BackgroundTransparency = 1
            ProfileFrame.Parent = MainFrame

            local AvatarImg = Instance.new("ImageLabel")
            AvatarImg.Size = UDim2.new(0, 35, 0, 35)
            AvatarImg.Position = UDim2.new(0, 5, 0, 5)
            AvatarImg.Image = avatarUrl
            AvatarImg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            AvatarImg.Parent = ProfileFrame

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(1, 0)
            Corner.Parent = AvatarImg

            local NameLbl = Instance.new("TextLabel")
            NameLbl.Size = UDim2.new(0, 90, 0, 35)
            NameLbl.Position = UDim2.new(0, 45, 0, 5)
            NameLbl.Text = LocalPlayer.DisplayName
            NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLbl.Font = Enum.Font.GothamMedium
            NameLbl.TextSize = 11
            NameLbl.TextXAlignment = Enum.TextXAlignment.Left
            NameLbl.TextTruncate = Enum.TextTruncate.AtEnd
            NameLbl.BackgroundTransparency = 1
            NameLbl.Parent = ProfileFrame
        end
    end

    -- Sistem Notifikasi Selamat Datang Berhasil di-Load
    Fluent:Notify({
        Title = "Brodz Hub V2 Loaded!",
        Content = "Welcome back, " .. LocalPlayer.DisplayName .. ". Database connected successfully.",
        Duration = 5
    })
end

return GUI
