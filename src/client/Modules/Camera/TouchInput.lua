local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

local touchGui, controlFrame, guiInset
if UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
	touchGui = Players.LocalPlayer.PlayerGui:WaitForChild("TouchGui")
	controlFrame = touchGui.TouchControlFrame:FindFirstChildOfClass("Frame")
	guiInset = GuiService:GetGuiInset()
end

local TouchInput = {}
TouchInput.__index = TouchInput

function TouchInput.new()
	local self = setmetatable({}, TouchInput)

	self.trackLimit = 2
	self.touches = {}

	self.onRender = {}
	self.onEnded = {}

	self:SetupConnections()

	return self
end

local function getPositions(touches)
	local positions = {}
	for _, touch in next, touches do
		table.insert(positions, touch.Position)
	end
	return positions
end

function TouchInput:SetupConnections()
	UserInputService.TouchStarted:Connect(function(touch, gp)
		if self:_positionInFrame(touch.Position, controlFrame) or #self.touches >= self.trackLimit then
			return
		end
		table.insert(self.touches, touch)
	end)

	UserInputService.TouchEnded:Connect(function(touch, gp)
		local index = table.find(self.touches, touch)
		if index then
			table.remove(self.touches, index)
		end

		for _, func in next, self.onEnded do
			coroutine.wrap(func)(getPositions(self.touches))
		end
	end)

	UserInputService.TouchMoved:Connect(function(touch, gp)
		if not self.touches[table.find(self.touches, touch)] then
			return
		end
		self.touches[table.find(self.touches, touch)] = touch

		for _, func in next, self.onRender do
			coroutine.wrap(func)(getPositions(self.touches))
		end
	end)
end

function TouchInput:Connect(event, func)
	table.insert(self[event], func)
end

function TouchInput:_positionInFrame(position, frame)
	local framePos, frameSize = frame.AbsolutePosition, frame.AbsoluteSize

	local inAxisX = position.X <= framePos.X + frameSize.X and position.X >= framePos.X
	local inAxisY = position.Y >= framePos.Y and position.Y <= (frameSize.Y + framePos.Y) + guiInset.Y

	return inAxisY and inAxisX
end

return TouchInput
