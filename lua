local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetDupeGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Draggable Duplicate Button
local dupeButton = Instance.new("TextButton")
dupeButton.Name = "DuplicateButton"
dupeButton.Size = UDim2.new(0, 160, 0, 50)
dupeButton.Position = UDim2.new(0.5, -80, 0.9, -25)
dupeButton.BackgroundColor3 = Color3.new(0, 0, 0) -- Black button
dupeButton.TextColor3 = Color3.new(1, 1, 1)
dupeButton.Font = Enum.Font.SourceSansBold
dupeButton.TextSize = 24
dupeButton.Text = "Duplicate"
dupeButton.Draggable = true
dupeButton.Active = true
dupeButton.Selectable = true
dupeButton.Parent = screenGui

-- Folder to hold visual clones
local clonesFolder = workspace:FindFirstChild("VisualPetClones") or Instance.new("Folder")
clonesFolder.Name = "VisualPetClones"
clonesFolder.Parent = workspace

-- Function to get the pet you're holding
local function getHeldPet()
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if not tool then return nil end

	-- Assume the tool is the pet or contains the pet
	local pet = tool:FindFirstChildWhichIsA("Model") or tool:FindFirstChild("Pet")
	return pet
end

-- Function to duplicate the held pet
local function duplicatePet()
	local pet = getHeldPet()
	if not pet then
		warn("No held pet found!")
		return
	end

	local clone = pet:Clone()
	clone.Name = "FakePet_" .. math.random(1000, 9999)
	clone.Parent = clonesFolder

	-- Match position near the player or original pet
	if clone:IsA("Model") and clone.PrimaryPart then
		local offset = Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))
		clone:SetPrimaryPartCFrame(player.Character:GetPrimaryPartCFrame() + offset)
	end

	-- Copy stats if exist
	if pet:FindFirstChild("Age") then
		local age = pet.Age:Clone()
		age.Parent = clone
	end
	if pet:FindFirstChild("Weight") then
		local weight = pet.Weight:Clone()
		weight.Parent = clone
	end

	print("Visual pet duplicated with age and weight!")
end

-- Connect button click to dupe
dupeButton.MouseButton1Click:Connect(duplicatePet)
