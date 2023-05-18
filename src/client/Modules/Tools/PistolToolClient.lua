local BaseToolClient = require(script.Parent.BaseToolClient)

local PistolToolClient = {}
PistolToolClient.__index = PistolToolClient
setmetatable(PistolToolClient, BaseToolClient)

function PistolToolClient.new(tool)
	local self = setmetatable(BaseToolClient.new(tool), PistolToolClient)

	return self
end

function PistolToolClient:_setupConnections() end

return PistolToolClient
