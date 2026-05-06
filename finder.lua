-- MASTER GUI V2: BRAINROT FINDER (GIỐNG ẢNH EPSILON HUB)
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Sidebar = Instance.new("Frame")
local Content = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local AutoEBtn = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
Main.Name = "EpsilonStyle"
Main.Size = UDim2.new(0, 450, 0, 300)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Active = true
Main.Draggable = true

-- Sidebar giả lập ảnh
Sidebar.Size = UDim2.new(0, 100, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Sidebar.Parent = Main

local TabLabel = Instance.new("TextLabel", Sidebar)
TabLabel.Text = "Brainrot Finder"
TabLabel.Size = UDim2.new(1, 0, 0, 50)
TabLabel.TextColor3 = Color3.new(1, 1, 1)
TabLabel.BackgroundTransparency = 1

-- Nút Auto E 0.17s
AutoEBtn.Parent = Sidebar
AutoEBtn.Size = UDim2.new(0.9, 0, 0, 40)
AutoEBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
AutoEBtn.Text = "Auto E: Off"
AutoEBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)

local autoE = false
AutoEBtn.MouseButton1Click:Connect(function()
    autoE = not autoE
    AutoEBtn.Text = autoE and "E: ON" or "E: OFF"
    AutoEBtn.BackgroundColor3 = autoE and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

task.spawn(function()
    while task.wait(0.5) do
        if autoE then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    end
end)

-- Vùng hiện danh sách Server
Content.Size = UDim2.new(0, 330, 0, 240)
Content.Position = UDim2.new(0, 110, 0, 50)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Content.BorderSizePixel = 0
Content.Parent = Main
UIListLayout.Parent = Content
UIListLayout.Padding = UDim.new(0, 5)

-- HÀM TẠO DÒNG SERVER (GIỐNG NÚT JOIN TRONG ẢNH)
local function CreateServerEntry(data)
    local Entry = Instance.new("Frame")
    Entry.Size = UDim2.new(1, -10, 0, 60)
    Entry.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Entry.Parent = Content

    local Info = Instance.new("TextLabel", Entry)
    Info.Text = "🔥 " .. data.PetName:upper() .. "\nPlayers: " .. data.Players
    Info.Size = UDim2.new(0.7, 0, 1, 0)
    Info.TextColor3 = Color3.new(1, 1, 1)
    Info.BackgroundTransparency = 1
    Info.TextXAlignment = Enum.TextXAlignment.Left

    local JoinBtn = Instance.new("TextButton", Entry)
    JoinBtn.Text = "Join"
    JoinBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
    JoinBtn.Position = UDim2.new(0.7, 0, 0.2, 0)
    JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    JoinBtn.TextColor3 = Color3.new(1, 1, 1)

    JoinBtn.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data.JobId)
    end)
end

-- LẮNG NGHE TÍN HIỆU TỪ 10 ACC PHỤ
game:GetService("MessagingService"):SubscribeAsync("BrainrotFinderSignal", function(message)
    local data = message.Data
    CreateServerEntry(data)
end)
