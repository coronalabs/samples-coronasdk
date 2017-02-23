-- 
-- Abstract: Status Bar sample app
-- 
-- Version: 1.2
-- 
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

-- Cycles through the different status bar modes, changing modes every second
--
-- Supports Graphics 2.0
-- 1.2 - Add support fro additional status bars. Made the background middle gray so you can
--       see both light and dark versions.
------------------------------------------------------------

-- array of status bar modes
local modes = {
        display.HiddenStatusBar,
        display.DefaultStatusBar,
        display.DarkStatusBar,
        display.TranslucentStatusBar,
        display.LightTransparentStatusBar,
        display.DarkTransparentStatusBar,
}

local modeNames = {
        "display.HiddenStatusBar",
        "display.DefaultStatusBar",
        "display.DarkStatusBar",
        "display.TranslucentStatusBar",
        "display.LightTransparentStatusBar",
        "display.DarkTransparentStatusBar",
}

local background = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
background:setFillColor( 0.5 )

local label

local function changeStatusBarMode( event )
	local numModes = #modes

	-- get an integer index between 1 and numModes
	local index = event.count % numModes + 1

	label.text = modeNames[index]
	display.setStatusBar( modes[index] )
end

local model = system.getInfo("model")
local environment = system.getInfo("environment") 
local platformName = system.getInfo("platformName")

-- this is only supported on iOS (simulated or device) or Android (device only)
if platformName == "Android" or platformName == "iPhone OS" or (environment == "simulator" and (model == "iPad" or model == "iPhone")) then
	label = display.newText( "Statusbar mode changes every 2 seconds", 0, 0, native.systemFontBold, 12 )
	label:setFillColor( 1, 1, 1 )
	-- center text
	label.x = display.contentWidth*0.5
	label.y = display.contentHeight*0.8

	-- call changeStatusBarMode() every second
	timer.performWithDelay( 2000, changeStatusBarMode, 0 )
else
	local msg = display.newText( "Statusbar mode not supported on this platform", 0, 60, native.systemFontBold, 12 )
	msg.x = display.contentWidth / 2
	msg:setFillColor( 1, 0, 0 )
	local msg2 = display.newText( "Try simulating or building for iOS", 0, 100, native.systemFontBold, 12 )
	msg2.x = display.contentWidth / 2
	msg2:setFillColor( 1, 0, 0 )
end

