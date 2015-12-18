-- Project: AsynchImageDownload
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Two simple ways to load an image from the network, using the new asynchronous HTTP network library
-- (Also note that the two downloads do not block each other!)
--
-- Demonstrates: network.download, display.loadRemoteImage APIs
--
-- File dependencies: none
--
-- Target devices: Corona Simulator and iOS devices
--
-- Limitations: Requires internet access
--
-- Update History:
--	1.0		January 3, 2011		Initialize version
--	1.1		March 6, 2013		Modified for Networking 2.0	
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

----------------------------------------------------------------------------------------------------
-- Method 1: use network.download() to create an image file, then load it as a display object

local myImage
local function networkListener( event )
	if ( event.isError ) then
		print ( "Network error - download failed" )
	else
		myImage = display.newImage( event.response.filename, event.response.baseDirectory, centerX, _H / 3 - 30 )
		myImage.alpha = 0
		transition.to( myImage, { alpha = 1.0 } )
		print ( "RESPONSE: ", event.response.filename )
	end
end

network.download( 
	"https://developer.coronalabs.com/demo/hello.png", 
	"GET", 
	networkListener, 
	"helloCopy.png", 
	system.TemporaryDirectory )

-- NOTE: files saved to system.TemporaryDirectory are not guaranteed to persist across launches.
-- Use system.DocumentsDirectory if you want files to persist.

----------------------------------------------------------------------------------------------------
-- Method 2: use display.loadRemoteImage() to get the file and create a display object in one step

local myImage2
local function networkListener2( event )
	if ( event.isError ) then
		print ( "Network error - download failed" )
	else
		myImage2 = event.target
		myImage2.alpha = 0
		transition.to( myImage2, { alpha = 1.0 } )
	end
	
	print ( "RESPONSE: ", event.response.filename )
end

display.loadRemoteImage( 
	"https://developer.coronalabs.com/demo/hello.png", 
	"GET", 
	networkListener2, 
	"helloCopy2.png", 
	system.TemporaryDirectory, 
	centerX, _H / 3 * 2 + 30 )

-- Update the app layout on resize event.
local function onResize( event )
	centerX = display.contentCenterX
	centerY = display.contentCenterY
	_W = display.contentWidth
	_H = display.contentHeight

	local isPortrait = ( _H > _W )
	print( _W, _W, isPortrait )

	if ( isPortrait ) then
		if ( myImage ) then
			myImage.x = centerX
			myImage.y = _H / 3 - 30
		end

		if ( myImage2 ) then
			myImage2.x = centerX
			myImage2.y = _H / 3 * 2 + 30
		end
	else
		if ( myImage ) then
			myImage.x = _W / 3 - 30
			myImage.y = centerY
		end

		if ( myImage2 ) then
			myImage2.x = _W / 3 * 2 + 30
			myImage2.y = centerY
		end
	end
end
Runtime:addEventListener( "resize", onResize )

-- On tvOS, we want to make sure we stay awake.
-- We also want to ensure that the menu button exits the app.
if system.getInfo( "platformName" ) == "tvOS" then
	system.activate( "controllerUserInteraction" )
	system.setIdleTimer( false )
end
