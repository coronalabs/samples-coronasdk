--==================================================================================================
-- 
-- Abstract: iAds Sample Project
-- 
-- This project demonstrates Corona Banner Ads support (from the iAds network).
--
-- IMPORTANT: You must have your app defined in iTunes Connect in order to be able to display banner ads.
-- Further, you must build for device to properly test this sample, because "ads" library is not 
-- supported by the Corona Simulator.
--
--   1. Get your app ID (ex. com.mycompany.myproduct)
--   2. Modify the code below to use your own app ID 
--   3. Build and deploy on device (or Xcode simulator)
--
-- The code below demonstrates the different banner ads you can use
-- with the iAds ad network.
--
-- Version: 1.0 (December 21, 2012)
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2012 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
--==================================================================================================

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- Include the widget library
local widget = require( "widget" )

-- The name of the ad provider.
local adNetwork = "iads"

-- Replace with your own application ID
local appID = "com.company.product"

-- Load Corona 'ads' library
local ads = require "ads"

--------------------------------------------------------------------------------
-- Setup ad provider
--------------------------------------------------------------------------------

-- Create a text object to display ad status
local statusText 

-- Set up ad listener.
local function adListener( event )
	-- event table includes:
	-- 		event.provider
	--		event.isError (e.g. true/false )
	--		event.response - the localized description of the event (error or confirmation message)

	local msg = event.response

	-- just a quick debug message to check what response we got from the library
	print("Message received from the ads library: ", msg)

	if event.isError then
		statusText:setFillColor( 1, 0, 0 )
		statusText.text = msg
		
	else
		statusText:setFillColor( 0, 1, 0 )
		statusText.text = msg
	end
end

-- Initialize the 'ads' library with the provider you wish to use.
if appID then
	ads.init( adNetwork, appID, adListener )
end

--------------------------------------------------------------------------------
-- UI
--------------------------------------------------------------------------------

-- initial variables
local sysModel = system.getInfo("model")
local sysEnv = system.getInfo("environment")

-- create a background for the app
local backgroundImg = display.newImageRect( "space.png", display.contentWidth, display.contentHeight )
backgroundImg.anchorX = 0
backgroundImg.anchorY = 0
backgroundImg.x, backgroundImg.y = 0, 0

-- the two buttons
local showBannerButton, showInterstitialButton

-- forward declaration for the showAd function
local showAd

-- Shows a specific type of ad
showAd = function( adType )
	local adX, adY = display.screenOriginX, 0
	statusText.text = "Working..."
	ads.show( adType, { x=adX, y=adY, testMode=true } )
end

-- callback function for the button events

local function onButtonEvent( event )
	
	local currentButton = event.target

	if currentButton.id == 1 then

		if event.phase == "ended" then
			-- state 1 equals the banner is hidden
			if currentButton.state == 1 then
				ads.hide()
				currentButton:setLabel( "Show Banner" )
				currentButton.state = 2
			-- state 2 equals the banner is displayed
			elseif currentButton.state == 2 then
				showAd( "banner" )
				currentButton:setLabel( "Hide Banner" )
				currentButton.state = 1
			end
		end
	
	elseif currentButton.id == 2 then
		if event.phase == "ended" then
				showAd( "interstitial" )
				statusText.text = "Displaying interstitial..."
				showBannerButton:setLabel( "Show Banner" )
				showBannerButton.state = 2
		end

	end


end

-- UI elements

statusText = display.newText( "Idle", 0, 0, display.contentWidth - 50, 60, native.systemFontBold, 14 )
statusText:setFillColor( 1 )
statusText.x, statusText.y = display.contentWidth * 0.5, display.contentHeight - statusText.contentHeight

-- the first button

showBannerButton = widget.newButton
{
	width = 298,
	height = 56,
    label = "Show Banner",
    font = native.systemFontBold,
    fontSize = 15,
	id = 1,
	onEvent = onButtonEvent
}
showBannerButton.x = display.contentCenterX
showBannerButton.y = display.contentCenterY 
showBannerButton.state = 2

-- the second button

showInterstitialButton = widget.newButton
{
	width = 298,
	height = 56,
    label = "Show IBanner",
    font = native.systemFontBold,
    fontSize = 15,
	id = 2,
	state = 2,
	onEvent = onButtonEvent
}
showInterstitialButton.x = display.contentCenterX
showInterstitialButton.y = display.contentCenterY + showBannerButton.contentHeight + 2
showInterstitialButton.state = 2


-- if on simulator, let user know they must build for device
if sysEnv == "simulator" then
	local font, size = native.systemFontBold, 22
	local warningText = display.newText( "Please build for device or Xcode simulator to test this sample.", 0, 0, 290, 300, font, size )
	warningText:setFillColor( 1 )
	warningText.x, warningText.y = display.contentWidth * 0.5, display.contentHeight * 0.5
else

	-- if we want to start displaying the banner ad
	-- showAd( "banner" ) 
	
end
