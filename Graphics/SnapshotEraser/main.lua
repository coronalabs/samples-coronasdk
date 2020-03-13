
-- Abstract: SnapshotEraser
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Snapshot Eraser", showBuildNum=false } )

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

-- Local variables and forward declarations
local previousX, previousY
local threshold = 6
local thresholdSq = threshold*threshold

-- Create images and snapshot
local imageUnder = display.newImageRect( mainGroup, "balloon.jpg", 360, 570 )
imageUnder.x, imageUnder.y = display.contentCenterX, display.contentCenterY

local snapshot = display.newSnapshot( mainGroup, display.actualContentWidth, display.actualContentHeight )
snapshot.x, snapshot.y = display.contentCenterX, display.contentCenterY

local imageOver = display.newImageRect( "sampleUI/back-darkgrey.png", 360, 640 )
snapshot.canvas:insert( imageOver )
snapshot:invalidate( "canvas" )

local function erase( x, y )

	local o = display.newImageRect( "eraser.png", 64, 64 )
	o.x, o.y = x, y
	o.fill.blendMode = { srcColor="zero", dstColor="oneMinusSrcAlpha" }
	snapshot.canvas:insert( o )
	snapshot:invalidate( "canvas" )  -- Accumulate changes without clearing
end

local function touchListener( event )

	local relX, relY = event.x-snapshot.x, event.y-snapshot.y

	if ( event.phase == "began" ) then
		previousX, previousY = relX, relY
		erase( relX, relY )

	elseif ( event.phase == "moved" ) then
		local dx = relX - previousX
		local dy = relY - previousY
		local deltaSq = dx*dx + dy*dy
		if ( deltaSq > thresholdSq ) then
			erase( relX, relY )
			previousX, previousY = relX, relY
		end
	end
	return true
end
Runtime:addEventListener( "touch", touchListener )

-- Instructions
local shade = display.newRect( mainGroup, display.contentCenterX, display.contentHeight-display.screenOriginY-18, display.actualContentWidth, 36 )
shade:setFillColor( 0, 0, 0, 0.7 )
local msg = display.newText( mainGroup, "Touch screen to reveal image underneath", display.contentCenterX, shade.y, appFont, 13 )
msg:setFillColor( 1, 0.9, 0.2 )
