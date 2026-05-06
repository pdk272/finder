-- MASTER HUB V5: AUTO E 0 GIÂY THỰC SỰ
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
local Sidebar = Instance.new("Frame", Main)
local Content = Instance.new("ScrollingFrame", Main)
local UIListLayout = Instance.new("UIListLayout", Content)

Main.Size = UDim2.new(0, 480, 0, 320)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true Main.Draggable = true

Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)

local TabLabel = Instance.new("TextLabel", Sidebar)
TabLabel.Text = "🐾 Brainrot Finder"
TabLabel.Size = UDim2.new(1, 0, 0, 40)
TabLabel.TextColor3 = Color3.new(1, 1, 1)
TabLabel.BackgroundTransparency = 1

-- NÚT AUTO E (0 GIÂY ĐỘ TRỄ)
local AutoEBtn = Instance.new("TextButton", Sidebar)
AutoEBtn.Size = UDim2.new(0.9, 0, 0, 50)
AutoEBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
AutoEBtn.Text = "AUTO E: OFF"
AutoEBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
AutoEBtn.TextColor3 = Color3.new(1, 1, 1)

local autoE = false
AutoEBtn.MouseButton1Click:Connect(function()
    autoE = not autoE
    AutoEBtn.Text = autoE and "E: ON (0s)" or "AUTO E: OFF"
    AutoEBtn.BackgroundColor3 = autoE and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

-- ÉP E 0 GIÂY (DÙNG RENDERSTEPPED)
local Vim = game:GetService("VirtualInputManager")
game:GetService("RunService").RenderStepped:Connect(function()
    if autoE then
        Vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        Vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end)

-- DANH SÁCH SERVER HIỆN TỪ ACC PHỤ
Content.Size = UDim2.new(0, 340, 0, 260)
Content.Position = UDim2.new(0, 130, 0, 50)
Content.BackgroundTransparency = 1
UIListLayout.Padding = UDim.new(0, 8)

local function CreateEntry(data)
    local Frame = Instance.new("Frame", Content)
    Frame.Size = UDim2.new(1, -10, 0, 70)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)

    local Info = Instance.new("TextLabel", Frame)
    Info.Text = "🌟 " .. tostring(data.PetName):upper() .. "\nPlayers: " .. tostring(data.Players) .. " | Nguồn: Acc " .. tostring(data.AccSource)
    Info.Size = UDim2.new(0.7, 0, 1, 0)
    Info.TextColor3 = Color3.new(1, 1, 1)
    Info.BackgroundTransparency = 1
    Info.TextXAlignment = Enum.TextXAlignment.Left

    local JoinBtn = Instance.new("TextButton", Frame)
    JoinBtn.Text = "Join"
    JoinBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
    JoinBtn.Position = UDim2.new(0.72, 0, 0.2, 0)
    JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    JoinBtn.TextColor3 = Color3.new(1, 1, 1)

    JoinBtn.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data.JobId)
    end)
    task.delay(120, function() Frame:Destroy() end)
end

game:GetService("MessagingService"):SubscribeAsync("BrainrotFinderSignal", function(msg)
    pcall(function()
        CreateEntry(msg.Data)
    end)
end)
