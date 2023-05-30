local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TreesManager = {}

function TreesManager._init(self)
	ReplicatedStorage.Remotes.HitTree.OnServerEvent:Connect(function(player, hitCF, branch)
		self:HitTree(player, hitCF, branch)
	end)
end

function TreesManager:HitTree(player, hitCF, branch)
	local axeNegate = ReplicatedStorage.Assets.AxeHits[player.Character:FindFirstChildOfClass("Tool").Name]:Clone()
	axeNegate.CFrame = CFrame.lookAt(
		hitCF.Position,
		Vector3.new(branch.CFrame.Position.X, hitCF.Position.Y, branch.CFrame.Position.Z)
	) * CFrame.Angles(0, math.rad(90), math.rad(math.random(1, 15)))
	axeNegate.Parent = workspace

	local success, newTree = pcall(function()
		return branch:SubtractAsync({ axeNegate })
	end)

	if success and newTree then
		newTree.CFrame = branch.CFrame
		newTree.Parent = branch.Parent
		axeNegate:Destroy()
		task.wait(0.05)
		branch:Destroy()
	end
end

return TreesManager
