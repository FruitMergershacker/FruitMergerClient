local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local tweenService = game:GetService("TweenService")

local autoFish = false
local inFishGame = false
local castRod = false

local fishFrame = CFrame.new(-90.864769, 29.9999981, -150.895401, -0.769102752, -7.8977429e-08, 0.639125109, -9.43034095e-08, 1, 1.00894377e-08, -0.639125109, -5.25118615e-08, -0.769102752)

local function equipAllTools()
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                humanoid:EquipTool(tool)
            end
        end
    end
end

local function tweenToPosition(cframe, duration)
    if hrp then
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {CFrame = cframe}
        local tween = tweenService:Create(hrp, tweenInfo, goal)
        tween:Play()
    end
end

local function activateProximityPrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        task.spawn(function()
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end)
    end
end

local function AutoFish()
	autoFish = true
	castRod = true
	local function activateFishingRod()
    	for _, tool in ipairs(character:GetChildren()) do
        	if tool:IsA("Tool") and (tool.Name == "Fishing Rod" or tool.Name == "Diamond Rod") then
           		tool:Activate()
            	return true
       		end
    	end
		return false
	end
	local function Sell()
		local fishermanPrompt = game.Workspace:WaitForChild("Fisherman"):WaitForChild("HumanoidRootPart"):WaitForChild("ProximityPrompt")
		activateProximityPrompt(fishermanPrompt)
	end
	coroutine.wrap(function()
		while autoFish do
			tweenToPosition(fishFrame, 0.5)
			if castRod then
				if activateFishingRod() then
					castRod = false
				end
			else
				if game.Players.LocalPlayer.PlayerGui.FishingGame.Enabled then
					inFishGame = true
					game.Players.LocalPlayer.PlayerGui.FishingGame.FishArea.Fish.Position = game.Players.LocalPlayer.PlayerGui.FishingGame.FishArea.Hook.Position
				else
					inFishGame = false
					castRod = true	
				end
			end
			wait()
		end
	end)()
end

AutoFish()

