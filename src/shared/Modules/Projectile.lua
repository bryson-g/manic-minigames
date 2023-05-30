local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function(data)
	local lookVector = data.tool.Parent.HumanoidRootPart.CFrame.LookVector

	local bullet = Instance.new("Part")
	bullet.Size = Vector3.new(2, 0.25, 0.25)
	bullet.Material = Enum.Material.Neon
	bullet.Color = Color3.fromRGB(255, 247, 0)
	bullet.CanCollide = false
	bullet.CFrame = CFrame.lookAt(data.tool.Base.Position, lookVector * 500) * CFrame.Angles(0, 0, math.rad(90))
	bullet.Parent = workspace
	bullet.AssemblyLinearVelocity = lookVector * 500
	Debris:AddItem(bullet, 3)

	if data.owner == Players.LocalPlayer then
		local conn
		conn = bullet.Touched:Connect(function(touched)
			local humanoid = touched.Parent:FindFirstChildOfClass("Humanoid")
			if humanoid then
				print(humanoid == Players.LocalPlayer.Character.Humanoid)
				if humanoid ~= Players.LocalPlayer.Character.Humanoid then
					conn:Disconnect()
					bullet:Destroy()
					ReplicatedStorage.Remotes.DevDamage:FireServer(humanoid, 5)
				end
			end
		end)
	end
end
