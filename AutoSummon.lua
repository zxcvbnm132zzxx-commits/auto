local player = game.Players.LocalPlayer

-- ===== ScreenGui =====
local gui = Instance.new("ScreenGui")
gui.Name = "MultiModeSummonGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- ===== Frame =====
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 320) -- ขยายความสูง
frame.Position = UDim2.new(0.5, -180, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- ===== Title =====
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "MULTI MODE AUTO SUMMON"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- ===== State =====
local running = false
local banner = "Anniversary"
local amount = 100
local delaySec = 1

-- ===== Helper =====
local function makeButton(parent, text, pos)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0,140,0,40)
	b.Position = pos
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
	return b
end

-- ===== Banner Buttons =====
local b1 = makeButton(frame, "Anniversary", UDim2.new(0.08,0,0.22,0))
local b2 = makeButton(frame, "Special",     UDim2.new(0.52,0,0.22,0))
local b3 = makeButton(frame, "Fall",        UDim2.new(0.08,0,0.38,0))
local b4 = makeButton(frame, "Selection",  UDim2.new(0.52,0,0.38,0))

local bannerButtons = {b1, b2, b3, b4}

local function selectBanner(name, btn)
	banner = name
	for _,b in pairs(bannerButtons) do
		b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	end
	btn.BackgroundColor3 = Color3.fromRGB(0,120,200)
end

-- ค่าเริ่มต้น
selectBanner("Anniversary", b1)

b1.MouseButton1Click:Connect(function() selectBanner("Anniversary", b1) end)
b2.MouseButton1Click:Connect(function() selectBanner("Special", b2) end)
b3.MouseButton1Click:Connect(function() selectBanner("Fall", b3) end)
b4.MouseButton1Click:Connect(function() selectBanner("Selection", b4) end)

-- ===== Amount Buttons =====
local a10  = makeButton(frame, "x10",  UDim2.new(0.08,0,0.55,0))
local a100 = makeButton(frame, "x100", UDim2.new(0.52,0,0.55,0))
a100.BackgroundColor3 = Color3.fromRGB(0,170,0)

a10.MouseButton1Click:Connect(function()
	amount = 10
	a10.BackgroundColor3 = Color3.fromRGB(0,170,0)
	a100.BackgroundColor3 = Color3.fromRGB(70,70,70)
end)

a100.MouseButton1Click:Connect(function()
	amount = 100
	a100.BackgroundColor3 = Color3.fromRGB(0,170,0)
	a10.BackgroundColor3 = Color3.fromRGB(70,70,70)
end)

-- ===== Start / Stop =====
local control = makeButton(frame, "START", UDim2.new(0.3,0,0.72,0))
control.Size = UDim2.new(0,160,0,45)
control.BackgroundColor3 = Color3.fromRGB(0,170,0)

control.MouseButton1Click:Connect(function()
	running = not running
	if running then
		control.Text = "STOP"
		control.BackgroundColor3 = Color3.fromRGB(170,0,0)
	else
		control.Text = "START"
		control.BackgroundColor3 = Color3.fromRGB(0,170,0)
	end
end)

-- ===== Loop =====
task.spawn(function()
	while true do
		if running then
			game:GetService("ReplicatedStorage")
				:WaitForChild("Networking")
				:WaitForChild("Units")
				:WaitForChild("SummonEvent")
				:FireServer("SummonMany", banner, amount)
		end
		task.wait(delaySec)
	end
end)
