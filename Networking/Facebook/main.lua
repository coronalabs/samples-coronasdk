-- 
-- Project: Facebook Connect sample app
--
-- Date: December 24, 2010
--
-- Version: 1.6
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Presents the Facebook Connect login dialog, and then posts to the user's stream
-- (Also demonstrates the use of external libraries.)
--
-- Demonstrates: webPopup, network, Facebook library
--
-- File dependencies: facebook.lua
--
-- Target devices: Simulator and Device
--
-- Limitations: Requires internet access; no error checking if connection fails
--
-- Update History:
--	v1.1		Layout adapted for Android/iPad/iPhone4
--  v1.2		Modified for new Facebook Connect API (from build #243)
--  v1.3		Added buttons to: Post Message, Post Photo, Show Dialog, Logout
--  v1.4		Added  ...{"publish_stream"} .. permissions setting to facebook.login() calls.
--	v1.5		Added single sign-on support in build.settings (must replace XXXXXXXXX with valid facebook appId)
--	v1.6		Modified the build.settings file to get the plugin for iOS.

--
-- Comments:
-- Requires API key and application secret key from Facebook. To begin, log into your Facebook
-- account and add the "Developer" application, from which you can create additional apps.
--
-- IMPORTANT: Please ensure your app is compatible with Facebook Single Sign-On or your
--			  Facebook implementation will fail! See the following blog post for more details:
--			  https://www.coronalabs.com/links/facebook-sso
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

-- Comment out the next line when through debugging your app.
io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console **tjn

local widget = require("widget")
local facebook = require("facebook")
local json = require("json")

display.setStatusBar( display.HiddenStatusBar )
	
-- Facebook Commands
local fbCommand			-- forward reference
local LOGOUT = 1
local SHOW_DIALOG = 2
local POST_MSG = 3
local POST_PHOTO = 4
local GET_USER_INFO = 5
local GET_PLATFORM_INFO = 6

-- Layout Locations
local ButtonOrigY = 175
local ButtonYOffset = 45
local StatusMessageY = 420		-- position of status message

local background = display.newImage( "facebook_bkg.png", centerX, centerY, true ) -- flag overrides large image downscaling

-- This function is useful for debugging problems with using FB Connect's web api,
-- e.g. you passed bad parameters to the web api and get a response table back
local function printTable( t, label, level )
	if label then print( label ) end
	level = level or 1

	if t then
		for k,v in pairs( t ) do
			local prefix = ""
			for i=1,level do
				prefix = prefix .. "\t"
			end

			print( prefix .. "[" .. tostring(k) .. "] = " .. tostring(v) )
			if type( v ) == "table" then
				print( prefix .. "{" )
				printTable( v, nil, level + 1 )
				print( prefix .. "}" )
			end
		end
	end
end

local function createStatusMessage( message, x, y )
	-- Show text, using default bold font of device (Helvetica on iPhone)
	local textObject = display.newText( message, 0, 0, native.systemFontBold, 24 )
	textObject:setFillColor( 1,1,1 )

	-- A trick to get text to be centered
	local group = display.newGroup()
	group.x = x
	group.y = y
	group:insert( textObject, true )

	-- Insert rounded rect behind textObject
	local r = 10
	local roundedRect = display.newRoundedRect( 0, 0, textObject.contentWidth + 2*r, textObject.contentHeight + 2*r, r )
	roundedRect:setFillColor( 55/255, 55/255, 55/255, 190/255 )
	group:insert( 1, roundedRect, true )

	group.textObject = textObject
	return group
end

local statusMessage = createStatusMessage( "   Not connected  ", centerX, StatusMessageY )

-- New Facebook Connection listener
--
local function listener( event )

--- Debug Event parameters printout --------------------------------------------------
--- Prints Events received up to 20 characters. Prints "..." and total count if longer
---
	print( "Facebook Listener events:" )
	
	local maxStr = 20		-- set maximum string length
	local endStr
	
	for k,v in pairs( event ) do
		local valueString = tostring(v)
		if string.len(valueString) > maxStr then
			endStr = " ... #" .. tostring(string.len(valueString)) .. ")"
		else
			endStr = ")"
		end
		print( "   " .. tostring( k ) .. "(" .. tostring( string.sub(valueString, 1, maxStr ) ) .. endStr )
	end
--- End of debug Event routine -------------------------------------------------------

    print( "event.name", event.name ) -- "fbconnect"
    print( "event.type:", event.type ) -- type is either "session" or "request" or "dialog"
	print( "isError: " .. tostring( event.isError ) )
	print( "didComplete: " .. tostring( event.didComplete) )
-----------------------------------------------------------------------------------------
	-- After a successful login event, send the FB command
	-- Note: If the app is already logged in, we will still get a "login" phase
	--
    if ( "session" == event.type ) then
        -- event.phase is one of: "login", "loginFailed", "loginCancelled", "logout"
		statusMessage.textObject.text = event.phase		-- tjn Added
		
		print( "Session Status: " .. event.phase )
		
		if event.phase ~= "login" then
			-- Exit if login error
			return
		end
		
		-- The following displays a Facebook dialog box for posting to your Facebook Wall
		if fbCommand == SHOW_DIALOG then

			-- "feed" is the standard "post status message" dialog
			facebook.showDialog( "feed", {
				name = "Test name",
				description = "Example description.",
				link = "http://www.coronasdk.com/"
			})

			-- for "apprequests", message is required; other options are supported
			--[[
			facebook.showDialog( "apprequests", {
				message = "Example message."
			})
			--]]
		end
	
		-- Request the Platform information (FB information)
		if fbCommand == GET_PLATFORM_INFO then
			facebook.request( "platform" )		-- **tjn Displays info about Facebook platform
		end

		-- Request the current logged in user's info
		if fbCommand == GET_USER_INFO then
			facebook.request( "me" )
--			facebook.request( "me/friends" )		-- Alternate request
		end

		-- This code posts a photo image to your Facebook Wall
		--
		if fbCommand == POST_PHOTO then
			local attachment = {
				name = "Developing a Facebook Connect app using the Corona SDK!",
				link = "https://www.coronalabs.com/links/forum",
				caption = "Link caption",
				description = "Corona SDK for developing iOS and Android apps with the same code base.",
				picture = "https://www.coronalabs.com/links/demo/Corona90x90.png",
				actions = json.encode( { { name = "Learn More", link = "http://coronalabs.com" } } )
			}
		
			facebook.request( "me/feed", "POST", attachment )		-- posting the photo
		end
		
		-- This code posts a message to your Facebook Wall
		if fbCommand == POST_MSG then
			local time = os.date("*t")
			local postMsg = {
				message = "Posting from Corona SDK! " ..
					os.date("%A, %B %e")  .. ", " .. time.hour .. ":"
					.. time.min .. "." .. time.sec
			}
		
			facebook.request( "me/feed", "POST", postMsg )		-- posting the message
		end
-----------------------------------------------------------------------------------------

    elseif ( "request" == event.type ) then
        -- event.response is a JSON object from the FB server
        local response = event.response
        
		if ( not event.isError ) then
	        response = json.decode( event.response )
	        
	        if fbCommand == GET_USER_INFO then
				statusMessage.textObject.text = response.name
				printTable( response, "User Info", 3 )
				print( "name", response.name )
				
			elseif fbCommand == POST_PHOTO then
				printTable( response, "photo", 3 )
				statusMessage.textObject.text = "Photo Posted"
							
			elseif fbCommand == POST_MSG then
				printTable( response, "message", 3 )
				statusMessage.textObject.text = "Message Posted"
				
			else
				-- Unknown command response
				print( "Unknown command response" )
				statusMessage.textObject.text = "Unknown ?"
			end

        else
        	-- Post Failed
			statusMessage.textObject.text = "Post failed"
			printTable( event.response, "Post Failed Response", 3 )
		end
		
	elseif ( "dialog" == event.type ) then
		-- showDialog response
		--
		print( "dialog response:", event.response )
		statusMessage.textObject.text = event.response
    end
end

---------------------------------------------------------------------------------------------------
-- NOTE: To create a mobile app that interacts with Facebook Connect, first log into Facebook
-- and create a new Facebook application. That will give you the "API key" and "application secret" 
-- that should be used in the following lines:

local appId  = nil	-- Add  your App ID here (also go into build.settings and replace XXXXXXXXX with your appId under CFBundleURLSchemes)
local apiKey = nil	-- Not needed at this time
---------------------------------------------------------------------------------------------------


-- NOTE: You must provide a valid application id provided from Facebook

if ( appId ) then
	facebook.login( appId, listener )
	-- ***
	-- ************************ Buttons Functions ********************************
	-- ***
	local function postPhoto_onRelease( event )
		-- call the login method of the FB session object, passing in a handler
		-- to be called upon successful login.
		fbCommand = POST_PHOTO
		facebook.login( appId, listener,  {"publish_actions"}  )
	end
	
	local function getInfo_onRelease( event )
		-- call the login method of the FB session object, passing in a handler
		-- to be called upon successful login.
		fbCommand = GET_USER_INFO
		facebook.login( appId, listener, {"publish_actions"}  )
	end
	
	local function postMsg_onRelease( event )
		-- call the login method of the FB session object, passing in a handler
		-- to be called upon successful login.
		fbCommand = POST_MSG
		facebook.login( appId, listener, {"publish_actions"} )
	end
	
	local function showDialog_onRelease( event )
		-- call the login method of the FB session object, passing in a handler
		-- to be called upon successful login.
		fbCommand = SHOW_DIALOG
		facebook.login( appId, listener, {"publish_actions"}  )
	end
	
	local function logOut_onRelease( event )
		-- call the login method of the FB session object, passing in a handler
		-- to be called upon successful login.
		fbCommand = LOGOUT
		facebook.logout()
	end

	-- ***
	-- ************************ Create Buttons ********************************
	-- ***
	
	-- "Post Photo with Facebook" button
	local fbButton = widget.newButton
	{
		defaultFile = "fbButton184.png",
		overFile = "fbButtonOver184.png",
		label = "  Post Photo",
		labelColor = 
		{ 
			default = { 255, 255, 255 }, 
		},
		onRelease = postPhoto_onRelease,
	}
	fbButton.x = 160
	fbButton.y = ButtonOrigY
	
	
	-- "Post Message with Facebook" button
	local fbButton2 = widget.newButton
	{
		defaultFile = "fbButton184.png",
		overFile = "fbButtonOver184.png",
		label = "Post Msg",
		labelColor = 
		{ 
			default = { 255, 255, 255 }, 
		},
		onRelease = postMsg_onRelease,
	}
	fbButton2.x = 160
	fbButton2.y = ButtonOrigY + ButtonYOffset * 1
	
	
	-- "Show Dialog Info with Facebook" button
	local fbButton3 = widget.newButton
	{
		defaultFile = "fbButton184.png",
		overFile = "fbButtonOver184.png",
		label = "    Show Dialog",
		labelColor = 
		{ 
			default = { 255, 255, 255 }, 
		},
		onRelease = showDialog_onRelease,
	}
	fbButton3.x = 160
	fbButton3.y = ButtonOrigY + ButtonYOffset * 2

	
	-- "Get User Info with Facebook" button
	local fbButton4 = widget.newButton
	{
		defaultFile = "fbButton184.png",
		overFile = "fbButtonOver184.png",
		label = "Get User",
		labelColor = 
		{ 
			default = { 255, 255, 255 }, 
		},
		onRelease = getInfo_onRelease,
	}
	fbButton4.x = 160
	fbButton4.y = ButtonOrigY + ButtonYOffset * 3
	
	-- "Logout with Facebook" button
	local fbButton5 = widget.newButton
	{
		defaultFile = "fbButton184.png",
		overFile = "fbButtonOver184.png",
		label = "Logout",
		labelColor = 
		{ 
			default = { 255, 255, 255 }, 
		},
		onRelease = logOut_onRelease,
	}
	fbButton5.x = 160
	fbButton5.y = ButtonOrigY + ButtonYOffset * 4
else
	-- Handle the response from showAlert dialog boxbox
	--
	local function onComplete( event )
		if event.index == 1 then
			system.openURL( "http://developers.facebook.com/docs/guides/canvas/" )
		end
	end

	native.showAlert( "Error", "To develop for Facebook Connect, you need to get an API key and application secret. This is available from Facebook's website.",
		{ "Learn More", "Cancel" }, onComplete )
end