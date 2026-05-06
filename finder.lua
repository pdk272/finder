if not game:IsLoaded() then game.Loaded:Wait() end

local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", Main)
local JobIdInput = Instance.new("TextBox", Main)
local JoinBtn = Instance.new("TextButton", Main)
local HackEBtn = Instance.new("TextButton", Main)

Main.Size = UDim2.new(0, 220, 0, 180)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true Main.Draggable = true

Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "HÚP PET CỔ ĐIỂN"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- NHẬP JOBID
JobIdInput.Size = UDim2.new(0.9, 0, 0, 30)
JobIdInput.Position = UDim2.new(0.05, 0, 0.25, 0)
JobIdInput.PlaceholderText = "Dán JobId vào đây..."
JobIdInput.TextScaled = true

-- NÚT BAY
JoinBtn.Size = UDim2.new(0.9, 0, 0, 35)
JoinBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
JoinBtn.Text = "BAY VÀO SERVER"
JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
JoinBtn.TextColor3 = Color3.new(1, 1, 1)

JoinBtn.MouseButton1Click:Connect(function()
    local id = JobIdInput.Text
    if id and #id > 5 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, id)
    end
end)

-- HACK ÉP E 0 GIÂY MÀ KHÔNG BỊ KICK
HackEBtn.Size = UDim2.new(0.9, 0, 0, 40)
HackEBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
HackEBtn.Text = "HACK E 0s: OFF"
HackEBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
HackEBtn.TextColor3 = Color3.new(1, 1, 1)

local autoHack = false
HackEBtn.MouseButton1Click:Connect(function()
    autoHack = not autoHack
    HackEBtn.Text = autoHack and "HACK 0s: ĐANG BẬT" or "HACK E 0s: OFF"
    HackEBtn.BackgroundColor3 = autoHack and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

-- Lõi Hack Nhặt Đồ 0 Giây (Bypass 2 giây của game)
task.spawn(function()
    while true do
        task.wait(0.1)
        if autoHack then
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0 -- Ép thời gian chờ về 0
                    if fireproximityprompt then
                        fireproximityprompt(prompt) -- Chọt cho nhặt luôn
                    end
                end
            end
        end
    end
end)
