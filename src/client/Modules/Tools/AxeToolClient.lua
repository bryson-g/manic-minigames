local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local BaseToolClient = require(script.Parent.BaseToolClient)
local CameraController = require(_G.Modules.Camera.CameraController)

local AxeToolClient = {}
AxeToolClient.__index = AxeToolClient
setmetatable(AxeToolClient, BaseToolClient)

function AxeToolClient.new(tool)
	local self = setmetatable(BaseToolClient.new(tool), AxeToolClient)

	self.mouse = Players.LocalPlayer:GetMouse()
	self.cooldown = false
	self.cooldownLength = 1

	self.mouse.TargetFilter = Players.LocalPlayer.Character

	self:_setupConnections()
	return self
end

function AxeToolClient:_setupConnections()
	local mouse = Players.LocalPlayer:GetMouse()
	local function updateBranch()
		local target = mouse.Target
		if target and target.Parent.Name == "Tree" then
			self.branch = target
		else
			self.branch = nil
		end
	end

	local treeHighlight = ReplicatedStorage.Assets.Highlights.TreeHighlight
	local function updateHighlight()
		if self.branch then
			treeHighlight.Adornee = self.branch
		else
			treeHighlight.Adornee = nil
		end
	end

	local function updateCharacter(deltaTime)
		if self.branch and self.equipped then
			local rootPart = Players.LocalPlayer.Character.HumanoidRootPart
			local rootPos = rootPart.CFrame.Position
			local treePos = self.branch.CFrame.Position
			local lookPos = Vector3.new(treePos.X, rootPos.Y, treePos.Z)
			rootPart.CFrame = rootPart.CFrame:Lerp(CFrame.lookAt(rootPos, lookPos), deltaTime * 10)
		end
	end

	self:Connect(self.eventTypes.Default, "Activated", function()
		if self.branch and not self.cooldown then
			self.cooldown = true
			self:_setHighlight(true)
			task.delay(self.cooldownLength, function()
				self:_setHighlight(false, true)
				self.cooldown = false
			end)

			self:Hit()
		end
	end)

	RunService.RenderStepped:Connect(updateHighlight)
	RunService.RenderStepped:Connect(updateBranch)
	RunService.RenderStepped:Connect(updateCharacter)
	self:Connect(self.eventTypes.Default, "Unequipped", function()
		treeHighlight.Adornee = nil
		self.branch = nil
	end)
	self:Connect(self.eventTypes.AnimationEvent, "Hit", function()
		self.tool.Sounds.AxeHitWood:Play()
	end)
end

-- test if the fade actually works
function AxeToolClient:_setHighlight(direction, threaded)
	local highlight = ReplicatedStorage.Assets.Highlights.TreeHighlight
	local start = highlight.OutlineTransparency
	local goal = direction and 1 or 0
	local multi = direction and 1 or -1

	local function fade()
		for i = start, goal, 0.1 * multi do
			highlight.OutlineTransparency = i
			task.wait()
		end
		highlight.OutlineTransparency = goal
	end

	if threaded then
		fade()
	else
		task.spawn(fade)
	end
end

function AxeToolClient:Hit()
	self.tracks.Activated:Play()
	self.tool.Sounds.AxeSwing:Play()
	ReplicatedStorage.Remotes.HitTree:FireServer(self.mouse.Hit, self.branch)
end

return AxeToolClient
