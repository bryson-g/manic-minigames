_G.Modules = game:GetService("StarterPlayer").StarterPlayerScripts.Modules

require(_G.Modules.ToolController):_setup()

game.Players.LocalPlayer.CharacterAdded:Wait()
require(_G.Modules.Camera.CameraController).new()
