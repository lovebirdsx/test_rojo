local RunService = game:GetService("RunService")
local SpinnerComponent = {}
SpinnerComponent.__index = SpinnerComponent

function SpinnerComponent.new(part)
	local self = setmetatable({}, SpinnerComponent)
	
	self.part = part
	self.spinSpeed = 5
	self.connection = nil
	
	return self
end

function SpinnerComponent:Start()
	if self.connection then return end
	
	self.connection = RunService.Heartbeat:Connect(function(deltaTime)
		local angle = self.spinSpeed * deltaTime
		self.part.CFrame = self.part.CFrame * CFrame.Angles(0, math.rad(angle), 0)
	end)
end

function SpinnerComponent:Stop()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
end

function SpinnerComponent:Destroy()
	self:Stop()
	-- 清理引用，帮助垃圾回收
	self.part = nil
end

return SpinnerComponent
