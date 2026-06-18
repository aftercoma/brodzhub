-- =================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local followEnabled = false
local followTarget = nil
local followConnection = nil

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
    local stats = peler:FindFirstChild("leaderstats")
    if stats then
        for _, v in pairs(stats:GetChildren()) do
            if v:IsA("NumberValue") or v:IsA("IntValue") then
                return v.Value
            end
        end
    end
    return 0
end
local function parseScore(n)
    if n >= 1e12 then return string.format("%.2fT", n/1e12)
    elseif n >= 1e9 then return string.format("%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.2fK", n/1e3)
    else return tostring(n) end
end

-- =============================================================================
function guiTp:GetSortedPlayers()
    local playerList = {}
    for _, pler in pairs(Players:GetPlayers()) do
        if pler ~= player then
            table.insert(playerList, {
                Obj = pler,
                Name = pler.Name,
                DisplayName = pler.DisplayName,
                Size = getSize(pler)
            })
        end
    end
    table.sort(playerList, function(a, b)
        return a.Size > b.Size
    end)
    local dropdownValues = {}
    local formatMap = {} 
    
    for i, data in ipairs(playerList) do
        local displayText = string.format("[%d] %s (@%s) | Size: %s", i, data.DisplayName, data.Name, parseScore(data.Size))
        table.insert(dropdownValues, displayText)
        formatMap[displayText] = data.Obj
    end
    
    return dropdownValues, formatMap
end

function guiTp:SetTarget(targetPlayerObj)
    followTarget = targetPlayerObj
end

function guiTp:ToggleFollow(state)
    followEnabled = state
    
    if followEnabled then
        if followConnection then followConnection:Disconnect() end
        
        followConnection = RunService.Heartbeat:Connect(function()
            if followEnabled and followTarget then
                local myHrp = getHRP(player)
                local targetHRP = getHRP(followTarget)
                if myHrp and targetHRP then
                    myHrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2)
                end
            end
        end)
    else
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
    end
end

return guiTp
