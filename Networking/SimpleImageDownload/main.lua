-- Project: SimpleImageDownload
--
-- Date: August 19, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: A simple way to load an image from the network
-- (Also demonstrates the use of external libraries.)
--
-- Demonstrates: sockets, network, ActivityIndicator
--
-- File dependencies: 
--
-- Target devices: Simulator and Device
--
-- Limitations: Requires internet access; no error checking if connection fails
--
-- Update History:
--	v1.1		Added ActivityIndicator during download; also app title on screen
--
-- Comments: 
-- Demonstrates how to download and display a remote image using the LuaSocket
-- libraries that ship with Corona. 
--
-- Note that this method blocks program execution during the download process. 
-- This can be addressed using Lua coroutines for a more "threaded" structure; 
-- future example code should demonstrate this.
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

-- Load the relevant LuaSocket modules (no additional files required for these)
local http = require("socket.http")
local ltn12 = require("ltn12")

local widget = require("widget")

-- Comes here after starting the HTTP image load
--
function showImage()

	-- We need to turn off the Activity Indicator in a different chunk
	native.setActivityIndicator( false )
	
	-- Normally we would io.close(myFile) but ltn12.sink.file does this for us.

	-- Display local file
	testImage = display.newImage("hello.png",system.DocumentsDirectory,display.contentCenterX,200);
end

-- Load the image from the network
--
-- Turn on the Activity Indicator showing download
--
function loadImage()
	-- Create local file for saving data
	local path = system.pathForFile( "hello.png", system.DocumentsDirectory )
	local myFile = io.open( path, "w+b" ) 
	
	native.setActivityIndicator( true )		-- show busy

	-- Request remote file and save data to local file
	http.request{ 
    	url = "https://developer.coronalabs.com/demo/hello.png",
    	sink = ltn12.sink.file(myFile),
	}

	-- Call the showImage function after a short time dealy
	timer.performWithDelay( 400, showImage)
end

-- Add demo button to screen
button1 = widget.newButton
{
	defaultFile = "btn.png", 
	overFile = "btnA.png", 
	onRelease = loadImage
}
button1.x = 160
button1.y = 360

-- Add label for button
b1text = display.newText( "Click To Load", 160, 360, nil, 15 )
b1text:setFillColor( 45/255, 45/255, 45/255, 1 )

-- Displays App title
title = display.newText( "Simple Image Download", 0, 30, native.systemFontBold, 20 )
title.x = display.contentWidth/2		-- center title
title:setFillColor( 1, 1, 0 )

