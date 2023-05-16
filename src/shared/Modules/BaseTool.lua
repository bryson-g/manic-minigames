local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local BaseTool = {}
BaseTool.__index = BaseTool

function BaseTool.new(player)
	local self = setmetatable({}, BaseTool)

	self.model = ReplicatedStorage.Assets.Tools.BaseTool:Clone()
	self.player = player

	self:_setup()
	return self
end

function BaseTool:_setup()
	local function initModel()
		local motor = self.model:FindFirstChildOfClass("Motor6D")
		motor.Part0 = self.player.Character[motor.Name]
		self.model.Parent = self.player.Backpack
		self:_toggleTransparency(1)
	end
	initModel()
	ReplicatedStorage.Remotes.ToolEvents:FireClient(self.player, "recieved", self.model)
end

function BaseTool:_toggleTransparency(transparency)
	self.model.Base.Transparency = transparency
	for _, v in self.model.Base:GetDescendants() do
		if v:IsA("BasePart") then
			v.Transparency = transparency
		end
	end
end

function BaseTool:ToggleEquipped() end

return BaseTool
