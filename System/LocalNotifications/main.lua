-- Project: LocalNotificaton_test
--
-- File name: main.lua
--
-- Local Notifications sample code
--
-- Update History:
--	v1.1	10/30/12	Layout adapted for Android/iPad/iPhone4
--	v1.2	12/5/12		Modified listener to accept a nil badge number (for Android)
--
-- Limitations: Currently only runs on iOS and Android devices (no simulators)
-- 				Note: Badge is not currently supported on Android
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

local launchArgs = ...
local notifications = require( "plugin.notifications" )
local widget = require( "widget" )

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

display.setStatusBar( display.HiddenStatusBar )		-- hide status bar
io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console

print();print("<-========================= Program Start =========================->");print()

local notificationID		-- forward reference
local notificationTime = 10	-- number of seconds until notification
local time = notficationTime
local badge = "none"				-- default value written to icon badge
local setBadge = 0
local running = false			-- used in countdown timer to enable/disable
local startTime				-- time we start the notification

local btnY = 70		-- start of buttons
local btnOff = 60	-- button offset

local msgOff = 400	-- Start of messages

display.setDefault( "anchorX", 0.0 )	-- default to TopLeft anchor point for new objects
display.setDefault( "anchorY", 0.0 )

local startText = display.newText( "", 10, msgOff, nil, 14 )
local cancelText = display.newText( "", 10, msgOff+20, nil, 14  )
local notificationText = display.newText( "", 10, msgOff+35, nil, 14  )
notificationText:setFillColor( 1,1,0 )

local notificationMsgText = display.newText( "", 10, msgOff+55, nil, 14  )
notificationMsgText:setFillColor( 1,1,0 )

display.setDefault( "anchorX", 0.5 )	-- restore anchor points for new objects to center anchor point
display.setDefault( "anchorY", 0.5 )

-- Options for iOS 
--
-- Note: options.badge and options.custom are added in the notification start
--
local options = {
   alert = "Wake up!",
   badge = 1,
   sound = "notification.wav",
   custom = { msg = "bar" }
}

titleMsg = display.newText( "Local Notification Test", centerX, 23, native.systemFontBold, 18 )

-------------------------------------------
-- *** Buttons Presses ***
-------------------------------------------

-- Start W/Time Button
local startWTimePress = function( event )
	time = notificationTime
	
	-- Add badge paramter if not "none"
	if badge ~= "none" then
		options.badge = badge
	end
	
	options.custom.msg = "Time Notification"

	notificationID = notifications.scheduleNotification( time, options )
	local displayText = "Notification using Time: " .. tostring( notificationID )
	startText.text = displayText
	startText.anchorX = 0	-- Left
	startText.anchorY = 0	-- Top
	startText.x = 10
	
	-- Clear previous text
	notificationText.text = ""
	cancelText.text = ""
	notificationMsgText.text = ""
	
	startTime = os.time( ( os.date( '*t' ) ) )  -- get current time in seconds
	running = true
	
	print( displayText )
end

-- Start W/UTC Button
local startWUtcPress = function( event )
	time = os.date( "!*t", os.time() + notificationTime )
	
	-- Add badge paramter if not "none"
	if badge ~= "none" then
		options.badge = badge
	end
	
	options.custom.msg = "UTC Notification"
	
	notificationID = notifications.scheduleNotification( time, options )
	local displayText = "Notification using UTC: " .. tostring( notificationID )
	startText.text = displayText
	startText.anchorX = 0	-- Left
	startText.anchorY = 0	-- Top
	startText.x = 10
	
	-- Clear previous text
	notificationText.text = ""
	cancelText.text = ""
	notificationMsgText.text = ""

	startTime = os.time( ( os.date( '*t' ) ) )  -- get current time in seconds
	running = true

	print( displayText )
end

-- Badge Button
-- Cycle: none, 0, 1, 2, -1
-- (This is updated when the notification is started)
--
local badgePress = function( event )
	if badge == "none" then
		badge = 0
	elseif badge == 0 then
		badge = 1
	elseif badge == 1 then
		badge = 2
	elseif badge == 2 then
		badge = -1
	else	-- assume badge == -1
		badge = "none"
	end
	
	-- Change button label with value
	badge_bnt:setLabel( "Badge (" .. badge .. ")" )

end

-- Set Badge Button
-- Cycle: 0, 5, 10
-- (Uses native.setProperty to update the badge)
--
local setBadgePress = function( event )
	-- Set badge to either 0, 5 or 10
	native.setProperty( "applicationIconBadgeNumber", setBadge )
	
	-- Now advance to next value
	if setBadge == 0 then
		setBadge = 5
	elseif setBadge == 5 then
		setBadge = 10
	else
		setBadge = 0
	end
	
	-- Change button label with value
	setBadge_bnt:setLabel( "Set Badge (" .. setBadge .. ")" )
	
end

-- Cancel All Button
local cancelAllPress = function( event )
	notifications.cancelNotification() 
	cancelText.text = "Notification Cancel All"
	cancelText.anchorX = 0	-- Left
	cancelText.anchorY = 0	-- Top
	cancelText.x = 10
end

-- Cancel W/ID Button
local cancelWIdPress = function( event )
	if notificationID then
		notifications.cancelNotification( notificationID ) 
		cancelText.text = "Notification Cancel ID"
		cancelText.anchorX = 0	-- Left
		cancelText.anchorY = 0	-- Top
		cancelText.x = 10
	end
end

-------------------------------------------
-- *** Create Buttons ***
-------------------------------------------

-- "Start W/Time" Button
startWTime_btn = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Start With Time",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	fontSize = 18,
	emboss = true,
	onPress = startWTimePress,
}

-- "Start W/UTC" Button
startWUtc_bnt = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Start With UTC",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	fontSize = 18,
	emboss = true,
	onPress = startWUtcPress,
}

-- "Cancel All" Button
cancelAll_bnt = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Cancel All",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	fontSize = 18,
	emboss = true,
	onPress = cancelAllPress,
}

-- "Cancel W/ID" Button
cancelWId_bnt = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Cancel W/ID",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	fontSize = 18,
	emboss = true,
	onPress = cancelWIdPress,
}

-- badge button
badge_bnt = widget.newButton
{
	id = "badge",
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Badge (" .. badge .. ")",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	yOffset = - 3,
	fontSize = 16,
	emboss = true,
	width = 130,
	onPress = badgePress,
}

-- set badge button
setBadge_bnt = widget.newButton
{
	id = "setBadge",
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Set Badge (" .. setBadge .. ")",
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	yOffset = - 3,
	fontSize = 16,
	emboss = true,
	onPress = setBadgePress,
}


-- Position the buttons on screen
--
startWTime_btn.x = centerX;	startWTime_btn.y = btnY
startWUtc_bnt.x = centerX;		startWUtc_bnt.y = btnY + btnOff*1
cancelAll_bnt.x = centerX;		cancelAll_bnt.y = btnY + btnOff*2
cancelWId_bnt.x = centerX;		cancelWId_bnt.y = btnY + btnOff*3
badge_bnt.x = centerX;				badge_bnt.y = btnY + btnOff*4
setBadge_bnt.x = centerX;			setBadge_bnt.y = btnY + btnOff*5


-------------------------------------------
-- Local Notification listener
-------------------------------------------
--
local notificationListener = function( event )
	
--- Debug Event parameters printout --------------------------------------------------
--- Prints Events received up to 20 characters. Prints "..." and total count if longer
---
	if event.custom == nil then
		local json = require("json")
		print("Notification listener unknown event: ", json.prettify(event))
		return
	end

	print( "Notification Listener event:" )

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

	local badgeOld = native.getProperty( "applicationIconBadgeNumber" )
	
	notificationText.text = "Notification fired: getProperty " ..
		tostring( badgeOld ) .. ", event.badge " .. tostring( event.badge )
	notificationText.anchorX = 0	-- Left
	notificationText.anchorY = 0	-- Top
	notificationText.x = 10
	
	notificationMsgText.text = "custom.msg = " .. tostring( event.custom.msg ) ..
		", " .. tostring( event.applicationState )
	notificationMsgText.anchorX = 0	-- Left
	notificationMsgText.anchorY = 0	-- Top
	notificationMsgText.x = 10
	print( "event.custom.msg = ", event.custom.msg, event.applicationState )
	
end

-------------------------------------------
-- One Second Listener
-- Called every second to update the countdown
-------------------------------------------
--
local function secondTimer( event )
	if running then
		local t = os.time( ( os.date( '*t' ) ) )  -- get current time in seconds
		local e = notificationTime - tonumber( t - startTime )
		
		-- Stop the counter when we reach 0
		if e < 0 then
			running = false
			e = 0
		end
		
		startWTime_btn:setLabel( "Start With Time - " .. e )
	end
end

-------------------------------------------
-- Determine if running on Corona Simulator
-------------------------------------------
--
local isSimulator = "simulator" == system.getInfo("environment")

-------------------------------------------
-- Add Listeners
-------------------------------------------
--
Runtime:addEventListener( "notification", notificationListener )

timer.performWithDelay(1000, secondTimer, 0)

-------------------------------------------
-- Check LaunchArgs
-- These ares are only set on a cold start
-------------------------------------------
--
if launchArgs and launchArgs.notification then
	
	native.showAlert( "LaunchArgs Found", launchArgs.notification.alert, { "OK" } )
	
	-- Need to call the notification listener since it won't get called if the
	-- the app was already closed.
	notificationListener( launchArgs.notification )
end

-- Code to show Alert Box if applicationOpen event occurs
-- (This shouldn't happen, but the code is here to prove the fact)
function onSystemEvent( event )
	print (event.name .. ", " .. event.type)
	
	if "applicationOpen" == event.type then
		native.showAlert( "Open via custom url", event.url, { "OK" } )
	end
end

-- Add the System callback event
Runtime:addEventListener( "system", onSystemEvent );

if notifications.isStub then
	local greyBox = display.newRoundedRect(centerX - 1, centerY - 1 , _W - 4, _H - 4, 4)
	greyBox:setFillColor( 0.8, 0.8 )

	local msg = display.newText( "Local notifications not supported on this platform", 0, centerY + 10, native.systemFontBold, 13 )
	msg.x = display.contentWidth / 2
	msg:setFillColor( 1, 0, 0 )

	local function ignoreTaps()
		return true
	end

	greyBox:addEventListener( "touch", ignoreTaps )
end

