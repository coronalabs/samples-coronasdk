
-- Abstract: HorseAnimation
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Horse Animation", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local worldGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

local tPrevious = system.getTimer()

-- Default to top-left anchor point for new objects
display.setDefault( "anchorX", 0.0 )
display.setDefault( "anchorY", 0.0 )

-- Create a container for the entire scene
local sceneContainer = display.newContainer( worldGroup, 480, 320 )
sceneContainer.x, sceneContainer.y = 0,0
sceneContainer.anchorChildren = false

-- Create "background" scene objects
local background = display.newImage( sceneContainer, "background.png", 0, 0 )

local moon = display.newImage( sceneContainer, "moon.png", 22, 19 )

local mountain_big = display.newImage( sceneContainer, "mountain_big.png", 132-240, 92 )
local mountain_big2 = display.newImage( sceneContainer, "mountain_big.png", 132-720, 92 )
local mountain_sma = display.newImage( sceneContainer, "mountain_small.png", 84, 111 )
local mountain_sma2 = display.newImage( sceneContainer, "mountain_small.png", 84-480, 111 )

local tree_s = display.newImage( sceneContainer, "tree_s.png", 129-30, 151 )
local tree_s2 = display.newImage( sceneContainer, "tree_s.png", 270+10, 151 )
local tree_l = display.newImage( sceneContainer, "tree_l.png", 145, 131 )

local tree_s3 = display.newImage( sceneContainer, "tree_s.png", 129-30-320, 151 )
local tree_s4 = display.newImage( sceneContainer, "tree_s.png", 270+10-320, 151 )
local tree_l2 = display.newImage( sceneContainer, "tree_l.png", 145-320, 131 )

local tree_s5 = display.newImage( sceneContainer, "tree_s.png", 129-30-640, 151 )
local tree_s6 = display.newImage( sceneContainer, "tree_s.png", 270+10-640, 151 )
local tree_l3 = display.newImage( sceneContainer, "tree_l.png", 145-640, 131 )

-- Create two fog pieces and scale horizontally by slight amount to prevent "seam" between each piece
local fog = display.newImage( sceneContainer, "fog.png", 240, 214 )
fog.xScale = 1.001
local fog2 = display.newImage( sceneContainer, "fog.png", -240, 214 )
fog2.xScale = 1.001

-- Set up horse image sheet and sprite instance
local options = {
	frames = require( "uma" ).frames,
}
local umaSheet = graphics.newImageSheet( "uma.png", options )
local spriteOptions = { name="uma", start=1, count=8, time=1000 }
local spriteInstance = display.newSprite( sceneContainer, umaSheet, spriteOptions )
spriteInstance.anchorX = 1
spriteInstance.anchorY = 1
spriteInstance.x = 460
spriteInstance.y = 320

-- Create "foreground" scene objects
local tree_l_sugi = display.newImage( sceneContainer, "tree_l_sugi.png", 23, 0 )
local tree_l_take = display.newImage( sceneContainer, "tree_l_take.png", 151, 0 )

local rakkan = display.newImage( sceneContainer, "rakkan.png", 19, 217 )
local rakkann = display.newImage( sceneContainer, "rakkann.png", 450, 11 )


-- Frame (runtime) listener to move objects
local function move( event )

	-- Move scene objects
	local tDelta = event.time - tPrevious
	tPrevious = event.time
	local xOffset = ( 0.2*tDelta )

	moon.x = moon.x + xOffset*0.05
	
	fog.x = fog.x + xOffset
	fog2.x = fog2.x + xOffset
	
	mountain_big.x = mountain_big.x + xOffset*0.5
	mountain_big2.x = mountain_big2.x + xOffset*0.5
	mountain_sma.x = mountain_sma.x + xOffset*0.5
	mountain_sma2.x = mountain_sma2.x + xOffset*0.5
	
	tree_s.x = tree_s.x + xOffset
	tree_s2.x = tree_s2.x + xOffset
	tree_l.x = tree_l.x + xOffset
	
	tree_s3.x = tree_s3.x + xOffset
	tree_s4.x = tree_s4.x + xOffset
	tree_l2.x = tree_l2.x + xOffset
	
	tree_s5.x = tree_s5.x + xOffset
	tree_s6.x = tree_s6.x + xOffset
	tree_l3.x = tree_l3.x + xOffset
	
	tree_l_sugi.x = tree_l_sugi.x + xOffset*1.5
	tree_l_take.x = tree_l_take.x + xOffset*1.5
	
	-- Move objects to other side of scene if they pass a horizontal position
	if moon.x > 480 + moon.width/2 then
		moon:translate ( -480*2 , 0)
	end
	if fog.x >= fog.width then
		fog:translate( -480*2, 0 )
	end
	if fog2.x >= fog2.width then
		fog2:translate( -480*2, 0 )
	end
	if mountain_big.x > 480 + mountain_big.width/2 then
		mountain_big:translate( -480*2, 0 )
	end
	if mountain_big2.x > 480 + mountain_big2.width/2 then
		mountain_big2:translate( -480*2, 0 )
	end
	if mountain_sma.x > 480 + mountain_sma.width/2 then
		mountain_sma:translate( -480*2, 0 )
	end
	if mountain_sma2.x > 480 + mountain_sma2.width/2 then
		mountain_sma2:translate( -480*2, 0 )
	end
	if tree_s.x > 480 + tree_s.width/2 then
		tree_s:translate( -480*2, 0 )
	end
	if tree_s2.x > 480 + tree_s2.width/2 then
		tree_s2:translate( -480*2, 0 )
	end
	if tree_l.x > 480 + tree_l.width/2 then
		tree_l:translate( -480*2, 0 )
	end
	if tree_s3.x > 480 + tree_s3.width/2 then
		tree_s3:translate( -480*2, 0 )
	end
	if tree_s4.x > 480 + tree_s4.width/2 then
		tree_s4:translate( -480*2, 0 )
	end
	if tree_l2.x > 480 + tree_l2.width/2 then
		tree_l2:translate( -480*2, 0 )
	end
	if tree_s5.x > 480 + tree_s5.width/2 then
		tree_s5:translate( -480*2, 0 )
	end
	if tree_s6.x > 480 + tree_s6.width/2 then
		tree_s6:translate( -480*2, 0 )
	end
	if tree_l3.x > 480 + tree_l3.width/2 then
		tree_l3:translate( -480*2, 0 )
	end
	if tree_l_sugi.x > 480 + tree_l_sugi.width/2 then
		tree_l_sugi:translate( -480*4, 0 )
	end
	if tree_l_take.x > 480 + tree_l_take.width/2 then
		tree_l_take:translate( -480*5, 0 )
	end
end

-- Start horse animation
spriteInstance:play()

-- Start runtime frame listener
Runtime:addEventListener( "enterFrame", move )
