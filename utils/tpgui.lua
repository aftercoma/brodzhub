local Players = game:GetService("Players")
local runService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
--tools
local followEnabled = false
local followConnection
local followTarget = nil
local refreshPlayerList
local tpGui
--table
local guiTp = {}


local function getHRP(pler, timeout)
    timeout = timeout or 10
    local start = tick()
     while tick() - start < timeout do
        if pler.Character and pler.Character:FindFirstChild("HumanoidRootPart") then
            return pler.Character.HumanoidRootPart
        end
        task.wait(0.1)
    end
    return nil

end

local function getSize(peler)
    local vrb = peler:FindFirstChild("leaderstats")
    if vrb then
        for _, asu in pairs(vrb:GetChildren()) do
             if asu.Name:lower():find("score") or asu.Name:lower():find("xp") or asu:IsA("NumberValue") or asu:IsA("IntValue") then
                return asu.Value
            end
        end
    end
    return 0
end

local function parseScore(numb)
    if numb >= 1e12 then
        return string.format("%.2fT", numb / 1e12)
    elseif numb >= 1e9 then
        return string.format("%.2fB", numb / 1e9)
    elseif numb >= 1e6 then
        return string.format("%.2fM", numb / 1e6)
    elseif numb >= 1e3 then
        return string.format("%.2fK", numb / 1e3)
    else
        return tostring(numb)
    end
end

function guiTp:Enable()
    local minimized = false
    if tpGui then tpGui:Destroy() end
    tpGui = Instance.new("ScreenGui")
    tpGui.Parent = player:WaitForChild("PlayerGui")
    tpGui.ResetOnSpawn = false
    local mainFrame = Instance.new("Frame", tpGui)
    mainFrame.Size = UDim2.new(0, 260, 0, 260)
    mainFrame.Position = UDim2.new(0.5, -130, 0.5, -130)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

    local top = Instance.new("Frame", mainFrame)
    top.Size = UDim2.new(1, 0, 0, 35)
    top.BackgroundColor3 = Color3.fromRGB(35,35,35)
    top.BorderSizePixel = 0
    top.ZIndex = 2
    Instance.new("UICorner", top).CornerRadius = UDim.new(0,12)
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0,4)
    padding.PaddingLeft = UDim.new(0,10)
    padding.Parent = top

    local corner = Instance.new("UICorner", top)
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = top

    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.TextSize = 13
    title.TextColor3 = Color3.new(1,1,1)
    title.Text = "TELEPORT OFF"
    title.Font = Enum.Font.Arcade
    title.TextScaled = false
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1
    Stroke.Color = Color3.fromRGB(0,0,0)
    Stroke.Parent = title

    local closeBtn = Instance.new("TextButton", top)
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextScaled = true
    closeBtn.ZIndex = 3
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)
   
    local function resize(size)
        TweenService:Create(
            mainFrame,
            TweenInfo.new(0.25),
            {Size = size}

        ):Play()
    end
    
    local minimizeBtn = Instance.new("TextButton", top)
    minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
    minimizeBtn.Position = UDim2.new(1, -65, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.new(1,1,1)
    minimizeBtn.TextScaled = true
    minimizeBtn.ZIndex = 3
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1,0)
    local list = Instance.new("ScrollingFrame", mainFrame)
    list.Position = UDim2.new(0, 10, 0, 40)
    list.Size = UDim2.new(1, -20, 1, -80)
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.ScrollBarImageTransparency = 0.3
    list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.BackgroundColor3 = Color3.fromRGB(35,35,35)
    list.BorderSizePixel = 0
    Instance.new("UICorner", list)
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = list
    
    local PepetBtn = Instance.new("TextButton", mainFrame)
    PepetBtn.Size = UDim2.new(1, -20, 0, 30)
    PepetBtn.Text = "TELEPORT TO PLAYERS"
    PepetBtn.Position = UDim2.new(0, 10, 1, -40)
    PepetBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    PepetBtn.TextColor3 = Color3.new(1,1,1)
    PepetBtn.BorderSizePixel = 0
    Instance.new("UICorner", PepetBtn)
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            resize(UDim2.new(0,260,0,35))
            list.Visible = false
            PepetBtn.Visible = false
        else
            resize(UDim2.new(0,260,0,260))
            list.Visible = true
            PepetBtn.Visible = true
        end
    end)
    closeBtn.MouseButton1Click:Connect(function()
        if tpGui then
            tpGui:Destroy()
            tpGui = nil
            list = nil
            followTarget = nil
            followEnabled = false
        end
    end)
    refreshPlayerList = function()
        if not tpGui or not list then return end
        for _, child in pairs(list:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
    end
    local players = {}
    for _,pler in pairs(Players:GetPlayers()) do
        if pler ~= player then
            table.insert(players, {
                player = pler,
                size = getSize(pler)

            })
        end
    end
    table.sort(players, function(a,b)
        return a.size > b.size
    end)
    for i, data in ipairs(players) do
        local pler = data.player
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.BorderSizePixel = 0
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.Parent = list
        Instance.new("UICorner", btn)
        btn.RichText = true
        local function UpdateBtn()

            btn.Text = string.format(
                '<b>%d.</b> %s <font color="rgb(170,170,170)">| %s</font>|<b> %s</b>',
                i,
                pler.DisplayName,
                pler.Name,
                parseScore(getSize(pler))
                )
        end
        btn.MouseButton1Click:Connect(function()
            followTarget = pler
            followEnabled = true

        end)
        UpdateBtn()
        local sizeValue = pler:FindFirstChild("Size", true)
        if sizeValue then
            sizeValue.Changed:Connect(function()
                UpdateBtn()
            end)
        end

    end
    refreshPlayerList()
    task.spawn(function()
        while tpGui and tpGui.Parent do
            refreshPlayerList()
            task.wait(1)
        end
    end)
    PepetBtn.MouseButton1Click:Connect(function()
        followEnabled = not followEnabled
        if followEnabled then
            PepetBtn.Text = "TELEPORT ON"
            PepetBtn.BackgroundColor3 = Color3.fromRGB(40,160,80)
        else
            PepetBtn.Text = "TELEPORT OFF"
            PepetBtn.BackgroundColor3 = Color3.fromRGB(120,40,40)
        end
    end)
    if followConnection then
        followConnection:Disconnect()
    end
    followConnection = runService.Heartbeat:Connect(function()
        if followEnabled and followTarget then
            local myHrp = getHRP(player)
            local targetHRP = getHRP(followTarget)
            if myHrp and targetHRP then
                myHrp.CFrame = targetHRP.CFrame * CFrame.new(0,0,-2)

            end
        end
    end)
    --[[
    runService.Heartbeat:Connect(function()
        if followEnabled and followTarget then
            local myHrp = getHRP(player)
            local targetHRP = getHRP(followTarget)
            if myHrp and targetHRP then
                myHrp.CFrame = targetHRP.CFrame * CFrame.new(0,0,-2)
            end
        end
    end)
    ]]
    
end
return guiTp
