-- Remote Event
local Triggered = game:GetService("ReplicatedStorage"):WaitForChild("triggered")

Triggered.OnServerEvent:Connect(function(playerWhoTriggered)
	local playerGUI = playerWhoTriggered:WaitForChild("PlayerGui")
	print("Achou a " .. playerGUI.Name .. " do Client")

	local remainingText = playerGUI:WaitForChild("remainingGui"):FindFirstChildOfClass("TextLabel")
	print("Achou o " .. remainingText.Name .. " na PlayerGui")

	local transparency = 1
	local Tstep = 0.1
	local visible = false

	local function VisibleText(playerWhoTriggered)
		if not visible then
			visible = true
			while transparency > 0 do
				transparency = transparency - Tstep
				remainingText.TextTransparency = transparency
				task.wait(0.1)
			end
		end
	end

	local function InvisibleText(playerWhoTriggered)
		if visible then
			visible = false
			while transparency < 1  do
				transparency = transparency + Tstep
				remainingText.TextTransparency = transparency
				task.wait(0.1)
			end
		end
	end

	VisibleText(playerWhoTriggered)
	
	task.wait(2)

    InvisibleText(playerWhoTriggered)
end)

-- Obelisco Management
local allObeliscos = game:GetService("Workspace"):WaitForChild("AllObeliscos")
local obeliscos = allObeliscos:GetChildren()

for _, obelisco in ipairs(obeliscos) do
	local sphere = obelisco:FindFirstChildOfClass("Part")
	local prompt = obelisco:FindFirstChildOfClass("ProximityPrompt")

	if prompt and sphere then
		
		local position = sphere.Position
		local new_position = Vector3.new(0, 0.526, 0)
		
		local luz = sphere.PointLight
		local brightness = 0
		local Bstep = 0.05
		
		local promptAtivo = false

		local ts = game:GetService("TweenService")
		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, false, 0)

		local goalAtivar = {
			CFrame = CFrame.new(position + new_position),
			Color = Color3.fromRGB(148, 255, 255)
		}
		local goalDesativar = {
			CFrame = CFrame.new(position),
			Color = Color3.fromRGB(74, 74, 74)
		}

		local function ativo(playerWhoTriggered)
			if not promptAtivo then
				promptAtivo = true
				local tweenAtivar = ts:Create(sphere, tweenInfo, goalAtivar)
				tweenAtivar:Play()
				prompt.Enabled = false

				while brightness < 1 do
					brightness = brightness + Bstep
					luz.Brightness = brightness
					task.wait(0.1)
				end

				tweenAtivar.Completed:Connect(function(status)
					if status == Enum.PlaybackState.Completed then
						print("Tween de ativação terminou")
					end
				end)
			end
		end

		prompt.Triggered:Connect(function(playerWhoTriggered)
			ativo(playerWhoTriggered)
		end)
	end
end
