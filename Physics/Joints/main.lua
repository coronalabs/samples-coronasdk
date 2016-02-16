
-- Abstract: Physics Joints
-- Version: 1.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Physics Joints", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
local composer = require( "composer" )
display.getCurrentStage():insert( sampleUI.backGroup )
display.getCurrentStage():insert( composer.stage )
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Require libraries/plugins
local physics = require( "physics" )

-- Set app font
composer.setVariable( "appFont", sampleUI.appFont )

-- Set boolean to display "debugging" information for joints
composer.setVariable( "consoleDebug", false )

-- Include callback function for showing/hiding info box
-- In this sample, the physics draw mode is adjusted when appropriate
sampleUI.onInfoEvent = function( event )

	if ( event.action == "show" and event.phase == "will" ) then
		physics.setDrawMode( "normal" )
	elseif ( event.action == "hide" and event.phase == "did" ) then
		physics.setDrawMode( "hybrid" )
	end
end

-- Set reference to "sampleUI" module for function calls in other modules
composer.setVariable( "sampleUI", sampleUI )

composer.recycleOnSceneChange = true
composer.gotoScene( "menu" )
