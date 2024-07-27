--[[Written by Milkeles]]--

--[[SERVICES]]--
local Players = game:GetService("Players")
local UserInput = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")


--[[MODULES]]--
--local moveListModule = require(ReplicatedStorage.Modules.Magics)
local animationModule = require(ReplicatedStorage.Shared.AnimationsList)
--local fireModule = require(game.ReplicatedStorage.SkillReplication:FindFirstChild("FireSkills"))
--local waterModule = require(game.ReplicatedStorage.SkillReplication:FindFirstChild("WaterSkills"))
--local angelicModule = require(game.ReplicatedStorage.SkillReplication:FindFirstChild("AngelicSkills"))
--local damageUIModule = require(game:GetService("ReplicatedStorage").SkillReplication.DamageReplication)


--[[VARIABLES]]--
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local runningWalkspeed = 21
local tweenInformation = TweenInfo.new(1) 
local sprintStartTween = TweenService:Create(camera, tweenInformation, {FieldOfView = 100})
local sprintEndTween = TweenService:Create(camera, tweenInformation, {FieldOfView = 70})
local replicate = game:GetService("ReplicatedStorage").Remotes:WaitForChild("ReplicationEvent")
local canDoAcrobatic = true;


--[[CLIENT INPUT]]--
mouse.TargetFilter = workspace.IgnoredParts

local function KeyPressed(key) --Checks if specific key is pressed.
	return UserInput:IsKeyDown(key)
end

local function runDash (character, direction) --Makes the player dash in specific direction.
	local dashAnimation = Instance.new("Animation")
	dashAnimation.AnimationId = "rbxassetid://"..animationModule.CoreAnimations[direction]

	local dashAnimationTrack = character.Humanoid.Animator:LoadAnimation(dashAnimation)
	dashAnimationTrack:Play()
	character.Humanoid.JumpPower = 0

	local bodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart)
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

	if direction == "forwardDash" then
		bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.lookVector * 100
	elseif direction == "backwardDash" then
		bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.lookVector * -100
	elseif direction == "leftDash" then
		bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.RightVector * -100
	elseif direction == "rightDash" then
		bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.RightVector * 100
	end

	wait(0.1)
	bodyVelocity:Destroy()
	wait(0.2)
	character.Humanoid.JumpPower = 50
end

local function runFlip (character) --Makes the player flip forward.
	local flipAnimation = Instance.new("Animation")
	flipAnimation.AnimationId = "rbxassetid://"..animationModule.CoreAnimations["flip"]

	local flipAnimationTrack = character.Humanoid.Animator:LoadAnimation(flipAnimation)
	flipAnimationTrack:Play()
	character.Humanoid.JumpPower = 0
	character.Humanoid.WalkSpeed = 0

	local bodyVelocity = Instance.new("BodyVelocity", character.HumanoidRootPart)
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	local powerGraph = 145
	local speed = 80
	
	while powerGraph > 0 do
		bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.lookVector * speed + character.HumanoidRootPart.CFrame.UpVector * powerGraph
		speed -= 4
		powerGraph -= 15
		wait(0.001)
	end
	bodyVelocity.Velocity = character.HumanoidRootPart.CFrame.lookVector * 50
	wait(0.05)
	bodyVelocity:Destroy()
	character.Humanoid.JumpPower = 50
	character.Humanoid.WalkSpeed = 16
end

local function InputStart(input, gameProcessedEvent) --Runned on input start. Checks input and runs the action (if any).
	if not gameProcessedEvent then
		--[[if KeyPressed(Enum.KeyCode.E) then
			print(KeyPressed(Enum.KeyCode.E))
			game.ReplicatedStorage.Events.AttackActivation:FireServer(moveListModule.Magics[player.Data.Element.Value].FirstMove, mouse.Hit)
		elseif KeyPressed(Enum.KeyCode.F) then
			game.ReplicatedStorage.Events.AttackActivation:FireServer(moveListModule.Magics[player.Data.Element.Value].SecondMove, mouse.Hit)
		elseif KeyPressed(Enum.KeyCode.C) then
			game.ReplicatedStorage.Events.AttackActivation:FireServer(moveListModule.Magics[player.Data.Element.Value].ThirdMove, mouse.Hit)
		elseif KeyPressed(Enum.KeyCode.V) then
			game.ReplicatedStorage.Events.AttackActivation:FireServer(moveListModule.Magics[player.Data.Element.Value].FourthMove, mouse.Hit)]]
			
		if KeyPressed(Enum.KeyCode.LeftShift) then
			if player.Character then
				sprintStartTween:Play()
				player.Character.Humanoid.WalkSpeed = runningWalkspeed
			end
			
		elseif KeyPressed(Enum.KeyCode.X) and canDoAcrobatic then
			canDoAcrobatic = false
			if KeyPressed(Enum.KeyCode.W) then
				if player.Character.Humanoid:GetState() == Enum.HumanoidStateType.Freefall and KeyPressed(Enum.KeyCode.Space) then
					runFlip(player.Character)
				else
					runDash(player.Character, "forwardDash")
				end
			elseif KeyPressed(Enum.KeyCode.S) then
				runDash(player.Character, "backwardDash")
			elseif KeyPressed(Enum.KeyCode.A) then
				runDash(player.Character, "leftDash")
			elseif KeyPressed(Enum.KeyCode.D) then
				runDash(player.Character, "rightDash")
			end
			wait(1.1)
			canDoAcrobatic = true
		end
		
	end
end

local function InputEnd(input) --Runned on input end.
	if not KeyPressed(Enum.KeyCode.LeftShift) then
		if player.Character then
			sprintEndTween:Play()
			player.Character.Humanoid.WalkSpeed = 16
		end
	end
end

UserInput.InputBegan:Connect(InputStart)	
UserInput.InputEnded:Connect(InputEnd)


--[[CHAT]]--
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

--[[MOVE REPLICATION]]--
--damageUIModule.DamageUI()

--fireModule["Fiery Eruption"](replicate,"Fiery Eruption")
--fireModule["Magma Outburst"](replicate,"Magma Outburst")
--fireModule["Fireball"](replicate,"Fireball")

--waterModule["Water Energy"](replicate, "Water Energy")
--waterModule["Droplets Burst"](replicate, "Droplets Burst")
--waterModule["Aquatic Slash"](replicate, "Aquatic Slash")
--waterModule["Spikey Trap"](replicate, "Spikey Trap")

--angelicModule["Thunderstorm"](replicate, "Thunderstorm")
