
-- Abstract: Twitter
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Twitter", showBuildNum=false } )

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
local twitter = require( "twitter" )
local widget = require( "widget" )

-- Set app font
local appFont = sampleUI.appFont

-- Fill in the following details from your Twitter app account
local consumerKey = ""  -- Key string goes here
local consumerSecret = ""  -- Secret string goes here

-- The web URL address below can be anything, but it should match what you put in your Twitter API setup;
-- Twitter sends the web address with the token back to your app and the code strips out the token
local webURL = "https://coronalabs.com/"

-- Local variables and forward references
local centerX = display.contentCenterX
local userNameMessage
local getInfoMessage
local statusText
local callbackFunctions = {}


-- Twitter callback functions
callbackFunctions.twitterCancel = function()

	statusText.text = "(cancelled by Twitter)"
	statusText:setFillColor( 1, 0, 0.2 )
end

callbackFunctions.twitterSuccess = function( requestType, name, response )

	statusText.text = "success"
	statusText:setFillColor( 1 )

	local results = ""
	if ( "friends" == requestType ) then
		results = response.users[1].name .. ", count: " .. response.users[1].statuses_count
	end
	
	if ( "users" == requestType ) then
		results = response.name .. ", count: " .. response.statuses_count
	end

	if ( "tweet" == requestType ) then
		results = "tweet posted"
	end

	getInfoMessage.text = results
	getInfoMessage:setFillColor( 1 )

	userNameMessage.text = name
	userNameMessage:setFillColor( 1 )
end

callbackFunctions.twitterFailed = function()

	statusText.text = "failed (invalid token)"
	statusText:setFillColor( 1, 0, 0.2 )
end


-- Handle button events
local function buttonRelease( event )

	local id = event.target.id

	if ( "getinfo" == id ) then

		local params = { "users", "users/show.json", "GET", { "screen_name", "SELF" }, { "skip_status", "true" }, { "include_entities", "false" } }
		twitter.tweet( callbackFunctions, params )

	elseif ( "tweet" == id ) then

		local time = os.date( "*t" )  -- Get time to append to the tweet
		local value = "Posted from Corona at coronalabs.com at " .. time.hour .. ":" .. time.min .. "." .. time.sec
		local params = { "tweet", "statuses/update.json", "POST", { "status", value } }
		twitter.tweet( callbackFunctions, params )

	elseif ( "friend" == id ) then

		local params = { "friends", "followers/list.json", "GET", { "skip_status", "true" } }
		twitter.tweet( callbackFunctions, params )
	end
end


-- Create buttons
local getInfoButton = widget.newButton(
	{
		label = "Get Info",
		id = "getinfo",
		shape = "rectangle",
		x = centerX,
		y = 75,
		width = 188,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.08,0.28,0.48,1 }, over={ 0.08,0.28,0.48,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonRelease
	})
getInfoButton:setEnabled( false )
getInfoButton.alpha = 0.3
mainGroup:insert( getInfoButton )

local tweetButton = widget.newButton(
	{
		label = "Tweet",
		id = "tweet",
		shape = "rectangle",
		x = getInfoButton.x,
		y = getInfoButton.y + 50,
		width = 188,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.08,0.28,0.48,1 }, over={ 0.08,0.28,0.48,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonRelease
	})
tweetButton:setEnabled( false )
tweetButton.alpha = 0.3
mainGroup:insert( tweetButton )

local friendButton = widget.newButton(
	{
		label = "Friend",
		id = "friend",
		shape = "rectangle",
		x = tweetButton.x,
		y = tweetButton.y + 50,
		width = 188,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.08,0.28,0.48,1 }, over={ 0.08,0.28,0.48,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonRelease
	})
friendButton:setEnabled( false )
friendButton.alpha = 0.3
mainGroup:insert( friendButton )


-- Check that user entered app key and secret above
if ( consumerKey == "" or consumerSecret == "" ) then

	-- Display an alert
	local alert = native.showAlert( "Error", 'Confirm that you have specified your unique Twitter API key and secret within "main.lua" on lines 34 and 35.', { "OK", "Help" },
			function( event )
				if ( event.action == "clicked" and event.index == 2 ) then
					system.openURL( "https://dev.twitter.com/" )
				end
			end )
else
	-- Initialize Twitter module
	twitter.init( consumerKey, consumerSecret, webURL )

	-- Enable buttons
	getInfoButton:setEnabled( true )
	getInfoButton.alpha = 1
	tweetButton:setEnabled( true )
	tweetButton.alpha = 1
	friendButton:setEnabled( true )
	friendButton.alpha = 1
end


-- Text object to display screen name
userNameMessage = display.newText( { parent=mainGroup, text="(name)", x=centerX, y=friendButton.y+75, width=display.actualContentWidth-40, font=appFont, fontSize=18, align="center" } )
userNameMessage:setFillColor( 0.5 )

-- Text object to display information from Twitter
getInfoMessage = display.newText( { parent=mainGroup, text="(info)", x=centerX, y=userNameMessage.y+75, width=display.actualContentWidth-40, font=appFont, fontSize=18, align="center" } )
getInfoMessage:setFillColor( 0.5 )

-- Text object to display status
statusText = display.newText( { parent=mainGroup, text="(status)", x=centerX, y=getInfoMessage.y+75, width=display.actualContentWidth-40, font=appFont, fontSize=18, align="center" } )
statusText:setFillColor( 0.5 )
