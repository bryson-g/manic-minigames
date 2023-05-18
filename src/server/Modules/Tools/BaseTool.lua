local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BaseTool = {}
BaseTool.__index = BaseTool

function BaseTool.new(player, tool)
	local self = setmetatable({}, BaseTool)

	self.tool = tool:Clone()
	self.player = player :: Player
	self.eventRemote = ReplicatedStorage.Remotes.ToolEvents

	self:_initTool()
	return self
end

function BaseTool:_initTool()
	local motor = self.tool:FindFirstChildOfClass("Motor6D")
	motor.Part1 = self.tool.Base
	motor.Part0 = self.player.Character[motor.Name]
	self.tool.Parent = self.player.Backpack

	self.eventRemote:FireClient(self.player, "CLIENT_SETUP", self.tool)
end

return BaseTool
