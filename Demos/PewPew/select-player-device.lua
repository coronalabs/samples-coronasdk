
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

local spinner


local function selectDevice( device, displayName )
	composer.setVariable( "userDevice", device )
	local controls = composer.getVariable( "controls" )
	if controls[device] == nil then
		controls[device] = {name=displayName}
	end
	composer.gotoScene( "setup-player", { effect="slideDown", time=600 } )
end


local function onKeyEvent( event )
	if event.keyName == "back" or event.keyName == "menu" then
		composer.setVariable( "userDevice", nil )
		composer.gotoScene( "main-menu", { effect="slideUp", time=600 } )
		return true
	end

	local getEventDevice = composer.getVariable( "getEventDevice" )
	local getNiceDeviceName = composer.getVariable( "getNiceDeviceName" )
	selectDevice( getEventDevice(event), getNiceDeviceName(event) )

	return true
end


local function onAxisEvent( event )
	if math.abs( event.normalizedValue ) > ( event.axis.accuracy or 0.5 ) then
		local getEventDevice = composer.getVariable( "getEventDevice" )
		local getNiceDeviceName = composer.getVariable( "getNiceDeviceName" )
		selectDevice( getEventDevice(event), getNiceDeviceName(event) )
	end
end


function scene:create( event )

	local sceneGroup = self.view

	display.newText{
		parent = sceneGroup,
		x = display.contentCenterX,
		y = display.contentCenterY-60,
		text = "(manipulate the keyboard/gamepad to configure)",
		font = composer.getVariable("appFont"),
		fontSize = 17
	}

	if ( system.getInfo( "platform" ) ~= "tvos" ) then
		spinner = widget.newSpinner{
			x = display.contentCenterX,
			y = display.contentCenterY,
			deltaAngle = 10,
			incrementEvery = 10
		}
		sceneGroup:insert( spinner )
	end
end


function scene:show( event )

	if event.phase == "did" then
		Runtime:addEventListener( "axis", onAxisEvent )
		Runtime:addEventListener( "key", onKeyEvent )
	elseif event.phase == "will" then
		if ( spinner ) then 
			spinner:start()
		end
	end
end


function scene:hide( event )

	if event.phase == "will" then
		Runtime:removeEventListener( "axis", onAxisEvent )
		Runtime:removeEventListener( "key", onKeyEvent )
	elseif event.phase == "did" then
		if ( spinner ) then
			spinner:stop()
		end
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
