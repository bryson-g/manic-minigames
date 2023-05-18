local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseToolServer = require(script.Parent.BaseToolServer)

local PistolToolServer = {}
PistolToolServer.__index = PistolToolServer
setmetatable(PistolToolServer, BaseToolServer)

function PistolToolServer.new(player, tool)
	local self = setmetatable(BaseToolServer.new(player, tool), PistolToolServer)

	return self
end

return PistolToolServer
