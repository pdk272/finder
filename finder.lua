local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Grabber"
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,180,0,90)
Frame.Position = UDim2.new(0.5,-90,0.4,0)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.Active = true
Frame.Draggable = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,8)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = Frame
ToggleBtn.Size = UDim2.new(0.8,0,0.5,0)
ToggleBtn.Position = UDim2.new(0.1,0,0.25,0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 20
ToggleBtn.Text = "GRAB: OFF"

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0,8)

-- TOGGLE
local Enabled = false

ToggleBtn.MouseButton1Click:Connect(function()
	Enabled = not Enabled

	if Enabled then
		ToggleBtn.Text = "GRAB: ON"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)
	else
		ToggleBtn.Text = "GRAB: OFF"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
	end
end)

-- CACHE PROMPTS
local GrabPrompts = {}

local function addPrompt(v)
	if v:IsA("ProximityPrompt") and v.ActionText == "Grab" then
		table.insert(GrabPrompts, v)
	end
end

for _, v in ipairs(workspace:GetDescendants()) do
	addPrompt(v)
end

workspace.DescendantAdded:Connect(addPrompt)

-- GET PART
local function getPart(prompt)
	local parent = prompt.Parent

	while parent do
		if parent:IsA("BasePart") then
			return parent
		end

		parent = parent.Parent
	end
end

-- AUTO GRAB
task.spawn(function()
	while task.wait(0.25) do
		if Enabled and LocalPlayer.Character then
			local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

			if hrp then
				for _, prompt in ipairs(GrabPrompts) do
					if prompt and prompt.Parent then
						local part = getPart(prompt)

						if part then
							local dist = (hrp.Position - part.Position).Magnitude

							if dist <= 10 then
								pcall(function()
									prompt.HoldDuration = 0
									prompt.MaxActivationDistance = 20

									if fireproximityprompt then
										fireproximityprompt(prompt)
									end
								end)
							end
						end
					end
				end
			end
		end
	end
end)
