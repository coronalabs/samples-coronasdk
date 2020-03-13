
-- Abstract: InputDevices
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Control and Movement", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
local composer = require( "composer" )
local mainScene = display.newGroup()
display.getCurrentStage():insert( sampleUI.backGroup )
display.getCurrentStage():insert( mainScene )
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Frequently used variables
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local originX = display.screenOriginX
local originY = display.screenOriginY
local width = display.actualContentWidth
local height = display.actualContentHeight

-- Load background and character from "background.lua" and "character.lua" respectively
local background = require( "background" )
mainScene:insert( background )

local character = require( "character" )
mainScene:insert( character )


-------------------------
-- BEGIN MOVEMENT LOGIC
-------------------------

-- Movement logic variables
local movementSpeed = 1.5
local moving = false
local moveDirection = "down"

-- Sets if the character should move and updates sprite animation
local function setMoving( state )
	moving = state
	if ( moving ) then
		character:play()
	else
		character:pause()
		character:setFrame(2)
	end
end

-- Sets the direction that the player should move and updates the character's sprite facing
local function setMovementDirection( direction )
	-- Don't change anything if we haven't altered direction
	if ( moveDirection == direction ) then
		return
	end

	-- Update the sprite playback
	moveDirection = direction
	character:setSequence( "walk-" .. direction )

	-- Refresh animation playback, which can pause after changing the sprite sequence
	setMoving( moving )
end

-- Set movement magnitudes
local movementX = 0
local movementY = 0
local function setMovement( x, y )
	local updatedMovement = false

	-- Horizontal movement checks
	if ( movementX ~= x and nil ~= x ) then
		movementX = x
		updatedMovement = true
	end

	-- Vertical movement checks
	if ( movementY ~= y and nil ~= y ) then
		movementY = y
		updatedMovement = true
	end

	-- Abort if nothing is updating
	-- We do this since axis/key events can fire multiple times with the same values
	if ( not updatedMovement ) then
		return
	end

	-- Determine movement direction
	if ( 0 ~= movementX or 0 ~= movementY ) then
		-- Favor horizontal animations over vertical ones
		if ( math.abs( movementX ) >= math.abs( movementY ) ) then
			if ( 0 < movementX ) then
				setMovementDirection( "right" )
			else
				setMovementDirection( "left" )
			end
		else
			if ( 0 < movementY ) then
				setMovementDirection( "down" )
			else
				setMovementDirection( "up" )
			end
		end
	end

	-- Update moving animation/variable
	if ( 0 == movementX and 0 == movementY ) then
		setMoving( false )
	else
		setMoving( true )
	end
end

-- Handle character translation on the screen per frame
local function onFrameEnter()
	if ( 0 ~= movementX ) then
		character.x = character.x + ( movementSpeed * movementX )
		setMoving( true )
	end

	if ( 0 ~= movementY ) then
		character.y = character.y + ( movementSpeed * movementY )
		setMoving( true )
	end
end
Runtime:addEventListener( "enterFrame", onFrameEnter )


---------------------------
-- BEGIN INPUT CODE: TOUCH
---------------------------

local padGraphic, padButtonUp, padButtonDown, padButtonLeft, padButtonRight

-- Determine if we have a joystick connected or not
local inputDevices = system.getInputDevices()
local function getHasJoystick()
	for i = 1, #inputDevices do
		if ( "joystick" == inputDevices[i].type ) then
			return true
		end
	end
	return false
end

local hasJoystick = getHasJoystick()

-- If we don't have any controllers found, create a virtual D-pad controller
if ( not hasJoystick ) then

	-- Called when one of the virtual D-pad buttons are used
	local function onTouchEvent( event )
		local phase = event.phase
		local targetID = event.target.id

		if ( "began" == phase or "moved" == phase ) then
			if ( "up" == targetID ) then
				setMovement( 0, -1 )
			elseif ( "down" == targetID ) then
				setMovement( 0, 1 )
			elseif ( "left" == targetID ) then
				setMovement( -1, 0 )
			elseif ( "right" == targetID ) then
				setMovement( 1, 0 )
			elseif ( "padGraphic" == targetID ) then
				setMovement( 0, 0 )
			end

		elseif ( "ended" == phase or "cancelled"  == phase ) then
			-- An alternative to checking for "cancelled" is to set focus on the control
			-- However, we don't want an incoming phone call to bug out input
			if ( "up" == targetID or "down" == targetID ) then
				setMovement( nil, 0 )
			elseif ( "left" == targetID or "right" == targetID ) then
				setMovement( 0, nil )
			end
		end
		return true
	end

	-- Create the visuals for the on-screen D-pad
	local padSize = 200
	padGraphic = display.newImageRect( mainScene, "pad.png", padSize, padSize )
	padGraphic.x = originX + padSize/2 - 40
	padGraphic.y = height + originY - padSize/2 + 40
	padGraphic.alpha = 0.35
	padGraphic.id = "padGraphic"
	padGraphic:addEventListener( "touch", onTouchEvent )

	-- Creates one of the invisible virtual D-pad buttons
	local function createPadButton( buttonID, offsetX, offsetY )
		local btn = display.newRect( mainScene, padGraphic.x+offsetX, padGraphic.y+offsetY, padSize/5, padSize/5 )
		btn:addEventListener( "touch", onTouchEvent )
		btn.id = buttonID
		btn.isVisible = false
		btn.isHitTestable = true
		return btn
	end

	-- Create buttons for handling the D-pad input
	padButtonUp = createPadButton( "up", 0, padSize/-5 )
	padButtonDown = createPadButton( "down", 0, padSize/5 )
	padButtonLeft = createPadButton( "left", padSize/-5, 0 )
	padButtonRight = createPadButton( "right", padSize/5, 0 )
end


--------------------------------------------------
-- BEGIN INPUT CODE: KEYBOARD & BASIC CONTROLLER
--------------------------------------------------

-- Detect if a joystick axis is being used
local joystickInUse = false

-- Keyboard input configuration
local keyUp = "up"
local keyDown = "down"
local keyLeft = "left"
local keyRight = "right"

-- Called when a key event has been received
local function onKeyEvent( event )
	local keyName = event.keyName
	local phase = event.phase

	-- Handle movement keys events; update movement logic variables
	if ( not joystickInUse ) then
		if ( "down" == phase ) then
			if ( keyUp == keyName ) then
				setMovement( nil, -1 )
			elseif ( keyDown == keyName ) then
				setMovement( nil, 1 )
			elseif ( keyLeft == keyName ) then
				setMovement( -1, nil )
			elseif ( keyRight == keyName ) then
				setMovement( 1, nil )
			end
		elseif ( "up" == phase ) then
			if ( keyUp == keyName ) then
				setMovement( nil, 0 )
			elseif ( keyDown == keyName ) then
				setMovement( nil, 0 )
			elseif ( keyLeft == keyName ) then
				setMovement( 0, nil )
			elseif ( keyRight == keyName ) then
				setMovement( 0, nil )
			end
		end
	end

	return false
end
Runtime:addEventListener( "key", onKeyEvent )


------------------------------------------
-- BEGIN INPUT CODE: ADVANCED CONTROLLER
------------------------------------------

-- We only support advanced controllers when one is detected
if ( getHasJoystick ) then
	-- Detect axis event updates
	local function onAxisEvent( event )
		local value = event.normalizedValue
		local axis = event.axis.type
		local descriptor = event.axis.descriptor

		-- We only care about "x" and "y" input events
		-- However, touch-screen events can fire these as well so we filter them out
		if ( ( "x" ~= axis and "y" ~= axis ) or ( string.find( descriptor, "Joystick" ) == nil ) ) then
			return
		end

		-- Detect zero movement at a certain cutoff so we don't get the character moving very, very slowly
		if ( math.abs(value) < 0.15 ) then
			value = 0
		end

		-- Based on which axis type we are dealing with, set movement variables
		if ( "x" == axis ) then
			setMovement( value, nil )
		elseif ( "y" == axis ) then
			setMovement( nil, value )
		end

		-- Some devices will send both up/down/left/right keys and the axis value
		-- We let our code know that we are using a joystick value so they do not conflict
		if ( 0 ~= value ) then
			joystickInUse = true
		else
			joystickInUse = false
		end
	end
	Runtime:addEventListener( "axis", onAxisEvent )
end
