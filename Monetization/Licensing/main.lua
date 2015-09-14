-- Abstract: Store Licensing sample project
--
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- This sample app will not work correctly unless it is built and uploaded to the google play store, although you don't have to publish it.
-- You also have to put in your own key into the config.lua file.
-- It might take the play store a few hours to register your uploaded app.  During this time you will get a "Not market managed" error.
--
-- History
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

local widget = require( "widget" )

display.setDefault( "background", 100/255 )

local response = display.newText( "Waiting for verification...", display.contentCenterX, 70, native.systemFont, 18)

-- Load Corona 'licensing' library
local licensing = require "licensing"

-- The name of the licensing provider.
local provider = "google"
local store = require("store")
if store.target == provider then
   licensing.init( provider )
end
-- Initializes the licensing module for this particular provider.

local t = {}
function t:licensing( event )
	--Prints the name of this event, "licensing".
	print(event.name)
	--Prints the name of the provider for this licensing instance, "google"
	print(event.provider)
	--Prints true if it has been verified else it prints false.
	print(event.isVerified)
	--Prints true if there was an error during verification else it will return nil.  Errors can be anything from configuration errors to network errors.
	print(event.isError)
	--Prints the type of error, "configuration" or "network".  If there was no error then this will return nil.
	print(event.errorType)
	--Prints a translated response from the licensing server.
	print(event.response)
	--Prints the expiration time of the expiration time of the cached license.
	print(event.expiration)

	local verifiedText = "NOT verified :("
	if event.isVerified then
		verifiedText = "Verified! :)"
	end
	response.text = verifiedText
end

--Once the button is pressed, the license will try to verify
local buttonHandler = function ( event )
	-- If the target store isn't for this provider then the verify will not call the listener.
	if store.target == provider and event.phase == "ended" then
	   licensing.verify( t )
	end
end


local verifyButton = widget.newButton
{
	top = 20,
	id = "verifyButton",
	label = "Verify",
	labelColor = 
	{ 
		default = { 51/255, 51/255, 51/255 },
	},
	fontSize = 22,
	onEvent = buttonHandler,
}
