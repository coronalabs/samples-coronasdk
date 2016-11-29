-- Abstract: Gyroscope Sample
--
-- Date: July 6, 2011
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: 
-- 		Demonstrates use of the gyroscope.
--		Controls panoramic view of a room using motion controls.
--
-- File dependencies: none
--
-- Target devices: iPhone and Android
--
-- Limitations: Does not work on all platforms
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

-- Require the widget library
local widget = require( "widget" )

local topLeft = {
	x = (display.contentWidth - display.viewableContentWidth) / 2, 
	y = (display.contentHeight - display.viewableContentHeight) / 2}

local pictureGroup = display.newGroup()

function main()
	display.setStatusBar( display.HiddenStatusBar )	

	initPanoramaPicture()
	initResetButton()
	initGyroscope()
end

function initPanoramaPicture()
	local imageWidth = 1000
	local imageHeight = 653

	for i = -2, 1 do
	
		local image
		image = display.newImageRect( "picture" .. (i + 3) .. ".jpg", imageWidth, imageHeight)
		image.x = i * imageWidth + imageWidth / 2
		
		pictureGroup:insert(image)
	end
	
	pictureGroup.x = display.contentWidth / 2
	pictureGroup.y = display.contentHeight / 2
	
end

function initResetButton()
	
	local function resetPicture()
		pictureGroup.x = display.contentWidth / 2
		pictureGroup.y = display.contentHeight / 2
	end
	
	-- Create a simple reset button that reset the picture to the center
	local resetButton = widget.newButton
	{ 
		defaultFile = "resetButton.png", 
		onRelease = resetPicture
	}
	local padding = 5
	resetButton.x = topLeft.x + display.viewableContentWidth - resetButton.width / 2 - padding
	resetButton.y = topLeft.y + display.viewableContentHeight - resetButton.height / 2 - padding
	
end

function initGyroscope()

	-- Add gyroscope listeners, but only if the device has a gyroscope, else display a message 
	if system.hasEventSource("gyroscope") then
		Runtime:addEventListener("gyroscope", onGyroscopeUpdate)
	else
		--
		-- Note that the current platform does not support gyroscope events
		--
		local msg = display.newText( "Gyroscope events not supported on this device", 0, 55, native.systemFontBold, 13 )
		msg.x = display.contentWidth / 2
		msg:setFillColor( 1, 0, 0 )
	end
	
end

function onGyroscopeUpdate( event )

	local horizontalMovementScale = 12
	local verticalMovementScale = 4

	local deltaRadiansX = event.xRotation * event.deltaTime
	local deltaDegreesX = deltaRadiansX * (180 / math.pi)
	
	local deltaRadiansY = event.yRotation * event.deltaTime
	local deltaDegreesY = deltaRadiansY * (180 / math.pi)
	
	if(math.abs(deltaDegreesX) > 0.05) then
		pictureGroup.x = pictureGroup.x + deltaDegreesX * horizontalMovementScale
		
		-- Set the left bounds for the piture
		if(pictureGroup.x - pictureGroup.width / 2 > 0) then pictureGroup.x = pictureGroup.width / 2 end
		
		-- Set the right bounds for the piture
		if(pictureGroup.x  + pictureGroup.width /2 < display.contentWidth) then pictureGroup.x = display.contentWidth - pictureGroup.width /2 end

	end
	
	if(math.abs(deltaDegreesY) > 0.05) then
		pictureGroup.y = pictureGroup.y - deltaDegreesY * verticalMovementScale
		
		-- Set the the top bounds for the picture
		if(pictureGroup.y - pictureGroup.height / 2 > 0) then pictureGroup.y =pictureGroup.height / 2 end 

		-- Set the the bottom bounds for the picture		
		if(pictureGroup.y  < 0) then pictureGroup.y = 0 end 
	end
	
end

main()
