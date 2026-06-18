local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local FlyModule = {
    Enabled = false,
    Speed = 16,
    Connection = nil
}

function FlyModule:setSpeed(value)
    self.Speed = tonumber(value) or 16
end

function FlyModule:Enable()
    if self.Enabled then return end
    self.Enabled = true
    
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Humanoid = Character:WaitForChild("Humanoid")
    

    local bv = Instance.new("BodyVelocity")
    bv.Name = "BrodzFlyBV"
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = HumanoidRootPart
    
    Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    
    self.Connection = RunService.Heartbeat:Connect(function()
        if not self.Enabled or not HumanoidRootPart or not HumanoidRootPart.Parent then 
            self:Disable()
            return 
        end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            bv.Velocity = moveDirection.Unit * self.Speed
        else
            bv.Velocity = Vector3.new(0, 0, 0)
        end
        
        HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    end)
    
    Humanoid.Died:Connect(function() self:Disable() end)
end

function FlyModule:Disable()
    self.Enabled = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    local Character = LocalPlayer.Character
    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if HumanoidRootPart then
            local bv = HumanoidRootPart:FindFirstChild("BrodzFlyBV")
            if bv then bv:Destroy() end
        end
        local Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end

return FlyModule
