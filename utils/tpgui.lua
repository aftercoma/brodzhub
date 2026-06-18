local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local guiTp = {}

local tpGui
local refreshPlayerList


-- PARSE VALUE
local function parseValue(num)
    if num >= 1e12 then
        return string.format("%.2fT", num / 1e12)

    elseif num >= 1e9 then
        return string.format("%.2fB", num / 1e9)

    elseif num >= 1e6 then
        return string.format("%.2fM", num / 1e6)

    elseif num >= 1e3 then
        return string.format("%.2fK", num / 1e3)

    else
        return tostring(num)
    end
end


-- AMBIL VALUE SIZE
local function getSize(plr)

    -- coba leaderstats
    local stats = plr:FindFirstChild("leaderstats")

    if stats then
        for _,v in pairs(stats:GetChildren()) do

            if v:IsA("NumberValue") 
            or v:IsA("IntValue") then

                return v.Value
            end
        end
    end


    -- coba attribute
    if plr.Character then
        return plr.Character:GetAttribute("Size") or 0
    end


    return 0
end



function guiTp:Enable()

    if tpGui then
        tpGui:Destroy()
    end


    tpGui = Instance.new("ScreenGui")
    tpGui.ResetOnSpawn = false
    tpGui.Parent = player.PlayerGui



    local frame = Instance.new("Frame",tpGui)

    frame.Size = UDim2.new(0,260,0,300)
    frame.Position = UDim2.new(.5,-130,.5,-150)

    frame.BackgroundColor3 = Color3.fromRGB(35,35,35)

    Instance.new("UICorner",frame)



    local title = Instance.new("TextLabel",frame)

    title.Size = UDim2.new(1,0,0,35)

    title.Text = "PLAYER LIST"

    title.Font = Enum.Font.Arcade

    title.TextColor3 = Color3.new(1,1,1)

    title.BackgroundTransparency = 1



    local list = Instance.new("ScrollingFrame",frame)

    list.Position = UDim2.new(0,10,0,45)

    list.Size = UDim2.new(1,-20,1,-55)

    list.BackgroundColor3 = Color3.fromRGB(25,25,25)

    list.ScrollBarThickness = 5

    list.CanvasSize = UDim2.new()



    Instance.new("UICorner",list)



    local layout = Instance.new("UIListLayout",list)

    layout.Padding = UDim.new(0,5)



    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

        list.CanvasSize =
            UDim2.new(
                0,
                0,
                0,
                layout.AbsoluteContentSize.Y + 10
            )

    end)




    refreshPlayerList = function()


        for _,v in pairs(list:GetChildren()) do

            if v:IsA("TextButton") then

                v:Destroy()

            end
        end



        local data = {}


        for _,plr in pairs(Players:GetPlayers()) do


            if plr ~= player then


                table.insert(data,{

                    player = plr,

                    size = getSize(plr)

                })


            end

        end



        table.sort(data,function(a,b)

            return a.size > b.size

        end)



        for i,v in ipairs(data) do


            local btn = Instance.new("TextButton")


            btn.Size =
                UDim2.new(1,0,0,30)


            btn.BackgroundColor3 =
                Color3.fromRGB(55,55,55)


            btn.TextColor3 =
                Color3.new(1,1,1)


            btn.Font =
                Enum.Font.SourceSans


            btn.TextSize = 15


            btn.Parent = list



            Instance.new("UICorner",btn)



            btn.Text =
                i..". "
                ..v.player.DisplayName
                .." | "
                ..parseValue(v.size)



            btn.MouseButton1Click:Connect(function()

                print("target:",v.player.Name)

            end)

        end


        print("player loaded:",#data)

    end



    refreshPlayerList()


    Players.PlayerAdded:Connect(refreshPlayerList)

    Players.PlayerRemoving:Connect(refreshPlayerList)


end



return guiTp
