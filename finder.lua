local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FastRobberV6"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- ================= TEXTBOX =================
local TextBox = Instance.new("TextBox", MainFrame)
TextBox.Size = UDim2.new(0.8, 0, 0.22, 0)
TextBox.Position = UDim2.new(0.1, 0, 0.08, 0)
TextBox.PlaceholderText = "JobId..."
TextBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
TextBox.TextColor3 = Color3.new(1,1,1)
TextBox.Text = ""
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0,6)

-- ================= BUTTONS =================
local function createBtn(text, y, color)
    local b = Instance.new("TextButton", MainFrame)
    b.Size = UDim2.new(0.8, 0, 0.22, 0)
    b.Position = UDim2.new(0.1, 0, y, 0)
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

local JoinBtn = createBtn("THAM GIA SERVER", 0.32, Color3.fromRGB(0,100,200))
local BoostBtn = createBtn("BOOST FPS: ON", 0.54, Color3.fromRGB(0,200,0))
local AutoEBtn = createBtn("AUTO E: OFF", 0.76, Color3.fromRGB(150,0,0))
local CopyBtn = createBtn("COPY JOBID", 0.98, Color3.fromRGB(80,80,80))
local JumpBtn = createBtn("JUMP BOOST", 1.18, Color3.fromRGB(80,120,255))
-- ================= FIX LAG =================
local function FixLag()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end
    end
end
----Conne-----------------------------Conne------ConnConne-
task.spawn(function()
    task.wait(0.5) -- chờ game load nhẹ

    FixLag()

    BoostBtn.Text = "BOOST FPS: ON"
    BoostBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
end)

--[[
    🚀 JUMP BOOST V10 (ANTI-CHANCE & ANTI-KICK)
    - Cơ chế: Thay đổi JumpPower thay vì dùng BodyVelocity.
    - Bảo mật: Tự động trả lại thông số gốc ngay sau khi nhảy.
    - Hiệu suất: Không tạo thêm Instance mới, giảm lag tối đa.
]]

JumpBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if hum then
        -- 1. Lấy thông số gốc để tránh làm hỏng nhân vật
        local originalPower = hum.JumpPower
        hum.UseJumpPower = true -- Đảm bảo game dùng JumpPower thay vì JumpHeight

        -- 2. Tăng lực nhảy nhẹ (Ngưỡng an toàn thường là 50-70)
        -- Đừng để quá cao (trên 100) nếu không muốn bị hệ thống Server-side kick
        hum.JumpPower =55 

        -- 3. Kích hoạt lệnh nhảy hợp lệ của Engine
        hum.Jump = true

        -- 4. Thay đổi trạng thái nhảy để đồng bộ hóa
        hum:ChangeState(Enum.HumanoidStateType.Jumping)

        -- 5. Trả lại thông số gốc sau một khoảng thời gian cực ngắn
        -- Việc này giúp server thấy rằng ông chỉ có JumpPower cao trong chớp mắt
        task.delay(0,01, function()
            if hum then
                hum.JumpPower = originalPower
            end
        end)
    end

    -- Hiệu ứng UI
    JumpBtn.Text = "⚡ BOOSTED"
    task.wait(0.5)
    JumpBtn.Text = "JUMP BOOST"
end)
-- ================= JOIN SERVER =================
JoinBtn.MouseButton1Click:Connect(function()
    local jobId = TextBox.Text:gsub("%s+", "")
    if jobId == "" then jobId = game.JobId end

    JoinBtn.Text = "ĐANG NHẢY..."

    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)
    end)

    task.wait(1)
    JoinBtn.Text = "THAM GIA SERVER"
end)

---------------------------------------------------
CopyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard(tostring(game.JobId))
    end)

    CopyBtn.Text = "ĐÃ COPY!"
    CopyBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)

    task.wait(1)

    CopyBtn.Text = "COPY JOBID"
    CopyBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
end)
-- ================= BOOST FPS =================
BoostBtn.MouseButton1Click:Connect(function()
    FixLag()
    BoostBtn.Text = "ĐÃ BOOST FPS"
    BoostBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
end)

-- ================= AUTO E (BẢN CŨ ÉP 0 GIÂY) =================
local autoE = false

AutoEBtn.MouseButton1Click:Connect(function()
    autoE = not autoE
    AutoEBtn.Text = autoE and "AUTO E: ON" or "AUTO E: OFF"
    AutoEBtn.BackgroundColor3 = autoE and Color3.fromRGB(0,180,0) or Color3.fromRGB(150,0,0)
end)

task.spawn(function()
    while true do
        if autoE and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position

            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    if obj.KeyboardKeyCode == Enum.KeyCode.E then
                        local parent = obj.Parent

                        if parent and parent:IsA("BasePart") then
                            if (myPos - parent.Position).Magnitude <= obj.MaxActivationDistance then
                                obj.HoldDuration = 0
                                pcall(function()
                                    obj:InputHoldBegin()
                                    obj:InputHoldEnd()
                                end)
                            end
                        else
                            obj.HoldDuration = 0
                            pcall(function()
                                obj:InputHoldBegin()
                                obj:InputHoldEnd()
                            end)
                        end
                    end
                end
            end
        end

        task.wait(0.17) -- giống bản cũ (nhanh nhưng nặng)
    end
end)

print("✅ FastRobber V6 FULL LOADED (AutoE + Boost + FixLag)")
