-- 
-- Abstract: Digital clock, with reformatted UI for different orientations
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local clock = display.newGroup()

local background = display.newImage( "purple.png", 160, 240 )
clock:insert( background )

-- Create dynamic textfields
-- Note: these are iOS/MacOS fonts. If building for Android, choose available system fonts, 
-- or use native.systemFont / native.systemFontBold

local hourField = display.newText( clock, "", 100, 90, native.systemFontBold, 180 )
hourField:setFillColor( 1, 1, 1, 70/255 )
hourField.rotation = -15

local minuteField = display.newText( clock, "", 100, 240, native.systemFontBold, 180 )
minuteField:setFillColor( 1, 1, 1, 70/255 )
minuteField.rotation = -15

local secondField = display.newText( clock, "", 100, 390, native.systemFontBold, 180 )
secondField:setFillColor( 1, 1, 1, 70/255 )
secondField.rotation = -15

-- Create captions
local hourLabel = display.newText( clock, "hours ", 220, 100, native.systemFont, 40 )
hourLabel:setFillColor( 131/255, 1, 131/255 )

local minuteLabel = display.newText( clock, "minutes ", 220, 250, native.systemFont, 40 )
minuteLabel:setFillColor( 131/255, 1, 131/255 )

local secondLabel = display.newText( clock, "seconds ", 210, 400, native.systemFont, 40 )
secondLabel:setFillColor( 131/255, 1, 131/255 )

-- Set the rotation point to the center of the screen
clock.anchorChildren = true 
clock.x, clock.y = display.contentCenterX, display.contentCenterY
 
local function updateTime()
	local time = os.date("*t")
	
	local hourText = time.hour
	if (hourText < 10) then hourText = "0" .. hourText end
	hourField.text = hourText
	
	local minuteText = time.min
	if (minuteText < 10) then minuteText = "0" .. minuteText end
	minuteField.text = minuteText
	
	local secondText = time.sec
	if (secondText < 10) then secondText = "0" .. secondText end
	secondField.text = secondText
end

updateTime() -- run once on startup, so correct time displays immediately


-- Update the clock once per second
local clockTimer = timer.performWithDelay( 1000, updateTime, -1 )


-- Use accelerometer to rotate display automatically
local function onOrientationChange( event )

print( clock.anchorX, clock.anchorY, clock.x, clock.y )
	-- Adapt text layout to current orientation	
	local direction = event.type

	if ( direction == "landscapeLeft" or direction == "landscapeRight" ) then
		hourField.y = 120
		secondField.y = 360
		hourLabel.y = 130
		secondLabel.y = 370
	elseif ( direction == "portrait" or direction == "portraitUpsideDown" ) then
		hourField.y = 90
		secondField.y = 390
		hourLabel.y = 100
		secondLabel.y = 400
	end

	-- Rotate clock so it remains upright
	local newAngle = clock.rotation - event.delta
	transition.to( clock, { time=150, rotation=newAngle } )	

end

Runtime:addEventListener( "orientation", onOrientationChange )