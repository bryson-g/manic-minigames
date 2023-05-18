local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local PistolToolServer = require(ServerScriptService.Modules.Tools.PistolToolServer)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		PistolToolServer.new(player, ReplicatedStorage.Assets.Tools.Pistol)
	end)
end)
