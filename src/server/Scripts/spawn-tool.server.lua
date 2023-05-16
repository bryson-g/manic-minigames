local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BaseTool = require(ReplicatedStorage.Shared.Modules.BaseTool)

local function main()
	Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function()
			task.wait(1)
			BaseTool.new(player)
		end)
	end)
end
main()
