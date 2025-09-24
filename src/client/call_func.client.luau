local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local screenGui = playerGui:WaitForChild("ScreenGui")
local textButton = screenGui:WaitForChild("TextButton")
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local getDataFunction = Remotes:WaitForChild("GetDataFunction")

textButton.MouseButton1Click:Connect(function()
    local serverData = getDataFunction:InvokeServer()
    textButton.Text = "Data: " .. tostring(serverData)
end)
