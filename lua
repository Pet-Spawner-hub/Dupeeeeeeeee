local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetDupeGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Draggable "Duplicate" Button
local dupeButton = Instance.new("TextButton")
dupeButton.Name = "DuplicateButton"
dupeButton.Size = UDim2.new(0, 160, 0, 50)
dupeButton.Position = UDim2.new(0.5, -80, 0.9, -25)
dupeButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black
dupeButton.TextColor3 = Color3.new(1, 1, 1)
dupeButton.Font = Enum.Font.SourceSansBold
dupeButton.TextSize = 22
dupeButton.Text = "Duplicate"
dupeButton.Draggable = true
dupeButton.Active = true
dupeButton.Selectable = true
dupeButton.Parent = screenGui

-- Duplication Message Label
local messageLabel = Instance.new("TextLabel")
messageLabel.Size = UDim2.new(0, 250, 0, 40)
messageLabel.Position = UDim2.new(0.5, -125, 0.8, -100)
messageLabel.BackgroundColor3 = Color3.new(0, 0, 0)
messageLabel.TextColor3 = Color3.new(1, 1, 1)
messageLabel.Font = Enum.Font.SourceSansBold
messageLabel.TextSize = 20
messageLabel.Text = ""
messageLabel.Visible = false
messageLabel.Parent = screenGui

-- Folder for visual clones
local clonesFolder = workspace:FindFirstChild("VisualPetClones") or Instance.new("Folder")
clonesFolder.Name = "VisualPetClones"
clonesFolder.Parent = workspace

-- Fake Inventory Folder (visual only)
local inventoryFolder = player:FindFirstChild("FakeInventory") or Instance.new("Folder")
inventoryFolder.Name = "FakeInventory"
inventoryFolder.Parent = player

-- Function: Get held pet (Tool)
local function getHeldPet()
	local character = player.Character or player.CharacterAdded:Wait()
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then return nil end

	-- Pet is inside the tool
	local petModel = tool:FindFirstChildWhichIsA("Model") or tool:FindFirstChild("Pet")
	return petModel, tool
end

-- Function: Duplicate pet visually
local function duplicatePet()
	local heldPet, tool = getHeldPet()
	if not heldPet or not tool then
		warn("No held pet/tool found.")
		return
	end

	-- Show duping message
	messageLabel.Text = "Duping in 3 minutes..."
	messageLabel.Visible = true

	-- Wait 3 minutes (180 seconds)
	task.delay(180, function()
		messageLabel.Visible = false

		local petClone = heldPet:Clone()
		petClone.Name = heldPet.Name .. "_Clone"

		-- Position near the player
		if petClone:IsA("Model") then
			if not petClone.PrimaryPart then
				local primary = petClone:FindFirstChildWhichIsA("BasePart")
				if primary then petClone.PrimaryPart = primary end
			end

			if petClone.PrimaryPart and player.Character then
				local pos = player.Character.PrimaryPart.Position + Vector3.new(math.random(-5,5), 0, math.random(-5,5))
				petClone:SetPrimaryPartCFrame(CFrame.new(pos))
			end
		end

		-- Copy Age and Weight values
		local age = heldPet:FindFirstChild("Age")
		local weight = heldPet:FindFirstChild("Weight")

		if age then
			local ageClone = age:Clone()
			ageClone.Parent = petClone
		end

		if weight then
			local weightClone = weight:Clone()
			weightClone.Parent = petClone
		end

		-- Parent the clone to workspace
		petClone.Parent = clonesFolder

		-- Also add to visual "inventory"
		local inventoryPet = petClone:Clone()
		inventoryPet.Parent = inventoryFolder

		print("✅ Pet visually duplicated with same name, age, and weight.")
	end)
end

-- Connect click to function
dupeButton.MouseButton1Click:Connect(duplicatePet)


