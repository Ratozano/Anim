--Remote Event Signal
local Triggered = game:GetService("ReplicatedStorage"):WaitForChild("triggered")

local allObeliscos = game:GetService("Workspace"):WaitForChild("AllObeliscos")
local obeliscos = allObeliscos:GetChildren()

for _, obelisco in ipairs(obeliscos) do

    local prompt = obelisco:FindFirstChildOfClass("ProximityPrompt")

    if prompt then
        prompt.Triggered:Connect(function(playerWhoTriggered)
            Triggered:FireServer(playerWhoTriggered)
        end)
    end
end
