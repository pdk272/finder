-- MASTER HUB V7: AUTO GIỮ E CHUẨN MEN + CHỐNG KICK
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
local Content = Instance.new("ScrollingFrame", Main)
local UIListLayout = Instance.new("UIListLayout", Content)

Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true Main.Draggable = true

-- NÚT 1: AUTO GIỮ E (An toàn 100%, tự giữ E 2.1 giây rồi nhả)
local HoldEBtn = Instance.new("TextButton", Main)
HoldEBtn.Size = UDim2.new(0, 110, 0, 40)
HoldEBtn.Position = UDim2.new(0.02, 0, 0.7, 0)
HoldEBtn.Text = "GIỮ E: OFF"
HoldEBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
HoldEBtn.TextColor3 = Color3.new(1, 1, 1)

local isHolding = false
HoldEBtn.MouseButton1Click:Connect(function()
    isHolding = not isHolding
    HoldEBtn.Text = isHolding and "ĐANG GIỮ E..." or "GIỮ E: OFF"
    HoldEBtn.BackgroundColor3 = isHolding and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(200, 0, 0)
end)

task.spawn(function()
    local Vim = game:GetService("VirtualInputManager")
    while true do
        if isHolding then
            Vim:SendKeyEvent(true, Enum.KeyCode.E, false, game) -- Nhấn xuống
            task.wait(2.1) -- Giữ chặt 2.1 giây để nhặt xong pet
            Vim:SendKeyEvent(false, Enum.KeyCode.E, false, game) -- Thả ra
            task.wait(0.1) -- Nghỉ 1 nhịp ngắn
        else
            task.wait(0.5)
        end
    end
end)

-- NÚT 2: HACK E 0 GIÂY (Bỏ qua 2s của game, pick ngay lập tức)
local HackEBtn = Instance.new("TextButton", Main)
HackEBtn.Size = UDim2.new(0, 110, 0, 40)
HackEBtn.Position = UDim2.new(0.02, 0, 0.85, 0)
HackEBtn.Text = "HACK E 0s: OFF"
HackEBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
HackEBtn.TextColor3 = Color3.new(1, 1, 1)

local autoHackE = false
HackEBtn.MouseButton1Click:Connect(function()
    autoHackE = not autoHackE
    HackEBtn.Text = autoHackE and "HACK 0s: ON" or "HACK E 0s: OFF"
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if autoHackE then
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0 -- Ép thời gian giữ về 0
                    if fireproximityprompt then fireproximityprompt(prompt) end
                end
            end
        end
    end
end)

-- KHU VỰC HIỆN SERVER TỪ ACC PHỤ
Content.Size = UDim2.new(0, 340, 0, 260)
Content.Position = UDim2.new(0, 130, 0, 20)
Content.BackgroundTransparency = 1
UIListLayout.Padding = UDim.new(0, 5)

local function CreateEntry(data)
    local Frame = Instance.new("Frame", Content)
    Frame.Size = UDim2.new(1, -10, 0, 60)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)

    local Info = Instance.new("TextLabel", Frame)
    Info.Text = "🔥 " .. tostring(data.PetName):upper() .. "\nBot: " .. tostring(data.AccSource)
    Info.Size = UDim2.new(0.7, 0, 1, 0)
    Info.TextColor3 = Color3.new(1, 1, 1)
    Info.BackgroundTransparency = 1
    Info.TextXAlignment = Enum.TextXAlignment.Left

    local Join = Instance.new("TextButton", Frame)
    Join.Text = "Join"
    Join.Size = UDim2.new(0.25, 0, 0.6, 0)
    Join.Position = UDim2.new(0.72, 0, 0.2, 0)
    Join.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    Join.TextColor3 = Color3.new(1, 1, 1)

    Join.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data.JobId)
    end)
    task.delay(180, function() Frame:Destroy() end)
end

game:GetService("MessagingService"):SubscribeAsync("HupPet_Channel", function(msg)
    pcall(function() CreateEntry(msg.Data) end)
end)
