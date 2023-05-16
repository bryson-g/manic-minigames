local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ToolController = {}

function ToolController.init()
	ToolController:_setup()
end

function ToolController._recieved(tool)
	print("Tool recieved: ", tool)
end

function ToolController:_setup()
	-- use rbx tool events for things as well.

	ReplicatedStorage.Remotes.ToolEvents.OnClientEvent:Connect(function(event, ...)
		self["_" .. string.lower(event)](...)
	end)
end

return ToolController
