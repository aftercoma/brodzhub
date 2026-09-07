-- =
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- =============================================================================
-- 3. INTERFACE INITIALIZATION (Fluent Library)
-- =============================================================================
 -- services

 -- services 

 local TweenService = game:GetService("TweenService") 

 local RunService = game:GetService("RunService") 

 local UserInputService = game:GetService("UserInputService") 

 local Players = game:GetService("Players") 

 local player = Players.LocalPlayer 

 local GUI = {} 

 local noclipEnabled = false 

 print("currently preparing the feature") 

 function GUI:Init(modules) 

     -- GUI 

     local gui = Instance.new("ScreenGui") 

     gui.Parent = player:WaitForChild("PlayerGui") 

     gui.ResetOnSpawn = false 

     -- MAIN FRAME 

     local defaultSize = UDim2.new(0, 380, 0, 340) 

     local frame = Instance.new("Frame", gui) 

     frame.Size = defaultSize 

     frame.Position = UDim2.new(0.5, -135, 0.5, -115) 

     frame.BackgroundColor3 = Color3.fromRGB(30,30,30) 

     local stroke = Instance.new("UIStroke", frame) 

     stroke.Color = Color3.fromRGB(0,255,180) 

     stroke.Thickness = 1 

     stroke.Transparency = 0.5 

     local corner = Instance.new("UICorner", frame) 

     corner.CornerRadius = UDim.new(0, 15) 

     -- HEADER 

     local header = Instance.new("Frame", frame) 

     header.Size = UDim2.new(1, 0, 0, 40) 

     header.BackgroundColor3 = Color3.fromRGB(45,45,45) 

     -- CONTENT FRANE 

     local content = Instance.new("ScrollingFrame", frame) 

     content.Size = UDim2.new(1,0,1,-40) 

     content.Position = UDim2.new(0,0,0,40) 

     content.CanvasSize = UDim2.new(0,0,0,0) 

     content.AutomaticCanvasSize = Enum.AutomaticSize.Y 

     content.ScrollBarThickness = 4 

     content.BackgroundTransparency = 1 

     --UILISTLAYOUT 

     local layout = Instance.new("UIListLayout", content) 

     layout.Padding = UDim.new(0,10) 

     layout.SortOrder = Enum.SortOrder.LayoutOrder 

     layout.HorizontalAlignment = Enum.HorizontalAlignment.Center 

     layout.VerticalAlignment = Enum.VerticalAlignment.Top 

     -- PADDING 

     local padding = Instance.new("UIPadding", content) 

     padding.PaddingTop = UDim.new(0,10) 

     padding.PaddingBottom = UDim.new(0,10) 

     -- TITLE 

     local title = Instance.new("TextLabel", header) 

     title.Size = UDim2.new(1, -40, 1, 0) 

     title.BackgroundColor3 = Color3.fromRGB(45,45,45) 

     title.BackgroundTransparency = 1 

     title.Font = Enum.Font.Arcade 

     title.Text = "Brodz Hub" 

     title.TextColor3 = Color3.fromRGB(0,255,180) 

     title.TextScaled = true 

      

     local titleStroke = Instance.new("UIStroke", title) 

     titleStroke.Color = Color3.fromRGB(0,255,180) 

     titleStroke.Thickness = 1 

     -- MINIMIZE 

     local minimize = Instance.new("TextButton", frame) 

     minimize.Size = UDim2.new(0, 30, 0, 30) 

     minimize.Position = UDim2.new(1, -35, 0, 5) 

     minimize.Text = "-" 

     minimize.BackgroundColor3 = Color3.fromRGB(200,60,60) 

     local miniCorner = Instance.new("UICorner", minimize) 

     miniCorner.CornerRadius = UDim.new(1,0) 

     -- CIRCLE 

     local circle = Instance.new("ImageButton", gui) 

     circle.Size = UDim2.new(0, 60, 0, 60) 

     circle.Position = UDim2.new(0,20,0.5,0) 

     circle.Image = "rbxassetid://75617196126271" 

     circle.Visible = false 

     circle.BackgroundTransparency = 1 

     circle.BackgroundColor3 = Color3.fromRGB(40,40,40) 

     local circleCorner = Instance.new("UICorner") 

     circleCorner.CornerRadius = UDim.new(1,0) 

     circleCorner.Parent = circle 


     -- TWEEN 

     local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) 

     local function makeDraggable(uiObject) 

         local dragging = false 

         local dragStart 

         local startPos 

         local canDrag = false 

      

         uiObject.InputBegan:Connect(function(input) 

             if not canDrag then return end 

             if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 

                 dragging = true 

                 dragStart = input.Position 

                 startPos = uiObject.Position 

             end 

         end) 

      

         uiObject.InputChanged:Connect(function(input) 


             if dragging and (input.UserInputType == 

Enum.UserInputType.MouseMovement or input.UserInputType == 

Enum.UserInputType.Touch) then 

                 local delta = input.Position - dragStart 

                 uiObject.Position = UDim2.new( 

                     startPos.X.Scale, 

                     startPos.X.Offset + delta.X, 

                     startPos.Y.Scale, 

                     startPos.Y.Offset + delta.Y 

                 ) 

             end 

         end) 

      

         UserInputService.InputEnded:Connect(function(input) 

             if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 

                 dragging = false 

             end 

         end) 

      

         return { 

             Enable = function() canDrag = true end, 

             Disable = function() canDrag = false end 

         } 

     end 

     -- FUNGSI TOMBOL 

     local function makeBtn(parent, text, callback) 

         local button = Instance.new("TextButton") 

         button.Size = UDim2.new(0.8, 0, 0, 32)  

         button.AnchorPoint = Vector2.new(0.5, 0) 

         button.Position = UDim2.new(0.5, 0, 0, 0) 

         button.BackgroundColor3 = Color3.fromRGB(60,60,60) 

         button.Font = Enum.Font.Arcade 

         button.TextColor3 = Color3.fromRGB(0,255,180) 

         button.Text = text 

         button.TextSize = 16 

         button.TextScaled = false 

         button.Parent = parent 


         local corner = Instance.new("UICorner", button) 

         corner.CornerRadius = UDim.new(0,10) 


         button.MouseEnter:Connect(function() 

             button.BackgroundColor3 = Color3.fromRGB(80,80,80) 

         end) 

         button.MouseLeave:Connect(function() 

             button.BackgroundColor3 = Color3.fromRGB(60,60,60) 

         end) 


         button.MouseButton1Click:Connect(function() 

             if callback then 

                 callback(button) 

             end 

         end) 


         return button 

     end 

      

     function createSlider(parent, minValue, maxValue, defaultValue, labelText, onValueChanged) 

         local sliderFrame = Instance.new("Frame", parent) 

         sliderFrame.Size = UDim2.new(0.9, 0, 0, 50) 

         sliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) 

         Instance.new("UICorner", sliderFrame) 

      

         local sliderLabel = Instance.new("TextLabel", sliderFrame) 

         sliderLabel.Size = UDim2.new(1, 0, 0, 25) 

         sliderLabel.BackgroundTransparency = 1 

         sliderLabel.TextColor3 = Color3.new(1,1,1) 

         sliderLabel.Font = Enum.Font.Arcade 

         sliderLabel.Text = labelText..": "..defaultValue 

      

         local sliderBar = Instance.new("Frame", sliderFrame) 

         sliderBar.Size = UDim2.new(0.8, 0, 0, 4) 

         sliderBar.Position = UDim2.new(0.1, 0, 0.7, 0) 

         sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60) 

      

         local sliderDot = Instance.new("Frame", sliderBar) 

         sliderDot.Size = UDim2.new(0, 14, 0, 14) 

         sliderDot.Position = UDim2.new((defaultValue-minValue)/(maxValue-minValue), -7, 0.5, -7) 

         sliderDot.BackgroundColor3 = Color3.fromRGB(0, 255, 180) 

         Instance.new("UICorner", sliderDot) 

      

         local isDragging = false 

         local currentValue = defaultValue 

         local function updateSlider(x) 

             local barPos = sliderBar.AbsolutePosition.X 

             local barSize = sliderBar.AbsoluteSize.X 

          

             local percent = math.clamp((x - barPos) / barSize, 0, 1) 

          

             sliderDot.Position = UDim2.new(percent, -7, 0.5, -7) 

          

             currentValue = math.floor(minValue + (percent * (maxValue - minValue))) 

             sliderLabel.Text = labelText..": "..currentValue 

          

             if onValueChanged then 

                 onValueChanged(currentValue) 

             end 

         end 

         sliderBar.InputBegan:Connect(function(input) 

             if input.UserInputType == Enum.UserInputType.MouseButton1 then 

                 isDragging = true 

                 updateSlider(input.Position.X) 

             end 

         end) 

          

         sliderBar.InputChanged:Connect(function(input) 

             if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then 

                 updateSlider(input.Position.X) 

             end 

         end) 

         sliderDot.InputBegan:Connect(function(input) 

             if input.UserInputType == Enum.UserInputType.MouseButton1  

             or input.UserInputType == Enum.UserInputType.Touch then 

                 isDragging = true 

             end 

         end) 

      

         UserInputService.InputEnded:Connect(function(input) 

             if input.UserInputType == Enum.UserInputType.MouseButton1  

             or input.UserInputType == Enum.UserInputType.Touch then 

                 isDragging = false 

             end 

         end) 

      

         RunService.RenderStepped:Connect(function() 

             if isDragging then 

                 local mousePos = UserInputService:GetMouseLocation().X 

                 local barPos = sliderBar.AbsolutePosition.X 

                 local barSize = sliderBar.AbsoluteSize.X 

                 local percent = math.clamp((mousePos - barPos) / barSize, 0, 1) 

      

                 sliderDot.Position = UDim2.new(percent, -7, 0.5, -7) 

                 currentValue = math.floor(minValue + (percent * (maxValue - minValue))) 

                 sliderLabel.Text = labelText..": "..currentValue 

      

                 if onValueChanged then 

                     onValueChanged(currentValue) 

                 end 

             end 

         end) 

      

         return sliderFrame 

     end 

     modules.ngabret:Enable() 

     createSlider(content, 16, 100, 16, "Speed", function(value) 

         if modules.ngabret and typeof(modules.ngabret.setSpeed) == "function" then 

             modules.ngabret:setSpeed(value) 

         end 

     end) 

      

     createSlider(content, 16, 100, 16, "Fly Speed", function(value) 

         if modules.ngapung and typeof(modules.ngapung.setSpeed) == "function" then 

             modules.ngapung:setSpeed(value) 

         end 

     end) 

     local flyEnabled = false 

     --[[ 

     makeBtn(content, "SPEED OFF", function(button) 

             if button.Text = "SPEED OFF" then 

                 button.Text = "SPEED ON!" 

                 button.BackgroundColor3 = Color3.fromRGB(0,170,0) 

                 modules.ngabret:Enable() 

             else 

                 button.Text = "SPEED OFF!" 

                 button.BackgroundColor3 = Color3.fromRGB(170,0,0) 

                 modules.ngabret:Disable() 

             end 

     end) 

     ]]-- 

     makeBtn(content, "NOCLIP OFF", function(button) 

         noclipEnabled = not noclipEnabled 

         modules.nclip:Enable(noclipEnabled) 

         button.Text = noclipEnabled and "NOCLIP ON" or "NOCLIP OFF" 

         button.BackgroundColor3 = noclipEnabled and Color3.fromRGB(40,160,80) or Color3.fromRGB(120,40,40) 

     end) 


     makeBtn(content, "ESP OFF", function(button) 

         if button.Text == "ESP OFF" then 

             button.BackgroundColor3 = Color3.fromRGB(40,160,80) 

             button.Text = "ESP ON" 

             modules.esp:Enable() 

         else 

             button.BackgroundColor3 = Color3.fromRGB(120,40,40) 

             button.Text = "ESP OFF" 

             modules.esp:Disable() 

         end 

     end) 

     makeBtn(content, "INF JUMP OFF", function(button) 

         if button.Text == "INF JUMP OFF" then 

             button.BackgroundColor3 = Color3.fromRGB(40,160,80) 

             button.Text = "INF JUMP ON" 

             modules.infjmp:Enable() 

         else 

             button.BackgroundColor3 = Color3.fromRGB(120,40,40) 

             button.Text = "INF JUMP OFF" 

             modules.infjmp:Disable() 

         end 

     end) 

     makeBtn(content,"TELEPORT TO PLAYERS", function() 

         modules.pepet:Enable() 

     end) 

     local frameDrag = makeDraggable(frame) 

     local circleDrag = makeDraggable(circle) 

     frameDrag:Disable() 

     circleDrag:Enable() 

     local minimizeTween = TweenService:Create(frame, tweenInfo, { 

         Size = UDim2.new(0,0,0,0) 

     }) 

     local openTween = TweenService:Create(frame, tweenInfo, { 

         Size = defaultSize 

     }) 

     minimize.MouseButton1Click:Connect(function() 

         minimizeTween:Play() 

         circle.Position = frame.Position 

         frame.Visible = false 

         circle.Visible = true 

         frameDrag:Disable() 

         circleDrag:Enable() 

     end) 

     circle.MouseButton1Click:Connect(function() 

         openTween:Play() 

         frame.Position = circle.Position 

         frame.Visible = true 

         circle.Visible = false 

         circleDrag:Enable() 

         frameDrag:Disable() 

     end) 

 end 

 return GUI 
