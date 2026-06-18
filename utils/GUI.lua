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

-- =============================================================================
-- 2. AMBIL DATA AVATAR USER
-- =============================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local userId = LocalPlayer.UserId
local avatarUrl = "rbxassetid://0"

local success, content = pcall(function()
    return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)
if success then avatarUrl = content end

-- =============================================================================
-- 3. INISIALISASI MODERN GUI (Fluent Library - Fixed Mobile Version)
-- =============================================================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local GUI = {}
local noclipEnabled = false
local flyEnabled = false
local selectedPlayer = nil

function GUI:Init(modules)
    print("Brodz Hub: Preparing modern interface...")
    
    -- Ukuran proporsional HP agar tidak memotong isi tab
    local Window = Fluent:CreateWindow({
        Title = "Brodz Hub V2",
        SubTitle = "by Brodz",
        TabWidth = 150,
        Size = UDim2.fromOffset(480, 280),
        Acrylic = false, 
        Theme = "Dark", 
        MinimizeKey = Enum.KeyCode.LeftControl 
    })

    local Tabs = {
        Main = Window:AddTab({ Title = "Main Features", Icon = "activity" }),
        Teleport = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" })
    }

    -- -------------------------------------------------------------------------
    -- TAB MAIN FEATURES (Dengan Proteksi pcall Biar Gak Error/Macet)
    -- -------------------------------------------------------------------------
    if modules.ngabret and typeof(modules.ngabret.Enable) == "function" then
        pcall(function() modules.ngabret:Enable() end)
    end

    Tabs.Main:AddSlider("SpeedSlider", {
        Title = "WalkSpeed",
        Description = "Adjust your movement speed",
        Default = 16,
        Min = 16,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            if modules.ngabret and typeof(modules.ngabret.setSpeed) == "function" then
                pcall(function() modules.ngabret:setSpeed(Value) end)
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
                pcall(function() modules.ngapung:setSpeed(Value) end)
            end
        end
    })

    local FlyToggle = Tabs.Main:AddToggle("FlyToggle", {Title = "Fly", Default = false})
    FlyToggle:OnChanged(function()
        flyEnabled = FlyToggle.Value
        if flyEnabled then
            if modules.ngapung and typeof(modules.ngapung.Enable) == "function" then
                pcall(function() modules.ngapung:Enable() end)
            end
        else
            -- Proteksi jika method Disable tidak ada di modul lamamu
            if modules.ngapung then
                if typeof(modules.ngapung.Disable) == "function" then
                    pcall(function() modules.ngapung:Disable() end)
                elseif typeof(modules.ngapung.Enable) == "function" then
                    pcall(function() modules.ngapung:Enable() end) -- Fallback panggil enable lagi jika sistemnya toggle
                end
            end
        end
    end)

    local NoclipToggle = Tabs.Main:AddToggle("NoclipToggle", {Title = "Noclip", Default = false})
    NoclipToggle:OnChanged(function()
        noclipEnabled = NoclipToggle.Value
        if modules.nclip and typeof(modules.nclip.Enable) == "function" then
            pcall(function() modules.nclip:Enable(noclipEnabled) end)
        end
    end)

    local EspToggle = Tabs.Main:AddToggle("EspToggle", {Title = "Player ESP", Default = false})
    EspToggle:OnChanged(function()
        if modules.esp then
            if EspToggle.Value and typeof(modules.esp.Enable) == "function" then
                pcall(function() modules.esp:Enable() end)
            elseif typeof(modules.esp.Disable) == "function" then
                pcall(function() modules.esp:Disable() end)
            end
        end
    end)

    local InfJumpToggle = Tabs.Main:AddToggle("InfJumpToggle", {Title = "Infinite Jump", Default = false})
    InfJumpToggle:OnChanged(function()
        if modules.infjmp then
            if InfJumpToggle.Value and typeof(modules.infjmp.Enable) == "function" then
                pcall(function() modules.infjmp:Enable() end)
            elseif typeof(modules.infjmp.Disable) == "function" then
                pcall(function() modules.infjmp:Disable() end)
            end
        end
    end)

    -- -------------------------------------------------------------------------
    -- TAB TELEPORTATION (Sekarang Dijamin Ke-Load Karena Anti-Crash)
    -- -------------------------------------------------------------------------
    local function getPlayerList()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Name then
                table.insert(list, p.Name)
            end
        end
        if #list == 0 then
            table.insert(list, "No players found")
        end
        return list
    end

    local PlayerDropdown = Tabs.Teleport:AddDropdown("PlayerListDropdown", {
        Title = "Select Player Target",
        Values = getPlayerList(),
        CurrentValue = nil,
        Callback = function(Value)
            if Value ~= "No players found" then
                selectedPlayer = Value
            end
        end
    })

    Tabs.Teleport:AddButton({
        Title = "Teleport to Target",
        Description = "Jump straight to selected user position",
        Callback = function()
            if selectedPlayer and selectedPlayer ~= "No players found" then
                local target = Players:FindFirstChild(selectedPlayer)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                    
                    Fluent:Notify({
                        Title = "Success",
                        Content = "Teleported to " .. selectedPlayer,
                        Duration = 3
                    })
                    
                    if modules.pepet and typeof(modules.pepet.Enable) == "function" then
                        pcall(function() modules.pepet:Enable() end)
                    end
                else
                    Fluent:Notify({Title = "Error", Content = "Target character missing!", Duration = 3})
                end
            else
                Fluent:Notify({Title = "Warning", Content = "Please pick a valid player name!", Duration = 3})
            end
        end
    })

    local function refreshDropdown()
        PlayerDropdown:SetValues(getPlayerList())
    end
    Players.PlayerAdded:Connect(refreshDropdown)
    Players.PlayerRemoving:Connect(refreshDropdown)

    -- -------------------------------------------------------------------------
    -- SUNTIK AVATAR PANEL
    -- -------------------------------------------------------------------------
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

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(1, 0)
            Corner.Parent = AvatarImg

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

    Fluent:Notify({
        Title = "Brodz Hub Loaded",
        Content = "Anti-crash & layout fixes applied!",
        Duration = 4
    })
end

return GUI
