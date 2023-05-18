--[[






    MAKE SYSTEM TO AUTO RUN FUNCS FOR EVERY ANIMATION EVENT, ON CLIENT !AND! SERVER
    THIS IS WHERE ORIGINALITY WILL COME IN WITH UNIQUE CLASSES.


    YOU'RE ON THE RIGHT TRACK.




]]

local Players = game:GetService("Players")

local BaseToolClient = {}
BaseToolClient.__index = BaseToolClient

function BaseToolClient.new(tool)
	local self = setmetatable({}, BaseToolClient)

	self.tool = tool
	self.tracks = {}

	self:_alwaysSetup()
	return self
end

function BaseToolClient:_alwaysSetup()
	for _, animation in self.tool.Animations:GetChildren() do
		self.tracks[animation.Name] = Players.LocalPlayer.Character.Humanoid.Animator:LoadAnimation(animation)

		for _, animEvent in animation:GetChildren() do
			self.tracks[animation.Name]:GetMarkerReachedSignal(animEvent.Value):Connect(function(...)
				if self[animEvent.Value] then
					-- probably send event notice to server too
					-- or maybe server can check animators loaded tracks and just use that?
					self[animEvent.Value](...)
				end
			end)
		end
	end

	self.tool.Activated:Connect(function()
		self.tracks.Activated:Play()

		if self.Activated then
			self:Activated()
		end
	end)
	self.tool.Equipped:Connect(function()
		task.spawn(function()
			self.tracks.Equipped:Play()
			self.tracks.Equipped.Stopped:Wait()
			self.tracks.Idle:Play()
		end)

		if self.Equipped then
			self:Equipped()
		end
	end)
	self.tool.Unequipped:Connect(function()
		for _, track in self.tracks do
			track:Stop()
		end

		if self.Unequipped then
			self:Unequipped()
		end
	end)
end

return BaseToolClient
