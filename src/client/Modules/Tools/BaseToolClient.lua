local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local BaseToolClient = {}
BaseToolClient.__index = BaseToolClient

function BaseToolClient.new(tool)
	local self = setmetatable({}, BaseToolClient)

	self.tool = tool

	self.defaultEventsRegistry = {}
	self.tracks = {}
	self.animEvents = {}

	self.eventTypes = {
		AnimationEvent = "AnimationEvent",
		Default = "Default",
	}
	self.unequipTracks = true

	self:_setupTracks()
	self:_defaultAnimSetup()
	return self
end

function BaseToolClient:_setupTracks()
	for _, animation in self.tool.Animations:GetChildren() do
		self.tracks[animation.Name] = Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(animation)

		for _, animEvent in animation:GetChildren() do
			self.tracks[animation.Name]:GetMarkerReachedSignal(animEvent.Value):Connect(function(...)
				ReplicatedStorage.Remotes.ToolEvents:FireServer(animEvent.Value, ...)
				if self.animEvents[animEvent.Value] then
					self.animEvents[animEvent.Value](...)
				end
			end)
		end
	end
end

function BaseToolClient:_defaultAnimSetup()
	self.tool.Equipped:Connect(function()
		self.equipped = true
	end)

	self.tool.Unequipped:Connect(function()
		self.equipped = false
		if self.unequipTracks then
			for _, track in self.tracks do
				track:Stop()
			end
		end
	end)

	for name, track in self.tracks do
		if name == "Equipped" then
			self.tool.Equipped:Connect(function()
				track:Play()
				if self.tracks.Idle then
					track.Stopped:Wait()
					self.tracks.Idle:Play()
				end
			end)
		end

		if name == "Idle" and not self.tracks.Equipped then
			self.tool.Equipped:Connect(function()
				track:Play()
			end)
		end

		if name == "Activated" then
			self.defaultEventsRegistry["Activated"] = self.tool.Activated:Connect(function()
				track:Play()
			end)
		end
	end
end

function BaseToolClient:Connect(type, name, callback)
	if type == self.eventTypes.AnimationEvent then
		self.animEvents[name] = callback
		return {
			Disconnect = function()
				self.animEvents[name] = nil
			end,
		}
	elseif type == self.eventTypes.Default then
		local existingConn = self.defaultEventsRegistry[name]
		if existingConn then
			existingConn:Disconnect()
			self.defaultEventsRegistry[name] = nil
		end
		return self.tool[name]:Connect(callback)
	end
end

return BaseToolClient
