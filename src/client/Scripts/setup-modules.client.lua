_G.Modules = game:GetService("StarterPlayer").StarterPlayerScripts.Modules

game.Players.LocalPlayer.CharacterAdded:Wait()
require(_G.Modules.Camera.CameraController).new()
