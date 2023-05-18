local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ClientToolLoader = {}

function ClientToolLoader._init()
	ReplicatedStorage.Remotes.ToolEvents.OnClientEvent:Connect(function(event, tool)
		if event == "CLIENT_SETUP" then
			local toolClient = _G.Modules.Tools:FindFirstChild(tool.Name .. "ToolClient")
			if toolClient then
				require(toolClient).new(tool)
			else
				require(_G.Modules.Tools.BaseToolClient).new(tool)
			end
		end
	end)
end

return ClientToolLoader
