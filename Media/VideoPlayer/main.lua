
-- Abstract: VideoPlayer
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
-- Video licensed as Creative Commons Attribute 3.0: https://peach.blender.org
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Video Player", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Require libraries/plugins
local widget = require( "widget" )

-- Set app font
local appFont = sampleUI.appFont

local function openVideoPlayer()
	-- Open device-specific video player and show video controls (third parameter)
	media.playVideo( "https://www.coronalabs.com/video/bbb/BigBuckBunny_640x360.m4v", media.RemoteSource, true )
end

-- Play button
local playButton = widget.newButton(
{
	x = display.contentCenterX,
	y = display.contentCenterY,
	width = 250,
	height = 32,
	shape = "rectangle",
	font = appFont,
	fontSize = 15,
	label = "Play Video",
	fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = openVideoPlayer
})
mainGroup:insert( playButton )
playButton:setEnabled( false )
playButton.alpha = 0.3

local function onResize( event )
	playButton.x = display.contentCenterX
	playButton.y = display.contentCenterY
end
Runtime:addEventListener( "resize", onResize )

-- Check if "media.playVideo()" is supported on platform
if ( system.getInfo("environment") == "simulator" and system.getInfo("platform") == "win32" ) then
	local alert = native.showAlert( "Error", "Video player not supported on this platform.", { "OK" } )
else
	playButton:setEnabled( true )
	playButton.alpha = 1
end
