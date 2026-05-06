-- ===== 1. GUI =====
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FastRobberV7"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

-- TEXTBOX
local TextBox = Instance.new("TextBox", MainFrame)
TextBox.Size = UDim2.new(0.8, 0, 0.25, 0)
TextBox.Position = UDim2.new(0.1, 0, 0.1, 0)
TextBox.PlaceholderText = "Dán JobId..."
TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TextBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", TextBox)

-- JOIN BUTTON
local JoinBtn = Instance.new("TextButton", MainFrame)
JoinBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
JoinBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
JoinBtn.Text = "JOIN SERVER"
JoinBtn.BackgroundColor3 = Color3.fromRGB(0,100,200)
JoinBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", JoinBtn)

-- AUTO E BUTTON
local AutoEBtn = Instance.new("TextButton", MainFrame)
AutoEBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
AutoEBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
AutoEBtn.Text = "AUTO E: OFF"
AutoEBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
AutoEBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", AutoEBtn)

-- ===== 2. JOIN =====
JoinBtn.MouseButton1Click:Connect(function()
    local jobId = TextBox.Text:gsub("%s+", "")

    if jobId ~= "" then
        JoinBtn.Text = "ĐANG NHẢY..."
        JoinBtn.BackgroundColor3 = Color3.fromRGB(150,150,0)

        local success = pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
        end)

        if not success then
            JoinBtn.Text = "LỖI!"
            task.wait(2)
            JoinBtn.Text = "JOIN SERVER"
        end
    else
        JoinBtn.Text = "NHẬP ID!"
        task.wait(1)
        JoinBtn.Text = "JOIN SERVER"
    end
end)

-- ===== 3. AUTO E =====
local AutoE_Enabled = false

AutoEBtn.MouseButton1Click:Connect(function()
    AutoE_Enabled = not AutoE_Enabled
    AutoEBtn.Text = AutoE_Enabled and "AUTO E: ON" or "AUTO E: OFF"
    AutoEBtn.BackgroundColor3 = AutoE_Enabled and Color3.fromRGB(0,180,0) or Color3.fromRGB(150,0,0)
end)

-- ===== 4. AUTO E LOOP (GIỮ LOGIC CŨ + FIX LAG) =====
task.spawn(function()
    while true do
        if AutoE_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position
            local processed = 0

            for _, obj in ipairs(workspace:GetDescendants()) do
                if processed >= 35 then break end -- 🔥 chống lag

                if obj:IsA("ProximityPrompt") then
                    if obj.KeyboardKeyCode == Enum.KeyCode.E then
                        local parent = obj.Parent

                        if parent and parent:IsA("BasePart") then
                            local dist = (myPos - parent.Position).Magnitude

                            if dist <= obj.MaxActivationDistance then
                                obj.HoldDuration = 0

                                pcall(function()
                                    obj:InputHoldBegin()
                                    task.wait(0.03)
                                    obj:InputHoldEnd()
                                end)

                                processed += 1
                            end
                        else
                            obj.HoldDuration = 0

                            pcall(function()
                                obj:InputHoldBegin()
                                task.wait(0.03)
                                obj:InputHoldEnd()
                            end)

                            processed += 1
                        end
                    end
                end
            end
        end

        task.wait(math.random(30,60)/100) -- 🔥 anti kick
    end
end)

-- ===== 5. ANTI AFK =====
LocalPlayer.Idled:Connect(function()
    pcall(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end)

print("✅ FastRobber V7 FULL READY")
