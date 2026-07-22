-- pink 229, 73, 232
-- gray 193, 193, 193

Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		else
			error("Invalid Service: " .. tostring(name))
		end
	end
})

local Players=Services.Players
local TextChatService=Services.TextChatService
local lp=Players.LocalPlayer

local allowedUserIds={

}

local loopTp=false
local currentlyFlinging=false



local SkidFling = function(TargetPlayer)
	local Character = lp.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Humanoid and Humanoid.RootPart

	local TCharacter = TargetPlayer.Character
	local THumanoid
	local TRootPart
	local THead
	local Accessory
	local Handle

	if TCharacter:FindFirstChildOfClass("Humanoid") then
		THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
	end
	if THumanoid and THumanoid.RootPart then
		TRootPart = THumanoid.RootPart
	end
	if TCharacter:FindFirstChild("Head") then
		THead = TCharacter.Head
	end
	if TCharacter:FindFirstChildOfClass("Accessory") then
		Accessory = TCharacter:FindFirstChildOfClass("Accessory")
	end
	if Accessoy and Accessory:FindFirstChild("Handle") then
		Handle = Accessory.Handle
	end

	if Character and Humanoid and RootPart then
		if RootPart.Velocity.Magnitude < 50 then
			getgenv().OldPos = RootPart.CFrame
		end
		if THead then
			workspace.CurrentCamera.CameraSubject = THead
		elseif not THead and Handle then
			workspace.CurrentCamera.CameraSubject = Handle
		elseif THumanoid and TRootPart then
			workspace.CurrentCamera.CameraSubject = THumanoid
		end
		if not TCharacter:FindFirstChildWhichIsA("BasePart") then
			return false
		end

		local FPos = function(BasePart, Pos, Ang)
			RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
			Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
			RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
			RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
		end

		local SFBasePart = function(BasePart)
			local TimeToWait = 2
			local Time = tick()
			local Angle = 0

			repeat
				if RootPart and THumanoid then
					if BasePart.Velocity.Magnitude < 50 then
						Angle = Angle + 100

						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
					else
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()
					end
				else
					break
				end
			until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
		end

		workspace.FallenPartsDestroyHeight = 0/0

		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

		if TRootPart and THead then
			if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
				SFBasePart(THead)
			else
				SFBasePart(TRootPart)
			end
		elseif TRootPart and not THead then
			SFBasePart(TRootPart)
		elseif not TRootPart and THead then
			SFBasePart(THead)
		elseif not TRootPart and not THead and Accessory and Handle then
			SFBasePart(Handle)
		end

		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = Humanoid

		repeat
			RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
			Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
			Humanoid:ChangeState("GettingUp")
			table.foreach(Character:GetChildren(), function(_, x)
				if x:IsA("BasePart") then
					x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
				end
			end)
			task.wait()
		until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
		workspace.FallenPartsDestroyHeight = getgenv().FPDH
	end
end



local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder=7683452
ScreenGui.ResetOnSpawn=false

local Frame = Instance.new("Frame")
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(110, 0, 168)
Frame.BorderColor = BrickColor.new("Really black")
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0.48, 0, 0.3, 0)

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 6

local UICorner = Instance.new("UICorner")
UICorner.BottomLeftRadius = UDim.new(0.05, 0)
UICorner.BottomRightRadius = UDim.new(0.05, 0)
UICorner.CornerRadius = UDim.new(0.05, 0)
UICorner.TopLeftRadius = UDim.new(0.05, 0)
UICorner.TopRightRadius = UDim.new(0.05, 0)

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.Active = true
ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderColor = BrickColor.new("Really black")
ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.Position = UDim2.new(0.64, 0, 0.5, 0)
ScrollingFrame.Size = UDim2.new(0.66, 0, 0.93, 0)
ScrollingFrame.Transparency = 1

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Frame_2 = Instance.new("Frame")
Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_2.BackgroundTransparency = 1
Frame_2.BorderColor = BrickColor.new("Really black")
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0.95, 0, 0.32, 0)
Frame_2.Transparency = 1
Frame_2.Visible = false

local Frame_3 = Instance.new("Frame")
Frame_3.AnchorPoint = Vector2.new(0.5, 0.5)
Frame_3.BackgroundColor3 = Color3.fromRGB(66, 6, 138)
Frame_3.BorderColor = BrickColor.new("Really black")
Frame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_3.BorderSizePixel = 0
Frame_3.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame_3.Size = UDim2.new(1, 0, 0.59, 0)

local UICorner_2 = Instance.new("UICorner")
UICorner_2.BottomLeftRadius = UDim.new(0.3, 0)
UICorner_2.BottomRightRadius = UDim.new(0.3, 0)
UICorner_2.CornerRadius = UDim.new(0.3, 0)
UICorner_2.TopLeftRadius = UDim.new(0.3, 0)
UICorner_2.TopRightRadius = UDim.new(0.3, 0)

local Frame_4 = Instance.new("Frame")
Frame_4.BackgroundColor3 = Color3.fromRGB(193, 193, 193)
Frame_4.BorderColor = BrickColor.new("Really black")
Frame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_4.BorderSizePixel = 0
Frame_4.Position = UDim2.new(0.9, 0, 0.25, 0)
Frame_4.Size = UDim2.new(0.07, 0, 0.5, 0)

local UICorner_3 = Instance.new("UICorner")
UICorner_3.BottomLeftRadius = UDim.new(0.31, 0)
UICorner_3.BottomRightRadius = UDim.new(0.31, 0)
UICorner_3.CornerRadius = UDim.new(0.31, 0)
UICorner_3.TopLeftRadius = UDim.new(0.31, 0)
UICorner_3.TopRightRadius = UDim.new(0.31, 0)

local UIStroke_2 = Instance.new("UIStroke")
UIStroke_2.Color = Color3.fromRGB(255, 255, 255)
UIStroke_2.Thickness = 2

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Image = "rbxassetid://6972510111"
--[[ Unsupported Type: Content For : ImageContent ]]
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderColor = BrickColor.new("Really black")
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel.Size = UDim2.new(0.7, 0, 0.7, 0)
ImageLabel.Transparency = 1
ImageLabel.Visible = false

local TextButton = Instance.new("TextButton")
TextButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TextButton.Text = ""
TextButton.TextColor = BrickColor.new("Really black")
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 14
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundTransparency = 1
TextButton.BorderColor = BrickColor.new("Really black")
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.BorderSizePixel = 0
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.Transparency = 1
TextButton.ZIndex = 2

local UICorner_4 = Instance.new("UICorner")
UICorner_4.BottomLeftRadius = UDim.new(0.31, 0)
UICorner_4.BottomRightRadius = UDim.new(0.31, 0)
UICorner_4.CornerRadius = UDim.new(0.31, 0)
UICorner_4.TopLeftRadius = UDim.new(0.31, 0)
UICorner_4.TopRightRadius = UDim.new(0.31, 0)

local TextLabel = Instance.new("TextLabel")
TextLabel.FontFace = Font.new("rbxassetid://12187365977", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextLabel.Text = "TwentyOneCharacters"
TextLabel.TextColor = BrickColor.new("Institutional white")
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14
TextLabel.TextWrapped = true
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1
TextLabel.BorderColor = BrickColor.new("Really black")
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel.Size = UDim2.new(0.7, 0, 0.55, 0)
TextLabel.Transparency = 1
TextLabel.TextTransparency = 0

local UIStroke_3 = Instance.new("UIStroke")
UIStroke_3.Thickness = 3

local ImageLabel_2 = Instance.new("ImageLabel")
ImageLabel_2.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
--[[ Unsupported Type: Content For : ImageContent ]]
ImageLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_2.BorderColor = BrickColor.new("Really black")
ImageLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel_2.BorderSizePixel = 0
ImageLabel_2.Position = UDim2.new(0.07, 0, 0.5, 0)
ImageLabel_2.Size = UDim2.new(0.1, 0, 0.74, 0)

local UICorner_5 = Instance.new("UICorner")
UICorner_5.BottomLeftRadius = UDim.new(0.31, 0)
UICorner_5.BottomRightRadius = UDim.new(0.31, 0)
UICorner_5.CornerRadius = UDim.new(0.31, 0)
UICorner_5.TopLeftRadius = UDim.new(0.31, 0)
UICorner_5.TopRightRadius = UDim.new(0.31, 0)

local Line = Instance.new("Frame")
Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Line.BorderColor = BrickColor.new("Really black")
Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
Line.BorderSizePixel = 0
Line.Position = UDim2.new(0.29, 0, 0.07, 0)
Line.Size = UDim2.new(0, 0, 0.86, 0)
Line.Name = "Line"

local TextLabel_2 = Instance.new("TextLabel")
TextLabel_2.FontFace = Font.new("rbxassetid://12187365977", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextLabel_2.Text = "[LATER]"
TextLabel_2.TextColor = BrickColor.new("Institutional white")
TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.TextScaled = true
TextLabel_2.TextSize = 14
TextLabel_2.TextWrapped = true
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.BorderColor = BrickColor.new("Really black")
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.03, 0, 0.44, 0)
TextLabel_2.Size = UDim2.new(0.23, 0, 0.1, 0)
TextLabel_2.Transparency = 1
TextLabel_2.TextTransparency = 0

local UIStroke_4 = Instance.new("UIStroke")
UIStroke_4.Thickness = 3

local UIShadow = Instance.new("UIShadow")
UIShadow.BlurRadius = UDim.new(0, 30)
UIShadow.Color = Color3.fromRGB(153, 0, 255)
UIShadow.Spread = UDim2.new(0.04, 0, 0.04, 0)
UIShadow.Transparency = 0.5

local btn = Instance.new("Frame")
btn.AnchorPoint = Vector2.new(0.5, 0.5)
btn.BackgroundColor3 = Color3.fromRGB(136, 3, 255)
btn.BorderColor = BrickColor.new("Really black")
btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
btn.BorderSizePixel = 0
btn.Position = UDim2.new(0.5, 0, 0.8, 0)
btn.Size = UDim2.new(0.05, 0, 0.06, 0)
btn.Name = "btn"

local UICorner_6 = Instance.new("UICorner")
UICorner_6.BottomLeftRadius = UDim.new(0.3, 0)
UICorner_6.BottomRightRadius = UDim.new(0.3, 0)
UICorner_6.CornerRadius = UDim.new(0.3, 0)
UICorner_6.TopLeftRadius = UDim.new(0.3, 0)
UICorner_6.TopRightRadius = UDim.new(0.3, 0)

local UIShadow_2 = Instance.new("UIShadow")
UIShadow_2.BlurRadius = UDim.new(0, 30)
UIShadow_2.Color = Color3.fromRGB(153, 0, 255)
UIShadow_2.Spread = UDim2.new(0.04, 0, 0.04, 0)
UIShadow_2.Transparency = 0.5

local TextLabel_3 = Instance.new("TextLabel")
TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TextLabel_3.Text = "X"
TextLabel_3.TextColor = BrickColor.new("Institutional white")
TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.TextScaled = true
TextLabel_3.TextSize = 14
TextLabel_3.TextWrapped = true
TextLabel_3.AnchorPoint = Vector2.new(0.5, 0.5)
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.BackgroundTransparency = 1
TextLabel_3.BorderColor = BrickColor.new("Really black")
TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.BorderSizePixel = 0
TextLabel_3.Position = UDim2.new(0.5, 0, 0.5, 0)
TextLabel_3.Size = UDim2.new(0.67, 0, 0.67, 0)
TextLabel_3.Transparency = 1
TextLabel_3.TextTransparency = 0

local TextButton_2 = Instance.new("TextButton")
TextButton_2.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TextButton_2.Text = ""
TextButton_2.TextColor = BrickColor.new("Really black")
TextButton_2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_2.TextSize = 14
TextButton_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton_2.BackgroundTransparency = 1
TextButton_2.BorderColor = BrickColor.new("Really black")
TextButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_2.BorderSizePixel = 0
TextButton_2.Size = UDim2.new(1, 0, 1, 0)
TextButton_2.Transparency = 1
TextButton_2.ZIndex = 2

local UICorner_7 = Instance.new("UICorner")
UICorner_7.BottomLeftRadius = UDim.new(0.31, 0)
UICorner_7.BottomRightRadius = UDim.new(0.31, 0)
UICorner_7.CornerRadius = UDim.new(0.31, 0)
UICorner_7.TopLeftRadius = UDim.new(0.31, 0)
UICorner_7.TopRightRadius = UDim.new(0.31, 0)

ScreenGui.Parent = lp.PlayerGui
Frame.Parent = ScreenGui
UIStroke.Parent = Frame
UICorner.Parent = Frame
ScrollingFrame.Parent = Frame
UIListLayout.Parent = ScrollingFrame
Frame_2.Parent = ScrollingFrame
Frame_3.Parent = Frame_2
UICorner_2.Parent = Frame_3
Frame_4.Parent = Frame_3
UICorner_3.Parent = Frame_4
UIStroke_2.Parent = Frame_4
ImageLabel.Parent = Frame_4
TextButton.Parent = Frame_4
UICorner_4.Parent = TextButton
TextLabel.Parent = Frame_3
UIStroke_3.Parent = TextLabel
ImageLabel_2.Parent = Frame_3
UICorner_5.Parent = ImageLabel_2
Line.Parent = Frame
TextLabel_2.Parent = Frame
UIStroke_4.Parent = TextLabel_2
UIShadow.Parent = Frame
btn.Parent = ScreenGui
UICorner_6.Parent = btn
UIShadow_2.Parent = btn
TextLabel_3.Parent = btn
TextButton_2.Parent = btn
UICorner_7.Parent = TextButton_2




local mainPanel=ScreenGui:WaitForChild("Frame")
local ScrollingFrame=mainPanel:WaitForChild("ScrollingFrame")
local Template = ScrollingFrame:WaitForChild("Frame")
local function cr(plr)
    if not ScrollingFrame:FindFirstChild("Entry_"..tostring(plr.UserId)) then

        local g=Template:Clone()
        local t=g:WaitForChild("Frame")
        local telab=t:WaitForChild("TextLabel")
        telab.Text=plr.DisplayName.." (@"..plr.Name..")"
        local tick=t:WaitForChild("Frame")
        local img=tick:WaitForChild("ImageLabel")
        tick:WaitForChild("TextButton").MouseButton1Click:Connect(function ()
            local found=false
            local position
            for pos, userid in allowedUserIds do
                if userid == plr.UserId then
                    position=pos
                    found=true
                end
            end
            if found then
                table.remove(allowedUserIds,position)
                img.Visible=false
                tick.BackgroundColor3=Color3.fromRGB(193, 193, 193)
            else
                table.insert(allowedUserIds,plr.UserId)
                img.Visible=true
                tick.BackgroundColor3=Color3.fromRGB(229, 73, 232)
            end
        end)
        g.Name="Entry_"..tostring(plr.UserId)
        g.Parent=ScrollingFrame
        g.Visible=true
    end
end

for _, plr in Players:GetPlayers() do
    cr(plr)
end

Players.PlayerAdded:Connect(function (plr)
    cr(plr)
end)

Players.PlayerRemoving:Connect(function (plr)
    for _, id in allowedUserIds  do
        if plr.UserId==id then
            table.remove(allowedUserIds,_)
            
        end
    end

    for _, child in ScrollingFrame:GetChildren() do
        if child.Name == "Entry_"..tostring(plr.UserId) then
            child:Destroy()
        end
    end
end)


TextChatService.OnIncomingMessage = function(message)
    local properties = Instance.new("TextChatMessageProperties")
    local userid=message.TextSource.UserId
    local al=false
    for _, g in allowedUserIds do
        if g == userid then
            al=true
            --return
        end
    end

    if message.TextSource and al then
        properties.PrefixText = "[Allowed] " .. (message.PrefixText or "[unknown username]")
    end

    local msg=message.Text

    if msg and al and (not currentlyFlinging) then
        if string.find(string.lower(msg),"#f1") then
            local splitText=string.split(msg, " ")
            local user=splitText[2]
            if user then
                local plr
                for _, player in Players:GetPlayers() do
                    if string.sub(player.Name,-1,string.len(user)) == string.sub(user,-1,string.len(user)) then
                        plr=player
                        --return
                    end
                end

                if plr~=nil then
                    currentlyFlinging=true
                    SkidFling(plr)
                    currentlyFlinging=false
                end
            end
        end
    end

    return properties
end


btn:WaitForChild("TextButton").MouseButton1Click:Connect(function ()
    if mainPanel.Visible then
        mainPanel.Visible=false
        btn:WaitForChild("TextLabel").Text="O"
    else
        mainPanel.Visible=true
        btn:WaitForChild("TextLabel").Text="X"
    end
end)
