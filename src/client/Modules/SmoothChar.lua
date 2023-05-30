local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local SmoothChar = {}

function SmoothChar._init(self)
	Players.LocalPlayer.CharacterAdded:Connect(function(character)
		self:_setup(character)
	end)

	RunService.RenderStepped:Connect(function()
		if self.character then
			local rootPart = self.character:FindFirstChild("HumanoidRootPart")
			if not rootPart or rootPart.Anchored or self.character.Humanoid.Sit then
				self:Reset()
			end

			self:_update()
		end
	end)
end

function SmoothChar:_update()
	local angVel = self.character.Torso.AssemblyAngularVelocity
	local speedPercent =
		math.clamp(self.character.Torso.AssemblyLinearVelocity.Magnitude / self.character.Humanoid.WalkSpeed, 0, 5)
	local alpha = (speedPercent * 0.1) + 0.1

	self.neck.C0 =
		self.neck.C0:Lerp(self.OGneckC0 * CFrame.Angles(0, math.rad(angVel.Y), math.rad(angVel.Y * 3)), alpha)
	self.rShoulder.C0 = self.rShoulder.C0:Lerp(self.OGrShoulderC0 * CFrame.Angles(0, math.rad(-angVel.Y * 3), 0), alpha)
	self.lShoulder.C0 = self.lShoulder.C0:Lerp(self.OGlShoulderC0 * CFrame.Angles(0, math.rad(-angVel.Y * 3), 0), alpha)
	self.rootJoint.C0 = self.rootJoint.C0:Lerp(self.OGrootC0 * CFrame.Angles(0, math.rad(angVel.Y), 0), alpha * 2)
end

function SmoothChar:_setup(character)
	character:WaitForChild("Humanoid")
	self.character = character

	self.neck = character.Torso.Neck
	self.rShoulder = character.Torso["Right Shoulder"]
	self.lShoulder = character.Torso["Left Shoulder"]
	self.rootJoint = character.HumanoidRootPart.RootJoint

	self.OGrootC0 = self.rootJoint.C0
	self.OGneckC0 = self.neck.C0
	self.OGrShoulderC0 = self.rShoulder.C0
	self.OGlShoulderC0 = self.lShoulder.C0
end

function SmoothChar:Reset()
	self.neck.C0 = self.OGneckC0
	self.rootJoint.C0 = self.OGrootC0
	self.rShoulder.C0 = self.OGrShoulderC0
	self.lShoulder.C0 = self.OGlShoulderC0
end

return SmoothChar
