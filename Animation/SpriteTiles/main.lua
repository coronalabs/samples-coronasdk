
-- Abstract: SpriteTiles
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
-- Artwork used within this project is licensed under Public Domain Dedication: https://creativecommons.org/publicdomain/zero/1.0/
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="mediumgrey", title="Sprite Tiles", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Seed the pseudo-random number generator
math.randomseed( os.time() )

-- Create player sprite sheet
local sheetOptions = {
	width = 50,
	height = 50,
	numFrames = 64,
	sheetContentWidth = 800,
	sheetContentHeight = 200
}
local characterSheet = graphics.newImageSheet( "sprites.png", sheetOptions )

-- Create display group for sprites
local group = display.newGroup()
mainGroup:insert( group )

-- Calculate how many total rows and columns will fill screen
local tilesPerRow = math.ceil( display.actualContentWidth / 60 )
local totalRows = math.ceil( (display.actualContentHeight-30) / 60 )

-- Generate sprites
for i = 1,totalRows do
	for j = 1,tilesPerRow do

		local rnd = math.random( 1,16 )

		local sequenceData = {
			name = "character",
			start = (rnd * 4) - 3,
			count = 4,
			time = 600
		}
		local sprite = display.newSprite( group, characterSheet, sequenceData )
		sprite.x = j * 60
		sprite.y = i * 60
		sprite:play()
	end
end

-- Re-position entire group on screen
group.anchorChildren = true
group.anchorY = 0
group.x = display.contentCenterX
group.y = sampleUI.titleBarBottom + 8
