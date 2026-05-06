-- ===== 1. TẠO GIAO DIỆN (GUI) =====
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fix lỗi chồng GUI
if CoreGui:FindFirstChild("FastRobberV6") then CoreGui.FastRobberV6:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FastRobberV6"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TextBox = Instance.new("TextBox", MainFrame)
TextBox.Size = UDim2.new(0.8, 0, 0.25, 0)
TextBox.Position = UDim2.new(0.1, 0, 0.1, 0)
TextBox.PlaceholderText = "Dán JobId..."
TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.ClearTextOnFocus = true
TextBox.Text = ""
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

local JoinBtn = Instance.new("TextButton", MainFrame)
JoinBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
JoinBtn.Position = UDim2.new(0.1, 0, 0.4, 0)
JoinBtn.Text = "JOIN SERVER"
JoinBtn.Font = Enum.Font.SourceSansBold
JoinBtn.TextSize = 16
JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
JoinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 6)

local AutoEBtn = Instance.new("TextButton", MainFrame)
AutoEBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
AutoEBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
AutoEBtn.Text = "AUTO E: OFF"
AutoEBtn.Font = Enum.Font.SourceSansBold
AutoEBtn.TextSize = 16
AutoEBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
AutoEBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", AutoEBtn).CornerRadius = UDim.new(0, 6)

-- ===== 2. LOGIC CACHE (FIX LAG 100%) =====
local prompts = {}

-- Hàm quét 1 lần duy nhất để lấy danh sách
local function refreshCache()
    table.clear(prompts)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            table.insert(prompts, obj)
        end
    end
end
refreshCache()

-- Tự cập nhật thêm pet mới khi nó spawn ra sân mà không cần quét lại map
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        table.insert(prompts, obj)
    end
end)

-- ===== 3. LOGIC XỬ LÝ =====

JoinBtn.MouseButton1Click:Connect(function()
    local jobId = TextBox.Text:gsub("%s+", "")
    if jobId ~= "" then
        JoinBtn.Text = "ĐANG NHẢY..."
        JoinBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 0)
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
        end)
    end
end)

local AutoE_Enabled = false
AutoEBtn.MouseButton1Click:Connect(function()
    AutoE_Enabled = not AutoE_Enabled
    AutoEBtn.Text = AutoE_Enabled and "AUTO E: ON" or "AUTO E: OFF"
    AutoEBtn.BackgroundColor3 = AutoE_Enabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(150, 0, 0)
end)

task.spawn(function()
    while true do
        if AutoE_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position
            
            -- Chạy trên danh sách prompts đã lưu (Cực nhẹ máy)
            for i = #prompts, 1, -1 do
                local obj = prompts[i]
                
                if obj and obj.Parent then
                    if obj.KeyboardKeyCode == Enum.KeyCode.E then
                        local parent = obj.Parent
                        local pos = parent:IsA("BasePart") and parent.Position or (parent:IsA("Model") and parent:GetModelCFrame().p)
                        
                        if pos and (myPos - pos).Magnitude <= obj.MaxActivationDistance then
                            obj.HoldDuration = 0
                            pcall(function()
                                obj:InputHoldBegin()
                                obj:InputHoldEnd()
                            end)
                        end
                    end
                else
                    table.remove(prompts, i) -- Xóa khỏi danh sách nếu pet biến mất
                end
            end
        end
        task.wait(0.05) -- Tốc độ thần thánh: 20 lần/giây nhưng đéo lag!
    end
end)

print("✅ Master V6 Turbo - Đã fix lag và Ready!")
