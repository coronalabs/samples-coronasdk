-- Project: DynamicImageResolution
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract:	Tests multiple resolution mode using display.newRectImage
--
-- Demonstrates: 
--		display.newRectImage (with image resolution table defined in config.lua)
--
-- File dependencies: config.lua
--
-- Target devices: Simulator and devices
--
-- Limitations: 
--
-- Update History:
--	Sept 12, 2010	v1.0
--	Jan 21, 2016	v1.1	Updated to @15x and @2x; added screen size
--
-- Comments:
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
---------------------------------------------------------------------------------------

-- The "newImageRect" function selects the best image for the resolution of the current device
-- and displays it at the specified size. 
-- In the example below, the specified image size is 200 x 200 in base content coordinates.
-- (The base content size is 320x480, defined in config.lua)

-- If no high-resolution alternates are found, the base image filename is used instead.
-- See the config.lua file for the "imageSuffix" naming table for alternate images.

display.setDefault( "background", 0.3 )

width = display.contentWidth
height = display.contentHeight

actualSizeRect = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth,
	 display.actualContentHeight )
actualSizeRect:setFillColor( 1,0,0,0.5 )	-- red letterbox

contentSizeRect = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth,
	 display.contentHeight )
contentSizeRect:setFillColor( 0.3 )		-- regular content area

local myImage = display.newImageRect( "hongkong.png", 200, 200 )
myImage.x = display.contentCenterX
myImage.y = display.contentCenterY

-- Create text message labels
local label1 = display.newText( "Dynamic Image Resolution", width/2, 30, native.systemFontBold, 20 )
label1:setFillColor( 190/255, 190/255, 1 )
local label2 = display.newText( "View in different simulated devices", width/2, 60, native.systemFont, 14 )
label2:setFillColor( 190/255, 190/255, 1 )
local label3 = display.newText( "(Best image is chosen automatically)", width/2, 80, native.systemFont, 14 )
label3:setFillColor( 190/255, 190/255, 1 )
local label4 = display.newText( "(Red equals letterbox area)", width/2, 100, native.systemFont, 14 )
label4:setFillColor( 190/255, 190/255, 1 )

display.newText( string.format( "Content Width x Height: %4.0f x %4.0f",
	display.contentWidth, display.contentHeight ), width/2, 360, nil, 14 )
display.newText( string.format( "actualContent Width x Height: %4.0f x %4.0f",
	display.actualContentWidth, display.actualContentHeight ), width/2, 385, nil, 14 )
display.newText( string.format( "Pixel Width x Height: %4.0f x %4.0f",
	display.pixelWidth, display.pixelHeight ), width/2, 410, nil, 14 )

display.newText( string.format( "Scale Factor (height): %2.2f", ( display.pixelHeight / display.actualContentHeight ) ), width/2, 435, nil, 14 )

-- Display the build number on the scree
buildText = display.newText( system.getInfo( "build" ), 260, 460, native.systemFont, 12 )
buildText:setFillColor( 1, 0.5 )
buildText.anchorX = 0
buildText.anchorY = 0