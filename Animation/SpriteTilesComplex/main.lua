-- 
-- Abstract: SpriteTilesComplex
-- By "complex", we mean it's more work; you specify the data for each frame manually.
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

--[[
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
--]]

-- The following is a manual duplication of the above:

-- (1) Generate the first 16 out of 256 frames
local options = 
{
	-- Required params
	frames = {
		{
			x = 64*0,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*1,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*2,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*3,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*4,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*5,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*6,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*7,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*8,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*9,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*10,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*11,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*12,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*13,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*14,
			y = 0,
			width = 64,
			height = 64,
		},
		{
			x = 64*15,
			y = 0,
			width = 64,
			height = 64,
		},
	},

	-- content scaling
	sheetContentWidth = 1024,
	sheetContentHeight = 1024,
}

-- (2) Generate the remaining 256 frames programatically:
-- Instead of typing them all out, we just duplicate the first row 15 more times,
-- adjusting the y value as necessary.
local frames = options.frames
for j=1,15 do
	for i=1,16 do
		local src = frames[i]
		local element = {
			x = src.x,
			y = 64 * j,
			width = src.width,
			height = src.height,
		}
		table.insert( frames, element )
	end
end

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
