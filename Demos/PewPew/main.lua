
display.setStatusBar( display.HiddenStatusBar )

local widget = require( "widget" )
local composer = require("composer")
local json = require("json")
local presetControls = require('presetControls')


--global
getEventDevice = function(event)
	return event.device and event.device.descriptor or "Keyboard"
end

getNiceDeviceName = function (event)
	if event.device then
		return event.device.displayName
	else
		return "Keyboard"
	end
end

-- Load preset controller file.
local controls = {}

if ( system.getInfo( "environment" ) == "simulator" or system.getInfo( "platformName" ) == "OSX" or system.getInfo( "platformName" ) == "Mac OS X" ) then
	controls.Keyboard = presetControls.presetForKeyboard()
end

local inputDevices = system.getInputDevices()
for i = 1, #inputDevices do
	local device = inputDevices[i]
	controls[device.descriptor] = presetControls.presetForDevice(device)
end

composer.setVariable( "controls", controls )

composer.gotoScene( "main-menu" )