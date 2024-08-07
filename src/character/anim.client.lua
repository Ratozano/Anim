--Player--
local plr = game:GetService("Players").LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

--Services--
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local runService = game:GetService("RunService")

--Anim / Value--
local IsRunning = script:FindFirstChild("IsRunning")
local IsWalking = script:FindFirstChild("IsWalking")
local Stopped = script:FindFirstChild("Stopped")
local idleANIM = humanoid:LoadAnimation(script:WaitForChild("idle"))
local runANIM = humanoid:LoadAnimation(script:WaitForChild("run"))
local walkANIM = humanoid:LoadAnimation(script:WaitForChild("walk"))

--BooleanValue--
local originalSpeed = humanoid.WalkSpeed
local lastPosition = character.PrimaryPart.Position 
local isOnGround = true
IsRunning = false
IsWalking = false
Stopped = false

--Changeable--
local runButton = Enum.KeyCode.LeftControl 
local DefaultFieldOfView = 75
local SprintFieldOfView = 85
local defaultSpeed = 16
local newSpeed = 25

--PlayerAnimFunction--

camera.FieldOfView = DefaultFieldOfView
humanoid.WalkSpeed = defaultSpeed

--Anim Functions--

local function Running(input)
    if input.KeyCode == runButton and isOnGround == true then
        IsRunning = true
        humanoid.WalkSpeed = newSpeed
        runANIM:Play()
        walkANIM:Stop()

        local goal1 = { FieldOfView = SprintFieldOfView }
        local tweenInfo1 = TweenInfo.new(0.5)
        local tween1 = ts:Create(camera,tweenInfo1,goal1)
        tween1:Play()
    end
end

local function StopRunning(input)
    if input.KeyCode == runButton and isOnGround == true then
        IsRunning = false
        humanoid.WalkSpeed = defaultSpeed
        runANIM:Stop()

        local goal2 = { FieldOfView = DefaultFieldOfView}
        local tweenInfo2 = TweenInfo.new(0.5)
        local tween2 = ts:Create(camera,tweenInfo2,goal2)
        tween2:Play()
    end
end

local function Walking(input)
    if not IsWalking and isOnGround == true then
        IsWalking = true
        camera.FieldOfView = DefaultFieldOfView
        walkANIM:Play()
    end
end

local function StopWalking(input)
    if IsWalking and isOnGround == true then
        IsWalking = false
        camera.FieldOfView = DefaultFieldOfView
        walkANIM:Stop()
    end
end

--KeyConfig--

local function UserInputConfig(input, isPressed)
    if  input.KeyCode == Enum.KeyCode.W or 
        input.KeyCode == Enum.KeyCode.A or 
        input.KeyCode == Enum.KeyCode.S or
        input.KeyCode == Enum.KeyCode.D then
        if isPressed then
            Walking(input)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            StopWalking(input)
            Running(input)
        local AnyKeyIsPressed = input.KeyCode == uis:IsKeyDown(Enum.KeyCode.W) or
                                input.KeyCode == uis:IsKeyDown(Enum.KeyCode.A) or
                                input.KeyCode == uis:IsKeyDown(Enum.KeyCode.S) or
                                input.KeyCode == uis:IsKeyDown(Enum.KeyCode.D) or
                                input.KeyCode == uis:IsKeyDown(Enum.KeyCode.LeftControl) 
            if not AnyKeyIsPressed then
                StopRunning()
                StopWalking()
            end  
        end
    end        
end

uis.InputBegan:Connect(function(input)
    UserInputConfig(input, true)
    Running(input)
end)

uis.InputEnded:Connect(function(input)
    UserInputConfig(input, false)
    StopRunning(input)
end)