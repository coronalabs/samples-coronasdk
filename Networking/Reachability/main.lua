-- Project: Reachability
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract:  Sample code for detecting Network Status (Wifi vs. Cellular connection)
--
-- Demonstrates:
--	Uses the Reachability library for iOS to detect a network connection and to
--	determine the type of connection (WiFi vs. Cellular). The connection type is
--	important when streaming high bandwidth media (e.g. video).
--
--	APIs used:
--		network.canDetectNetworkStatusChanges
--		network.setStatusListener
--		native UI objects
--
-- File dependencies: none
--
-- Target devices: Mac Simulator and iOS device
--
-- Limitations: Does not run on Windows or Android. Limited functions on Mac Simulator.
--
-- Update History:
--	v1.0	6/1/2011		Initial sample code release
--
-- Comments: 
--	The sample code uses a default URL to determine the network connection status.
--	A network status event occurs and the screen is updated with the event information
--	along with a text message showing the type of connection (red for no connection,
--	yellow for cellular, and green for wifi).
--	When running on an iOS device, you can enter in a new URL for testing.
--
--	There currently is bug (Apple OS?) that causes URLs with subfolders ("www.apple.com/xyz")
--	to fail to show a connection when running on a cellular connection.
--
--	Note: The sample will work on the Mac simulator but the event results are displayed
--	in the terminal instead of on the device.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

display.setStatusBar( display.HiddenStatusBar )		-- hide status bar
io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console

if "Android" == system.getInfo("platformName") then
	native.showAlert( "Not Supported", "The Reachability sample is not supported on android devices", { "OK" } )
end

print( system.getInfo( "model" ) )

if "Droid" == system.getInfo("model") or "Nexus One" == system.getInfo("model") or "Sensation" == system.getInfo("model")
	or "Galaxy Tab" == system.getInfo("model") or "Kindle Fire" == system.getInfo("model") or "Nook Color" == system.getInfo("model") then
		native.showAlert( "Warning", "The Reachability sample is not supported on android devices", { "OK" } )
end

--Droid
--Nexus One
--Sensation
--Galaxy Tab
--Kindle Fire
--Nook Color


print();print("<-========================= Program Start =========================->");print()

local defaultURL = "www.yahoo.com"
local eventCount = 0					-- count the number of network events
local MyNetworkReachabilityListener		-- forward reference

--------------------------------
-- Code Execution Start Here
--------------------------------

local background = display.newImage("carbonfiber.jpg", centerX, centerY, true) -- flag overrides large image downscaling

local roundedRect1 = display.newRoundedRect( centerX, 35, 300, 40, 8 )
roundedRect1:setFillColor( 0, 170/255 )

local netStatusRect = display.newRoundedRect( centerX, 145, 300, 40, 8 )
netStatusRect:setFillColor( 1, 0, 0, 170/255 )

t = display.newText( "Network Status Check", centerX, 32, nil, 24 )
t:setFillColor( 1, 1, 0 )

-- Create Status field
netStatus = display.newText( "---", centerX, 145, native.systemFont, 26 )
netStatus:setFillColor( 1, 1, 1 )

-------------------------------------------
-- Text Entry Event handler
--
-- Clear the network event listener when
--  user presses the text input field
--
-- Add new network listener after newFont
--  Url entered
-------------------------------------------

local function urlTextHandler( event )

	if ( "began" == event.phase ) then
		-- This is the "keyboard has appeared" event
		-- In some cases you may want to adjust the interface when the keyboard appears.
		print("removing network event listener")
		network.setStatusListener( urlField.text, nil)
	
	elseif ( "ended" == event.phase ) then
		-- This event is called when the user stops editing a field: for example, when they touch a different field
	
	elseif ( "submitted" == event.phase ) then
		-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
		
		-- Hide keyboard
		native.setKeyboardFocus( nil )
		
		-- Verify the length of the URL entered is long enough
		if string.len( urlField.text ) < 5 then
			native.showAlert( "URL Error", "The URL must be at least five characters!", {"Ok"} )
		end
		
		print("adding network event listener")
		network.setStatusListener( urlField.text, MyNetworkReachabilityListener )		-- setup new listener
	end

end

-- Create Text Input Field
--
urlField = native.newTextField( 130, 105, 240, 30 )
--urlField = native.newTextField( 10, 90, 240, 30 )
if "Win" == system.getInfo("environment") then
	urlField = display.newRect( 10, 90, 240, 30 )
end

urlField.x = centerX
urlField.font = native.newFont( native.systemFontBold, 18 )
urlField.inputType = "url"
urlField.text = defaultURL
urlField:addEventListener( "userInput", urlTextHandler )


-- Create Text Output Box
--
textBox = native.newTextBox( 160, 310, 300, 220 )
--textBox = native.newTextBox( 10, 200, 300, 220 )
if "win" == system.getInfo("environment") then
	textBox = display.newRect( 10, 200, 300, 220 )
	textBoxt = display.newText( "*** Build for device to see event data ***", 15, 210, native.systemFont, 14 )
	textBoxt:setFillColor( 0)
end
textBox.x = centerX
textBox.font = native.newFont( "Courier-Bold", 16 )

-------------------------------------------------
-- Network Reachability Event handler
--
-- Display a message with the connection type.
-- Update the Text Box with event information
-- Display update event counter.
--
-- Note: This listener is called whenever the
-- network connection changes. This listener
-- can be used to control the content/operation
-- based on the connection type.
-------------------------------------------------

function MyNetworkReachabilityListener( event )
		eventCount = eventCount + 1
		
		-- Update the status field
		if event.isReachable then
			if event.isReachableViaWiFi then
				netStatus.text = "W i F i"
				netStatusRect:setFillColor( 0, 1, 0, 170/255 )
			else
				netStatus.text = "C e l l u l a r"
				netStatusRect:setFillColor( 1, 1, 0, 170/255 )
			end
		else
			netStatus.text = "N o  C o n n e c t i o n"
			netStatusRect:setFillColor( 1, 0, 0, 170/255 )
		end
		
		netStatus.x = display.contentWidth / 2

		textBox.text = "Event Count: " .. eventCount
		textBox.text = textBox.text .. "\n" .. "Address: " .. tostring( event.address ) .. "\n"
		textBox.text = textBox.text .. "\n" .. "isReachable:           " .. tostring( event.isReachable )
		textBox.text = textBox.text .. "\n" .. "isConnectionRequired:   " .. tostring( event.isConnectionRequired )
		textBox.text = textBox.text .. "\n" .. "isConnectionOnDemand:   " .. tostring( event.isConnectionOnDemand )
		textBox.text = textBox.text .. "\n" .. "isInteractionRequired:  " .. tostring( event.isInteractionRequired )
		textBox.text = textBox.text .. "\n" .. "isReachableViaCellular: " .. tostring( event.isReachableViaCellular )
		textBox.text = textBox.text .. "\n" .. "isReachableViaWiFi:     " .. tostring( event.isReachableViaWiFi )
		
		-- For terminal display (debug)
        print( "address", event.address )
        print( "isReachable", event.isReachable )
        print("isConnectionRequired", event.isConnectionRequired)
        print("isConnectionOnDemand", event.isConnectionOnDemand)
        print("IsInteractionRequired", event.isInteractionRequired)
        print("IsReachableViaCellular", event.isReachableViaCellular)
        print("IsReachableViaWiFi", event.isReachableViaWiFi) 

end

-- Check to make sure platform supports Network Status change
--
if network.canDetectNetworkStatusChanges then
	if "simulator" == system.getInfo("environment") then
        network.setStatusListener( "apple.com", MyNetworkReachabilityListener )
    else
		network.setStatusListener( urlField.text, MyNetworkReachabilityListener )
	end

else
		textBox.text = "Network Reachability not supported!"
        print("network reachability not supported on this platform")
end
