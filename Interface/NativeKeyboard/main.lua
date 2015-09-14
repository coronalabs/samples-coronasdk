--
-- Project: NativeKeyboard2
--
-- Date: November 30, 2010
--
-- Version: 1.6
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract: Shows different native text entry options (keypad, normal, phone, etc.)
--
-- Demonstrates: 	Adding and removing native text fields objects
--					Changing button labels on the flyable
--					Tapping the background to dismiss the native keyboard.
--
-- File dependencies:
--
-- Target devices: Devices only
--
-- Limitations: Native Text Fields not supported on the windows Simulator
--
-- Update History:
--	v1.2	Added Simulator warning message
--			Buttons now remove and add text fields
--
--  v1.3	Increased native.textField height when running on Android device
--	v1.4 	Updated with new textfield listener type.
--  v1.5	Updated to support auto-sized text field heights.
--  v1.6	Added native TexField and TextBox support on Windows.
--
-- Comments: Slight tweak added for Android textfields, which have more chrome
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

-- Require the widget library
local widget = require( "widget" )

display.setDefault( "background", 80/255 )

-------------------------------------------
-- General event handler for fields
-------------------------------------------

-- You could also assign different handlers for each textfield

local function fieldHandler( textField )
	return function( event )
		if ( "began" == event.phase ) then
			-- This is the "keyboard has appeared" event
			-- In some cases you may want to adjust the interface when the keyboard appears.
		
		elseif ( "ended" == event.phase ) then
			-- This event is called when the user stops editing a field: for example, when they touch a different field
			
		elseif ( "editing" == event.phase ) then
		
		elseif ( "submitted" == event.phase ) then
			-- This event occurs when the user presses the "return" key (if available) on the onscreen keyboard
			print( textField().text )
			
			-- Hide keyboard
			native.setKeyboardFocus( nil )
		end
	end
end

-- Predefine local objects for use later
local defaultField, numberField, phoneField, urlField, emailField, passwordField
local fields = display.newGroup()

-------------------------------------------
-- *** Buttons Presses ***
-------------------------------------------

-- Default Button Pressed
local defaultButtonPress = function( event )
	
	-- Make sure display object still exists before removing it
	if defaultField then
		print("Default button pressed ... removing textField")
		fields:remove( defaultField )
		defaultButton:setLabel( "Add Default textField" )
		
		defaultField = nil				-- do this so we don't remove it a second time
	else
		-- Add the text field back again
		defaultField = native.newTextField( 10, 30, 180, 30 )
		defaultField:addEventListener( "userInput", fieldHandler( function() return defaultField end ) ) 
		fields:insert(defaultField)
		defaultButton:setLabel( "Remove Default textField" )
	end
end

-- Number Button Pressed
local numberButtonPress = function( event )
	print("Number button pressed ... removing textField")
	
	-- Make sure display object still exists before removing it
	if numberField then
		numberField:removeSelf()
		numberButton:setLabel( "Add Number textField" )
		numberField = nil				-- do this so we don't remove it a second time
	else
		-- Add the text field back again
		numberField = native.newTextField( 10, 70, 180, 30 )
		numberField.inputType = "number"
		numberField:addEventListener( "userInput", fieldHandler( function() return numberField end ) ) 
		fields:insert(numberField)
		numberButton:setLabel( "Remove Number textField" )
	end
end

-------------------------------------------
-- *** Create native input textfields ***
-------------------------------------------

display.setDefault( "anchorX", 0.0 )	-- default to TopLeft anchor point for new objects
display.setDefault( "anchorY", 0.0 )

defaultField = native.newTextField( 10, 30, 180, 30 )
defaultField:addEventListener( "userInput", fieldHandler( function() return defaultField end ) ) 

numberField = native.newTextField( 10, 70, 180, 30 )
numberField.inputType = "number"
numberField:addEventListener( "userInput", fieldHandler( function() return numberField end ) ) 

phoneField = native.newTextField( 10, 110, 180, 30 )
phoneField.inputType = "phone"
phoneField:addEventListener( "userInput", fieldHandler( function() return phoneField end ) ) 

urlField = native.newTextField( 10, 150, 180, 30 )
urlField.inputType = "url"
urlField:addEventListener( "userInput", fieldHandler( function() return urlField end ) ) 

emailField = native.newTextField( 10, 190, 180, 30 )
emailField.inputType = "email"
emailField:addEventListener( "userInput", fieldHandler( function() return emailField end ) ) 

passwordField = native.newTextField( 10, 230, 180, 30 )
passwordField.isSecure = true
passwordField:addEventListener( "userInput", fieldHandler( function() return passwordField end ) ) 

-- Add fields to our new group
fields:insert(defaultField)
fields:insert(numberField)

-------------------------------------------
-- *** Add field labels ***
-------------------------------------------

local defaultLabel = display.newText( "Default", 200, 35, native.systemFont, 18 )
defaultLabel:setFillColor( 170/255, 170/255, 1 )

local defaultLabel = display.newText( "Number", 200, 75, native.systemFont, 18 )
defaultLabel:setFillColor( 1, 150/255, 180/255 )

local defaultLabel = display.newText( "Phone", 200, 115, native.systemFont, 18 )
defaultLabel:setFillColor( 1, 220/255, 120/255 )

local defaultLabel = display.newText( "URL", 200, 155, native.systemFont, 18 )
defaultLabel:setFillColor( 170/255, 1, 170/255 )

local defaultLabel = display.newText( "Email", 200, 195, native.systemFont, 18 )
defaultLabel:setFillColor( 120/255, 1, 245/255 )

local defaultLabel = display.newText( "Password", 200, 235, native.systemFont, 18 )
defaultLabel:setFillColor( 1, 235/255, 170/255 )

--display.setDefault( "anchorX", 0.5 )	-- restore anchor points for new objects to center anchor point
--display.setDefault( "anchorY", 0.5 )

-------------------------------------------
-- *** Create Buttons ***
-------------------------------------------

-- "Remove Default" Button
defaultButton = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Remove Default textField",
	labelColor = 
	{ 
		default = { 1, 1, 1 }, 
	},
	fontSize = 18,
	emboss = true,
	onPress = defaultButtonPress,
}

-- "Remove Number" Button
numberButton = widget.newButton
{
	defaultFile = "buttonBlue.png",
	overFile = "buttonBlueOver.png",
	label = "Remove Number textField",
	labelColor = 
	{ 
		default = { 1, 1, 1 }, 
	},
	fontSize = 18,
	emboss = true,
	onPress = numberButtonPress,
}

-- Position the buttons on screen
defaultButton.x = display.contentCenterX - defaultButton.contentWidth/2;	defaultButton.y = 325
numberButton.x =  display.contentCenterX - numberButton.contentWidth/2;	numberButton.y = 400

-------------------------------------------
-- Create a Background touch event
-------------------------------------------

local bkgd = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
bkgd:setFillColor( 0, 0, 0, 0 )		-- set Alpha = 0 so it doesn't cover up our buttons/fields

-- Tapping screen dismisses the keyboard
--
-- Needed for the Number and Phone textFields since there is
-- no return key to clear focus.

local listener = function( event )
	-- Hide keyboard
	print("tap pressed")
	native.setKeyboardFocus( nil )
	
	return true
end

-- Add listener to background for user "tap"
bkgd:addEventListener( "tap", listener )
