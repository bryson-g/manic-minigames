local BaseToolClient = require(script.Parent.BaseToolClient)
local CameraController = require(_G.Modules.Camera.CameraController)

local PistolToolClient = {}
PistolToolClient.__index = PistolToolClient
setmetatable(PistolToolClient, BaseToolClient)

function PistolToolClient.new(tool)
	local self = setmetatable(BaseToolClient.new(tool), PistolToolClient)

	-- probably make this a base config thats toggleable with self.charLocked
	self:Connect(self.eventTypes.Default, "Equipped", function()
		CameraController:ToggleCharacterLock(true)
	end)

	self:Connect(self.eventTypes.Default, "Unequipped", function()
		CameraController:ToggleCharacterLock(false)
	end)

	return self
end

function PistolToolClient:_setupConnections() end

return PistolToolClient
