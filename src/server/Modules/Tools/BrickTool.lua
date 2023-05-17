local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BaseTool = require(script.Parent.BaseTool)

local Brick = {}
Brick.__index = Brick
setmetatable(Brick, BaseTool)

function Brick.new(player, tool)
	local self = setmetatable(BaseTool.new(player, tool), Brick)

	self.tool = tool

	return self
end

return Brick
