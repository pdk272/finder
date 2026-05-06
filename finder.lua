-- SCRIPT CHO ACC CHÍNH (MASTER BRAIN)
if not game:IsLoaded() then game.Loaded:Wait() end

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local AutoE_Btn = Instance.new("TextButton")
local JobIdInput = Instance.new("TextBox")
local Join_Btn = Instance.new("TextButton")

-- Cấu hình Giao diện
ScreenGui.Parent = game:GetService("CoreGui")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Size = UDim2.new(0, 200, 0, 180)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Active = true
MainFrame.Draggable = true -- Có thể kéo bảng đi chỗ khác cho đỡ vướng

Title.Parent = MainFrame
Title.Text = "BRAIN MASTER V1"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- 1. NÚT AUTO E (0.17 GIÂY)
AutoE_Btn.Parent = MainFrame
AutoE_Btn.Position = UDim2.new(0.1, 0, 0.25, 0)
AutoE_Btn.Size = UDim2.new(0.8, 0, 0.25, 0)
AutoE_Btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
AutoE_Btn.Text = "AUTO E: OFF"
AutoE_Btn.TextColor3 = Color3.new(1, 1, 1)

local autoE = false
AutoE_Btn.MouseButton1Click:Connect(function()
    autoE = not autoE
    AutoE_Btn.Text = autoE and "AUTO E: ON (0.17s)" or "AUTO E: OFF"
    AutoE_Btn.BackgroundColor3 = autoE and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

task.spawn(function()
    while task.wait(0.17) do -- Tốc độ 0.17 giây theo ý ông
        if autoE then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.05)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end
    end
end)

-- 2. NHẬP JOBID VÀ JOIN NHANH
JobIdInput.Parent = MainFrame
JobIdInput.PlaceholderText = "Dán JobId vào đây..."
JobIdInput.Size = UDim2.new(0.8, 0, 0.15, 0)
JobIdInput.Position = UDim2.new(0.1, 0, 0.55, 0)

Join_Btn.Parent = MainFrame
Join_Btn.Text = "BAY VÀO SERVER"
Join_Btn.Size = UDim2.new(0.8, 0, 0.2, 0)
Join_Btn.Position = UDim2.new(0.1, 0, 0.75, 0)
Join_Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
Join_Btn.TextColor3 = Color3.new(1, 1, 1)

Join_Btn.MouseButton1Click:Connect(function()
    local id = JobIdInput.Text
    if id and #id > 5 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, id)
    end
end)
