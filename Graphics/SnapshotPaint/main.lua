-- 
-- Abstract: SnapshotPaint sample app
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

display.setDefault( "background", 1 )

local snapshot = display.newSnapshot( w,h )
snapshot:translate( display.contentCenterX, display.contentCenterY )

-- Don't record changes to save memory. 
-- 
-- However, saving memory comes at a cost. If the GL context changes,
-- the snapshot will *not* be able to re-draw the contents. For example,
-- on some Android devices, this can occur after a suspend/resume cycle.
snapshot.canvasMode = "discard"

local previousX, previousY
local threshold = 0
local thresholdSq = threshold*threshold

local function draw( x, y )
	local o = display.newImage( "brush.png", x, y )
	o:setFillColor( 1, 0, 1 ) -- magenta paint

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

local instruction = display.newText{
	text="Touch screen to start painting",
	x = display.contentCenterX,
	y = 30,
	fontSize=12,
}
instruction:setFillColor( 0 )
