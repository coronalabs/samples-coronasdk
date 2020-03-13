
-- Abstract: Licensing
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Licensing (Android)", showBuildNum=false } )

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
widget.setTheme( "widget_theme_android_holo_light" )
local licensing = require( "licensing" )

-- Set local variables
local setupComplete = false

-- Set app font
local appFont = sampleUI.appFont

-- Create spinner widget for indicating ad status
local spinner = widget.newSpinner( { x=display.contentCenterX, y=display.contentCenterY, deltaAngle=10, incrementEvery=10 } )
mainGroup:insert( spinner )
spinner.alpha = 0

-- Function to manage spinner appearance/animation
local function manageSpinner( action )
	if ( action == "show" ) then
		spinner:start()
		transition.cancel( "spinner" )
		transition.to( spinner, { alpha=1, tag="spinner", time=((1-spinner.alpha)*320), transition=easing.outQuad } )
	elseif ( action == "hide" ) then
		transition.cancel( "spinner" )
		transition.to( spinner, { alpha=0, tag="spinner", time=((1-(1-spinner.alpha))*320), transition=easing.outQuad,
			onComplete=function() spinner:stop(); end } )
	end
end

-- Licensing listener
local licensingListener = {}
function licensingListener:licensing( event )

	if not ( event.isVerified ) then
		-- Failed to verify app from the Google Play store
		local errorMsg = ""
		if ( event.isError == true and event.response ) then
			errorMsg = event.response
		end
		local alert = native.showAlert( "Licensing Error", "Application could not be verified!" .. errorMsg, { "OK" } )
	else
		-- License verified!
		local alert = native.showAlert( "Licensing Success", "Application verified!", { "OK" } )
	end
	manageSpinner( "hide" )
end

-- Button handler
local function buttonHandler( event )
	licensing.verify( licensingListener )
	manageSpinner( "show" )
end

-- Button to verify license
local verifyButton = widget.newButton(
{
	label = "Verify License",
	x = display.contentCenterX,
	y = display.contentHeight-120,
	shape = "rectangle",
	width = 200,
	height = 32,
	font = appFont,
	fontSize = 15,
	fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = buttonHandler
})
mainGroup:insert( verifyButton )
verifyButton:setEnabled( false )
verifyButton.alpha = 0.3

-- Detect if licensing is supported (Android only)
if not ( system.getInfo("platform") == "android" ) then
	local shade = display.newRect( mainGroup, display.contentCenterX, display.contentHeight-display.screenOriginY-18, display.actualContentWidth, 36 )
	shade:setFillColor( 0, 0, 0, 0.7 )
	local msg = display.newText( mainGroup, "Licensing is not supported on this platform", display.contentCenterX, shade.y, appFont, 13 )
	msg:setFillColor( 1, 0, 0.2 )
else
	-- Check if license key is specified
	local config = require( "config" )
	local json = require( "json" )
	local keyCheck = string.find( json.encode(application), '{"google":{"key":"YOUR_LICENSE_KEY"' )
	if keyCheck then
		local alert = native.showAlert( "Important", 'Confirm that you have specified your unique Google license key within "config.lua" on line 23. This must be a Base64-encoded RSA public key from the "Services & APIs" section of the Google Play Developer Console.', { "OK", "documentation" },
			function( event )
				if ( event.action == "clicked" and event.index == 2 ) then
					system.openURL( "https://docs.coronalabs.com/api/library/licensing/index.html" )
				end
			end )
	else
		if ( system.getInfo("targetAppStore") == "google" ) then
			licensing.init( "google" )
			setupComplete = true
		end
	end
end

if ( setupComplete == true ) then
	verifyButton:setEnabled( true )
	verifyButton.alpha = 1
end
