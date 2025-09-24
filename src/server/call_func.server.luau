local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local getDataFunction = Remotes:WaitForChild("GetDataFunction")

local counter = 0
getDataFunction.OnServerInvoke = function(player)
    counter = counter + 1
    return player.Name .. ": " .. counter
end

