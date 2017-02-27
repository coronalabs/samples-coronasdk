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

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="whiteorange", title="Dynamic Image Resolution", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

local contentSizeRect = display.newRect( mainGroup, display.contentCenterX, display.contentCenterY, display.contentWidth,
         display.contentHeight )
contentSizeRect:setFillColor( 0.5, 0.5 )             -- regular content area
contentSizeRect.x = display.contentCenterX
contentSizeRect.y = display.contentCenterY

local function GetScreenParamsStr(portraitOrientation)
	print(orientation)
	local separator = "\n" -- (portraitOrientation) and "\n" or " / "

	return  string.format( "display.contentWidth/Height: %4.0f x %4.0f ✪ display.actualContentWidth/Height: %4.0f x %4.0f%sdisplay.pixelWidth/Height: %4.0f x %4.0f ✪ Scale Factor (height): %2.2f ✪ display.imageSuffix: %s",
		display.contentWidth, display.contentHeight,
		display.actualContentWidth, display.actualContentHeight,
		separator,
		display.pixelWidth, display.pixelHeight,
		(display.pixelHeight / display.actualContentHeight),
		(display.imageSuffix == nil and "(none)" or display.imageSuffix))
end

local width = display.contentWidth
local height = display.contentHeight

local theImage = display.newImageRect( mainGroup, "Dragons.jpg", 300, 225 )
theImage.x = display.contentCenterX
theImage.y = display.contentCenterY

-- Create text message labels
local descOptions = 
{
	text = "",
	parent = mainGroup,
    x = width/2,
    y = 60,
    font = native.systemFont,   
    fontSize = 12,
    align = "center",
}
local description = display.newText( descOptions )
description.text = "View in different simulated devices\n(best resolution image is chosen automatically)\n\nGrey rectangle is content area"
description:setFillColor(130/255, 159/255, 249/255)

local paramOptions = 
{
	text = GetScreenParamsStr(true),
	parent = mainGroup,
    font = native.systemFont,   
    fontSize = 6,
    align = "center",
}
local params = display.newText( paramOptions )
params:setFillColor(130/255, 159/255, 249/255)

local function onResizeChange( )
	local isPortrait = (display.contentWidth < display.contentHeight)
	local screenParamsStr = GetScreenParamsStr(isPortrait)
	params.text = screenParamsStr

	contentSizeRect.x = display.contentCenterX
	contentSizeRect.y = display.contentCenterY
	contentSizeRect.width = display.contentWidth
	contentSizeRect.height = display.contentHeight

	description.x = display.contentCenterX
	theImage.x = display.contentCenterX
	theImage.y = display.contentCenterY
	if isPortrait then
		theImage.width = display.contentWidth - 2
		theImage.height = theImage.width * 0.75
	else
		theImage.height = display.contentHeight - 70
		theImage.width = theImage.height * (4000/3000)
	end

	params.x = display.contentCenterX
	params.y =  theImage.y + (theImage.height / 2) + (params.height / 2) + 10

	description.isVisible = isPortrait
end
Runtime:addEventListener( "resize", onResizeChange )

-- Get everything laid out consistently
onResizeChange( )
