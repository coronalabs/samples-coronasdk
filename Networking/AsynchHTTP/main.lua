-- Project: AsynchHTTP
--
-- Date: January 4, 2011
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Uses an asychronous HTTPS call to make a network request over SSL.
-- This feature exposes native OS network functionality, and includes both HTTP and HTTPS/SSL support. 
-- For large responses, use network.download() to save to a file rather than loading into memory. 
-- See the "AsynchImageDownload" sample project for more on network.download.
--
-- Demonstrates: network.request API
--
-- File dependencies: none
--
-- Target devices: Corona Simulator and iOS devices
--
-- Limitations: Requires internet access
--
-- Update History:
--
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local json = require("json")

-- Access Google over SSL:
local url = "https://encrypted.google.com"

local myTitle = display.newText("AsyncHTTP", display.contentCenterX, 15, native.systemFont, 20)
local myText = display.newText("(Waiting for response)", display.contentCenterX, 45, native.systemFont, 14)

local myInfoBackground = display.newRect( display.contentCenterX, display.contentCenterY + 30, display.contentWidth - 20, 400 )
local myInfo = display.newText("", myInfoBackground.x, myInfoBackground.y, myInfoBackground.width - 10, myInfoBackground.height - 10, "Courier New", 8)
myInfo:setFillColor( 0, 0, 0 )

local function networkListener( event )
	if ( event.isError ) then
		myText.text = "Network error!"
		myInfo.text = "networkRequest event: " .. json.prettify(event)

	else
		local rawResponse = event.response

		myText.text = "Server responded with HTTP status " .. event.status
		event.response = "<data from retrieved URL is available here>"
		myInfo.text = "networkRequest event: " .. json.prettify(event) .. "\n\n(see console for complete network event)"

		print ( "networkRequest event: " .. json.prettify(event) )
		print ( "RESPONSE: " .. tostring(rawResponse) )
	end
end

myInfo.text = "Requesting " .. url .. " ..."

network.request( url, "GET", networkListener )
