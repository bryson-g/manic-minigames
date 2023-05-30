local Players = game:GetService("Players")

local BaseToolClient = require(script.Parent.BaseToolClient)
local CameraController = require(_G.Modules.Camera.CameraController)

local PistolToolClient = {}
PistolToolClient.__index = PistolToolClient
setmetatable(PistolToolClient, BaseToolClient)

function PistolToolClient.new(tool)
	local self = setmetatable(BaseToolClient.new(tool), PistolToolClient)

	self:_setupConnections()
	return self
end

function PistolToolClient:_setupConnections()
	-- probably make this a base config thats toggleable with self.charLocked
	self:Connect(self.eventTypes.Default, "Equipped", function()
		CameraController:ToggleCharacterLock(true)
	end)

	self:Connect(self.eventTypes.Default, "Unequipped", function()
		CameraController:ToggleCharacterLock(false)
	end)

	-- activated
	self:Connect(self.eventTypes.Default, "Activated", function()
		-- local lookVector = Players.LocalPlayer.Character.PrimaryPart.CFrame.LookVector

		-- -- probably make a projectile class
		-- local bullet = Instance.new("Part")
		-- bullet.Size = Vector3.new(2, 0.25, 0.25)
		-- bullet.Material = Enum.Material.Neon
		-- bullet.Color = Color3.fromRGB(255, 247, 0)
		-- bullet.CanCollide = false
		-- bullet.CFrame = CFrame.lookAt(self.tool.Base.Position, lookVector * 500) * CFrame.Angles(0, 0, math.rad(90))
		-- bullet.Parent = workspace
		-- bullet.AssemblyLinearVelocity = lookVector * 500
	end)
end

return PistolToolClient
