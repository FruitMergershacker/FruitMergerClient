local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")
local tweenService = game:GetService("TweenService")

local autoFish = false
local inFishGame = false
local castRod = false

local fishedAmount = 0

local sets = {
	speedAmount = 16,
	sellAmount = 10,
	treeCrateAmount = 1
}

local speedBoost = false

local fishFrame = CFrame.new(-90.864769, 29.9999981, -150.895401, -0.769102752, -7.8977429e-08, 0.639125109, -9.43034095e-08, 1, 1.00894377e-08, -0.639125109, -5.25118615e-08, -0.769102752)
local treeFrame = CFrame.new(-30.8521118, 7.99999905, -195.127869, 0.00704389857, -6.7769129e-08, 0.999975204, 6.53891474e-09, 1, 6.77247485e-08, -0.999975204, 6.06170625e-09, 0.00704389857)

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
	local function activateFishingRod()
   		for _, tool in ipairs(character:GetChildren()) do
        	if tool:IsA("Tool") and (tool.Name == "Fishing Rod" or tool.Name == "Diamond Rod" or tool.Name =="Steel Rod" or tool.Name == "Angler Rod" or tool.Name == "Golden Rod") then
        	    tool:Activate()
        	    return true
        	end
    	end
    	return false
	end

	local function equipAllTools()
    	local backpack = player:FindFirstChild("Backpack")
    	if backpack then
    	    for _, tool in ipairs(backpack:GetChildren()) do
    	        if tool:IsA("Tool") then
    	            humanoid:EquipTool(tool)
					local fishermanPrompt = game.Workspace:WaitForChild("Fisherman"):WaitForChild("HumanoidRootPart"):WaitForChild("ProximityPrompt")
    				activateProximityPrompt(fishermanPrompt)
					wait()
    	        end
    	    end
    	end
	end

	local function Sell()
    	equipAllTools()
    	local fishermanPrompt = game.Workspace:WaitForChild("Fisherman"):WaitForChild("HumanoidRootPart"):WaitForChild("ProximityPrompt")
    	activateProximityPrompt(fishermanPrompt)
    	wait() -- Wait for the selling process to complete
    	fishedAmount = 0 -- Reset the fished amount
	end

    if not autoFish then
        autoFish = true
        castRod = true

        coroutine.wrap(function()
            while autoFish do
                tweenToPosition(fishFrame, 0.5)
                if castRod then
                    equipAllTools()
                    if activateFishingRod() then
                        castRod = false
                    end
                else
                    if game.Players.LocalPlayer.PlayerGui.FishingGame.Enabled then
                        inFishGame = true
                        game.Players.LocalPlayer.PlayerGui.FishingGame.FishArea.Fish.Position = game.Players.LocalPlayer.PlayerGui.FishingGame.FishArea.Hook.Position
                    else
                        if inFishGame then
                            fishedAmount += 1
                            if fishedAmount >= sets.sellAmount then
                                Sell()
                            end
                            inFishGame = false
                            castRod = true    
                        end
                    end
                end
                wait()
            end
        end)()
    else
        autoFish = false
    end
end

local function BuyTreeCrates()
	local buy = game.Players.LocalPlayer.PlayerGui.ZoneUis.TreeShop.BuyCrate.Button

	for i = 0, sets.treeCrateAmount, 1 do
		tweenToPosition(treeFrame, 0.5)

		buy.MouseButton1Click:Connect(function()
			wait(5)
			local crate = game.Workspace:FindFirstChild("TreeCrate")
			tweenToPosition(crate.Center.CFrame.Position, 0.5)
			local function prompt()
				activateProximityPrompt(crate.Center.ProximityPrompt)
				if crate then
					prompt()
				else
					tweenToPosition(treeFrame, 0.5)
				end
			end
			prompt()
		end)
	end
end

-- GUI
-- Create ScreenGui (Main container)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame (Cheat Menu)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(70, 70, 70)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title Frame
local TitleFrame = Instance.new("Frame")
TitleFrame.Size = UDim2.new(1, 0, 0, 40)
TitleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleFrame.Parent = MainFrame

-- Title Label
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "Fruit Mergers Cheat Menu"
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.Parent = TitleFrame

-- Create Scrolling Frame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, -40) -- Adjust height to account for the title
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40) -- Position below the title
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Parent = MainFrame
ScrollingFrame.ClipsDescendants = true -- Clip descendants
ScrollingFrame.ScrollBarThickness = 10

-- Create UIListLayout for the scrolling frame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder -- Set SortOrder to LayoutOrder

-- Counter for LayoutOrder
local layoutOrderCounter = 1 -- Start from 1 since title is 1

-- Create Categories
local function CreateCategory(name)
    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Size = UDim2.new(0.9, 0, 0, 30)
    CategoryLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    CategoryLabel.Text = name
    CategoryLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    CategoryLabel.TextScaled = true
    CategoryLabel.Font = Enum.Font.SourceSansBold
    CategoryLabel.Parent = ScrollingFrame
    CategoryLabel.LayoutOrder = layoutOrderCounter
    layoutOrderCounter = layoutOrderCounter + 1
end

-- Create Toggle Button
local function CreateToggleButton(name, func)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 30)
    Button.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
    Button.Text = name .. " [OFF]"
    Button.TextScaled = true
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.Parent = ScrollingFrame
    Button.LayoutOrder = layoutOrderCounter
    layoutOrderCounter = layoutOrderCounter + 1

    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            Button.BackgroundColor3 = Color3.fromRGB(100, 200, 80)
            Button.Text = name .. " [ON]"
            func() -- Call the function passed to the button
        else
            Button.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
            Button.Text = name .. " [OFF]"
            autoFish = false -- Stop AutoFish when untoggled
        end
    end)
end

-- Create Input Field
local function CreateInputField(name, value)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.9, 0, 0, 25) 
	Label.Text = name
    Label.TextScaled = true
    Label.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.SourceSansBold
    Label.Parent = ScrollingFrame
    Label.LayoutOrder = layoutOrderCounter
    layoutOrderCounter = layoutOrderCounter + 1

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0.9, 0, 0, 25)
    InputBox.Position = UDim2.new(0.05, 0, 0.3, 0)
    InputBox.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    InputBox.Text = "Enter value"
    InputBox.Font = Enum.Font.SourceSansBold
    InputBox.TextScaled = true
    InputBox.Parent = ScrollingFrame
    InputBox.LayoutOrder = layoutOrderCounter
    layoutOrderCounter = layoutOrderCounter + 1

    InputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local inputValue = tonumber(InputBox.Text)
            if inputValue then
                sets[value] = inputValue
            end
        end
    end)
end

-- Create Categories and their elements in order
CreateCategory("Auto Fishing")
CreateToggleButton("Auto Fish", AutoFish)
CreateInputField("Sell at", "sellAmount")

CreateCategory("Auto tree crate")
CreateToggleButton("Buy crates", BuyTreeCrates)
CreateInputField("Buy:", "treeCrateAmount")

CreateCategory("Utilities")
CreateToggleButton("Speed Boost", function()
    speedBoost = not speedBoost
    humanoid.WalkSpeed = speedBoost and sets.speedAmount or 16 -- Set speed based on toggle
end)
CreateInputField("Walk Speed", "speedAmount")

CreateCategory("Esentials")

local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 30)
	Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Button.Text = "Close"
    Button.TextScaled = true
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.Parent = ScrollingFrame
    Button.LayoutOrder = layoutOrderCounter
    layoutOrderCounter = layoutOrderCounter + 1

    local enabled = false
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            autoFish = false
			MainFrame.Parent = nil
		end
    end)


