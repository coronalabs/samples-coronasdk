-- Desktop Window Test Project
--
-- Demonstrates the following desktop features:
-- * How to change the window mode to "normal", "minimzed", "maximized", and "fullscreen".
-- * How to get and set the window title bar text.
-- * How to toggle fullscreen mode on Windows via an F11 key event.
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2015 Corona Labs Inc. All Rights Reserved.
----------------------------------------------------------------------------------------------------


-- Desktop apps support the Corona widgets library!
-- Require it in so that we can use widget buttons below.
local widget = require("widget")
widget.setTheme("widget_theme_android_holo_dark")


-- Determine if this app is running in a desktop window.
local isRunningOnDesktop = false
if (system.getInfo("environment") == "device") then
	local platform = system.getInfo("platform")
	if (platform == "win32") or (platform == "macos") then
		isRunningOnDesktop = true
	end
end


-- Set up the screen to support 5 buttons.
local buttonCount = 5
local buttonRowHeight = display.contentHeight / buttonCount


-- Set up a widget button that puts the window into "fullscreen" mode.
local fullscreenButton = widget.newButton
{
	label = "Fullscreen",
	fontSize = 32,
	width = display.contentWidth * 0.75,
	onRelease = function(event)
		native.setProperty("windowMode", "fullscreen")
		print("Window Mode = " .. tostring(native.getProperty("windowMode")))
	end,
}
fullscreenButton.x = display.contentCenterX
fullscreenButton.y = (buttonRowHeight * 1) - (buttonRowHeight * 0.5)


-- Set up a widget button that will maximize the desktop window.
local maximizeButton = widget.newButton
{
	label = "Maximize",
	fontSize = 32,
	width = display.contentWidth * 0.75,
	onRelease = function(event)
		native.setProperty("windowMode", "maximized")
		print("Window Mode = " .. tostring(native.getProperty("windowMode")))
	end,
}
maximizeButton.x = display.contentCenterX
maximizeButton.y = (buttonRowHeight * 2) - (buttonRowHeight * 0.5)


-- Set up a widget button that will minimize the desktop window.
local minimizeButton = widget.newButton
{
	label = "Minimize",
	fontSize = 32,
	width = display.contentWidth * 0.75,
	onRelease = function(event)
		native.setProperty("windowMode", "minimized")
		print("Window Mode = " .. tostring(native.getProperty("windowMode")))
	end,
}
minimizeButton.x = display.contentCenterX
minimizeButton.y = (buttonRowHeight * 3) - (buttonRowHeight * 0.5)


-- Set up a widget button that will change the desktop window to "normal" mode.
-- In this mode, the window can be resized and can be dragged by its title bar.
local restoreButton = widget.newButton
{
	label = "Windowed",
	fontSize = 32,
	width = display.contentWidth * 0.75,
	onRelease = function(event)
		native.setProperty("windowMode", "normal")
		print("Window Mode = " .. tostring(native.getProperty("windowMode")))
	end,
}
restoreButton.x = display.contentCenterX
restoreButton.y = (buttonRowHeight * 4) - (buttonRowHeight * 0.5)


-- Fetch and store the current window title bar text.
-- Will be used by the button created down below.
local originalTitleText = native.getProperty("windowTitleText")
if originalTitleText == nil then
	originalTitleText = ""
end
local updateTitleCount = 0

-- Set up a button that will change the window's title bar text.
local updateTitleButton = widget.newButton
{
	label = "Update Title Text",
	fontSize = 32,
	width = display.contentWidth * 0.75,
	onRelease = function(event)
		updateTitleCount = updateTitleCount + 1
		local newTitleText = originalTitleText .. " [Title Update " .. tostring(updateTitleCount) .. "]"
		native.setProperty("windowTitleText", newTitleText)
		print("Window Title Text = " .. tostring(native.getProperty("windowTitleText")))
	end,
}
updateTitleButton.x = display.contentCenterX
updateTitleButton.y = (buttonRowHeight * 5) - (buttonRowHeight * 0.5)


-- Called when a key up/down event has been received.
local function onKeyReceived(event)
	-- Toggle the window in/out of fullscreen mode when the F11 key is pressed.
	-- Note: This is a Microsoft Windows de-facto standard that you must opt-in to programmatically.
	--       Windows games do not typically support the F11 key for fullscreen support.
	--       But it is typically supported by apps such as web browsers, video players, presentation tools, etc.
	if (system.getInfo("platformName") == "Win") then
		if (event.keyName == "f11") and (event.phase == "down") then
			if (native.getProperty("windowMode") == "fullscreen") then
				native.setProperty("windowMode", "normal")
			else
				native.setProperty("windowMode", "fullscreen")
			end
		end
	end
end
Runtime:addEventListener("key", onKeyReceived)


-- Called when the window has been resized.
local function onResized(event)
	-- Fetch and print the surface's pixel width and height.
	-- Note: Pixel width and height is relative to portrait when an "orentation" table is defined in "build.settings".
	--       This is consistent with the behavior on Android and iOS, making your code portable on all platforms.
	local pixelWidth = display.pixelWidth
	local pixelHeight = display.pixelHeight
	if ((system.orientation == "landscapeRight") or (system.orientation == "landscapeLeft")) then
		local tempLength = pixelWidth
		pixelWidth = pixelHeight
		pixelHeight = tempLength
	end
	print(
		"Window resized to: " .. tostring(pixelWidth) .. "x" .. tostring(pixelHeight) ..
		" pixels (" .. tostring(system.orientation) .. ")")
end
Runtime:addEventListener("resize", onResized)


-- If this app is not running in a desktop window, then display a warning message as an overlay.
if (false == isRunningOnDesktop) then
	-- Display an overlay which will steal all tap and touch events.
	local overlay = display.newRect(
			display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	overlay:setFillColor(0, 0, 0, 0.70)
	overlay:addEventListener("tap", function() return true end)
	overlay:addEventListener("touch", function() return true end)

	-- Display a warning stating that this app's features are only supported in a desktop window.
	local message =
			"This app's desktop features are not supported on mobile devices or in the Corona Simulator.\n" ..
			"\n" ..
			"Please build this app for macOS or Win32 to test it."
	display.newText(
			message, display.contentCenterX, display.contentCenterY, display.contentWidth * 0.8, 0,
			native.systemFont, 16)
end
