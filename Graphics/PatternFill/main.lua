--
-- Abstract: repeating fills sample app, demonstrating how to use repeating fills with transitions and filter effects
--
-- Date: October 2013
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: graphics, fills, textures, filters, transitions
--
-- File dependencies: none
--
-- Target devices: Simulator and devices
--
-- Limitations:
--
-- Comments: 
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )


-- Create container for visual objects
local myContainer = display.newContainer( 570, 570 )
myContainer.x = display.contentCenterX 
myContainer.y = display.contentCenterY


-- Place Corona logo
local x,y = display.contentCenterX, display.contentCenterY
local logo = display.newImage( "corona-logo-large.png" )
myContainer:insert( logo )
logo.fill.effect = "filter.wobble"
logo.fill.effect.amplitude = 10


local water1 = display.newRect( 0,0,800,800 )
myContainer:insert( water1 )
local water2 = display.newRect( 0,0,800,800 )
myContainer:insert( water2 )


-- Calculate scale factor for repeating textures
local scaleFactorX = 1 ; local scaleFactorY = 1
if ( water1.width > water1.height ) then
	scaleFactorY = water1.width / water1.height
else
	scaleFactorX = water1.height / water1.width
end

-- Set defaults for repeated textures which follow
display.setDefault( "textureWrapX", "repeat" )
display.setDefault( "textureWrapY", "mirroredRepeat" )

-- Apply repeating textures and filters to objects
water2.fill = { type="image", filename="water-fill.png" }
water2.fill.scaleX = 0.25 * scaleFactorX
water2.fill.scaleY = 0.25 * scaleFactorY
water2.fill.rotation = 40
water2.fill.effect = "filter.wobble"
water2.fill.effect.amplitude = 6
water2.alpha = 0.4

water1.fill = { type="image", filename="water-fill.png" }
water1.fill.scaleX = 0.25 * scaleFactorX
water1.fill.scaleY = 0.25 * scaleFactorY
water1.fill.effect = "filter.wobble"
water1.fill.effect.amplitude = 6
water1.alpha = 0.9

-- Reset texture wrap modes
display.setDefault( "textureWrapX", "clampToEdge" )
display.setDefault( "textureWrapY", "clampToEdge" )

-- Begin repeating transition function
local function repeatTrans()
	transition.to( water1.fill, { time=4000, x=water1.fill.x+0.5, onComplete=repeatTrans })
	transition.to( water2.fill, { time=4000, x=water1.fill.x+0.5 })
	if ( logo.alpha == 1 ) then
		transition.to( logo, { time=3000, alpha=0.8, transition=easing.inOutQuad } )
		transition.to( water1, { time=3000, alpha=1, transition=easing.inOutQuad } )
		transition.to( water2, { time=3600, alpha=0.6, transition=easing.inOutQuad } )
	else
		transition.to( logo, { time=3000, alpha=1, transition=easing.inOutQuad } )
		transition.to( water1, { time=3000, alpha=0.9, transition=easing.inOutQuad } )
		transition.to( water2, { time=3600, alpha=0.4, transition=easing.inOutQuad } )
	end
end
repeatTrans()
