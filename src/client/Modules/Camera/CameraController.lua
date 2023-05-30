local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local TouchInput = require(script.Parent.TouchInput).new()

local CameraController = {}
function CameraController.new()
	local self = CameraController

	self.smoothing = 30
	self.maxOffset = 80
	self.minOffset = 5
	self.panning = false

	self.sens = 0.3
	self.xDelta = 0
	self.offset = 30

	workspace.CurrentCamera.CameraSubject = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
	workspace.CurrentCamera.FieldOfView = 17.5

	self.InterferenceHandler = require(script.Parent.InterferenceHandler).new()
	self:SetupConnections()
end

function CameraController:SetupConnections()
	self.InterferenceHandler:Start()
	--

	RunService:BindToRenderStep("cameraRender", Enum.RenderPriority.Camera.Value, function(dt)
		self:Update(dt)
	end)
	--

	local function setMouseDelta(_, _, inputObj)
		self.xDelta += inputObj.Delta.X
	end
	ContextActionService:BindAction("setDelta", setMouseDelta, false, Enum.UserInputType.MouseMovement)
	--

	local function setMouseOffset(_, _, inputObj)
		self.offset = math.clamp(self.offset - inputObj.Position.Z * 10, self.minOffset, self.maxOffset)
	end
	ContextActionService:BindAction("setMouseOffset", setMouseOffset, false, Enum.UserInputType.MouseWheel)
	--

	local oldPositions = {}
	local function updateVelocities(newPositions)
		if #newPositions == #oldPositions then
			if #newPositions == 2 then
				local newMag = (newPositions[1] - newPositions[2]).Magnitude
				local oldMag = (oldPositions[1] - oldPositions[2]).Magnitude
				local velocity = oldMag - newMag

				self.offset = math.clamp(self.offset + velocity * 0.8, self.minOffset, self.maxOffset)
			elseif #newPositions == 1 then
				local mag = (newPositions[1] - oldPositions[1]).Magnitude
				local direction = (newPositions[1] - oldPositions[1]).Unit.X
				local velocity = mag * direction

				self.xDelta += velocity * (1 + self.sens)
			end
		end
		oldPositions = newPositions
	end
	TouchInput:Connect("onRender", updateVelocities)
	--

	local function onEnded(positions)
		if #positions == 0 then
			oldPositions = {}
		end
	end
	TouchInput:Connect("onEnded", onEnded)
	--

	Players.LocalPlayer.CharacterAdded:Connect(function(character)
		workspace.CurrentCamera.CameraSubject = character:WaitForChild("HumanoidRootPart")
	end)
end

function CameraController:Update(dt)
	local char = Players.LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then
		return
	end

	if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
	else
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end

	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable

	local subject = workspace.CurrentCamera.CameraSubject

	local center = CFrame.new(subject.Position) * CFrame.Angles(0, math.rad(-self.xDelta * self.sens), 0)
	local origin = center * CFrame.new(Vector3.new(1, 1, 1) * self.offset)
	local lookAt = CFrame.lookAt(camera.CFrame:Lerp(origin, dt * self.smoothing).Position, subject.Position)

	camera.CFrame = lookAt
end

function CameraController:SetSubject(subject)
	workspace.CurrentCamera.CameraSubject = subject
end

function CameraController:SetMaxOffset(offset)
	self.maxOffset = offset
end

function CameraController:GetMaxOffset()
	return self.maxOffset
end

function CameraController:ToggleCharacterLock(on)
	local character = Players.LocalPlayer.Character

	if on then
		character.Humanoid.AutoRotate = false
		self.lockConn = RunService.PreSimulation:Connect(function(dt)
			local rootPart = character.HumanoidRootPart
			local lv = workspace.CurrentCamera.CFrame.LookVector * 3000
			rootPart.CFrame =
				rootPart.CFrame:Lerp(CFrame.lookAt(rootPart.CFrame.Position, Vector3.new(lv.X, 0, lv.Z)), dt * 20)
		end)
	else
		character.Humanoid.AutoRotate = true
		if self.lockConn then
			self.lockConn:Disconnect()
		end
	end
end

return CameraController
