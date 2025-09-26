-- 服务获取
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- 本地玩家和摄像机
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- ## 配置项 ##
local PITCH_ANGLE = 60    -- 摄像机的俯视角度 (degrees)
local YAW_ANGLE = 0      -- 摄像机的水平角度 (degrees)
local SMOOTH_SPEED = 1  -- 平滑移动的速度 (0到1之间，越小越慢，越平滑)
local MIN_ZOOM = 20       -- 最小缩放距离
local MAX_ZOOM = 300      -- 最大缩放距离
local ZOOM_SENSITIVITY = 10 -- 缩放灵敏度

-- 初始缩放值
local currentZoom = 300

-- 将角度转换为弧度
local PITCH = math.rad(PITCH_ANGLE)
local YAW = math.rad(YAW_ANGLE)

-- 设置摄像机为脚本控制模式
camera.CameraType = Enum.CameraType.Scriptable

-- ## 核心更新函数 ##
local function updateCamera(deltaTime)
    if not character or not humanoidRootPart then return end
    
    -- 1. 确定焦点位置 (角色位置)
    local focusPosition = humanoidRootPart.Position
    
    -- 2. 计算目标偏移量
    local offset = Vector3.new(
        math.sin(YAW) * currentZoom,
        currentZoom * math.sin(PITCH), -- 使用 sin 和 cos 来构建一个球形偏移，更稳定
        math.cos(YAW) * currentZoom
    )
    
    -- 3. 计算摄像机目标 CFrame
    local targetPosition = focusPosition + offset
    local targetCFrame = CFrame.lookAt(targetPosition, focusPosition)
    
    -- 4. 使用 Lerp 实现平滑过渡
    -- camera.CFrame:Lerp(targetCFrame, SMOOTH_SPEED)
    -- 注意：为了防止抖动，更好的Lerp方式是基于deltaTime (每帧的时间差)
    local alpha = 1 - math.exp(-deltaTime * SMOOTH_SPEED * 10) -- 帧率无关的平滑因子
    camera.CFrame = camera.CFrame:Lerp(targetCFrame, alpha)
    
    -- 5. 设置视野以伪造正交视图
    camera.FieldOfView = 5
end

-- ## 缩放控制 ##
local function handleZoom(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        currentZoom = currentZoom - input.Position.Z * ZOOM_SENSITIVITY
        currentZoom = math.clamp(currentZoom, MIN_ZOOM, MAX_ZOOM)
    end
end

RunService.RenderStepped:Connect(updateCamera)
UserInputService.InputChanged:Connect(handleZoom)
