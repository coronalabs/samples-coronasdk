-- Abstract: DynamicImageResolution
-- Version: 1.2
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="whiteorange", title="Dynamic Image Resolution", showBuildNum=false } )

-- The following property represents the bottom Y position of the sample title bar
local titleBarBottom = sampleUI.titleBarBottom

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set app font
local appFont = sampleUI.appFont

local contentSizeRect = display.newRect( mainGroup, display.contentCenterX, display.contentCenterY, display.contentWidth,
         display.contentHeight )
contentSizeRect:setFillColor( 0.5, 0.6 )  -- Regular content area


local function getScreenParamsStr( portraitOrientation )
	local separator = "\n" -- (portraitOrientation) and "\n" or " / "

	local paramsStr = string.format( "display.contentWidth/Height: %4.0f ×%4.0f\ndisplay.actualContentWidth/Height: %4.0f ×%4.0f%sdisplay.pixelWidth/Height: %4.0f × %4.0f\nScale Factor (height): %2.2f  •  display.imageSuffix: %s",
		display.contentWidth, display.contentHeight,
		display.actualContentWidth, display.actualContentHeight,
		separator,
		display.pixelWidth, display.pixelHeight,
		(display.pixelHeight / display.actualContentHeight),
		(display.imageSuffix == nil and "(none)" or display.imageSuffix))

	return paramsStr
end

local width = display.contentWidth
local height = display.contentHeight

local theImage = display.newImageRect( mainGroup, "Dragons.jpg", 300, 225 )
theImage.x = display.contentCenterX
theImage.y = display.contentCenterY

-- Create text message labels
local descOptions = {
	text = "",
	parent = mainGroup,
	x = width/2,
	y = 60,
	font = appFont,
	fontSize = 12,
	align = "center",
}
local description = display.newText( descOptions )
description.text = "View in different simulated devices\n(best resolution image is chosen automatically)\n\nGrey rectangle is Corona content area"
description:setFillColor( 0 )

local paramOptions = 
{
	text = getScreenParamsStr( true ),
	parent = mainGroup,
    font = appFont,
    fontSize = 8,
    align = "center",
}
local params = display.newText( paramOptions )
params.anchorY = 0
params:setFillColor( 0 )


local function onResizeChange()

	local isPortrait = ( display.contentWidth < display.contentHeight )
	local screenParamsStr = getScreenParamsStr( isPortrait )
	params.text = screenParamsStr

	contentSizeRect.x = display.contentCenterX
	contentSizeRect.y = display.contentCenterY
	contentSizeRect.width = display.contentWidth
	contentSizeRect.height = display.contentHeight

	description.x = display.contentCenterX
	theImage.x = display.contentCenterX

	if isPortrait then
		theImage.width = display.contentWidth - 2
		theImage.height = theImage.width * 0.75
		theImage.anchorY = 0.5
		theImage.y = display.contentCenterY
	else
		theImage.width = theImage.height * (4000/3000)
		theImage.height = display.contentHeight - 100
		theImage.anchorY = 0
		theImage.y = titleBarBottom + 10
	end

	params.x = display.contentCenterX
	params.y =  theImage.contentBounds.yMax + 10

	description.isVisible = isPortrait
end
Runtime:addEventListener( "resize", onResizeChange )

-- Get everything laid out consistently
onResizeChange( )
