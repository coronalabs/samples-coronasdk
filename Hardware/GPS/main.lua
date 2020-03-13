
-- Abstract: GPS
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="GPS", showBuildNum=false } )

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

-- Local variables and forward references
local currentLatitude = 0
local currentLongitude = 0

-- Create data labels
display.setDefault( "anchorX", 1.0 )
local yStart = math.max( sampleUI.titleBarBottom+30, 40 )
local latitudeLabel = display.newText( mainGroup, "Latitude", 120, yStart, appFont, 19 )
local longitudeLabel = display.newText( mainGroup, "Longitude", 120, latitudeLabel.y+50, appFont, 19 )
local altitudeLabel = display.newText( mainGroup, "Altitude", 120, longitudeLabel.y+50, appFont, 19 )
local accuracyLabel = display.newText( mainGroup, "Accuracy", 120, altitudeLabel.y+50, appFont, 19 )
local speedLabel = display.newText( mainGroup, "Speed", 120, accuracyLabel.y+50, appFont, 19 )
local directionLabel = display.newText( mainGroup, "Direction", 120, speedLabel.y+50, appFont, 19 )
local timeLabel = display.newText( mainGroup, "Time", 120, directionLabel.y+50, appFont, 19 )

-- Create data values
display.setDefault( "anchorX", 0.0 )
display.setDefault( "fillColor", 1, 0.3, 0.3 )
local latitude = display.newText( mainGroup, "?", 140, latitudeLabel.y, appFont, 19 )
local longitude = display.newText( mainGroup, "?", 140, longitudeLabel.y, appFont, 19 )
local altitude = display.newText( mainGroup, "?", 140, altitudeLabel.y, appFont, 19 )
local accuracy = display.newText( mainGroup, "?", 140, accuracyLabel.y, appFont, 19 )
local speed = display.newText( mainGroup, "?", 140, speedLabel.y, appFont, 19 )
local direction = display.newText( mainGroup, "?", 140, directionLabel.y, appFont, 19 )
local time = display.newText( mainGroup, "?", 140, timeLabel.y, appFont, 19 )

-- Reset default values
display.setDefault( "anchorX", 0.5 )
display.setDefault( "fillColor", 1, 1, 1 )

-- Button event handler
local buttonOnRelease = function( event )

	local mapURL = "https://maps.google.com/maps?q=Hello,+Corona!@" .. currentLatitude .. "," .. currentLongitude
	if system.canOpenURL( mapURL ) then
		-- Show location on map
		system.openURL( mapURL )
	else
		native.showAlert( "Alert", "No browser found to show location on map!", { "OK" } )
	end
end

-- Map button
local showMapButton = widget.newButton(
	{
		label = "Show on Map",
		shape = "rectangle",
		x = display.contentCenterX,
		y = timeLabel.y+60,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( showMapButton )

-- Location event listener function
local locationHandler = function( event )

	-- Check for error (user may have turned off location services)
	if event.errorCode then
		native.showAlert( "GPS Location Error", event.errorMessage, { "OK" } )

	-- If location events are enabled, update text values
	else
		currentLatitude = event.latitude
		latitude.text = string.format( "%.4f", event.latitude )
		currentLongitude = event.longitude
		longitude.text = string.format( "%.4f", event.longitude )
		altitude.text = string.format( "%.3f", event.altitude )
		accuracy.text = string.format( "%.3f", event.accuracy )
		speed.text = string.format( "%.3f", event.speed )
		direction.text = string.format( "%.3f", event.direction )
		time.text = string.format( "%.0f", event.time )
	end
end

-- Detect if platform supports location events
if system.hasEventSource( "location" ) then

	-- Activate location listener
	Runtime:addEventListener( "location", locationHandler )
else
	local shade = display.newRect( mainGroup, display.contentCenterX, display.contentHeight-display.screenOriginY-18, display.actualContentWidth, 36 )
	shade:setFillColor( 0, 0, 0, 0.7 )

	local msg = display.newText( mainGroup, "Location events not supported on this platform", display.contentCenterX, shade.y, appFont, 13 )
	msg:setFillColor( 1, 0, 0.2 )
end
