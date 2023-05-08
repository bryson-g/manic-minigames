--[[
 DEV NOTE :
 
 Cast a ray to the floor as well, to know whether or not the player is in a room.
 Otherwise, the player can see through walls if they're not even inside of the room.

]]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local InterferenceHandler = {}
InterferenceHandler.__index = InterferenceHandler

function InterferenceHandler.new()
	local self = setmetatable({}, InterferenceHandler)

	self.originRayTo = "Head"
	self.tweenInfo = TweenInfo.new(0.25)
	self.INVISIBLE = 0.975
	self.VISIBLE = 0

	self.currentWall = nil

	return self
end

function InterferenceHandler:_getInterference(origin, destination): Instance
	local result: RaycastResult = workspace:Raycast(origin, destination - origin)
	return result and result.Instance
end

function InterferenceHandler:_findAncestor(part): Model | nil
	repeat
		if part.Parent.Name == "Wall" and part.Parent:IsA("Model") then
			return part.Parent
		else
			part = part.Parent
		end
	until part == workspace
end

function InterferenceHandler:_update()
	local character = Players.LocalPlayer.Character
	if not character then
		return
	end

	local cameraCF = workspace.CurrentCamera.CFrame
	local interferencePart =
		self:_getInterference(cameraCF.Position, character[self.originRayTo].Position - cameraCF.LookVector * 3)
	local interferenceWall
	do
		if interferencePart then
			interferenceWall = self:_findAncestor(interferencePart)
		end
	end

	if interferenceWall then
		if interferenceWall ~= self.currentWall then
			self:_phaseObject(interferenceWall, self.INVISIBLE)
			if self.currentWall then
				self:_phaseObject(self.currentWall, self.VISIBLE)
			end

			self.currentWall = interferenceWall
		end
	elseif self.currentWall then
		self:_phaseObject(self.currentWall, self.VISIBLE)
		self.currentWall = nil
	end
end

function InterferenceHandler:_phaseObject(wall, goal)
	for _, v in next, wall:GetDescendants() do
		if v:IsA("BasePart") then
			TweenService:Create(v, self.tweenInfo, { Transparency = goal }):Play()
		end
	end
end

function InterferenceHandler:Start()
	RunService.Heartbeat:Connect(function()
		self:_update()
	end)
end

return InterferenceHandler
