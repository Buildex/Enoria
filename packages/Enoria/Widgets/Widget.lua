local Widget = {}
Widget.__index = Widget

function Widget.new(options, theme, context)
	local self = {}
	setmetatable(self, Widget)
	
	self.Options = options or {}
	
	self.StateInitiated = false
	self.Context = context
	
	if context.Theme == nil then
		self.Theme = {}
	else
		self.Theme = context.Theme[theme]
	end
	
	self.DefaultTheme = context.DefaultTheme[theme]
	
	return self
end

function Widget:BuildTree(tree)
	local folder = Instance.new("Frame")
	folder.Name = "_"
	self.Folder = folder
	tree.Parent = folder.Parent
	self.CurrentTree = tree
	
	return tree
end

function Widget:SetState(fnc)
	self.StateInitiated = true
	fnc()
	local parent = self.CurrentTree.Parent
	self.Folder:Destroy()
	self.CurrentTree:Destroy()
	local element = self:Build(self.Context)
	element.Parent = parent
end

function Widget:SetPropertyFromOptionsOrTheme(element, propertyName, options, theme, defaultTheme)
	theme = theme or self.Theme
	if theme == nil then theme = {} end
	defaultTheme = defaultTheme or self.DefaultTheme
	
	if element[propertyName] == true or element[propertyName] == false then
		if options[propertyName] ~= nil then
			element[propertyName] = options[propertyName] 
		elseif theme[propertyName] ~= nil then
			element[propertyName] = theme[propertyName]
		else
			element[propertyName] = defaultTheme[propertyName]
		end
	else
		if options[propertyName] ~= nil then
			element[propertyName] = options[propertyName]
		elseif theme[propertyName] ~= nil then
			element[propertyName] = theme[propertyName]
		else
			element[propertyName] = defaultTheme[propertyName]
		end
	end
end

function Widget:DoWithOptionsOrTheme(options, theme, key, doFunction)
	if options[key] ~= nil then
		doFunction(options)
	else
		if theme ~= nil then
			if theme[key] ~=nil then
				doFunction(theme)
			end
		end
	end
end

function Widget:SetBaseGuiProperties(element)
	local Theme = self.Theme
	
	local options = self.Options

	if options.Class then
		Theme = self.Context.Classes[options.Class]
	end
	
	self:SetPropertyFromOptionsOrTheme(element, "Active", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "Visible", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "AnchorPoint", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "AutomaticSize", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "BackgroundColor3", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "BackgroundTransparency", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "BorderColor3", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "BorderMode", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "BorderSizePixel", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "LayoutOrder", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "NextSelectionDown", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "NextSelectionLeft", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "NextSelectionRight", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "NextSelectionUp", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "Selectable", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "Size", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "SizeConstraint", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ClipsDescendants", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "Position", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "Rotation", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "SelectionImageObject", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ZIndex", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "AutoLocalize", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "RootLocalizationTable", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "Archivable", options, Theme, self.DefaultTheme)
	
	self:DoWithOptionsOrTheme(options, Theme, "Name", function(obj)
		element.Name = obj.Name
	end)

	self:DoWithOptionsOrTheme(options, Theme, "UIGradient", function(obj)
		local gradient = Instance.new("UIGradient")
		gradient.Parent = element

		local white = Color3.new(1, 1, 1)
		local lightBlue = Color3.new(0, 2/3, 1)
		local yellow = Color3.new(1, 1, 0)
		gradient.Color = obj.UIGradient.Color or ColorSequence.new{
			ColorSequenceKeypoint.new(0, white),
			ColorSequenceKeypoint.new(0.25, lightBlue),
			ColorSequenceKeypoint.new(0.5, white),
			ColorSequenceKeypoint.new(0.75, yellow),
			ColorSequenceKeypoint.new(1, white)
		}
		gradient.Enabled = obj.UIGradient.Enabled or true
		gradient.Offset = obj.UIGradient.Offset or Vector2.new(0, 0)
		gradient.Rotation = obj.UIGradient.Rotation or 0
		gradient.Transparency = obj.UIGradient.Transparency or NumberSequence.new{
			NumberSequenceKeypoint.new(0, 0), -- (time, value)
			NumberSequenceKeypoint.new(.5, .75),
			NumberSequenceKeypoint.new(1, 1)
		}
	end)

	self:DoWithOptionsOrTheme(options, Theme, "UIPadding", function(obj)
		local padding = Instance.new("UIPadding")
		padding.Parent = element

		padding.PaddingBottom = obj.UIPadding.Bottom or UDim.new(0, 0)
		padding.PaddingLeft = obj.UIPadding.Left or UDim.new(0, 0)
		padding.PaddingRight = obj.UIPadding.Right or UDim.new(0, 0)
		padding.PaddingTop = obj.UIPadding.Top or UDim.new(0, 0)

		if obj.UIPadding.All then
			padding.PaddingBottom = obj.UIPadding.All
			padding.PaddingLeft = obj.UIPadding.All
			padding.PaddingRight = obj.UIPadding.All
			padding.PaddingTop = obj.UIPadding.All
		end

		if obj.UIPadding.Vertical then
			padding.PaddingBottom = obj.UIPadding.Vertical
			padding.PaddingTop = obj.UIPadding.Vertical
		end

		if obj.UIPadding.Horizontal then
			padding.PaddingLeft = obj.UIPadding.Horizontal
			padding.PaddingRight = obj.UIPadding.Horizontal
		end
	end)

	self:DoWithOptionsOrTheme(options, Theme, "UIAspectRatioConstraint", function(obj)
		local constraint = Instance.new("UIAspectRatioConstraint")
		constraint.Parent = element
		
		constraint.AspectRatio = obj.UIAspectRatioConstraint.AspectRatio or 1
		constraint.AspectType = obj.UIAspectRatioConstraint.ApectType or Enum.AspectType.FitWithinMaxSize
		constraint.DominantAxis = obj.UIAspectRatioConstraint.DominantAxis or Enum.DominantAxis.Width
	end)

	self:DoWithOptionsOrTheme(options, Theme, "Centered", function(obj)
		element.Position = UDim2.new(0.5, 0, 0.5, 0)
		element.AnchorPoint = Vector2.new(0.5, 0.5)
	end)

	self:DoWithOptionsOrTheme(options, Theme, "CenteredVertically", function(obj)
		element.Position = UDim2.fromScale(element.Position.X.Scale, 0.5)
		element.AnchorPoint = Vector2.new(0, 0.5)
	end)

	self:DoWithOptionsOrTheme(options, Theme, "CenteredHorizontally", function(obj)
		element.Position = UDim2.fromScale(0.5, element.Position.Y.Scale)
		element.AnchorPoint = Vector2.new(0.5, 0)
	end)

	self:DoWithOptionsOrTheme(options, Theme, "UICorner", function(obj)
		local corner = Instance.new("UICorner", element)
		corner.CornerRadius = obj.UICorner.CornerRadius or UDim.new(0, 8)
	end)
end

function Widget:SetBaseGuiEvents(element)
	local options = self.Options

	element.InputBegan:Connect(options.OnInputBegan or function()end)
	element.InputChanged:Connect(options.OnInputChanged or function()end)
	element.InputEnded:Connect(options.OnInputEnded or function()end)
	element.MouseEnter:Connect(options.OnMouseEnter or function()end)
	element.MouseLeave:Connect(options.OnMouseLeave or function()end)
	element.MouseMoved:Connect(options.OnMouseMoved or function()end)
	element.MouseWheelBackward:Connect(options.OnMouseWheelBackward or function()end)
	element.MouseWheelForward:Connect(options.OnMouseWheelForward or function()end)
	element.SelectionGained:Connect(options.OnSelectionGained or function()end)
	element.SelectionLost:Connect(options.OnSelectionLost or function()end)
	element.TouchLongPress:Connect(options.OnTouchLongPress or function()end)
	element.TouchPan:Connect(options.OnTouchPan or function()end)
	element.TouchPinch:Connect(options.OnTouchPinch or function()end)
	element.TouchRotate:Connect(options.OnTouchRotate or function()end)
	element.TouchSwipe:Connect(options.OnTouchSwipe or function()end)
	element.TouchTap:Connect(options.OnTouchTap or function()end)
	element.AncestryChanged:Connect(options.OnAncestryChanged or function()end)
	element.AttributeChanged:Connect(options.OnAttributeChanged or function()end)
	element.Changed:Connect(options.OnChanged or function()end)
	element.ChildAdded:Connect(options.OnChildAdded or function()end)
	element.ChildRemoved:Connect(options.OnChildRemoved or function()end)
	element.DescendantAdded:Connect(options.OnDescendantAdded or function()end)
	element.DescendantRemoving:Connect(options.OnDescendantRemoving or function()end)
end

function Widget:SetButtonGuiEvents(element)
	local options = self.Options
	
	element.MouseButton1Click:Connect(options.OnClick or function()end)
	element.MouseButton1Down:Connect(options.OnClickDown or function()end)
	element.MouseButton1Up:Connect(options.OnClickUp or function()end)
	element.MouseButton2Click:Connect(options.OnRightClick or function()end)
	element.MouseButton2Down:Connect(options.OnRightClickDown or function()end)
end

function Widget:SetTextGuiProperties(element)
	local options = self.Options
	local Theme = self.Theme
	
	if Theme == nil then Theme = {} end

	if options.Class then
		Theme = self.Context.Classes[options.Class]
	end

	self:SetPropertyFromOptionsOrTheme(element, "Font", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "LineHeight", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "RichText", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "TextColor3", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "TextScaled", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "TextSize", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "TextStrokeColor3", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "TextStrokeTransparency", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "TextTransparency", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "TextTruncate", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "TextWrapped", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "TextXAlignment", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
	self:SetPropertyFromOptionsOrTheme(element, "TextYAlignment", options, Theme.TextTheme, self.DefaultTheme.TextTheme)
end

function Widget:SetImageButtonGuiProperties(element)
	local options = self.Options
	local Theme = self.Theme

	if options.Class then
		Theme = self.Context.Classes[options.Class]
	end
	
	self:SetPropertyFromOptionsOrTheme(element, "HoverImage", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "PressedImage", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ImageColor3", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ImageRectSize", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ImageTransparency", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ScaleType", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "SliceScale", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ImageRectOffset", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "SliceCenter", options, Theme, self.DefaultTheme)
	
	self:SetButtonGuiEvents(element)
end

function Widget:SetImageLabelGuiProperties(element)
	local options = self.Options
	local Theme = self.Theme

	if options.Class then
		Theme = self.Context.Classes[options.Class]
	end
	
	self:SetPropertyFromOptionsOrTheme(element, "ImageColor3", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ImageRectSize", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ImageTransparency", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ScaleType", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "SliceScale", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "SliceCenter", options, Theme, self.DefaultTheme)
end

function Widget:SetViewportGuiProperties(element)
	local options = self.Options
	local Theme = self.Theme

	if options.Class then
		Theme = self.Context.Classes[options.Class]
	end

	self:SetPropertyFromOptionsOrTheme(element, "Ambient", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "CurrentCamera", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ImageColor3", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "ImageTransparency", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "LightColor", options, Theme, self.DefaultTheme)
	self:SetPropertyFromOptionsOrTheme(element, "LightDirection", options, Theme, self.DefaultTheme)
end

return Widget
