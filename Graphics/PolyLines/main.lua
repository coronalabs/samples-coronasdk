-- 
-- Abstract: PolyLines sample app, demonstrating how to draw shapes using line segments
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

-- Example of shape drawing function
local function newStar()

	-- need initial segment to start
	local star = display.newLine( 0,-110, 27,-35 ) 

	-- further segments can be added later
	star:append( 105,-35, 43,16, 65,90, 0,45, -65,90, -43,15, -105,-35, -27,-35, 0,-110 )

	-- default color and width (can also be modified later)
	star:setStrokeColor( 255/255, 255/255, 25/2555, 255/255 )
	star.strokeWidth = 3

	return star
end


-- Create stars with random color and position
local stars = {}

for i = 1, 20 do

	local myStar = newStar()
	
	-- Graphics 2.0 needs colors from 0 to 1
	myStar:setStrokeColor( math.random(255)/255, math.random(255)/255, math.random(255)/255, math.random(200)/255 + 55/255 )
	myStar.strokeWidth = math.random(10)
	
	myStar.x = math.random( display.contentWidth )
	myStar.y = math.random( display.contentHeight )
	myStar.rotation = math.random(360)
	
	myStar.xScale = math.random(150)/100 + 0.5
	myStar.yScale = myStar.xScale
	
	local dr = math.random( 1, 4 )
	myStar.dr = dr
	if ( math.random() < 0.5 ) then
		myStar.dr = -dr
	end

	table.insert( stars, myStar )
end


function stars:enterFrame( event )

	for i,v in ipairs( self ) do
		v.rotation = v.rotation + v.dr
	end
end

Runtime:addEventListener( "enterFrame", stars )
