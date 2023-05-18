local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BrickTool = require(ServerScriptService.Modules.Tools.BrickTool)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		BrickTool.new(player, ReplicatedStorage.Assets.Tools.Brick)
	end)
end)
