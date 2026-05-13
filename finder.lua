local CoreGui = game:GetService("CoreGui")



local TeleportService = game:GetService("TeleportService")



local Players = game:GetService("Players")



local LocalPlayer = Players.LocalPlayer







local ScreenGui = Instance.new("ScreenGui", CoreGui)



ScreenGui.Name = "FastRobberV6"







local MainFrame = Instance.new("Frame", ScreenGui)



MainFrame.Size = UDim2.new(0, 200, 0, 150)



MainFrame.Position = UDim2.new(0.5, -100, 0.4, 0)



MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)



MainFrame.Active = true



MainFrame.Draggable = true -- Có thể dùng chuột kéo bảng đi chỗ khác



Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)







-- Ô nhập JobId



local TextBox = Instance.new("TextBox", MainFrame)



TextBox.Size = UDim2.new(0.8, 0, 0.25, 0)



TextBox.Position = UDim2.new(0.1, 0, 0.1, 0)



TextBox.PlaceholderText = "Dán JobId..."



TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)



TextBox.TextColor3 = Color3.new(1, 1, 1)



TextBox.ClearTextOnFocus = true



TextBox.Text = ""



Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)







-- Nút Join



local JoinBtn = Instance.new("TextButton", MainFrame)



JoinBtn.Size = UDim2.new(0.8, 0, 0.25, 0)



JoinBtn.Position = UDim2.new(0.1, 0, 0.4, 0)



JoinBtn.Text = "tham gia"



JoinBtn.Font = Enum.Font.SourceSansBold



JoinBtn.TextSize = 16



JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)



JoinBtn.TextColor3 = Color3.new(1, 1, 1)



Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 6)







-- Nút Auto E



local AutoEBtn = Instance.new("TextButton", MainFrame)



AutoEBtn.Size = UDim2.new(0.8, 0, 0.25, 0)



AutoEBtn.Position = UDim2.new(0.1, 0, 0.7, 0)



AutoEBtn.Text = " AutoE: OFF"



AutoEBtn.Font = Enum.Font.SourceSansBold



AutoEBtn.TextSize = 16



AutoEBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)



AutoEBtn.TextColor3 = Color3.new(1, 1, 1)



Instance.new("UICorner", AutoEBtn).CornerRadius = UDim.new(0, 6)







-- ===== 2. LOGIC XỬ LÝ =====







-- Xử lý Nhảy Server



JoinBtn.MouseButton1Click:Connect(function()



local jobId = TextBox.Text:gsub("%s+", "")



if jobId ~= "" then



JoinBtn.Text = "ĐANG NHẢY..."



JoinBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 0)





local success, err = pcall(function()



TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, LocalPlayer)



end)





if not success then



JoinBtn.Text = "LỖI! THỬ LẠI"



JoinBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)



task.wait(2)



JoinBtn.Text = "JOIN SERVER"



JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)



end



else



JoinBtn.Text = "CHƯA NHẬP ID!"



task.wait(1)



JoinBtn.Text = "JOIN SERVER"



end



end)







-- Logic Cướp Siêu Tốc (Ép 0 Giây)



local AutoE_Enabled = false







AutoEBtn.MouseButton1Click:Connect(function()



AutoE_Enabled = not AutoE_Enabled



if AutoE_Enabled then



AutoEBtn.Text = "AUTO: ON"



AutoEBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)



else



AutoEBtn.Text = "AUTO: OFF"



AutoEBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)



end



end)







task.spawn(function()



while true do



if AutoE_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then



local myPos = LocalPlayer.Character.HumanoidRootPart.Position





for _, obj in ipairs(workspace:GetDescendants()) do



if obj:IsA("ProximityPrompt") then



-- Kiểm tra phím E



if obj.KeyboardKeyCode == Enum.KeyCode.E then



local parent = obj.Parent



if parent and parent:IsA("BasePart") then



local dist = (myPos - parent.Position).Magnitude



if dist <= obj.MaxActivationDistance then



-- ÉP VỀ 0 GIÂY VÀ KÍCH HOẠT TỨC THÌ



obj.HoldDuration = 0



obj:InputHoldBegin()



obj:InputHoldEnd()



end



else



-- Nếu pet không phải Part, cứ ép 0s và nhặt cho chắc



obj.HoldDuration = 0



obj:InputHoldBegin()



obj:InputHoldEnd()



end



end



end



end



end



task.wait(0.35) -- Tốc độ nhặt cực nhanh, khoảng 6 lần/giây để tránh bị kick



end



end)
