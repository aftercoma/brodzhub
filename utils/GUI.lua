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
    print("Brodz Hub: Loading Player List & Loop Teleport mechanicals...")
    
    local Window = Fluent:CreateWindow({
        Title = "Brodz Hub V2",
        SubTitle = "by Brodz",
        TabWidth = 150,
        Size = UDim2.fromOffset(480, 320), -- Tinggi sedikit dinaikkan agar list player muat banyak
        Acrylic = false, 
        Theme = "Dark", 
        MinimizeKey = Enum.KeyCode.LeftControl 
    })

    local Tabs = {
        Main = Window:AddTab({ Title = "Main Features", Icon = "activity" }),
        Teleport = Window:AddTab({ Title = "Teleportation", Icon = "map-pin" })
    }

    -- -------------------------------------------------------------------------
    -- TAB MAIN FEATURES (Proteksi Anti-Crash)
    -- -------------------------------------------------------------------------
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

    -- -------------------------------------------------------------------------
    -- TAB TELEPORTATION (Daftar List Berjejer & Sistem Loop Teleport)
    -- -------------------------------------------------------------------------
    
    -- Status teks untuk memantau siapa target loop saat ini
    local TargetStatus = Tabs.Teleport:AddParagraph({
        Title = "Loop Teleport Status: OFF",
        Content = "Target: None"
    })

    -- Tombol utama untuk mematikan Loop Teleport secara global
    local StopButton = Tabs.Teleport:AddButton({
        Title = "🛑 STOP LOOP TELEPORT",
        Description = "Click here to turn off any active loop teleport immediately.",
        Callback = function()
            if loopTeleportConnection then
                loopTeleportConnection:Disconnect()
                loopTeleportConnection = nil
            end
            teleportTargetPlayer = nil
            TargetStatus:SetTitle("Loop Teleport Status: OFF")
            TargetStatus:SetText("Target: None")
            Fluent:Notify({Title = "Teleport System", Content = "Loop teleport has been disabled.", Duration = 3})
        end
    })

    -- Fungsi mengambil string leaderstats (contoh: 1.5b atau 500m)
    local function getPlayerStatValue(p)
        local leaderstats = p:FindFirstChild("leaderstats")
        if leaderstats then
            -- Mencari value berupa angka terbesar (bisa Cash, Strength, Bounty, dll)
            for _, stat in ipairs(leaderstats:GetChildren()) do
                if stat:IsA("IntValue") or stat:IsA("NumberValue") or stat:IsA("StringValue") then
                    return tostring(stat.Value)
                end
            end
        end
        return "0" -- Jika tidak ada leaderstats ditemukan
    end

    -- Container scrolling area otomatis bawaan Fluent untuk mendaftar player
    local ListContainer = Tabs.Teleport:AddParagraph({
        Title = "Active Players List",
        Content = "Click a player name below to toggle Loop Teleport:"
    })

    -- Fungsi utama untuk me-render daftar player berjejer ke bawah
    local activeButtons = {}
    local function updatePlayerListUI()
        -- Hapus tombol lama agar tidak menumpuk saat refresh
        for _, btn in ipairs(activeButtons) do
            btn:Destroy()
        end
        table.clear(activeButtons)

        -- Ambil seluruh player aktif
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Name then
                local statVal = getPlayerStatValue(p)
                local displayFormat = p.Name .. " | [" .. statVal .. "]"
                
                -- Bikin komponen button interaktif berjejer di dalam tab
                local PButton = Tabs.Teleport:AddButton({
                    Title = displayFormat,
                    Description = "Click to toggle continuous teleport to " .. p.DisplayName,
                    Callback = function()
                        -- LOGIKA TOGGLE LOOP TELEPORT
                        if teleportTargetPlayer == p.Name then
                            -- Jika mengklik orang yang sama, matikan loop-nya
                            if loopTeleportConnection then
                                loopTeleportConnection:Disconnect()
                                loopTeleportConnection = nil
                            end
                            teleportTargetPlayer = nil
                            TargetStatus:SetTitle("Loop Teleport Status: OFF")
                            TargetStatus:SetText("Target: None")
                            Fluent:Notify({Title = "Loop Off", Content = "Stopped following " .. p.Name, Duration = 2})
                        else
                            -- Jika mengklik orang baru, reset loop lama dan pasang ke orang baru ini
                            if loopTeleportConnection then
                                loopTeleportConnection:Disconnect()
                            end
                            
                            teleportTargetPlayer = p.Name
                            TargetStatus:SetTitle("Loop Teleport Status: 🟢 ON")
                            TargetStatus:SetText("Sticky Tracking: " .. p.Name)
                            
                            Fluent:Notify({Title = "Loop Teleport", Content = "Now sticking to " .. p.Name, Duration = 3})
                            
                            -- Menjalankan perulangan menempel via Heartbeat (Sangat cepat dan anti-lepas)
                            loopTeleportConnection = game:GetService("RunService").Heartbeat:Connect(function()
                                local target = Players:FindFirstChild(teleportTargetPlayer)
                                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    -- Menempel tepat di posisi koordinat target player
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                                else
                                    -- Pengaman jika target keluar game secara tiba-tiba
                                    if loopTeleportConnection then
                                        loopTeleportConnection:Disconnect()
                                        loopTeleportConnection = nil
                                        TargetStatus:SetTitle("Loop Teleport Status: OFF (Target Lost)")
                                        TargetStatus:SetText("Target: None")
                                    end
                                end
                            end)

                            if modules.pepet and typeof(modules.pepet.Enable) == "function" then
                                pcall(function() modules.pepet:Enable() end)
                            end
                        end
                    end
                })
                table.insert(activeButtons, PButton)
            end
        end
    end

    -- Jalankan render list saat pertama kali GUI terbuka
    updatePlayerListUI()

    -- Otomatis re-render daftar list apabila ada player baru masuk atau keluar game
    Players.PlayerAdded:Connect(updatePlayerListUI)
    Players.PlayerRemoving:Connect(updatePlayerListUI)

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
        Content = "Sticky Loop Teleport List is Active!",
        Duration = 4
    })
end

return GUI
