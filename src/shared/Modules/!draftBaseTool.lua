-- rewrite so that basetool shouldn't have to interact with custom events at all
-- the configuration should be done through which animations you put into the folder and animevents
-- also make base tool alongside an actual tool so you arent implenting both methods in 1 class idiot

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local BaseTool = {}
BaseTool.__index = BaseTool
BaseTool.events = {
	recieved = "recieved",
}

function BaseTool.new(player)
	local self = setmetatable({}, BaseTool)

	self.model = ReplicatedStorage.Assets.Tools.BaseTool:Clone()
	self.player = player

	self:_setup()
	return self
end

function BaseTool:_setup()
	local function initModel()
		local motor = self.model:FindFirstChildOfClass("Motor6D")
		motor.Part0 = self.player.Character[motor.Name]
		self.model.Parent = self.player.Backpack
		self:_toggleTransparency(1)
	end

	local function setupEvents()
		ReplicatedStorage.Remotes.ToolEvents.OnServerEvent:Connect(function(player, event, ...)
			if self.player == player then
				if not self["_" .. string.lower(event)] then
					return
				end
				self["_" .. string.lower(event)](self, ...)
			end
		end)

		self.model.Unequipped:Connect(function()
			self:_toggleTransparency(1)
		end)
	end

	initModel()
	setupEvents()
	ReplicatedStorage.Remotes.ToolEvents:FireClient(self.player, self.events.recieved, self.model)
end

-- function BaseTool._throw(self)
-- 	self.model:FindFirstChildOfClass("Motor6D"):Destroy()
-- end

function BaseTool._out(self)
	print("out event")
	self:_toggleTransparency(0)
end

function BaseTool:_toggleTransparency(transparency)
	self.model.Base.Transparency = transparency
	for _, v in self.model.Base:GetDescendants() do
		if v:IsA("BasePart") then
			v.Transparency = transparency
		end
	end
end

function BaseTool:ToggleEquipped() end

return BaseTool
