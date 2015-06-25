-- 
-- Abstract: Drag Me Multitouch (drag multiple objects simultaneously)
-- 
-- Version: 1.3
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

-- Demonstrates how to use create draggable objects with multitouch. Also shows how to move
-- an object to the front of the display hierarchy.
--
-- Supports Graphics 2.0

system.activate( "multitouch" )

local arguments =
{
--	{ x=100, y=60, w=100, h=100, r=10, red=255/255, green=0/255, blue=128/255 },
--	{ x=60, y=100, w=100, h=100, r=10, red=0/255, green=128/255, blue=255/255 },
--	{ x=140, y=140, w=100, h=100, r=10, red=255/255, green=255/255, blue=0/255 }
	
	{ x=75, y=135, w=50, h=50, r=10, red=255/255, green=0/255, blue=128/255 },
	{ x=47, y=175, w=75, h=50, r=10, red=0/255, green=128/255, blue=255/255 },
	{ x=140, y=215, w=100, h=50, r=10, red=255/255, green=255/255, blue=0/255 }

--	{ x=50, y=110, w=50, h=50, r=10, red=255/255, green=0/255, blue=128/255 },
--	{ x=10, y=150, w=75, h=50, r=10, red=0/255, green=128/255, blue=255/255 },
--	{ x=90, y=190, w=100, h=50, r=10, red=255/255, green=255/255, blue=0/255 }
}

local eventInfoText1 = display.newText(" ", 100,300, native.systemFont, 12) 
eventInfoText1:setFillColor(100,255,255)
local eventInfoText2 = display.newText(" ", 100,320, native.systemFont, 12) 
eventInfoText2:setFillColor(100,255,255)

local function printTouch( event )
 	if event.target then 
 		local bounds = event.target.contentBounds
		print( "event(" .. event.phase .. ") ("..event.x..","..event.y..") bounds: "..bounds.xMin..","..bounds.yMin..","..bounds.xMax..","..bounds.yMax )
		eventInfoText1.x = event.x
		eventInfoText1.y = bounds.yMin - 30
		eventInfoText1.text = "event(" .. event.phase .. ") ("..event.x..","..event.y..")"
		eventInfoText2.x = event.x
		eventInfoText2.y = bounds.yMin - 10
		eventInfoText2.text = "bounds: "..bounds.xMin..","..bounds.yMin..","..bounds.xMax..","..bounds.yMax
	end 
end

local function onTouch( event )
	local t = event.target

	-- Print info about the event. For actual production code, you should
	-- not call this function because it wastes CPU resources.
	printTouch(event)

	local phase = event.phase
	if "began" == phase then
		-- Make target the top-most object
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t, event.id )

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
			display.getCurrentStage():setFocus( t, nil )
			t.isFocus = false
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
	button:setStrokeColor( 200,200,200,255 )

	-- Make the button instance respond to touch events
	button:addEventListener( "touch", onTouch )
end

-- listener used by Runtime object. This gets called if no other display object
-- intercepts the event.
local function printTouch2( event )
	print( "event(" .. event.phase .. ") ("..event.x..","..event.y..")" )
	eventInfoText1.x = event.x
	eventInfoText1.y = event.y
	eventInfoText1.text = "event(" .. event.phase .. ") ("..event.x..","..event.y..")"
	eventInfoText2.text = " "
end

Runtime:addEventListener( "touch", printTouch2 )
