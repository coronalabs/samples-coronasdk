-- 
-- Abstract: Drag Me Multitouch (drag multiple objects simultaneously)
-- 
-- Version: 1.3
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

-- Demonstrates how to use create draggable objects with multitouch. Also shows how to move
-- an object to the front of the display hierarchy.
--
-- Supports Graphics 2.0

if not system.hasEventSource( "multitouch" ) then
	local msg = display.newText( "Multitouch events not supported on this platform", 0, 20, native.systemFontBold, 13 )
	msg.x = display.contentWidth / 2
	msg:setFillColor( 1, 0, 0 )
else
	system.activate( "multitouch" )
end

local function getFormattedPressure( pressure )
	if pressure then
		return math.floor( pressure * 1000 + 0.5 ) / 1000
	end
	return "unsupported"
end

local arguments =
{
	{ x=75, y=135, w=50, h=50, r=10, red=1, green=0, blue=0 },
	{ x=47, y=175, w=75, h=50, r=10, red=0, green=1, blue=0 },
	{ x=140, y=215, w=100, h=50, r=10, red=0, green=0, blue=1 },
}

local touchText = {}

local function getTouchTextDisplay( touchId, index )
	local texts = touchText[touchId]
	if ( not texts ) then
		texts = {
			basics = display.newText(" ", 100, 300, native.systemFont, 12),
			bounds = display.newText(" ", 100, 320, native.systemFont, 12),
		}
		touchText[touchId] = texts
	end
	return texts[index]
end

local function printTouch( event )
 	if event.target then 
 		local bounds = event.target.contentBounds
 		local pressure = getFormattedPressure(event.pressure)

		print( event.name.."(" .. event.phase .. ") "..tostring(event.id).." ("..event.x..","..event.y..") bounds: "..bounds.xMin..","..bounds.yMin..","..bounds.xMax..","..bounds.yMax.."; pressure: "..pressure )

 		local dataText = getTouchTextDisplay( event.id, "basics" )
		dataText.x = event.x
		dataText.y = bounds.yMin - 30
		dataText.text = "event(" .. event.phase .. ") ("..event.x..","..event.y..")"
		if event.pressure then
			dataText.text = dataText.text .. " (" .. pressure .. ")"
		end

 		local boundsText = getTouchTextDisplay( event.id, "bounds" )
		boundsText.x = event.x
		boundsText.y = bounds.yMin - 10
		boundsText.text = "bounds: "..bounds.xMin..","..bounds.yMin..","..bounds.xMax..","..bounds.yMax
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
			
			-- Gradually show the shape's stroke depending on how much pressure is applied.
			if ( event.pressure ) then
				t:setStrokeColor( 1, 1, 1, event.pressure )
			end
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( t, nil )
			t:setStrokeColor( 1, 1, 1, 0 )
			t.isFocus = false
		end
	end

	if "ended" == phase or "cancelled" == phase then
		getTouchTextDisplay( event.id, "basics" ):removeSelf()
		getTouchTextDisplay( event.id, "bounds" ):removeSelf()
		touchText[event.id] = nil
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
	button:setStrokeColor( 1, 1, 1, 0 )

	-- Make the button instance respond to touch events
	button:addEventListener( "touch", onTouch )
end

-- listener used by Runtime object. This gets called if no other display object
-- intercepts the event.
local function printTouch2( event )
	local id = event.id
	local phase = event.phase

	local message = event.name.."(" .. phase .. ") "..tostring(id).." ("..event.x..","..event.y..") " .. "(" .. getFormattedPressure( event.pressure ) .. ")"
	print( message )

	if "ended" ~= phase and "cancelled" ~= phase then
	 	local dataText = getTouchTextDisplay( id, "basics" )
		dataText.x = event.x
		dataText.y = event.y
		dataText.text = message

		getTouchTextDisplay( id, "bounds" ).text = ""
	else
		getTouchTextDisplay( id, "basics" ):removeSelf()
		getTouchTextDisplay( id, "bounds" ):removeSelf()
		touchText[event.id] = nil
	end
	
	return true
end

Runtime:addEventListener( "touch", printTouch2 )
