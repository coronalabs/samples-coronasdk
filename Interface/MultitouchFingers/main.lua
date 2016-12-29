-- Abstract: Follow Me 2 (touch event) sample app
-- 
-- Version: 1.1
-- Modified by Tom Newman to show touches outside of the 3 button objects.
--
-- Modified by Tom Newman to display a circle when an area is touched outside
-- one of the objects. Multiple touches will display multiple circles where touched.
-- The circles will fade in and then disapear.
-- 
-- Modified by Joshua Quick to check for multitouch support via system.hasEventSource().
-- 
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

-- Demonstrates how to use create draggable objects. Also shows how to move
-- an object to the top.
--
-- Supports Graphics 2.0
------------------------------------------------------------

system.activate( "multitouch" )

local arguments =
{
	{ x=100, y=60, w=100, h=100, r=10, red=1, green=0, blue=0.5 },
	{ x=60, y=100, w=100, h=100, r=10, red=0, green=0.5, blue=1 },
	{ x=140, y=140, w=100, h=100, r=10, red=1, green=1, blue=0 }
}

local function printTouch( event )
 	if event.target then 
 		local bounds = event.target.contentBounds
		print( "event(" .. event.phase .. ") ("..event.x..","..event.y..") bounds: "..bounds.xMin..","..bounds.yMin..","..bounds.xMax..","..bounds.yMax )
	end 
end


-- Display the Event info on the screen
local function showEvent( event )
	txtPhase.text = "Phase: " .. event.phase
	txtXY.text = "(" .. string.format("%0.1f", event.x) .. "," .. string.format("%0.1f", event.y) .. ")"
	txtId.text = "Id: " .. tostring( event.id )
end

local function onTouch( event )
	local t = event.target
	showEvent( event )
	
	print ("onTouch - event: " .. tostring(event.target), event.phase, event.target.x, tostring(event.id) )

	-- Print info about the event. For actual production code, you should
	-- not call this function because it wastes CPU resources.
	printTouch(event)

	local phase = event.phase
	if "began" == phase then
		-- Make target the top-most object
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t, event.id )

		-- **tjn: I don't this this comment applies in Beta 6 Multitouch
		-- I also don't think we need t.isFocus.
		--
		-- Spurious events can be sent to the target, e.g. the user presses 
		-- elsewhere on the screen and then moves the finger over the target.
		-- To prevent this, we add this flag. Only when it's true will "move"
		-- events be sent to the target.
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
			t.x = event.x - t.x0
			t.y = event.y - t.y0
		elseif "ended" == phase or "cancelled" == phase then
			if not(nil == t.id) then
--				print("Removing object from stage")
				t:removeSelf()
			else
				display.getCurrentStage():setFocus( t, nil )
				t.isFocus = false
			end
		end
	end

	-- Important to return true. This tells the system that the event
	-- should not be propagated to listeners of any objects underneath.
	return true
end

-- Iterate through arguments array and create rounded rects (vector objects) for each item
for _,item in ipairs( arguments ) do
	local button = display.newRoundedRect( item.x, item.y, item.w, item.h, item.r )
	button:setFillColor( item.red, item.green, item.blue )
	button.strokeWidth = 6
	button:setStrokeColor( 200/255, 200/255, 200/255 )

	-- Make the button instance respond to touch events
	button:addEventListener( "touch", onTouch )
end

-- listener used by Runtime object. This gets called if no other display object
-- intercepts the event.
--
-- Create a circle where the user touched the screen.
-- Multiple touches will generate multiple circles
-- Moving the object is handled in onTouch()
local function otherTouch( event )
	
	print( "otherTouch: event(" .. event.phase .. ") ("..event.x..","..event.y..")" .. tostring(event.id) )
	local s = display.getCurrentStage() 
					
	if "began" == event.phase then
		showEvent( event )

--		print("Found otherTouch -- began", display.getCurrentStage())
		local circle = display.newCircle(event.x, event.y, 45)
		circle:setFillColor(  0, 0, 255, 255 )		-- start with Alpha = 0
		
		-- Store initial position
		circle.x0 = event.x - circle.x
		circle.y0 = event.y - circle.y
		circle.isFocus = true		-- **tbr - remove later
		touchCircle = circle		-- **tbr - temp
		circle.id = event.id		-- save our id so we can access the object later
--		print( "new circle:", tostring(circle) ); print()

		circle:addEventListener( "touch", onTouch )
		event.target = circle
		onTouch( event )
	end	
end

-- Define text areas on the screen
txtPhase = display.newText( "Phase: _____", 55, 450, native.systemFontBold, 12 )

txtXY = display.newText( "(___,___)", 55, 465, native.systemFontBold, 12 )

txtId = display.newText( "Id: ______", 225, 450, native.systemFontBold, 12 )

Runtime:addEventListener( "touch", otherTouch )
--	Runtime:addEventListener( "touch", printTouch2 )	-- **tjn No longer used                  

-- Determine if multitouch is supported
--
if not system.hasEventSource("multitouch") then
	msg = display.newText( "Multitouch not supported on this device!", display.contentCenterX, 400, native.systemFontBold, 14 )
	msg:setFillColor( 1 ,1, 0 )
end
