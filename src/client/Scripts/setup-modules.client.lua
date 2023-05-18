_G.Modules = game:GetService("StarterPlayer").StarterPlayerScripts.Modules

for _, module in _G.Modules:GetChildren() do
	if module:IsA("ModuleScript") then
		local required = require(module)
		if required._init then
			required._init()
		end
	end
end

-- reconfig cameracontroller with init ^
game.Players.LocalPlayer.CharacterAdded:Wait()
require(_G.Modules.Camera.CameraController).new()
