-- MASTER HUB V6: SIÊU TỐC ĐỘ + CHỐNG KICK + FIX TÍN HIỆU
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
local Sidebar = Instance.new("Frame", Main)
local Content = Instance.new("ScrollingFrame", Main)
local UIListLayout = Instance.new("UIListLayout", Content)

Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.Active = true Main.Draggable = true

Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

-- NÚT AUTO E SIÊU CẤP (ÉP 20-30 LẦN/S)
local AutoEBtn = Instance.new("TextButton", Sidebar)
AutoEBtn.Size = UDim2.new(0.9, 0, 0, 50)
AutoEBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
AutoEBtn.Text = "AUTO E: OFF"
AutoEBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
AutoEBtn.TextColor3 = Color3.new(1, 1, 1)

local autoE = false
AutoEBtn.MouseButton1Click:Connect(function()
    autoE = not autoE
    AutoEBtn.Text = autoE and "E: MAX SPEED" or "AUTO E: OFF"
    AutoEBtn.BackgroundColor3 = autoE and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

-- Vòng lặp ép E: Dùng Heartbeat để tối ưu tốc độ mà không gây crash
game:GetService("RunService").Heartbeat:Connect(function()
    if autoE then
        local Vim = game:GetService("VirtualInputManager")
        Vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait() -- Nghỉ cực ngắn để tránh BAC-6197
        Vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end)

-- Danh sách Server
Content.Size = UDim2.new(0, 340, 0, 260)
Content.Position = UDim2.new(0, 130, 0, 50)
Content.BackgroundTransparency = 1
UIListLayout.Padding = UDim.new(0, 8)

local function CreateEntry(data)
    local Frame = Instance.new("Frame", Content)
    Frame.Size = UDim2.new(1, -10, 0, 70)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)

    local Info = Instance.new("TextLabel", Frame)
    Info.Text = "🌟 " .. tostring(data.PetName):upper() .. "\nAcc: " .. tostring(data.AccSource) .. " | " .. tostring(data.Players)
    Info.Size = UDim2.new(0.7, 0, 1, 0)
    Info.TextColor3 = Color3.new(1, 1, 1)
    Info.BackgroundTransparency = 1
    Info.TextXAlignment = Enum.TextXAlignment.Left

    local Join = Instance.new("TextButton", Frame)
    Join.Text = "Join"
    Join.Size = UDim2.new(0.25, 0, 0.6, 0)
    Join.Position = UDim2.new(0.72, 0, 0.2, 0)
    Join.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    Join.TextColor3 = Color3.new(1, 1, 1)

    Join.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data.JobId)
    end)
    task.delay(180, function() Frame:Destroy() end)
end

-- NHẬN TÍN HIỆU (MessagingService - Dùng tên kênh riêng biệt)
game:GetService("MessagingService"):SubscribeAsync("HupPet_Channel", function(msg)
    pcall(function() CreateEntry(msg.Data) end)
end)
