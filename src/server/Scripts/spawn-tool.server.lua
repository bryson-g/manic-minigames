local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local AxeToolServer = require(ServerScriptService.Modules.Tools.AxeToolServer)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		task.wait(1)
		AxeToolServer.new(player, ReplicatedStorage.Assets.Tools.Axe)
	end)
end)
