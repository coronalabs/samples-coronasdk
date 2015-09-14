
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

-- Set app font based on platform
if ( "Win" == system.getInfo( "platformName" ) or "Android" == system.getInfo( "platformName" ) ) then
	composer.setVariable( "appFont", native.systemFont )
else
	composer.setVariable( "appFont", "HelveticaNeue-Light" )
end

-- Set boolean to display "debugging" information for joints
composer.setVariable( "consoleDebug", false )

-- Set reference to "sampleUI" module for function calls in other modules
composer.setVariable( "sampleUI", sampleUI )

composer.recycleOnSceneChange = true
composer.gotoScene( "menu" )
