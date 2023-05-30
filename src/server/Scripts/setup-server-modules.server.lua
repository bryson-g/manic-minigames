_G.Modules = game:GetService("ServerScriptService").Modules

for _, module in _G.Modules:GetChildren() do
	if module:IsA("ModuleScript") then
		local required = require(module)
		if required._init then
			required._init(required)
		end
	end
end
