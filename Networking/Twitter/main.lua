-- Project: Twitter sample app
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Demonstrates how to connect to Twitter using Oauth Authenication.
--
-- File dependencies: TwiterManager.lua, oAuth.lua
--
-- Target devices: simulator, device
--
-- Limitations: Requires internet access; no error checking if connection fails
--
-- Update History:
--	March 5, 2013	Updated for Twitter v1.1 API and oAuth 1.0a
--
-- Comments:
-- Requires API key and application secret key from Twitter. To begin, log into your Twiter
-- account and add the "Developer" application, from which you can create additional apps.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2012-2013 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console

local TwitterManager = require( "Twitter" )
local widget = require( "widget" )

-- Layout Locations
local StatusMessageY = 420		-- position of status message

local background = display.newImage( "tweetscreen.jpg", display.contentCenterX, display.contentCenterY )

--------------------------------
-- Create Status Message area
--------------------------------
--
local function createStatusMessage( message, x, y )
	-- Show text, using default bold font of device (Helvetica on iPhone)
	local textObject = display.newText( message, 0, 0, native.systemFontBold, 24 )
	textObject:setFillColor( 1, 1, 1 )

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

local statusMessage = createStatusMessage( "   Not connected  ", 0.5*display.contentWidth, StatusMessageY )

-- Initialize text object to display Screen Name
local userNameMessage = display.newText( "", 0, 0, native.systemFontBold, 18 )
userNameMessage.x = display.contentCenterX
userNameMessage.y = display.contentHeight - 30

-- Initialize text object to display Get Information from Twitter
local getInfoMessage = display.newText( "info", 0, 0, native.systemFontBold, 20 )
getInfoMessage.x = display.contentCenterX
getInfoMessage.y = display.contentHeight - 300

local callback = {}

-- Callbacks
function callback.twitterCancel()
	print( "Twitter Cancel" )
	statusMessage.textObject.text = "Twitter Cancel"
end

-----------------------------------------------------------------
-- Successful Twitter Callback
--
-- Determine the request type and update the display
-----------------------------------------------------------------
--
function callback.twitterSuccess( requestType, name, response )
	local results = ""
	
	print( "Twitter Success" )
	statusMessage.textObject.text = "Twitter Success"

	if "friends" == requestType then
		results = response.users[1].name .. ", count: " ..
			response.users[1].statuses_count
	end
	
	if "users" == requestType then
		results = response.name .. ", count: " ..
			response.statuses_count
	end

	if "tweet" == requestType then
		results = "Tweet Posted"
	end

	print( results )
	getInfoMessage.text = results	
	userNameMessage.text = name

end

function callback.twitterFailed()
	print( "Failed: Invalid Token" )
	statusMessage.textObject.text = "Failed: Invalid Token"
end

--------------------------------
-- Tweet the message
--------------------------------
--
local function tweetit( event )
	local time = os.date( "*t" )		-- Get time to append to our tweet
	local value = "Posted from Corona SDK at www.coronalabs.com at " ..time.hour .. ":"
			.. time.min .. "." .. time.sec
			
	local params = {"tweet", "statuses/update.json", "POST",
		{"status", value} }
	TwitterManager.tweet(callback, params)
end


--------------------------------
-- Get Account Info
-- for current screen name
--------------------------------
--
local function getInfo( event )
	local params = {"users", "users/show.json", "GET",
		{"screen_name", "SELF"}, {"skip_status", "true"},
		{"include_entities", "false"} }
	TwitterManager.tweet(callback, params)
end

--------------------------------
-- Get Friend Info
--------------------------------
--
local function getFriend( event )
	local params = {"friends", "followers/list.json", "GET",
		{"skip_status", "true"} }
	TwitterManager.tweet(callback, params)
end

--------------------------------
-- Create "Tweet" Button
--------------------------------
--
twitterButton = widget.newButton
{
	left = 380,
	top = 350,
	width = 140,
	height = 50,
	id = "button1",
	defaultFile = "smallButton.png",
	overFile = "smallButtonOver.png",
	label = "Tweet",
	fontSize = 34,
	onRelease = tweetit
}
twitterButton.x = display.contentWidth / 2

--------------------------------
-- Create "Get Info" Button
--------------------------------
--
-- Created without images
--
twitterGetButton = widget.newButton
{
	left = 380,
	top = 285,
	width = 140,
	height = 50,
	id = "button1",
	defaultFile = "smallButton.png",
	overFile = "smallButtonOver.png",
	label = "Get Info",
	fontSize = 34,
	onRelease = getInfo
}
twitterGetButton.x = display.contentWidth / 2

--------------------------------
-- Create "Get Info" Button
--------------------------------
--
-- Created without images
--
twitterFriendButton = widget.newButton
{
	left = 380,
	top = 220,
	width = 140,
	height = 50,
	id = "button1",
	defaultFile = "smallButton.png",
	overFile = "smallButtonOver.png",
	label = "Friend",
	fontSize = 34,
	onRelease = getFriend
}
twitterFriendButton.x = display.contentWidth / 2

