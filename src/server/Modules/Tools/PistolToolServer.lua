local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseToolServer = require(script.Parent.BaseToolServer)

local PistolToolServer = {}
PistolToolServer.__index = PistolToolServer
setmetatable(PistolToolServer, BaseToolServer)

function PistolToolServer.new(player, tool)
	local self = setmetatable(BaseToolServer.new(player, tool), PistolToolServer)

	self:_setupConnections()
	return self
end

function PistolToolServer:_setupConnections()
	self:Connect(self.eventTypes.Default, "Activated", function()
		self:Fire()
	end)
end

function PistolToolServer:Fire()
	ReplicatedStorage.Remotes.EffectEvents:FireAllClients({
		blacklist = { self.player },
		module = ReplicatedStorage.Shared.Modules.Projectile,
		tool = self.tool,
		owner = self.player,
	})
end

return PistolToolServer
