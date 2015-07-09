
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

local controlButtons = {"left", "right", "up", "down",  "fire", "start"}

local function UpdateText()
	local device = composer.getVariable( "userDevice" )
	local controls = composer.getVariable( "controls" )
	local ret = controls[device].name .. '\n'

	for a = 1,#controlButtons do
		ret = ret .. "\n" .. controlButtons[a] .. ' : '
		if composer.getVariable( "currentInputConfig" ) == a and controls[device][controlButtons[a]] ~= nil then
			ret = ret .. "<press button now> (" .. controls[device][controlButtons[a]] .. ")"
		elseif controls[device][controlButtons[a]] ~= nil then
			ret = ret .. controls[device][controlButtons[a]]
		elseif composer.getVariable( "currentInputConfig" ) == a then
			ret = ret .. "<press button now>"
		else
			ret = ret .. "..."
		end
	end

	if (composer.getVariable( "currentInputConfig" ) or 0) > #controlButtons then
		ret = ret .. '\n\nDone. Press any key to return to main menu.'
	end

	scene.statusText.text = ret
end

local function processKey(keyName)
	local ccf = composer.getVariable( "currentInputConfig" ) or 0
	local device = composer.getVariable( "userDevice" )

	if ccf>0 then
		local controls = composer.getVariable( "controls" )
		controls[device][controlButtons[ccf]] = keyName
		composer.setVariable( "currentInputConfig", 0 )
		UpdateText()
		timer.performWithDelay( 300, function ( )
			composer.setVariable( "currentInputConfig", ccf+1 )
			UpdateText()
		end)
	end
end

local function onKeyEvent( event )
	local ccf = composer.getVariable( "currentInputConfig" ) or 0
	local device = composer.getVariable( "userDevice" )

	if ccf > #controlButtons then
		composer.setVariable( "currentInputConfig" , 0) 
		composer.setVariable( "userDevice", nil )
		print( require("json").encode(composer.getVariable( "controls" )) )
		composer.gotoScene( "main-menu" )
	end		

	if not (event.phase == "down" and getEventDevice(event) == device) then
		return
	end
	processKey(event.keyName)
end

local function onAxisEvent( event )
	local device = composer.getVariable( "userDevice" )

	if not (getEventDevice(event) == device and math.abs( event.normalizedValue ) > ( event.axis.accuracy or 0.5 ) ) then
		return
	end

	local ccf = composer.getVariable( "currentInputConfig" ) or 0
	if ccf > #controlButtons then
		composer.setVariable( "currentInputConfig" , 0) 
		composer.setVariable( "userDevice", nil )
		composer.gotoScene( "main-menu" )
	end		


	if event.normalizedValue > 0 then
		processKey(event.axis.type .. "+")
	else
		processKey(event.axis.type .. "-")
	end

end


function scene:create( event )

	local sceneGroup = self.view

	-- Settings button
	display.newText{
		parent = sceneGroup,
		x = display.contentCenterX,
		y = 10,
		text = "Controller Setup",
		fontSize = 17,
	}

	self.statusText = display.newText{
		parent = sceneGroup,
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = display.contentWidth,
		text = "",
		align = "center",
		fontSize = 17,
	}

end

function scene:show( event )

	local sceneGroup = self.view

	UpdateText()

	Runtime:addEventListener( "axis", onAxisEvent )
	Runtime:addEventListener( "key", onKeyEvent )

	timer.performWithDelay( 300, function (  )
		composer.setVariable( "currentInputConfig", 1 )
		UpdateText()
	end)

end

function scene:hide( event )

	local sceneGroup = self.view

	Runtime:removeEventListener( "axis", onAxisEvent )
	Runtime:removeEventListener( "key", onKeyEvent )

end



scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
