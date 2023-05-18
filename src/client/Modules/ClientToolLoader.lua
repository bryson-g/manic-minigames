local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ClientToolLoader = {}

function ClientToolLoader._init()
	ReplicatedStorage.Remotes.ToolEvents.OnClientEvent:Connect(function(event, tool)
		if event == "CLIENT_SETUP" then
			local toolClient = _G.Modules.Tools:FindFirstChild(tool.Name .. "ToolClient")
			require(toolClient).new(tool)
		end
	end)
end

return ClientToolLoader
