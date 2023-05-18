local BaseToolClient = require(script.Parent.BaseToolClient)

local BrickToolClient = {}
BrickToolClient.__index = BrickToolClient
setmetatable(BrickToolClient, BaseToolClient)

function BrickToolClient.new(tool)
	local self = setmetatable(BaseToolClient.new(tool), BrickToolClient)
	return self
end

function BrickToolClient:Out()
	print("pulled out")
end

function BrickToolClient:Throw()
	print("he throwin doe")
end

return BrickToolClient
