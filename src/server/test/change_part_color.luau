local M = {}

function M.test()
    local workspace = game:GetService("Workspace")
    local part = workspace:WaitForChild("ServerPart")

    -- 启动一个task，每1秒改变一次颜色
    task.spawn(function()
        while true do
            part.Color = Color3.new(math.random(), math.random(), math.random())
            task.wait(1)
        end
    end)
end

return M
