local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BaseToolServer = {}
BaseToolServer.__index = BaseToolServer

function BaseToolServer.new(player, tool)
	local self = setmetatable({}, BaseToolServer)

	self.tool = tool:Clone()
	self.player = player :: Player
	self.eventRemote = ReplicatedStorage.Remotes.ToolEvents
	self.eventCallbacks = {}
	self.eventTypes = {
		AnimationEvent = "AnimationEvent",
		Default = "Default",
	}

	self:_initTool()
	self:_setupEvents()
	return self
end

function BaseToolServer:_setupEvents()
	for _, event in { "Activated", "Equipped", "Unequipped" } do
		if self[event] then
			self.tool[event]:Connect(self[event])
		end
	end

	self.eventRemote.OnServerEvent:Connect(function(player, event, ...)
		if player == self.player and self.player.Character:FindFirstChildOfClass("Tool") == self.tool then
			if self.eventCallbacks[event] then
				self.eventCallbacks[event](self, ...)
			end
		end
	end)
end

function BaseToolServer:_initTool()
	self.tool.RequiresHandle = false
	local motor = self.tool:FindFirstChildOfClass("Motor6D")
	motor.Part1 = self.tool.Base
	motor.Part0 = self.player.Character[motor.Name]
	self.tool.Parent = self.player.Backpack

	self.eventRemote:FireClient(self.player, "CLIENT_SETUP", self.tool)
end

function BaseToolServer:Connect(type, name, callback)
	if type == self.eventTypes.Default then
		return self.tool[name]:Connect(callback)
	end
end

return BaseToolServer
