local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local clickEffectEvent = ReplicatedStorage:WaitForChild("ClickEffectEvent")
local effectTemplate = ReplicatedStorage:WaitForChild("EffectPart")
local clickablePart = Workspace:WaitForChild("ClickablePart")
local clickDetector = clickablePart:WaitForChild("ClickDetector")

-- 创建爆炸特效函数
local function createExplosionEffect(position)
    -- 创建爆炸粒子
    local particleCount = 15
    for i = 1, particleCount do
        local particle = effectTemplate:Clone()
        particle.Parent = Workspace
        particle.Position = position
        
        -- 设置随机颜色
        local colors = {
            Color3.fromRGB(255, 140, 0),  -- 橙色
            Color3.fromRGB(255, 69, 0),   -- 红橙色
            Color3.fromRGB(255, 215, 0),  -- 金色
            Color3.fromRGB(255, 255, 0),  -- 黄色
        }
        particle.Color = colors[math.random(1, #colors)]
        
        -- 随机方向和速度
        local randomDirection = Vector3.new(
            math.random(-1, 1),
            math.random(0.5, 1),
            math.random(-1, 1)
        ).Unit
        
        local force = math.random(20, 40)
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = randomDirection * force
        bodyVelocity.Parent = particle
        
        -- 创建旋转效果
        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyAngularVelocity.AngularVelocity = Vector3.new(
            math.random(-10, 10),
            math.random(-10, 10),
            math.random(-10, 10)
        )
        bodyAngularVelocity.Parent = particle
        
        -- 创建缩放和透明度动画
        local tweenInfo = TweenInfo.new(
            1.2,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        )
        
        local goal = {
            Transparency = 1,
            Size = particle.Size * 0.1
        }
        
        local tween = TweenService:Create(particle, tweenInfo, goal)
        
        -- 在动画完成时清理粒子
        tween.Completed:Connect(function()
            particle:Destroy()
        end)
        
        tween:Play()
        
        -- 使用 Debris 服务作为备用清理机制
        Debris:AddItem(particle, 2)
    end
    
    -- 创建中心爆炸闪光
    local flash = effectTemplate:Clone()
    flash.Parent = Workspace
    flash.Position = position
    flash.Color = Color3.fromRGB(255, 255, 255)
    flash.Size = Vector3.new(0.5, 0.5, 0.5)
    flash.Shape = Enum.PartType.Ball
    flash.Material = Enum.Material.Neon
    
    local flashTweenInfo = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local flashGoal = {
        Size = Vector3.new(8, 8, 8),
        Transparency = 1
    }
    
    local flashTween = TweenService:Create(flash, flashTweenInfo, flashGoal)
    flashTween.Completed:Connect(function()
        flash:Destroy()
    end)
    flashTween:Play()
end

clickDetector.MouseClick:Connect(function(player)
    print(player.Name .. " clicked the part!")

    if player == Players.LocalPlayer then
        -- 只在本地玩家点击时触发效果
        clickEffectEvent:FireServer(clickablePart.Position)
    end
end)

clickEffectEvent.OnClientEvent:Connect(function(position)
    -- 使用新的爆炸特效
    createExplosionEffect(position + Vector3.new(0, 2, 0))
end)
