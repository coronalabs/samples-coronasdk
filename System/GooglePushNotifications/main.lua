-- Project: GooglePushNotifications
--
-- File name: main.lua
--
-- Author: Corona Labs Inc.
--
-- This sample app demonstrates how to send and receive push notifications via the
-- Google Cloud Messaging service (aka: GCM).
-- See the "build.settings" file to see what Android permissions are required.
-- See the "config.lua" file on how to register for push notifications with Google.
-- See the following website on how to set up your app for Google's push notification system.
--   https://developer.android.com/google/gcm/gs.html
--
-- Limitations: This sample app only works on an Android device with "Google Play" installed.
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2012 Corona Labs Inc. All Rights Reserved.
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

-- A Google API Key is needed to send push notifications. It is not needed to receive notifications.
-- This number can be obtained from the Firebase Console https://console.firebase.google.com/
-- Select your project -> (Gear Icon) -> Project Settings -> Cloud Messaging -> Server key
local serverKey = "Your API key goes here."

-- A Google registration ID (also know as Device Token) is also needed to send push notifications.
-- This key will be obtained by the notification listener below after this app has successfully
-- registered with Google. See the "config.lua" file on how to register this app with Google.
local googleRegistrationId = nil


-- Show the status bar so that we can easily access the received notifications.
display.setStatusBar(display.DefaultStatusBar)

-- Set up the background.
local background = display.newRect(centerX, centerY, display.contentWidth, display.contentHeight)
background:setFillColor(0.5, 0, 0)

local boxY = centerY
local textY = boxY - 1
local box = display.newRoundedRect( centerX, boxY, display.contentWidth - 20, 30, 6 )
box:setFillColor( 0.5, 0.5, 0.5, 0.5 )
local msg

if system.getInfo("platformName") ~= "Android" then
	msg = display.newText( "Google Push Notifications only on Android", centerX, textY, native.systemFontBold, 12 )
	msg:setFillColor( 1, 0, 0 )
elseif serverKey == "Your API key goes here." then
	msg = display.newText( "Google Push Notifications need to be configured", centerX, textY, native.systemFontBold, 12 )
	msg:setFillColor( 0, 0, 1 )
else
	-- Display instructions.
	msg = display.newText("Tap the screen to push a notification", centerX, textY, native.systemFont, 18)
	msg:setFillColor(1, 1, 1)
end


-- Called when a sent notification has succeeded or failed.
local function onSendNotification(event)
	local errorMessage = nil

	-- Determine if we have successfully sent the notification to Google's server.
	if event.isError then
		-- Failed to connect to the server.
		-- This typically happens due to lack of Internet access.
		errorMessage = "Failed to connect to the server."

	elseif event.status == 200 then
		-- A status code of 200 means that the notification was sent succcessfully.
		print("Notification was sent successfully.")

	elseif event.status == 400 then
		-- There was an error in the sent notification's JSON data.
		errorMessage = event.response

	elseif event.status == 401 then
		-- There was a user authentication error.
		errorMessage = "Failed to authenticate the sender's Google Play account."

	elseif (event.status >= 500) and (event.status <= 599) then
		-- The Google Cloud Messaging server failed to process the given notification.
		-- This indicates an internal error on the server side or the server is temporarily unavailable.
		-- In this case, we are supposed to silently fail and try again later.
		errorMessage = "Server failed to process the request. Please try again later."
	end

	-- Display an error message if there was a failure.
	if errorMessage then
		native.showAlert("Notification Error", errorMessage, { "OK" })
	end
end

-- Sends the given JSON message to the Google Cloud Messaging server to be pushed to Android devices.
local function sendNotification(jsonMessage)
	-- Do not continue if a Google API Key was not provided.
	if not serverKey then
		return
	end

	-- Print the JSON message to the log.
	print("--- Sending Notification ----")
	print(jsonMessage)

	-- Send the push notification to this app.
	local url = "https://android.googleapis.com/gcm/send"
	local parameters =
	{
		headers =
		{
			["Authorization"] = "key=" .. serverKey,
			["Content-Type"] = "application/json",
		},
		body = jsonMessage,
	}
	network.request(url, "POST", onSendNotification, parameters)
end

-- Sends a push notification when the screen has been tapped.
local function onTap(event)
	-- Do not continue if this app has not been registered for push notifications yet.
	if not googleRegistrationId then
		return
	end

	-- Set up a JSON message to send a push notification to this app.
	-- The "registration_ids" tells Google to whom this push notification should be delivered to.
	-- The "alert" field sets the message to be displayed when the notification has been received.
	-- The "sound" field is optional and will play a sound file in the app's ResourceDirectory.
	-- The "custom" field is optional and will be delivered by the notification event's "event.custom" property.
	local jsonMessage =
[[
{
	"registration_ids": ["]] .. tostring(googleRegistrationId) .. [["],
	"data":
	{
		"alert": "Hello World!",
		"sound": "notification.wav",
		"custom":
		{
			"boolean": true,
			"number": 123.456,
			"string": "Custom data test.",
			"array": [ true, false, 0, 1, "", "This is a test." ],
			"table": { "x": 1, "y": 2 }
		}
	}
}
]]
	sendNotification(jsonMessage)
end
Runtime:addEventListener("tap", onTap)

-- Prints all contents of a Lua table to the log.
local function printTable(table, stringPrefix)
	if not stringPrefix then
		stringPrefix = "### "
	end
	if type(table) == "table" then
		for key, value in pairs(table) do
			if type(value) == "table" then
				print(stringPrefix .. tostring(key))
				print(stringPrefix .. "{")
				printTable(value, stringPrefix .. "   ")
				print(stringPrefix .. "}")
			else
				print(stringPrefix .. tostring(key) .. ": " .. tostring(value))
			end
		end
	end
end

-- Called when a notification event has been received.
local function onNotification(event)
	if event.type == "remoteRegistration" then
		-- This device has just been registered for Google Cloud Messaging (GCM) push notifications.
		-- Store the Registration ID that was assigned to this application by Google.
		googleRegistrationId = event.token

		-- Display a message indicating that registration was successful.
		local message = "This app has successfully registered for Google push notifications."
		native.showAlert("Information", message, { "OK" })

		-- Print the registration event to the log.
		print("### --- Registration Event ---")
		printTable(event)

	else
		-- A push notification has just been received. Print it to the log.
		print("### --- Notification Event ---")
		printTable(event)
	end
end

-- Set up a notification listener.
Runtime:addEventListener("notification", onNotification)

-- Print this app's launch arguments to the log.
-- This allows you to view what these arguments provide when this app is started by tapping a notification.
local launchArgs = ...
print("### --- Launch Arguments ---")
printTable(launchArgs)

