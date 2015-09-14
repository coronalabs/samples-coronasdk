-- 
-- Abstract: SnapshotEraser sample app
--  
-- Version: 2.0
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
------------------------------------------------------------

local w = display.actualContentWidth
local h = display.actualContentHeight

local aquarium = display.newImage( "aquarium.jpg", display.contentCenterX, display.contentCenterY )

local snapshot = display.newSnapshot( w,h )
snapshot:translate( display.contentCenterX, display.contentCenterY )

local background = display.newImage( "world.jpg" )

snapshot.canvas:insert( background )
snapshot:invalidate( "canvas" )

local previousX, previousY
local threshold = 10
local thresholdSq = threshold*threshold

local function draw( x, y )
	local o = display.newImage( "brush.png", x, y )
	o.fill.blendMode = { srcColor = "zero", dstColor="oneMinusSrcAlpha" }

	snapshot.canvas:insert( o )
	snapshot:invalidate( "canvas" ) -- accumulate changes w/o clearing
end

local function listener( event )
	local x,y = event.x - snapshot.x, event.y - snapshot.y

	if ( event.phase == "began" ) then
		previousX,previousY = x,y
		draw( x, y )
	elseif ( event.phase == "moved" ) then
		local dx = x - previousX
		local dy = y - previousY
		local deltaSq = dx*dx + dy*dy
		if ( deltaSq > thresholdSq ) then
			draw( x, y )
			previousX,previousY = x,y
		end
	end
end

Runtime:addEventListener( "touch", listener )

display.newText{
	text="Touch screen to reveal image underneath",
	x = display.contentCenterX,
	y = 30,
	fontSize=12,
}
