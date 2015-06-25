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

local myText = display.newText("(Waiting for response)", display.contentCenterX, 120, native.systemFont, 16)

local function networkListener( event )
	if ( event.isError ) then
		myText.text = "Network error!"
	else
		myText.text = "See Corona Terminal for response"
		print ( "RESPONSE: " .. event.response )
	end
end

-- Access Google over SSL:
network.request( "https://encrypted.google.com", "GET", networkListener )
