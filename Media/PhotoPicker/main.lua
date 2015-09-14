-- Abstract: Photo Library sample app
-- 
-- Demonstrates how to display pick and display a photo from the photo library.
--
-- Update History:
-- 	v1.0	12/1/11		Initial program
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

display.setStatusBar( display.HiddenStatusBar ) 

local photo		-- holds the photo object
local PHOTO_FUNCTION = media.PhotoLibrary 		-- or media.SavedPhotosAlbum

-- Camera not supported on simulator.                    
local isXcodeSimulator = "iPhone Simulator" == system.getInfo("model")
if (isXcodeSimulator) then
	 local alert = native.showAlert( "Information", "No Photo Library available on iOS Simulator.", { "OK"})    
end
--

print( "display.contentScale x,y: " .. display.contentScaleX, display.contentScaleY )

local bkgd = display.newRect( centerX, centerY, _W, _H )
bkgd:setFillColor( 0.5, 0, 0 )

local text = display.newText( "Tap to launch Photo Picker", centerX, centerY, nil, 16 )
text:setFillColor( 1, 1, 1 )

-- Media listener
-- Executes after the user picks a photo (or cancels)
--
local sessionComplete = function(event)
	photo = event.target
	
	if photo then

		if photo.width > photo.height then
			photo:rotate( -90 )			-- rotate for landscape
			print( "Rotated" )
		end
		
		-- Scale image to fit content scaled screen
		local xScale = _W / photo.contentWidth
		local yScale = _H / photo.contentHeight
		local scale = math.max( xScale, yScale ) * .75
		photo:scale( scale, scale )
		photo.x = centerX
		photo.y = centerY
		print( "photo w,h = " .. photo.width .. "," .. photo.height, xScale, yScale, scale )

	else
		text.text = "No Image Selected"
		text.x = display.contentCenterX
		text.y = display.contentCenterY
		print( "No Image Selected" )
	end
end

-- Screen tap comes here to launch Photo Picker
--
local tapListener = function( event )
	display.remove( photo )		-- remove the previous photo object
	text.text = "Select a picture ..."
	text.x = centerX
	text.y = centerY
	
	-- Delay some to allow the display to refresh before calling the Photo Picker
	timer.performWithDelay( 100, function() media.selectPhoto( { listener = sessionComplete, mediaSource = PHOTO_FUNCTION } ) 
	end )
	return true
end

bkgd:addEventListener( "tap", tapListener )
