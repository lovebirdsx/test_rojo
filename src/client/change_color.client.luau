local part = game:GetService("Workspace"):WaitForChild("ClientPart")

-- 启动一个task，每1秒改变一次颜色
task.spawn(function()
    -- 随机的种子使用client端的id，这样每个客户端看到的颜色变化都不一样
    local userId = game:GetService("Players").LocalPlayer.UserId
    print("UserId:", userId)
    math.randomseed(userId)
    while true do
        part.Color = Color3.new(math.random(), math.random(), math.random())
        task.wait(1)
    end
end)
