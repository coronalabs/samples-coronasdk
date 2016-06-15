--
-- File name: main.lua
--
-- Code type: Flurry Sample App
--
-- Author: Corona Labs
--
-- File dependencies: Flurry Analytics plugin, Google Play Services
--
-- Target devices: iOS, Android
--
-- Limitations:
--
-- Update History:
--
--  1.1 - Replaced depreciated ui library with widget library
--  1.2 - Reimplemented to use new Flurry Analytics plugin
--
-- Comments:
--
--     This sample demonstrates the use of analytics in Corona.
--     To use it, you must first create an account on Flurry.
--     Go to www.flurry.com and sign up for an account. Once you have
--     logged in to flurry, go to Manage Applications. Click "Create a new app".
--     Choose iPhone, iPad, or Android as appropriate. This will create
--     an "Application key" which you must enter in the code below (we
--     recommend making a copy of this sample, rather than editing it directly).
--
--     Build your app for device and install it. When you run it, you can
--     optionally click on the buttons to create additional event types.
--     The analytics data is uploaded as soon as device conditions allow.
--     For example, they may be delayed because of no network connection.
--
--     Finally, in your Flurry account, choose "View analytics" to 
--     see the data created by your app.
--     Note that it takes some time for the analytics data to appear
--     in the Flurry statistics, it does not appear immediately.
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2016 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
----------------------------------------------------------------------------------------

local flurry = require( "plugin.flurry.analytics" )
local widget = require( "widget" )

----------------------- 
-- Setup
----------------------- 
local eventDataTextBox              -- text box to display event data
local baseTime = 0                  -- timer used to scroll text into text box
local reportTime = baseTime         -- timer used to scroll text into text box

display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "background", 1 )

-- function for scrolling text into text box (makes new entries more obvious)
local reportEvent = function( eventData )
    reportTime = reportTime + 100

    timer.performWithDelay( reportTime - baseTime, function()
        print( eventData )
        eventDataTextBox.text = eventData .. "\n" .. eventDataTextBox.text
    end)
end

local flurryListener = function( event )
    local phase = event.phase
    local adType = event.type
    local response = event.response

    baseTime = system.getTimer()    -- update base times
    reportTime = baseTime           -- reset report time to base time

    local eventData
    reportEvent( "- - - - - - - - - - - - - - - - - - - - -")

    for k, v in pairs( event ) do
        if type(v) == "table" then
            for k1, v1 in pairs( v ) do
                if type(v1) == "table" then
                    for k2, v2 in pairs( v1 ) do
                        reportEvent( k ..".".. tostring(k1) .."={".. tostring(k2) .."=".. tostring(v2) .."}" )
                    end
                else
                    reportEvent( k ..".".. tostring(k1) .."=".. tostring(v1) )
                end
            end
        else
            reportEvent( tostring(k) .."=".. tostring(v) )
        end
    end
end

local apiKey = system.getInfo( "platformName" ) == "Android" and "66V4Q6JWN257B7JRB5DX" or "P23CTV66R29QRD6G4PFS"
print( "Using " .. apiKey )

flurry.init(flurryListener, { 
    apiKey = apiKey,
    crashReportingEnabled = true
})

----------------------- 
-- UI
----------------------- 
local flurryLogo = display.newImage( "flurrylogo.png" )
flurryLogo.anchorY = 0
flurryLogo.x, flurryLogo.y = display.contentCenterX, 5
flurryLogo:scale( 0.3, 0.3 )

local subTitle = display.newText {
    text = "plugin for Corona SDK",
    x = display.contentCenterX,
    y = 95,
    font = display.systemFont,
    fontSize = 20
}
subTitle:setTextColor( 0.2, 0.2, 0.2 )

eventDataTextBox = native.newTextBox( display.contentCenterX, display.contentHeight - 55, 310, 100)
eventDataTextBox.placeholder = "Event data will appear here"

-- Standard event logging
local standardEventButton = widget.newButton {
    label = "Log Event",
    width = 300,
    fontSize = 15,
    emboss = false,
    labelColor = { default={1,1,1,0.75}, over={0,0,0,0.5} },
    shape = "roundedRect",
    width = 200,
    height = 35,
    cornerRadius = 4,
    fillColor = { default = { 0.6, 0.7, 0.8, 1 }, over = { 0.4, 0.5, 0.6, 1 } },
    strokeColor = { default = { 0.4, 0.4, 0.4 }, over = { 0.4, 0.4, 0.4 } },
    strokeWidth = 2,
    onRelease = function( event )
        flurry.logEvent( "Entered dungeon" )
    end
}
standardEventButton.x = display.contentCenterX
standardEventButton.y = 150

-- Standard event with params
local standardEventWithParamsButton = widget.newButton {
    label = "Log Event With Params",
    width = 300,
    fontSize = 15,
    emboss = false,
    labelColor = { default={1,1,1,0.75}, over={0,0,0,0.5} },
    shape = "roundedRect",
    width = 200,
    height = 35,
    cornerRadius = 4,
    fillColor = { default = { 0.6, 0.7, 0.8, 1 }, over = { 0.4, 0.5, 0.6, 1 } },
    strokeColor = { default = { 0.4, 0.4, 0.4 }, over = { 0.4, 0.4, 0.4 } },
    strokeWidth = 2,
    onRelease = function( event )
        flurry.logEvent( "Menu selection" , { location = "Main Menu", selection = "Multiplayer mode" } )
    end
}
standardEventWithParamsButton.x = display.contentCenterX
standardEventWithParamsButton.y = standardEventButton. y + 50

-- Start timed event logging
local timedEventButton = widget.newButton {
    label = "Start Timed Event",
    width = 300,
    fontSize = 15,
    emboss = false,
    labelColor = { default={1,1,1,0.75}, over={0,0,0,0.5} },
    shape = "roundedRect",
    width = 200,
    height = 35,
    cornerRadius = 4,
    fillColor = { default = { 0.6, 0.7, 0.8, 1 }, over = { 0.4, 0.5, 0.6, 1 } },
    strokeColor = { default = { 0.4, 0.4, 0.4 }, over = { 0.4, 0.4, 0.4 } },
    strokeWidth = 2,
    onRelease = function( event )
        flurry.startTimedEvent( "Level 1 (Beginner)" )
    end
}
timedEventButton.x = display.contentCenterX
timedEventButton.y = standardEventWithParamsButton.y + 75

-- End timed event logging
local endTimedEventButton = widget.newButton {
    label = "End Timed Event",
    width = 300,
    fontSize = 15,
    emboss = false,
    labelColor = { default={1,1,1,0.75}, over={0,0,0,0.5} },
    shape = "roundedRect",
    width = 200,
    height = 35,
    cornerRadius = 4,
    fillColor = { default = { 0.6, 0.7, 0.8, 1 }, over = { 0.4, 0.5, 0.6, 1 } },
    strokeColor = { default = { 0.4, 0.4, 0.4 }, over = { 0.4, 0.4, 0.4 } },
    strokeWidth = 2,
    onRelease = function( event )
        flurry.endTimedEvent( "Level 1 (Beginner)" )
    end
}
endTimedEventButton.x = display.contentCenterX
endTimedEventButton.y = timedEventButton.y + 50
