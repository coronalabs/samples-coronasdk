-- 
-- Abstract: SpriteTiles
--
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

--display.setDefault( "background", 1 )
display.setStatusBar( display.HiddenStatusBar )

local options = 
{
	-- Required params
	width = 64,
	height = 64,
	numFrames = 256,

	-- content scaling
	sheetContentWidth = 1024,
	sheetContentHeight = 1024,
}
local sheet = graphics.newImageSheet( "dancers.png", options )

local sequenceData = {}

local w = 64
local h = 64
local halfW = w*0.5
local halfH = h*0.5

local function createTiles( x, y, xMax, yMax, group )
	local xStart = x
	local j = 0
	while ( true ) do
		local i = 1+math.fmod( j, 16 )
		j = j + 1
		
		local dancer = "dancer" .. i
		local numFrames = 16
		local start = (i % 16)*numFrames + 1
		local sequence = { name=dancer, start=start, count=numFrames, loopDirection="bounce" }

		local sprite

		if ( group ) then
			sprite = display.newSprite( sheet, sequence )
			group:insert( sprite )
		else
			sprite = display.newSprite( sheet, sequence )
		end

		sprite:translate( x, y )
		sprite:play()

		x = x + w
		if ( x > xMax ) then
			x = xStart
			y = y + h
		end

		if ( y > yMax ) then
			break
		end
	end

end

local function createTileGroup( nx, ny )
	local group = display.newGroup( )
	-- local group = display.newImageGroup( sheet )
	group.xMin = -(nx-1)*display.contentWidth - halfW
	group.yMin = -(ny-1)*display.contentHeight - halfH
	group.xMax = halfW
	group.yMax = halfH
	function group:touch( event )
		if ( "began" == event.phase ) then
			self.xStart = self.x
			self.yStart = self.y
			self.xBegan = event.x
			self.yBegan = event.y
		elseif ( "moved" == event.phase ) then
			local dx = event.x - self.xBegan
			local dy = event.y - self.yBegan
			local x = dx + self.xStart
			local y = dy + self.yStart
			if ( x < self.xMin ) then x = self.xMin end
			if ( x > self.xMax ) then x = self.xMax end
			if ( y < self.yMin ) then y = self.yMin end
			if ( y > self.yMax ) then y = self.yMax end
			self.x = x
			self.y = y
		end
		return true
	end
	group:addEventListener( "touch", group )
	
	
	local x = halfW
	local y = halfH
	
	local xMax = nx * display.contentWidth
	local yMax = ny * display.contentHeight
	
	createTiles( x, y, xMax, yMax, group )

	return group
end

local nx = 2
local ny = 2
local group = createTileGroup( nx, ny )

local prevTime = system.getTimer()
local fps = display.newText( "30", 30, 47, nil, 24 )
fps:setFillColor( 1 )
fps.prevTime = prevTime

local function enterFrame( event )
	local curTime = event.time
	local dt = curTime - prevTime
	prevTime = curTime
	if ( (curTime - fps.prevTime ) > 100 ) then
		-- limit how often fps updates
		fps.text = string.format( '%.2f', 1000 / dt )
	end
end
Runtime:addEventListener( "enterFrame", enterFrame )
