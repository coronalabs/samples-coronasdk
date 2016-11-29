-- Abstract: Accelerometer sample
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: 
-- 		Demonstrates use of the accelerometer.
--		Displays accelerometer values on screen and moves objected based on values.
--		Beeps and displays message when Shake detected.
--
-- File dependencies: none
--
-- Target devices: iPhone and Android
--
-- Limitations: Accelerator doesn't work on every platform
--
-- Update History:
--	v1.1	Changed check from Simulator to system.hasEventSource( )
--	v1.2	Modified for landscape/portrait modes for tvOS (12/15/2015)
--
-- Comments: 
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2015 Corona Labs Inc. All Rights Reserved.
--
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )		-- hide status bar

display.setDefault( "background", 80/255 )

local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Displays App title
title = display.newText( "Accelerometer / Shake", centerX, 20, native.systemFontBold, 20 )
title:setFillColor( 1,1,0 )

--
-- Check if accelerator is supported on this platform
--
if not system.hasEventSource( "accelerometer" ) then
	msg = display.newText( "Accelerometer not supported on this device", centerX, 55, native.systemFontBold, 13 )
	msg:setFillColor( 1,1,0 )
end

local msg, box

if system.getInfo("environment") == "simulator" then
	local boxY = display.contentHeight - 40
	msg = display.newText( "Choose 'Shake' in the Hardware menu", centerX, boxY, native.systemFontBold, 13 )
	box = display.newRoundedRect( centerX, boxY, display.contentWidth - 20, 30, 6 )
	box:setFillColor( 0.5, 0.5, 0.5, 0.5 )
	msg.x = display.contentWidth / 2
	msg:setFillColor( 1, 0, 0 )
else

end

local soundID = audio.loadSound ("beep_wav.wav")

-----------------------------------------------------------
-- Create Text and Display Objects
-----------------------------------------------------------

-- Text parameters
local labelx = 50
local x = 220
local y = 80
local fontSize = 24

local frameUpdate = false					-- used to update our Text Color (once per frame)

display.setDefault( "anchorX", 0.0 )	-- default to TopLeft anchor point for new objects
display.setDefault( "anchorY", 0.0 )

local xglabel = display.newText( "gravity x = ", labelx, y, native.systemFont, fontSize ) 
xglabel:setFillColor(1,1,1)
local xg = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
xg:setFillColor(1,1,1)
y = y + 25
local yglabel = display.newText( "gravity y = ", labelx, y, native.systemFont, fontSize ) 
local yg = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
yglabel:setFillColor(1,1,1)
yg:setFillColor(1,1,1)
y = y + 25
local zglabel = display.newText( "gravity z = ", labelx, y, native.systemFont, fontSize ) 
local zg = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
zglabel:setFillColor(1,1,1)
zg:setFillColor(1,1,1)
y = y + 50
local xilabel = display.newText( "instant x = ", labelx, y, native.systemFont, fontSize ) 
local xi = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
xilabel:setFillColor(1,1,1)
xi:setFillColor(1,1,1)
y = y + 25
local yilabel = display.newText( "instant y = ", labelx, y, native.systemFont, fontSize ) 
local yi = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
yilabel:setFillColor(1,1,1)
yi:setFillColor(1,1,1)
y = y + 25
local zilabel = display.newText( "instant z = ", labelx, y, native.systemFont, fontSize ) 
local zi = display.newText( "0.0", x, y, native.systemFont, fontSize ) 
zilabel:setFillColor(1,1,1)
zi:setFillColor(1,1,1)

-- Create a circle that moves with Accelerator events (for visual effects)
--
Circle = display.newCircle(0, 0, 20)
Circle.x = centerX
Circle.y = centerY
Circle:setFillColor( 0, 0, 1 )		-- blue

display.setDefault( "anchorX", 0.5 )	-- restore anchor points for new objects to center anchor point
display.setDefault( "anchorY", 0.5 )

-----------------------------------------------------------
-- textMessage() --
-----------------------------------------------------------
-- v1.0
--
-- Create a message that is displayed for a few seconds.
-- Text is centered horizontally on the screen.
--
-- Enter:	str = text string
--			scrTime = time (in seconds) message stays on screen (0 = forever) -- defaults to 3 seconds
--			location = placement on the screen: "Top", "Middle", "Bottom" or number (y)
--			size = font size (defaults to 24)
--			color = font color (table) (defaults to white)
--
-- Returns:	text object (for removing or hiding later)
--
local textMessage = function( str, location, scrTime, size, color, font )

	local x, t
	
	size = tonumber(size) or 24
	color = color or {1, 1, 1}
	font = font or native.systemFont

	-- Determine where to position the text on the screen
	if "string" == type(location) then
		if "Top" == location then
			x = display.contentHeight/4
		elseif "Bottom" == location then
			x = (display.contentHeight/4)*3
		else
			-- Assume middle location
			x = display.contentHeight/2
		end
	else
		-- Assume it's a number -- default to Middle if not
		x = tonumber(location) or display.contentHeight/2
	end
	
	scrTime = (tonumber(scrTime) or 3) * 1000		-- default to 3 seconds (3000) if no time given

	t = display.newText(str, 0, 0, font, size )
	t.x = display.contentWidth/2
	t.y = x
	t:setFillColor( color[1], color[2], color[3] )
	
	-- Time of 0 = keeps on screen forever (unless removed by calling routine)
	--
	if scrTime ~= 0 then
	
		-- Function called after screen delay to fade out and remove text message object
		local textMsgTimerEnd = function()
			transition.to( t, {time = 500, alpha = 0}, 
				function() t.removeSelf() end )
		end
	
		-- Keep the message on the screen for the specified time delay
		timer.performWithDelay( scrTime, textMsgTimerEnd )
	end
	
	return t		-- return our text object in case it's needed
	
end	-- textMessage()
-----------------------------------------------------------


-----------------------------------------------------------
-- Hardware Events
-----------------------------------------------------------

-- Display the Accerator Values
--
-- Update the text color once a frame based on sign of the value
--
local function 	xyzFormat( obj, value)

	obj.text = string.format( "%1.3f", value )
	
	-- Exit if not time to update text color
	if not frameUpdate then return end
	
	if value < 0.0 then
		-- Only update the text color if the value has changed
		if obj.positive ~= false then 
			obj:setFillColor( 1, 0, 0 )		-- red if negative
			obj.positive = false
			print("[---]")
		end
	else

		if obj.positive ~= true then 
			obj:setFillColor( 1, 1, 1)		-- white if postive
			obj.positive = true
			print("+++")
		end

	end
end


-- event.xGravity is the acceleration due to gravity in the x-direction
-- event.yGravity
-- event.yGravity is the acceleration due to gravity in the y-direction
-- event.zGravity
-- event.zGravity is the acceleration due to gravity in the z-direction
-- event.xInstant
-- event.xInstant is the instantaneous acceleration in the x-direction
-- event.yInstant
-- event.yInstant is the instantaneous acceleration in the y-direction
-- event.zInstant
-- event.zInstant is the instantaneous acceleration in the z-direction
-- event.isShake
-- event.isShake is true when the user shakes the device

-- Called for Accelerator events
--
-- Update the display with new values
-- If shake detected, make sound and display message for a few seconds
--
local function onAccelerate( event )

	-- Format and display the Accelerator values
	--
	xyzFormat( xg, event.xGravity)
	xyzFormat( yg, event.yGravity)
	xyzFormat( zg, event.zGravity)
	xyzFormat( xi, event.xInstant)
	xyzFormat( yi, event.yInstant)	
	xyzFormat( zi, event.zInstant)	
	
	frameUpdate = false		-- update done 
	
	-- Move our object based on the accelerator values
	--
	Circle.x = centerX + (centerX * event.xGravity)
	Circle.y = centerY + (centerY * event.yGravity * -1)

	-- Display message and sound beep if Shake'n
	--
	if event.isShake == true then
		-- str, location, scrTime, size, color, font
		textMessage( "Shake!", 55, 3, 52, {1, 1, 0} )
		audio.play( soundID )
	end
end

-- Function called every frame
-- Sets update flag to time our color changes
--
local function onFrame()
	frameUpdate = true
	
--[[
	if xg.positive == true then
		xg:setFillColor( 1, 1, 1)	-- white if postive
	else
		xg:setFillColor( 1, 0, 0)		-- red if negative
	end
--]]
end

-- Set up the accelerometer to provide measurements 60 times per second.
-- Note that this matches the frame rate set in the "config.lua" file.
system.setAccelerometerInterval( 60 )

-----------------------------------------------------------------------
-- Change the orientation of the app here
--
-- Adjust objects for Portrait or Landscape mode
--
-- Enter: mode = orientation mode
-----------------------------------------------------------------------
--
function changeOrientation( mode ) 
	print( "changeOrientation ...", mode )

	centerX = display.contentCenterX		-- find new center of screen
	centerY = display.contentCenterY		-- find new center of screen

	title.x = centerX
	Circle.x = centerX
	Circle.y = centerY

	if msg then
		print( "found msg" )
		msg.x = centerX
		msg.y = display.contentHeight - 20
		box.x = centerX
		box.y = display.contentHeight - 20
	end

end

-----------------------------------------------------------------------
-- Come here on Resize Events
-- Display the Orientation Message on the screen
-----------------------------------------------------------------------
--
function onResizeEvent( event ) 
	print ("onResizeEvent: " .. event.name)
	changeOrientation( system.orientation )
end

-- Set up the display after the app starts
changeOrientation( system.orientation )

-- Add the Orientation callback event
Runtime:addEventListener( "resize", onResizeEvent )

-- Add runtime listeners
--
Runtime:addEventListener ("accelerometer", onAccelerate);
Runtime:addEventListener ("enterFrame", onFrame);
