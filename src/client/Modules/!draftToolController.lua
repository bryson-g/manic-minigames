local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ToolController = {}

function ToolController.init()
	ToolController:_setup()
end

function ToolController._recieved(self, tool)
	do -- Setup anim tracks
		local animator = Players.LocalPlayer.Character.Humanoid.Animator
		self.tracks[tool] = {}

		for _, animation in tool.Animations:GetChildren() do
			local track = animator:LoadAnimation(animation)
			self.tracks[tool][animation.Name] = track

			for _, animEvent in animation:GetChildren() do
				track:GetMarkerReachedSignal(animEvent.Value):Connect(function(...)
					local animEventFunc = self["_" .. animEvent.Value]
					if animEventFunc then
						animEventFunc(self, ...)
					end
					ReplicatedStorage.Remotes.ToolEvents:FireServer(string.lower(animEvent.Value), ...)
				end)
			end
		end
	end

	do -- Setup connections
		tool.Equipped:Connect(function()
			self.tracks[tool]["Equip"]:Play()
			self.tracks[tool]["Equip"].Stopped:Wait()
			self.tracks[tool]["Idle"]:Play()
		end)

		tool.Activated:Connect(function()
			self.tracks[tool]["Activate"]:Play()
		end)

		tool.Unequipped:Connect(function()
			for _, track in self.tracks[tool] do
				track:Stop()
			end
		end)
	end
end

function ToolController:_throw()
	print("throw here")
end

function ToolController:_setup()
	-- make a module for this event system if you're gonna use this concept in other places.
	self.tracks = {}
	ReplicatedStorage.Remotes.ToolEvents.OnClientEvent:Connect(function(event, ...)
		self["_" .. string.lower(event)](self, ...)
	end)
end

return ToolController
