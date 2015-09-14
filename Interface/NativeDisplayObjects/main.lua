-- Project: NativeDisplayObjects
--
-- File name: main.lua
--
-- Code type: Sample code
--
-- Author: Corona Labs
--
-- Demonstrates:
--	Native Display Objects
--		native.newTextField
--		native.newTextBox
--		native.showAlert
--		native.setActivityIndicator
--		native.showWebPopup
--
--	Using UI library for buttons and labels
--	System orientation events
--	Display changes between portrait and landscape modes
--  Detect running in Simulator and modifying program operation
--
-- File dependencies:
--
-- Target devices: Devices, Simulator (limited features on Windows)
--
-- Limitations: No native text display or text input on Windows simulator.
--
-- Update History:
--	v1.1	Android: added warning that ActivityIndicator not supported
--			Android: Submit button (webpoup) not supported
--
--  v1.2	Increased native.textField height when running on Android device
--			Removed texthandler parameter from native.textBox (not used)
--
--  v1.3	Android: Added ActivityIndicator support.
--
--  v1.4    11/30/10	Modified project to work properly on Mac OS X simulator, since
-- 			support for native display objects has been added.
--
--	v1.5	11/29/11	TextBox can now be edited.
--	v1.6	19/7/12		Updated with new textfield listener type.
--  v1.7	11/4/2013	Added "Dismiss KB" button for Textbox
--  v1.8	12/10/2014	Updated to support auto-sizing of text fields.
--  v1.9	08/12/2015  Added TextField and TextBox support on Windows.
--
-- Comments: 
--		The program detects it running in the Corona simulator and changes the
--		native.newTextField and native.newTextBox to display.newRect to simulate
--		the location and properties of the native text objects.
--
-- TO-DO
-- o Add WebPopUp object (using local HTML file)
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

-- Require the widget library
local widget = require( "widget" );

display.setStatusBar( display.HiddenStatusBar )		-- hide status bar

-- Determine if running on Corona Simulator
--
local isSimulator = "simulator" == system.getInfo("environment")
if system.getInfo( "platformName" ) == "Mac OS X" then isSimulator = false; end

--------------------------------
-- Code Execution Start Here
--------------------------------

local isPortrait = true			-- assume we are in Portrait screen mode

local textMode = false			-- true when text keyboard is present
local kDimBtn = 0.6				-- Button dim value (when disabled)

-- forward references
local screenCenter
local clrKbButton
local txtFieldButton
local txtBoxButton
local webPopButton

local background = display.newImage("wood_bg.jpg", display.contentCenterX, display.contentCenterY )		-- Load background image


-----------------------------------------------------------
-- textMessage()
--
-- v1.0
--
-- Create a message that is displayed for a few seconds.
-- Text is centered horizontally on the screen.
--
-- Enter:	str = text string
--			scrTime = time (in seconds) message stays on screen (0 = forever) -- defaults to 3 seconds
--			location = placement on the screen: "Top", "Middle", "Bottom" or number (y)
--			size = font size (defaults to 24)
--			color = font color (table) (defaults to white)
--
-- Returns:	text object (for removing or hiding later)
--
local textMessage = function( str, location, scrTime, size, color, font )

	local x, t
	
	size = tonumber(size) or 24
	color = color or {255, 255, 255}
	font = font or native.systemFont

	-- Determine where to position the text on the screen
	if "string" == type(location) then
		if "Top" == location then
			x = display.contentHeight/4
		elseif "Bottom" == location then
			x = (display.contentHeight/4)*3
		else
			-- Assume middle location
			x = display.contentCenterY
		end
	else
		-- Assume it's a number -- default to Middle if not
		x = tonumber(location) or display.contentCenterY
	end
	
	scrTime = (tonumber(scrTime) or 3) * 1000		-- default to 3 seconds (3000) if no time given

	t = display.newText(str, 0, 0, font, size )
	t.x = display.contentCenterX
	t.y = x
	t:setFillColor( color[1], color[2], color[3] )
	
	-- Time of 0 = keeps on screen forever (unless removed by calling routine)
	--
	if scrTime ~= 0 then
	
		-- Function called after screen delay to fade out and remove text message object
		local textMsgTimerEnd = function()
			transition.to( t, {time = 500, alpha = 0}, 
				function() t.removeSelf() end )
		end
	
		-- Keep the message on the screen for the specified time delay
		timer.performWithDelay( scrTime, textMsgTimerEnd )
	end
	
	return t		-- return our text object in case it's needed
	
end	-- textMessage()
-----------------------------------------------------------

		
-------------------------------------------
-- *** Create Labels ***
-------------------------------------------

-- Title
--

local titleLabel = display.newText( "Native Display Objects", 0, 0, native.systemFontBold, 24 )
titleLabel.anchorY = 0
--titleLabel:setReferencePoint(display.TopCenterReferencePoint)
titleLabel.x, titleLabel.y = display.contentCenterX, 5
titleLabel:setFillColor( 240/255, 240/255, 90/255 )

-- Orientation
--
-- Display current orientation using "system.orientation"
-- (default orientation is determined in build.settings file)
--

local orientationLabel = display.newText( "Orientation: " .. system.orientation, 0, 0, native.systemFontBold, 16 )
orientationLabel.anchorY = 0
--orientationLabel:setReferencePoint(display.TopCenterReferencePoint)
orientationLabel.x, orientationLabel.y = display.contentCenterX, 40

-- Keyboard Label
--

local keyboardLabel = display.newText( "Click text field (above) to enter text", 0, 0, native.systemFontBold, 16 )
keyboardLabel.anchorY = 0
--keyboardLabel:setReferencePoint(display.TopCenterReferencePoint)
keyboardLabel.x, keyboardLabel.y = display.contentCenterX, 120
keyboardLabel.isVisible = false

-------------------------------------------
--  *** Button Press Routines ***
-------------------------------------------

-- Handle the textField keyboard input
--
local function fieldHandler( event )

	if ( "began" == event.phase ) then
		-- This is the "keyboard has appeared" event
		-- In some cases you may want to adjust the interface when the keyboard appears.

		-- Show Dismiss Keyboard button if in portrait mode
		if isPortrait then
			clrKbButton.isVisible = true
		end
		
		textMode = true
	
	elseif ( "ended" == event.phase ) then
		-- This event is called when the user stops editing a field: for example, when they touch a different field
	
	elseif ( "submitted" == event.phase ) then
		-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard

		-- Hide keyboard
		native.setKeyboardFocus( nil )
		textMode = false
		clrKbButton.isVisible = false		-- Hide the Dismiss KB button
	end

end


-- textField Button Pressed
--
-- Display a one line text box and accept keyboard input
--
local textFieldButtonPress = function( event )
	
	if textField then
		textField:removeSelf()
		textField = nil				-- set to nil so we recreate it next time
		clrKbButton.isVisible = false		-- hide Dismiss button
		txtBoxButton.alpha = 1.0			-- Restore the other text object button
		keyboardLabel.isVisible = false		-- hide our text
	else
		-- Only allow one text object at a time
		if textBox then return end	-- return if other object active
		
		-- Create Native Text Field
		textField = native.newTextField( 15, 80, 280, 30 )
		textField:addEventListener( "userInput", fieldHandler )
--		textField.anchorX = 0
		textField.anchorY = 0		
		textField.isVisible = false
--		textField:setReferencePoint(display.TopCenterReferencePoint)
		textField.x = screenCenter
		textField.isVisible = true
		
		txtBoxButton.alpha = kDimBtn		-- Dim the other text object button
		keyboardLabel.isVisible = true		-- display our text
	end

end

-- textBox Button Pressed
--
-- Display text box with preloaded text
--
local textBoxButtonPress = function( event )

	if textBox then
		textBox:removeSelf()
		textBox = nil				-- set to nil so we recreate it next time
		clrKbButton.isVisible = false		-- hide Dismiss button
		txtFieldButton.alpha = 1.0			-- Restore the other text object button
	else
		-- Only allow one text object at a time
		if textField then return end	-- return if other object active
		
		-- Create Native Text Box
		textBox = native.newTextBox( 15, 70, 280, 70 )
		textBox:addEventListener( "userInput", fieldHandler )
--		textBox.anchorX = 0
		textBox.anchorY = 0	
		textBox.text = "This is information placed into the Text Box all on one line.\nThis is text forced to a new line.\nYou can now edit this box."
--		textBox:setReferencePoint(display.TopCenterReferencePoint)
		textBox.x = screenCenter
		textBox.size = 16
		textBox.isEditable = true
		txtFieldButton.alpha = kDimBtn	-- Dim the other text object button

	end

end

-- Dismiss Keyboard Button Pressed
--
local clrKbButtonPress = function( event )
	native.setKeyboardFocus( nil )		-- remove keyboard
	clrKbButton.isVisible = false		-- hide button
	textMode = false
end

-- Alert Button Pressed
--
local alertButtonPress = function( event )
	-- Create Native Alert Box
	local alertBox = native.showAlert( "My Alert Box",
			"Your message goes here ©Corona Labs",
			{"OK", "Cancel"} )
end


-- Activity Indicator Button Pressed
--
-- Display for 1 second
local activityButton = function( event )
	-- Create Activity Indicator
	native.setActivityIndicator( true )
	
	timer.performWithDelay( 1000, 
		function() native.setActivityIndicator( false ) end 
	)
end

-- WebPopUp Listener
--
local function webListener( event )
	local shouldLoad = true

	local url = event.url
	if 1 == string.find( url, "corona:close" ) then
		-- Close the web popup
		shouldLoad = false
		isWebPopup = false			-- show Web object is gone
	end
	
	return shouldLoad
end

-- Display WebPopUp object
--
-- Used for WebPopup button and on orientation change
--
local dispWebPopUp = function()
	local options = { hasBackground=true, baseUrl=system.ResourceDirectory,
		urlRequest=webListener }
		
	local x = (display.contentWidth - 320) /2
		
	if isPortrait then
		y = 80			-- Portrait
	else
		y = 75			-- Landscape
	end
	
	-- x, y, w, h, url, options
	native.showWebPopup(x, y, 320, 180, "localpage.html", options )
	isWebPopup = true
end

-- WebPopUp Button Pressed
--
-- Display local HTML page
--
local webPopButtonButtonPress = function( event )
 
 	if isSimulator then
		textMessage( "WebPopup not supported in Simulator", "Middle", 1, 18)
	else
		if isWebPopup then
			native.cancelWebPopup()
			isWebPopup = false
		else			
			dispWebPopUp()
		end
	end

end

-------------------------------------------
-- *** Create Buttons ***
-------------------------------------------

-- textField Button
--
txtFieldButton = widget.newButton
{
	defaultFile = "btnBlueMedium.png",
	overFile = "btnBlueMediumOver.png",
	label = "textField",
	fontSize = 16,
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	emboss = true,
	onPress = textFieldButtonPress,	
}
txtFieldButton.anchorY = 0
--txtFieldButton:setReferencePoint(display.TopCenterReferencePoint)

-- textBox Button
--
txtBoxButton = widget.newButton
{
	defaultFile = "btnBlueMedium.png",
	overFile = "btnBlueMediumOver.png",
	label = "textBox",
	fontSize = 16,
	labelColor = 
	{ 
		default = { 255, 255, 255 },
	},
	emboss = true,
	onPress = textBoxButtonPress,
}
txtBoxButton.anchorY = 0
--txtBoxButton:setReferencePoint(display.TopCenterReferencePoint)

-- Clear Keyboard Button
-- Invisible until used in Portrait text mode
--
clrKbButton = widget.newButton
{
	defaultFile = "btnBlueMedium.png",
	overFile = "btnBlueMediumOver.png",
	label = "Dismiss KB",
	fontSize = 16,
	labelColor = 
	{ 
		default = { 255, 255, 255 },
	},
	emboss = true,
	onPress = clrKbButtonPress,
}
clrKbButton.isVisible = false		-- we will use it later
clrKbButton.anchorY = 0
--txtBoxButton:setReferencePoint(display.TopCenterReferencePoint)

-- Alert Button
--
local alertButton = widget.newButton
{
	defaultFile = "btnBlueMedium.png",
	overFile = "btnBlueMediumOver.png",
	label = "Alert",
	fontSize = 16,
	labelColor = 
	{ 
		default = { 255, 255, 255 }, 
	},
	emboss = true,
	onRelease = alertButtonPress,			-- used onRelease to avoid system interaction
}
alertButton.anchorY = 0
--alertButton:setReferencePoint(display.TopCenterReferencePoint)

-- Activity Indicator Button
--
local activityButton = widget.newButton
{
	defaultFile = "btnBlueMedium.png",
	overFile = "btnBlueMediumOver.png",
	label = "Activity",
	fontSize = 16,
	labelColor = 
	{ 
		default = { 255, 255, 255 },
	},
	emboss = true,
	onRelease = activityButton,			-- used onRelease to avoid system interaction
}
activityButton.anchorY = 0
--activityButton:setReferencePoint(display.TopCenterReferencePoint)

-- WebPopup Button
--
webPopButton = widget.newButton
{
	defaultFile = "btnBlueMedium.png",
	overFile = "btnBlueMediumOver.png",
	label = "WebPopup",
	fontSize = 16,
	labelColor = 
	{ 
		default = { 255, 255, 255 },
	},
	emboss = true,
	onPress = webPopButtonButtonPress,
}
webPopButton.anchorY = 0
--webPopButton:setReferencePoint(display.TopCenterReferencePoint)


-----------------------------------------------
-- *** Locate the buttons on the screen ***
-----------------------------------------------

-- Adjust objects for Portrait or Landscape mode
--
-- Enter: mode = orientation mode
--
local function changeOrientation( mode )

local Y_Btn_P = 310		-- First button Y position for Portrait
local Y_Btn_L = 155		-- First button Y position for Landscape
local BtnOffset = 55	-- offset between buttons
	
	clrKbButton.alpha = 0.0			-- hide it during the transition

	-- Ignore "faceUp" and "faceDown" modes
	if mode == "portrait" or mode == "portraitUpsideDown" then
		background:removeSelf()
		background = display.newImage("wood_bg.jpg")		-- Load portrait background image
		background.parent:insert(1, background )
	
		background.x = display.contentCenterX
		background.y = display.contentCenterY
		
		isPortrait = true
		screenCenter = display.contentWidth * 0.5
				
		txtFieldButton.x = screenCenter - 80;
		txtBoxButton.x = screenCenter +80;
		txtFieldButton.y = Y_Btn_P
		txtBoxButton.y = Y_Btn_P

		alertButton.x = screenCenter - 80;
		activityButton.x = screenCenter +80;
		alertButton.y = Y_Btn_P + BtnOffset*1
		activityButton.y = Y_Btn_P + BtnOffset*1

		webPopButton.x = screenCenter;
		webPopButton.y = Y_Btn_P + BtnOffset*2
		
		-- Adjust WebPopUp box if present
		--
		if isWebPopup then
			-- Since we can relocate the object, close and reopen
			native.cancelWebPopup()			-- close it first
			-- Delay some time before showing the Webpopup again
			timer.performWithDelay( 400, dispWebPopUp )
		end
		
		if textMode then
			clrKbButton.isVisible = true		-- make Dismiss KB button visible
		end
	elseif	mode == "landscapeLeft" or mode == "landscapeRight" then
	
			-- Remove old background image and insert new image at the bottom
			background:removeSelf()
			background = display.newImage("wood_bg_lc.jpg")		-- Load landscape background image
			background.parent:insert( 1, background )

			background.x = display.contentCenterX
			background.y = display.contentCenterY
			
			isPortrait = false
			screenCenter = display.contentWidth * 0.5

			txtFieldButton.x = screenCenter - 100;
			txtBoxButton.x = screenCenter +100;
			txtFieldButton.y = Y_Btn_L
			txtBoxButton.y = Y_Btn_L
	
			alertButton.x = screenCenter - 100;
			activityButton.x = screenCenter +100;
			alertButton.y = Y_Btn_L + BtnOffset*1
			activityButton.y = Y_Btn_L + BtnOffset*1
	
			webPopButton.x = screenCenter;
			webPopButton.y = Y_Btn_L + BtnOffset*2
			
			clrKbButton.isVisible = false		-- hide Dismiss button

			-- Adjust WebPopUp box if present
			--
			if isWebPopup then
				-- Since we can relocate the object, close and reopen
				native.cancelWebPopup()			-- close it first
				-- Delay some time before showing the Webpopup again
				timer.performWithDelay( 400, dispWebPopUp )

--[[
				local options = { hasBackground=true, baseUrl=system.ResourceDirectory,
					urlRequest=webListener }
					
				local x = (display.contentWidth - 320) /2
				-- Delay some time before showing the Webpopup again
				-- x, y, w, h, url, options
				timer.performWithDelay( 200,
					function() native.showWebPopup( x,
						80, 320, 180, "localpage.html", options )
					end )
--]]
			end
	end

	-- Adjustments that are common to all screen orientations
	if textField then
		textField.x = screenCenter
	end
	
	if textBox then
		textBox.x = screenCenter
	end

	clrKbButton.x = screenCenter
	clrKbButton.y = 180
	
	-- Auto center our text strings
	orientationLabel.x = screenCenter
	titleLabel.x = screenCenter
	keyboardLabel.x = screenCenter
	
	transition.to( clrKbButton, {time = 500, alpha = 1.0} )			-- restore the alpha channel
end

-- Set up the display after the app starts
changeOrientation( system.orientation )

-- Come here when an Orientation Change event occurs
--
-- Change the display to fix the new mode
-- Display the change on screen
--
local function onOrientationChange( event )

	changeOrientation( event.type )
	orientationLabel.text = "Orientation: " .. event.type
end

-- Add listerner for Orientation changes
--
Runtime:addEventListener( "orientation", onOrientationChange )
