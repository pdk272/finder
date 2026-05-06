-- ===== ANTI LAG + ANTI KICK =====
local prompts = {}
local MAX_PER_TICK = 15
local MIN_DELAY = 0.35
local MAX_DELAY = 0.7

local function smartDelay()
    return math.random() * (MAX_DELAY - MIN_DELAY) + MIN_DELAY
end

-- cache prompt có sẵn
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
        table.insert(prompts, obj)
    end
end

-- thêm prompt mới khi spawn
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        table.insert(prompts, obj)
    end
end)

-- AUTO E (đã tối ưu)
task.spawn(function()
    while true do
        if AutoE_Enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local myPos = hrp.Position
            local processed = 0

            for i = #prompts, 1, -1 do
                if processed >= MAX_PER_TICK then break end

                local obj = prompts[i]

                if obj and obj.Parent then
                    if obj.KeyboardKeyCode == Enum.KeyCode.E then
                        local parent = obj.Parent

                        if parent and parent:IsA("BasePart") then
                            local dist = (myPos - parent.Position).Magnitude

                            if dist <= obj.MaxActivationDistance then
                                obj.HoldDuration = 0

                                pcall(function()
                                    obj:InputHoldBegin()
                                    task.wait(0.05)
                                    obj:InputHoldEnd()
                                end)

                                processed += 1
                            end
                        end
                    end
                else
                    table.remove(prompts, i)
                end
            end
        end

        task.wait(smartDelay())
    end
end)

LocalPlayer.Idled:Connect(function()
    pcall(function()
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end)
