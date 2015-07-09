
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()


local function selectDevice(device, displayName)
	composer.setVariable( "userDevice", device )
	local controls = composer.getVariable( "controls" )
	if controls[device] == nil then
		controls[device] = {name=displayName}
	end
	composer.gotoScene( "setup-player", { effect="crossFade", time=200 } )
end

local function onKeyEvent( event )
	selectDevice(getEventDevice(event), getNiceDeviceName(event))
end

local function onAxisEvent( event )
	if math.abs( event.normalizedValue ) > ( event.axis.accuracy or 0.5 ) then
		selectDevice(getEventDevice(event), getNiceDeviceName(event))
	end
end


function scene:create( event )

   local sceneGroup = self.view

   -- Settings button
   display.newText{
   		parent = sceneGroup,
		x = display.contentCenterX,
		y = display.contentCenterY,
		text = "Use controls on the keyboard or gamepad to configure device.",
		fontSize = 17,
   }

end

function scene:show( event )

   local sceneGroup = self.view

	Runtime:addEventListener( "axis", onAxisEvent )
	Runtime:addEventListener( "key", onKeyEvent )
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
