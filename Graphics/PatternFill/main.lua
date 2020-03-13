
-- Abstract: Pattern Fill
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Pattern Fill", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Local variables and forward references
local centerX, centerY = display.contentCenterX, display.contentCenterY
local transCycle = 2

local background = display.newRect( mainGroup, centerX, centerY, display.actualContentWidth, display.actualContentHeight )
background:setFillColor( 0, 0.6, 0.8 )

-- Place Corona logo
local logo = display.newImageRect( mainGroup, "corona-logo.png", 256, 256 )
logo.x, logo.y = centerX, centerY+12
logo.alpha = 0.8
logo.fill.effect = "filter.wobble"
logo.fill.effect.amplitude = 6

-- Create vector rectangles for water (will be filled with repeating texture)
local water1 = display.newRect( mainGroup, centerX, centerY, 768, 768 )
local water2 = display.newRect( mainGroup, centerX, centerY, 768, 768 )

-- Calculate scale factor for repeating texture
local scaleFactorX = 1
local scaleFactorY = 1
if ( water1.width > water1.height ) then
	scaleFactorY = water1.width / water1.height
else
	scaleFactorX = water1.height / water1.width
end

-- Set defaults for repeated textures which follow
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "mirroredRepeat" )

-- Apply repeating textures and filters to objects
water1.fill = { type="image", filename="water-fill.png" }
water1.fill.scaleX = 0.25 * scaleFactorX
water1.fill.scaleY = 0.25 * scaleFactorY
water1.fill.effect = "filter.wobble"
water1.fill.effect.amplitude = 6
water1.alpha = 0.8

water2.fill = { type="image", filename="water-fill.png" }
water2.fill.scaleX = 0.25 * scaleFactorX
water2.fill.scaleY = 0.25 * scaleFactorY
water2.fill.rotation = 40
water2.fill.effect = "filter.wobble"
water2.fill.effect.amplitude = 6
water2.alpha = 0.6

-- Reset texture wrap modes
display.setDefault( "textureWrapX", "clampToEdge" )
display.setDefault( "textureWrapY", "clampToEdge" )

-- Begin repeating transition function
local function repeatTrans()
	transition.to( water1.fill, { time=4000, x=water1.fill.x+0.5, onComplete=repeatTrans })
	transition.to( water2.fill, { time=4000, x=water1.fill.x+0.5 })
	if ( transCycle == 1 ) then
		transCycle = 2
		transition.to( logo, { time=3000, alpha=0.8, transition=easing.inOutQuad } )
		transition.to( water1, { time=3000, alpha=0.8, transition=easing.inOutQuad } )
		transition.to( water2, { time=3600, alpha=0.6, transition=easing.inOutQuad } )
	else
		transCycle = 1
		transition.to( logo, { time=3000, alpha=0.7, transition=easing.inOutQuad } )
		transition.to( water1, { time=3000, alpha=0.6, transition=easing.inOutQuad } )
		transition.to( water2, { time=3600, alpha=0.4, transition=easing.inOutQuad } )
	end
end
repeatTrans()
