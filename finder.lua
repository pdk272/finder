-- MASTER HUB V3: FIX LỖI NHẬN TÍN HIỆU + SIÊU CẤP AUTO E
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
local Sidebar = Instance.new("Frame", Main)
local Content = Instance.new("ScrollingFrame", Main)
local UIListLayout = Instance.new("UIListLayout", Content)

-- Giao diện Epsilon Style
Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true Main.Draggable = true

Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)

-- NÚT AUTO E (20 LẦN/GIÂY)
local AutoEBtn = Instance.new("TextButton", Sidebar)
AutoEBtn.Size = UDim2.new(0.9, 0, 0, 40)
AutoEBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
AutoEBtn.Text = "AUTO E: OFF"
AutoEBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
AutoEBtn.TextColor3 = Color3.new(1, 1, 1)

local autoE = false
AutoEBtn.MouseButton1Click:Connect(function()
    autoE = not autoE
    AutoEBtn.Text = autoE and "E: ON (20/s)" or "AUTO E: OFF"
    AutoEBtn.BackgroundColor3 = autoE and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

-- Vòng lặp ép E thần tốc (0.05s = 20 lần/giây)
task.spawn(function()
    local Vim = game:GetService("VirtualInputManager")
    while true do
        if autoE then
            Vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.02) -- Nhấn xuống
            Vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.03) -- Thả ra (Tổng 0.05s)
        else
            task.wait(0.5)
        end
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
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)

    local Info = Instance.new("TextLabel", Frame)
    Info.Text = "🌟 " .. tostring(data.PetName):upper() .. "\nPlayers: " .. tostring(data.Players)
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
    task.delay(120, function() Frame:Destroy() end)
end

-- FIX LỖI NHẬN TÍN HIỆU
game:GetService("MessagingService"):SubscribeAsync("BrainrotFinderSignal", function(msg)
    local success, err = pcall(function()
        CreateEntry(msg.Data)
    end)
    if not success then warn("Lỗi hiển thị GUI: " .. err) end
end)
