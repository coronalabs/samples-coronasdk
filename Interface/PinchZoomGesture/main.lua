--
-- Project: PinchZoom
--
-- Date: August 19, 2010
--
-- Version: 1.1
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Pinch/Zoom Gesture sample app
--
-- Demonstrates: locations events, buttons, touch
--
-- File dependencies: none
--
-- Target devices: Devices only
--
-- Limitations: Mutitouch not supported on Simulator
--
-- Update History:
--	v1.1	Added Simulator warning message
--
-- Comments: Pinch and Zoom to scale the image on the screen.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

-- add bkgd image to screen
local background = display.newImage( "aquariumbackgroundIPhone.jpg", display.contentCenterX, display.contentCenterY )

if not system.hasEventSource( "multitouch" ) then
	local msg = display.newText( "Multitouch events not supported on this platform", 0, 20, native.systemFontBold, 13 )
	msg.x = display.contentWidth / 2
	msg:setFillColor( 1, 0, 0 )
else
	-- activate multitouch
	system.activate( "multitouch" )
	local msg = display.newText( "Pinch and zoom the image", display.contentWidth / 2, display.contentHeight - 40, native.systemFontBold, 13 )
	msg:setFillColor( 0, 1, 0 )
end

local function calculateDelta( previousTouches, event )
	local id,touch = next( previousTouches )
	if event.id == id then
		id,touch = next( previousTouches, id )
		assert( id ~= event.id )
	end

	local dx = touch.x - event.x
	local dy = touch.y - event.y
	return dx, dy
end

-- create a table listener object for the bkgd image
function background:touch( event )
	local result = true

	local phase = event.phase

	local previousTouches = self.previousTouches

	local numTotalTouches = 1
	if ( previousTouches ) then
		-- add in total from previousTouches, subtract one if event is already in the array
		numTotalTouches = numTotalTouches + self.numPreviousTouches
		if previousTouches[event.id] then
			numTotalTouches = numTotalTouches - 1
		end
	end

	if "began" == phase then
		-- Very first "began" event
		if ( not self.isFocus ) then
			-- Subsequent touch events will target button even if they are outside the contentBounds of button
			display.getCurrentStage():setFocus( self )
			self.isFocus = true

			previousTouches = {}
			self.previousTouches = previousTouches
			self.numPreviousTouches = 0
		elseif ( not self.distance ) then
			local dx,dy

			if previousTouches and ( numTotalTouches ) >= 2 then
				dx,dy = calculateDelta( previousTouches, event )
			end

			-- initialize to distance between two touches
			if ( dx and dy ) then
				local d = math.sqrt( dx*dx + dy*dy )
				if ( d > 0 ) then
					self.distance = d
					self.xScaleOriginal = self.xScale
					self.yScaleOriginal = self.yScale
					print( "distance = " .. self.distance )
				end
			end
		end

		if not previousTouches[event.id] then
			self.numPreviousTouches = self.numPreviousTouches + 1
		end
		previousTouches[event.id] = event

	elseif self.isFocus then
		if "moved" == phase then
			if ( self.distance ) then
				local dx,dy
				if previousTouches and ( numTotalTouches ) >= 2 then
					dx,dy = calculateDelta( previousTouches, event )
				end
	
				if ( dx and dy ) then
					local newDistance = math.sqrt( dx*dx + dy*dy )
					local scale = newDistance / self.distance
					print( "newDistance(" ..newDistance .. ") / distance(" .. self.distance .. ") = scale("..  scale ..")" )
					if ( scale > 0 ) then
						self.xScale = self.xScaleOriginal * scale
						self.yScale = self.yScaleOriginal * scale
					end
				end
			end

			if not previousTouches[event.id] then
				self.numPreviousTouches = self.numPreviousTouches + 1
			end
			previousTouches[event.id] = event

		elseif "ended" == phase or "cancelled" == phase then
			if previousTouches[event.id] then
				self.numPreviousTouches = self.numPreviousTouches - 1
				previousTouches[event.id] = nil
			end

			if ( #previousTouches > 0 ) then
				-- must be at least 2 touches remaining to pinch/zoom
				self.distance = nil
			else
				-- previousTouches is empty so no more fingers are touching the screen
				-- Allow touch events to be sent normally to the objects they "hit"
				display.getCurrentStage():setFocus( nil )

				self.isFocus = false
				self.distance = nil
				self.xScaleOriginal = nil
				self.yScaleOriginal = nil

				-- reset array
				self.previousTouches = nil
				self.numPreviousTouches = nil
			end
		end
	end

	return result
end

--
-- register table listener
background:addEventListener( "touch", background )
