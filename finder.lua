-- TẠO GIAO DIỆN (GUI)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TextBox = Instance.new("TextBox")
local JoinBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- Cấu hình GUI
ScreenGui.Parent = game:GetService("CoreGui") -- Hiện trong menu ẩn của Roblox
ScreenGui.Name = "QuickJoinGui"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true -- Ông có thể lấy chuột kéo bảng này đi chỗ khác

local FrameCorner = UICorner:Clone()
FrameCorner.Parent = MainFrame

-- Ô Nhập JobId
TextBox.Parent = MainFrame
TextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBox.Position = UDim2.new(0.1, 0, 0.15, 0)
TextBox.Size = UDim2.new(0.8, 0, 0.3, 0)
TextBox.Font = Enum.Font.SourceSans
TextBox.PlaceholderText = "Dán JobId vào đây..."
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 14
TextBox.TextTruncate = Enum.TextTruncate.AtEnd

UICorner:Clone().Parent = TextBox

-- Nút Join
JoinBtn.Parent = MainFrame
JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
JoinBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
JoinBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
JoinBtn.Font = Enum.Font.SourceSansBold
JoinBtn.Text = "JOIN SERVER"
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.TextSize = 18

UICorner:Clone().Parent = JoinBtn

-- XỬ LÝ NHẢY SERVER
JoinBtn.MouseButton1Click:Connect(function()
    local jobId = TextBox.Text:gsub("%s+", "") -- Xóa khoảng trắng thừa
    
    if jobId and jobId ~= "" then
        JoinBtn.Text = "ĐANG NHẢY..."
        JoinBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 0)
        
        local success, err = pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobId, game.Players.LocalPlayer)
        end)
        
        if not success then
            JoinBtn.Text = "LỖI! THỬ LẠI"
            JoinBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
            warn("Lỗi Join: " .. tostring(err))
            task.wait(2)
            JoinBtn.Text = "JOIN SERVER"
            JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        end
    else
        JoinBtn.Text = "CHƯA NHẬP ID!"
        task.wait(1)
        JoinBtn.Text = "JOIN SERVER"
    end
end)

print("✅ GUI Nhập JobId đã sẵn sàng!")
