-- Project: ComposeEmailSMS
--
-- Date: January 17, 2012
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs, Inc.
--
-- Abstract: Native E-mail and SMS client's compose feature is shown, pre-populated with
-- text, recipients, and attachments (E-mail).
--
-- Demonstrates: native.showPopup() API
--
-- Target devices: iOS and Android devices (or Xcode simulator)
--
-- Limitations: Requires build for device (and data access to send email/sms message).
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

-- Require the widget library
local widget = require( "widget" )

local emailImage = display.newImage( "email.png", centerX, 156 )

-- BUTTON LISTENERS ---------------------------------------------------------------------

-- onRelease listener for 'sendEmail' button
local function onSendEmail( event )
	-- compose an HTML email with two attachments
	local options =
	{
	   to = { "john.doe@somewhere.com", "jane.doe@somewhere.com" },
	   cc = { "john.smith@somewhere.com", "jane.smith@somewhere.com" },
	   subject = "My High Score",
	   isBodyHtml = true,
	   body = "<html><body>I scored over <b>9000</b>!!! Can you do better?</body></html>",
	   attachment =
	   {
		  { baseDir=system.ResourceDirectory, filename="email.png", type="image" },
		  { baseDir=system.ResourceDirectory, filename="coronalogo.png", type="image" },
	   },
	}
	local result = native.showPopup("mail", options)
	
	if not result then
		print( "Mail Not supported/setup on this device" )
		native.showAlert( "Alert!",
		"Mail not supported/setup on this device.", { "OK" }
	);
	end
	-- NOTE: options table (and all child properties) are optional
end

-- onRelease listener for 'sendSMS' button
local function onSendSMS( event )
	-- compose an SMS message (doesn't support attachments)
	local options =
	{
	   to = { "16505551212", "15125550189" },
	   body = "I scored over 9000!!! Can you do better?"
	}
	local result = native.showPopup("sms", options)

	if not result then
		print( "SMS Not supported/setup on this device" )
		native.showAlert( "Alert!",
		"SMS not supported/setup on this device.", { "OK" }
		)
	end
	
	-- NOTE: options table (and all child properties) are optional
end

-- CREATE BUTTONS -----------------------------------------------------------------------

local sendEmail = widget.newButton
{
	left = 0, 
	top = 0,
	width = 298,
	height = 56,
	label = "Compose Email",
	onRelease = onSendEmail
}

-- center horizontally on the screen
sendEmail.x = centerX
sendEmail.y = _H - 156

local sendSMS = widget.newButton
{
	left = 0, 
	top = 0,
	width = 298,
	height = 56,
	label = "Compose SMS",
	onRelease = onSendSMS
}

-- center horizontally on the screen
sendSMS.x = centerX
sendSMS.y = _H - 100
