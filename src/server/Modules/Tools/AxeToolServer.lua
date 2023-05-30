local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseToolServer = require(script.Parent.BaseToolServer)

local AxeToolServer = {}
AxeToolServer.__index = AxeToolServer
setmetatable(AxeToolServer, BaseToolServer)

function AxeToolServer.new(player, tool)
	local self = setmetatable(BaseToolServer.new(player, tool), AxeToolServer)

	self:_setupConnections()
	return self
end

function AxeToolServer:_setupConnections()
	self:Connect(self.eventTypes.Default, "Activated", function()
		self:Fire()
	end)
end

function AxeToolServer:Fire()
	print("swing")
end

return AxeToolServer
