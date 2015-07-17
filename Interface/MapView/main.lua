-- Abstract: MapView sample project
-- Demonstrates the API for embedded maps and location data
-- 
-- Update History:
--  v1.0	First release. Supports iOS only.
--  v1.1	Added Android support.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

-- Display the status bar.
display.setStatusBar( display.DefaultStatusBar )

-- Load external Lua libraries (from project directory)
local widget = require( "widget" )


local locationNumber = 1 -- a counter to display on location labels
local currentLocation, currentLatitude, currentLongitude

local background = display.newImage( "bkg_grass.png", true )
background.x = display.contentWidth / 2
background.y = display.contentHeight / 2

local shadow = display.newRect( 7, 7, 306, 226 )
shadow.anchorX = 0.0		-- TopLeft anchor
shadow.anchorY = 0.0		-- TopLeft anchor
shadow:setFillColor( 0, 0, 0, 120/255 )

local simulatorMessage = "MapView is not supported on this platform.\n\nYou should build for iOS or Android to try MapView."
local label = display.newText( simulatorMessage, 20, 70, shadow.contentWidth - 10, 0, native.systemFont, 14 )
label.anchorX = 0.0		-- TopLeft anchor
label.anchorY = 0.0		-- TopLeft anchor

-- Create a native MapView (requires Xcode Simulator build or device build)
-- You can create multiple maps, if you like...
local myMap = native.newMapView( 20, 20, 300, 220 )
-- myMap.anchorX = 0.0		-- TopLeft anchor
-- myMap.anchorY = 0.0		-- TopLeft anchor

if myMap then
	-- Display a normal map with vector drawings of the streets.
	-- Other mapType options are "satellite" and "hybrid".
	myMap.mapType = "normal"

	-- The MapView is just another Corona display object and can be moved, resized, etc.
	myMap.x = display.contentWidth / 2
	myMap.y = 120

	-- Initialize map to a real location, since default location (0,0) is not very interesting
	myMap:setCenter( 37.331692, -122.030456 )

	-- Add a new marker when a user taps the map.
	local function mapTapListener( event )
		print( "The tapped location is at: " .. event.latitude .. ", " .. event.longitude )
		local options = { 
			title = 'You tapped here!',
			subtitle = event.latitude .. ' , ' .. event.longitude, 
		}
		myMap:addMarker( event.latitude, event.longitude, options )
	end
	myMap:addEventListener( "mapLocation", mapTapListener )
end

-- A handler for the native keyboard
local fieldHandler = function( event )
	-- Hide keyboard when the user clicks "Return" in this field
	if ( "submitted" == event.phase ) then
		native.setKeyboardFocus( nil )
	end
end

-- A native text input field (requires Xcode Simulator build or device build)
display.setDefault( "anchorX", 0 )
display.setDefault( "anchorY", 0 )
local inputField = native.newTextField( 10, 247, 300, 38 )
inputField.font = native.newFont( native.systemFont, 16 )
-- inputField.anchorX = 0.0		-- TopLeft anchor
-- inputField.anchorY = 0.0		-- TopLeft anchor
inputField.text = "Broadway and Columbus, San Francisco" -- example of searchable location
inputField:setTextColor( 45/255, 45/255, 45/255 )
inputField:addEventListener( "userInput", fieldHandler )

display.setDefault( "anchorX", 0.5 )
display.setDefault( "anchorY", 0.5 )

-- A function to handle the "mapAddress" event (also known as "reverse geocoding", ie: coordinates -> string).
local mapAddressHandler = function( event )
	if event.isError then
		-- Failed to receive location information.
		native.showAlert( "Error", event.errorMessage, { "OK" } )
	else
		-- Location information received. Display it.
		local locationText =
				"Latitude: " .. currentLatitude .. 
				", Longitude: " .. currentLongitude ..
				", Address: " .. ( event.streetDetail or "" ) ..
				" " .. ( event.street or "" ) ..
				", " .. ( event.city or "" ) ..
				", " .. ( event.region or "" ) ..
				", " .. ( event.country or "" ) ..
				", " .. ( event.postalCode or "" )
		native.showAlert( "You Are Here", locationText, { "OK" } )
	end
end

-- A function to handle the "mapLocation" event (also known as "forward geocoding", ie: string -> coordinates).
local mapLocationHandler = function( event )
	if event.isError then
		-- Location name not found.
		native.showAlert( "Error", event.errorMessage, { "OK" } )
	else
		-- Move map so this location is at the center
		-- (The final parameter toggles map animation, which may not be visible if moving a large distance)
		myMap:setCenter( event.latitude, event.longitude, true )

		-- Add a pin to the map at the new location
		markerTitle = "Location " .. locationNumber
		locationNumber = locationNumber + 1
		myMap:addMarker( event.latitude, event.longitude, { title=markerTitle, subtitle=inputField.text } )
	end
end

-- Create buttons and their functions:

local button1Release = function( event )
	-- This finds the location of the submitted string.
	-- Valid strings include addresses, intersections, and landmarks like "Golden Gate Bridge", "Eiffel Tower" or "Buckingham Palace".
	-- The result is returned in a "mapLocation" event, handled above).
	if myMap then
		myMap:requestLocation( inputField.text, mapLocationHandler )
	end
end

local button2Release = function( event )
	-- Do not continue if a MapView has not been created.
	if myMap == nil then
		return
	end

	-- Fetch the user's current location
	-- Note: in Xcode Simulator, the current location defaults to Apple headquarters in Cupertino, CA
	currentLocation = myMap:getUserLocation()
	if currentLocation.errorCode then
		-- Current location is unknown if the "errorCode" property is not nil.
		currentLatitude = 0
		currentLongitude = 0
		native.showAlert( "Error", currentLocation.errorMessage, { "OK" } )
	else
		-- Current location data was received.
		-- Move map so that current location is at the center.
		currentLatitude = currentLocation.latitude
		currentLongitude = currentLocation.longitude
		myMap:setRegion( currentLatitude, currentLongitude, 0.01, 0.01, true )
		
		-- Look up nearest address to this location (this is returned as a "mapAddress" event, handled above)
		myMap:nearestAddress( currentLatitude, currentLongitude, mapAddressHandler )
	end
end

local button3Release = function( event )
	if myMap then
		myMap:removeAllMarkers()
		locationNumber = 1 -- reset counter for popup labels
	end
end


local button1 = widget.newButton
{
	defaultFile = "buttonGreen.png",
	overFile = "buttonGreenOver.png",
	label = "Find Location",
	emboss = true,
	onRelease = button1Release,
}

local button2 = widget.newButton
{
	defaultFile = "buttonOrange.png",
	overFile = "buttonOrangeOver.png",
	label = "Current Location",
	emboss = true,
	onRelease = button2Release,
}

local button3 = widget.newButton
{
	defaultFile = "buttonRed.png",
	overFile = "buttonRedOver.png",
	label = "Remove All Markers",
	emboss = true,
	onRelease = button3Release,
}

button1.x = display.contentWidth / 2; button1.y = 320
button2.x = display.contentWidth / 2; button2.y = 380
button3.x = display.contentWidth / 2; button3.y = 440
