game.ReplicatedStorage.Remotes.DevDamage.OnServerEvent:Connect(function(_, hum, dmg)
	hum.Health -= dmg
end)
