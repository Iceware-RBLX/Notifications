local Client = game:GetService("Players").LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local RunService = game:GetService("RunService")
local TS = game:GetService("TweenService")

local default_properties = {
	Frame = {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 300, 0, 100),
		AnchorPoint = Vector2.new(1, 1),
		BorderColor3 = Color3.new(0, 0, 0),
	},
	TextLabel = {
		BackgroundTransparency = 1,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
		TextSize = 16,
		Text = "Label",
		Size = UDim2.new(1, 0, 1, 0),
		TextColor3 = Color3.new(1, 1, 1),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		BorderColor3 = Color3.new(0, 0, 0),
	},
	ScrollingFrame = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 3,
		BackgroundTransparency = 1,
		Active = true,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0.9, 0, 0.06, 42),
		ScrollBarImageColor3 = Color3.new(0, 0, 0),
		BorderColor3 = Color3.new(0, 0, 0),
		Position = UDim2.new(0, 15, 0, 40),
	},
}



local function create(className: string, instanceProperties, children): Instance
	local instance = Instance.new(className)

	if default_properties[className] then
		for property, value in pairs(default_properties[className]) do
			if instance:GetPropertyChangedSignal(property) ~= nil then
				instance[property] = value
			end
		end
	end

	if instanceProperties then
		for property, value in pairs(instanceProperties) do
			if instance:GetPropertyChangedSignal(property) ~= nil then
				instance[property] = value
			end

			if property == "Parent" then
				instance.Parent = value
			end
		end
	end

	if children then
		mount(children, instance)
	end

	return instance
end


function mount(instances: GuiObject | {}, target: GuiObject)
	if not instances then
		return
	end

	if type(instances) ~= "table" then
		instances.Parent = target
	end

	if type(instances) == "table" then
		for _, c in next, instances do
			c.Parent = target
		end
	end
end

local Notifications = {
	stack = {},
	container = (game:GetService("CoreGui"):FindFirstChild("Notifications") or (function()
		local sg = Instance.new("ScreenGui")
		sg.Name = "Notifications"
		sg.Parent = game:GetService("CoreGui")
		return sg
	end)())
}

function Notifications:pushNotificationInstance(instance: Instance)
	table.insert(Notifications.stack, instance)
	instance.Parent = Notifications.container
end

function Notifications:popNotificationInstance(index: number)
	local notification = table.remove(Notifications.stack, index)

	local remove = TS:Create(notification, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Position = notification.Position + UDim2.fromOffset(notification.AbsoluteSize.X + 50, 0) })
	remove.Completed:Connect(function() 
		notification:Destroy() 
		Notifications:shiftNotifications(index) 
	end)

	remove:Play()
end

function Notifications:shiftNotifications(poppedIndex: number)
	for index, notification in next, Notifications.stack do
		if index > poppedIndex - 1 then
			TS:Create(notification, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Position = UDim2.new(1, -10, 1, -10 - (index - 1) * 110) }):Play()    
		end
	end
end

function Notifications:sortNotifications()
	for index, notification in next, Notifications.stack do
		TS:Create(notification, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), { Position = UDim2.new(1, -10, 1, -10 - (index - 1) * 110) }):Play() 
	end
end

function Notifications:Push(message: string, duration: number, title: string?, icon: string?)
	local index = #Notifications.stack + 1

	local notification = create("Frame", {
		Name = "Notif",
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.new(0, 300, 0, 100),
		BorderColor3 = Color3.new(0, 0, 0),
		Position = UDim2.new(1, 310, 1, -10 - (index - 1) * 110), -- Start offscreen right
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.new(1, 1, 1),
		Parent = Notifications.container,
	}, {
		create("UICorner", {
			CornerRadius = UDim.new(0, 5)
		}),
		create("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = Color3.new(1, 1, 1),
		}, {
			create("UIGradient", {
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.new(0.12, 0.12, 0.12)),
					ColorSequenceKeypoint.new(1, Color3.new(0.24, 0.24, 0.24))
				}),
				Rotation = -90,
			})
		}),
		create("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0.09, 0.09, 0.09)),
				ColorSequenceKeypoint.new(1, Color3.new(0.14, 0.14, 0.14))
			}),
			Rotation = -90,
		}),
		create("ScrollingFrame", {
			Name = "Content",
			Active = true,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = Color3.new(1, 1, 1),
			Size = UDim2.new(0.9, 0, 0.06, 42),
			ScrollBarImageColor3 = Color3.new(0, 0, 0),
			BorderColor3 = Color3.new(0, 0, 0),
			ScrollBarThickness = 3,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 15, 0, 40),
		}, {
			create("TextLabel", {
				Name = "Message",
				TextWrapped = true,
				BorderSizePixel = 0,
				TextYAlignment = Enum.TextYAlignment.Top,
				BackgroundColor3 = Color3.new(1, 1, 1),
				FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextSize = 13,
				Size = UDim2.new(1, 0, 1, 0),
				BorderColor3 = Color3.new(0, 0, 0),
				Text = message,
				TextColor3 = Color3.new(0.85, 0.85, 0.85),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
			}, {
				create("UIPadding", {
					PaddingLeft = UDim.new(0, 5),
					PaddingRight = UDim.new(0, 5),
				})
			})
		}),
		create("TextLabel", {
			Name = "Title",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = 16,
			Size = UDim2.new(0.87, 0, 0.26, 0),
			BorderColor3 = Color3.new(0, 0, 0),
			Text = title or "Notification",
			TextColor3 = Color3.new(1, 1, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.11, 0, 0.07, 0),
		}, {
			create("UIPadding", {
				PaddingLeft = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 5),
			})
		}),
		create("ImageLabel", {
			Name = "Icon",
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.new(1, 1, 1),
			Image = icon or "rbxassetid://70856241901857",
			Size = UDim2.new(0, 20, 0, 20),
			BorderColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 15, 0, 11),
		}),
		create("ImageLabel", {
			Name = "Shadow",
			BorderSizePixel = 0,
			SliceCenter = Rect.new(52, 31, 261, 502),
			ScaleType = Enum.ScaleType.Slice,
			BackgroundColor3 = Color3.new(1, 1, 1),
			Image = "rbxassetid://14898786664",
			Size = UDim2.new(1, 89, 1, 52),
			BorderColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, -48, 0, -31),
		})
	})

	Notifications:pushNotificationInstance(notification)

	TS:Create(notification, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {
		Position = UDim2.new(1, -10, 1, -10 - (index - 1) * 110)
	}):Play()
	Notifications:sortNotifications()

	coroutine.wrap(function()
		task.wait(duration)
		Notifications:popNotificationInstance(table.find(Notifications.stack, notification) :: number or 1)
	end)()
end


return Notifications
