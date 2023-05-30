local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EffectHandler = {}

function EffectHandler._init(self)
	ReplicatedStorage.Remotes.EffectEvents.OnClientEvent:Connect(function(data)
		require(data.module)(data)
	end)
end

return EffectHandler
