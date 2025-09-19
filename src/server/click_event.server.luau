local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clickEffectEvent = ReplicatedStorage:WaitForChild("ClickEffectEvent")

local function onClickEffectRequested(player, position)
    clickEffectEvent:FireAllClients(position)
end

clickEffectEvent.OnServerEvent:Connect(onClickEffectRequested)
