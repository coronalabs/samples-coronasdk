
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

local controlButtons = { "left", "right", "up", "down", "fire", "start" }
local tableObjects = {
	labels = { "move left", "move right", "move up", "move down", "fire", "start game" },
	rects = {},
	valuesObjects = {}
}
local titleText
local currentInputIndex = 1
local deviceNameText


local function updateControlHighlight( )
	-- Highlight current selection box in red
	if currentInputIndex <= #tableObjects["rects"] and currentInputIndex>0 then
		tableObjects["rects"][currentInputIndex]:setFillColor( 0.8, 0.2, 0.2 )
	end
end


-- Process the just-pressed key/button/axis
local function processKey( keyName )

	local device = composer.getVariable( "userDevice" )

	-- Do not allow users to set the mediaPause button to the fire button.
	if controlButtons[i] == "fire" and keyName == "mediaPause" then
		titleText.alpha = 1
		titleText.text = "invalid fire button"
		titleText:setFillColor( 0.8, 0.2, 0.2 )
		transition.to( titleText, { time=280, delay=1500, alpha=0, transition=easing.outQuad } )
		return false
	end

	if currentInputIndex > 0 then
		local controls = composer.getVariable( "controls" )

		-- Prevent duplicate key selection
		-- Fail if the key has currently been selected
		local keyExists = false
		for i = 1,currentInputIndex-1 do
			if controls[device][controlButtons[i]] == keyName then
				keyExists = true
			end
		end

		-- If fail case, show alert message and return
		if keyExists then
			titleText.alpha = 1
			titleText.text = "control already selected"
			titleText:setFillColor( 0.8, 0.2, 0.2 )
			transition.to( titleText, { time=280, delay=1500, alpha=0, transition=easing.outQuad } )
			return false
		end

		-- Set key to current control
		controls[device][controlButtons[currentInputIndex]] = keyName
		tableObjects["rects"][currentInputIndex]:setFillColor( 0.4 )
		tableObjects["valuesObjects"][currentInputIndex].text = keyName

		-- Increment selection index row and update text value
		local newInputIndex = currentInputIndex + 1
		currentInputIndex = 0
		updateControlHighlight(  )
		timer.performWithDelay( 300, function (  )
			currentInputIndex = newInputIndex
			updateControlHighlight( )
		end )
	end

	return true
end


local function onKeyEvent( event )
	if event.phase ~= "up" then
		return false
	end

	if  event.keyName == "back" then
		return true
	end

	local getEventDevice = composer.getVariable( "getEventDevice" )
	local device = composer.getVariable( "userDevice" )

	if currentInputIndex > #controlButtons then
		composer.setVariable( "userDevice", nil )
		print( require("json").encode(composer.getVariable( "controls" )) )
		composer.gotoScene( "main-menu", { effect="slideUp", time=600 } )
		return false
	end		

	if getEventDevice(event) ~= device then
		return false
	end

	return processKey( event.keyName )
end


local function onAxisEvent( event )
	local getEventDevice = composer.getVariable( "getEventDevice" )
	local device = composer.getVariable( "userDevice" )

	if getEventDevice(event) ~= device or math.abs( event.normalizedValue ) < math.max( event.axis.accuracy, 0.6 ) then
		return
	end

	if currentInputIndex > #controlButtons then
		composer.setVariable( "userDevice", nil )
		composer.gotoScene( "main-menu", { effect="slideUp", time=600 } )
		return
	end


	if event.normalizedValue > 0 then
		processKey( event.axis.type .. "+" )
	else
		processKey( event.axis.type .. "-" )
	end
end


function scene:create( event )

	local sceneGroup = self.view
	local setupGroup = display.newGroup()

	-- Title/message text
	titleText = display.newText{
		parent = sceneGroup,
		x = display.contentCenterX,
		y = 60,
		text = "",
		font = composer.getVariable("appFont"),
		fontSize = 15
	}

	-- Layout control selection UI
	local device = composer.getVariable( "userDevice" )
	local controls = composer.getVariable( "controls" )

	local topRect = display.newRect( setupGroup, 101, 60, 322, 27 )
		topRect:setFillColor( 0.52 )
	deviceNameText = display.newText( setupGroup, controls[device].name, topRect.x, topRect.y, composer.getVariable("appFont"), 14 )
		
	for i = 1,#tableObjects["labels"] do
		local controlRectLeft = display.newRect( setupGroup, 0, 60+(i*29), 120, 27 )
		controlRectLeft:setFillColor( 0.32 )
		local controlLabel = display.newText( setupGroup, tableObjects["labels"][i], controlRectLeft.x+50, controlRectLeft.y, composer.getVariable("appFont"), 15 )
		controlLabel:setFillColor( 0.9 )
		controlLabel.anchorX = 1
		local controlRectRight = display.newRect( setupGroup, 62, 60+(i*29), 200, 27 )
		tableObjects["rects"][i] = controlRectRight
		controlRectRight.anchorX = 0
		controlRectRight:setFillColor( 0.4 )
		local currentSetting = controls[device][controlButtons[i]] or ""
		local controlValue = display.newText( setupGroup, currentSetting, controlRectRight.x+10, controlRectRight.y, composer.getVariable("appFont"), 15 )
		tableObjects["valuesObjects"][i] = controlValue
		controlValue.anchorX = 0
	end
	sceneGroup:insert( setupGroup )
	setupGroup.anchorChildren = true
	setupGroup.x, setupGroup.y = display.contentCenterX, display.contentCenterY+24
end


function scene:show( event )

	if event.phase == "did" then
		Runtime:addEventListener( "axis", onAxisEvent )
		Runtime:addEventListener( "key", onKeyEvent )
	elseif event.phase == "will" then
		local device = composer.getVariable( "userDevice" )
		local controls = composer.getVariable( "controls" )

		deviceNameText.text = controls[device].name

		for i = 1,#tableObjects["labels"] do
			local currentSetting = controls[device][controlButtons[i]] or ""
			tableObjects["valuesObjects"][i].text = currentSetting
		end

		currentInputIndex = 1
		updateControlHighlight()
	end
end


function scene:hide( event )

	if event.phase == "will" then
		Runtime:removeEventListener( "axis", onAxisEvent )
		Runtime:removeEventListener( "key", onKeyEvent )
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
