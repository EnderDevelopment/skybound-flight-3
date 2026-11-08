local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local FLY_TOGGLE_KEY = Enum.KeyCode.F
local FLIGHT_SPEED = 60

local character
local humanoid
local rootPart
local attachment
local velocityConstraint
local orientationConstraint
local flying = false
local heldKeys = {}

local function stopFlight()
	flying = false
	heldKeys = {}

	if velocityConstraint then
		velocityConstraint:Destroy()
		velocityConstraint = nil
	end

	if orientationConstraint then
		orientationConstraint:Destroy()
		orientationConstraint = nil
	end

	if attachment then
		attachment:Destroy()
		attachment = nil
	end

	if humanoid and humanoid.Parent then
		humanoid.PlatformStand = false
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

local function startFlight()
	if not character or not humanoid or not rootPart or humanoid.Health <= 0 then
		return
	end

	stopFlight()
	flying = true
	humanoid.PlatformStand = true

	attachment = Instance.new("Attachment")
	attachment.Name = "FlightAttachment"
	attachment.Parent = rootPart

	velocityConstraint = Instance.new("LinearVelocity")
	velocityConstraint.Name = "FlightVelocity"
	velocityConstraint.Attachment0 = attachment
	velocityConstraint.RelativeTo = Enum.ActuatorRelativeTo.World
	velocityConstraint.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	velocityConstraint.MaxForce = math.huge
	velocityConstraint.VectorVelocity = Vector3.zero
	velocityConstraint.Parent = rootPart

	orientationConstraint = Instance.new("AlignOrientation")
	orientationConstraint.Name = "FlightOrientation"
	orientationConstraint.Attachment0 = attachment
	orientationConstraint.Mode = Enum.OrientationAlignmentMode.OneAttachment
	orientationConstraint.MaxTorque = math.huge
	orientationConstraint.Responsiveness = 25
	orientationConstraint.Parent = rootPart
end

local function setCharacter(newCharacter)
	stopFlight()
	character = newCharacter
	humanoid = character:WaitForChild("Humanoid")
	rootPart = character:WaitForChild("HumanoidRootPart")
end

local function getFlightDirection()
	local camera = workspace.CurrentCamera
	if not camera then
		return Vector3.zero
	end

	local direction = Vector3.zero
	local cameraLook = camera.CFrame.LookVector
	local cameraRight = camera.CFrame.RightVector
	local forward = Vector3.new(cameraLook.X, 0, cameraLook.Z)
	local right = Vector3.new(cameraRight.X, 0, cameraRight.Z)

	if forward.Magnitude > 0 then
		forward = forward.Unit
	end
	if right.Magnitude > 0 then
		right = right.Unit
	end

	if heldKeys[Enum.KeyCode.W] then
		direction += forward
	end
	if heldKeys[Enum.KeyCode.S] then
		direction -= forward
	end
	if heldKeys[Enum.KeyCode.D] then
		direction += right
	end
	if heldKeys[Enum.KeyCode.A] then
		direction -= right
	end
	if heldKeys[Enum.KeyCode.Space] then
		direction += Vector3.yAxis
	end
	if heldKeys[Enum.KeyCode.LeftControl] then
		direction -= Vector3.yAxis
	end

	return direction.Magnitude > 0 and direction.Unit or Vector3.zero
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == FLY_TOGGLE_KEY then
		if flying then
			stopFlight()
		else
			startFlight()
		end
		return
	end

	heldKeys[input.KeyCode] = true
end)

UserInputService.InputEnded:Connect(function(input)
	heldKeys[input.KeyCode] = nil
end)

RunService.RenderStepped:Connect(function()
	if not flying or not velocityConstraint or not orientationConstraint or not rootPart then
		return
	end

	velocityConstraint.VectorVelocity = getFlightDirection() * FLIGHT_SPEED
	local camera = workspace.CurrentCamera
	if camera then
		local look = camera.CFrame.LookVector
		local flatLook = Vector3.new(look.X, 0, look.Z)
		if flatLook.Magnitude > 0 then
			orientationConstraint.CFrame = CFrame.lookAt(Vector3.zero, flatLook.Unit)
		end
	end
end)

player.CharacterAdded:Connect(setCharacter)
if player.Character then
	setCharacter(player.Character)
else
	setCharacter(player.CharacterAdded:Wait())
end
