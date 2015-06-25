
-------------------------------------------------------------------------------------------------------
-- Artwork used within this project is licensed under Public Domain Dedication
-- See the following site for further information: https://creativecommons.org/publicdomain/zero/1.0/
-------------------------------------------------------------------------------------------------------

-- Randomly generate a character in our sprite sheet to use
local selOffset = ( math.random(4) - 1 ) * 4

-- Create our player sprite sheet
local sheetOptions = {
	width = 50,
	height = 50,
	numFrames = 64,
	sheetContentWidth = 800,
	sheetContentHeight = 200
}

local sheet_character = graphics.newImageSheet( "sprites.png", sheetOptions )

local sequences_character = {
	{
		name = "walk-down",
		--start = 1 + selOffset,
		--count = 4,
		frames = { 1+selOffset, 2+selOffset, 3+selOffset, 1+selOffset, 2+selOffset, 4+selOffset },
		time = 600,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "walk-left",
		--start = 17 + selOffset,
		--count = 4,
		frames = { 17+selOffset, 18+selOffset, 19+selOffset, 17+selOffset, 18+selOffset, 20+selOffset },
		time = 600,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "walk-right",
		--start = 33 + selOffset,
		--count = 4,
		frames = { 33+selOffset, 34+selOffset, 35+selOffset, 33+selOffset, 34+selOffset, 36+selOffset },
		time = 600,
		loopCount = 0,
		loopDirection = "forward"
	},
	{
		name = "walk-up",
		--start = 49 + selOffset,
		--count = 4,
		frames = { 49+selOffset, 50+selOffset, 51+selOffset, 49+selOffset, 50+selOffset, 52+selOffset },
		time = 600,
		loopCount = 0,
		loopDirection = "forward"
	},
}

-- And, create the player that it belongs to
local character = display.newSprite( sheet_character, sequences_character )
character.x = display.contentCenterX
character.y = display.contentCenterY
character:setSequence( "walk-down" )
character:setFrame( 2 )

return character
