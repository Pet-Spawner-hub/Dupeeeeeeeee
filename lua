local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetDupeGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Create the draggable "Duplicate" button
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

-- Create a folder in Workspace to store visual clones
local clonesFolder = workspace:FindFirstChild("VisualPetClones") or Instance.new("Folder")
clonesFolder.Name = "VisualPetClones"
clonesFolder.Parent = workspace

-- Function: Get the pet from the Tool the player is holding
local function getHeldPet()
	local character = player.Character or player.CharacterAdded:Wait()
	local tool = character:FindFirstChildOfClass("Tool")
	if not tool then return nil end

	-- Try to find a model or pet part inside the tool
	local petModel = tool:FindFirstChildWhichIsA("Model") or tool:FindFirstChild("Pet")
	return petModel
end

-- Function: Duplicate the held pet visually
local function duplicatePet()
	local heldPet = getHeldPet()
	if not heldPet then
		warn("No held pet found.")
		return
	end

	-- Clone the held pet
	local petClone = heldPet:Clone()
	petClone.Name = heldPet.Name .. "_Clone"

	-- Optional: Ensure clone has PrimaryPart if it's a model
	if petClone:IsA("Model") then
		if not petClone.PrimaryPart then
			local primary = petClone:FindFirstChildWhichIsA("BasePart")
			if primary then
				petClone.PrimaryPart = primary
			end
		end

		if petClone.PrimaryPart then
			petClone:SetPrimaryPartCFrame((player.Character.PrimaryPart.CFrame or CFrame.new()) * CFrame.new(math.random(-4,4), 0, math.random(-4,4)))
		end
	elseif petClone:IsA("BasePart") then
		petClone.Position = player.Character:GetPrimaryPartCFrame().Position + Vector3.new(3, 0, 0)
	end

	-- Copy metadata if available: Age and Weight
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

	petClone.Parent = clonesFolder

	print("✅ Visual pet clone created with name, age, and weight.")
end

-- Connect button click
dupeButton.MouseButton1Click:Connect(duplicatePet)

