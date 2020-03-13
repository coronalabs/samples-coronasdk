
-- Abstract: Filter Graph
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Filter Graph", showBuildNum=false } )

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

-- Local variables and forward references
local imageName = "image.jpg"

local function renderImages()

	-- Original image
	local imageOriginal = display.newImageRect( mainGroup, imageName, 92, 128 )
	imageOriginal.x = 60
	imageOriginal.y = 98
	local labelOriginal = display.newText( mainGroup, "original", imageOriginal.x, 172, appFont, 13 )

	-- Image with "swirl" effect
	local imageFilter1 = display.newImageRect( mainGroup, imageName, 92, 128 )
	imageFilter1.x = display.contentCenterX
	imageFilter1.y = 98
	local labelFilter1 = display.newText( mainGroup, "swirl", imageFilter1.x, 172, appFont, 13 )
	imageFilter1.fill.effect = "filter.swirl"
	imageFilter1.fill.effect.intensity = 0.75

	-- Image with "scatter" effect
	local imageFilter2 = display.newImageRect( mainGroup, imageName, 92, 128 )
	imageFilter2.x = display.contentWidth - 60
	imageFilter2.y = 98
	local labelFilter2 = display.newText( mainGroup, "scatter", imageFilter2.x, 172, appFont, 13 )
	imageFilter2.fill.effect = "filter.scatter"
	imageFilter2.fill.effect.intensity = 0.2

	-- Image for filter graph effect
	local imageFilterGraph = display.newImageRect( mainGroup,  imageName, 184, 256 )
	imageFilterGraph.x = display.contentCenterX
	imageFilterGraph.y = 320
	local labelFilterGraph = display.newText( mainGroup, "swirl + scatter", imageFilterGraph.x, 460, appFont, 15 )

	-- Load and define "graphDemo" effect from external module ("kernel_filter_graph.lua")
	local graphEffect = require( "kernel_filter_graph" )
	graphics.defineEffect( graphEffect )

	-- Assign effect to image
	imageFilterGraph.fill.effect = "filter.custom.graphDemo"

	-- Assign same filter properties as images above
	imageFilterGraph.fill.effect.swirl.intensity = imageFilter1.fill.effect.intensity
	imageFilterGraph.fill.effect.scatter.intensity = imageFilter2.fill.effect.intensity
end

-- Detect if high-precision fragment shaders are supported
if ( system.getInfo("gpuSupportsHighPrecisionFragmentShaders") == true ) then
	renderImages()
else
	local shade = display.newRect( mainGroup, display.contentCenterX, display.contentHeight-display.screenOriginY-18, display.actualContentWidth, 36 )
	shade:setFillColor( 0, 0, 0, 0.7 )
	local msg = display.newText( mainGroup, "High-precision shaders not supported on this device", display.contentCenterX, shade.y, appFont, 13 )
	msg:setFillColor( 1, 0, 0.2 )
end
