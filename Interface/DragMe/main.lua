
-- Abstract: DragMe
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Drag Me", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

local isMultitouchEnabled = false

-- Require libraries/plugins
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios7" )

-- Set app font
local appFont = sampleUI.appFont

-- Function to toggle multitouch
local function onSwitchPress( event )

	if ( event.target.isOn ) then
		-- Activate multitouch
		system.activate( "multitouch" )
		isMultitouchEnabled = true
	else
		-- Loop through touch-sensitive objects and force-release touch
		for i = 1,mainGroup.numChildren do
			if ( mainGroup[i].isDragObject == true ) then
				mainGroup[i]:dispatchEvent( { name="touch", phase="ended", target=mainGroup[i] } )
			end
		end
		-- Deactivate multitouch
		system.deactivate( "multitouch" )
		isMultitouchEnabled = false
	end
end

-- Detect if multitouch is supported
if not system.hasEventSource( "multitouch" ) then

	-- Inform that multitouch is not supported
	local shade = display.newRect( mainGroup, display.contentCenterX, display.contentHeight-display.screenOriginY-18, display.actualContentWidth, 36 )
	shade:setFillColor( 0, 0, 0, 0.7 )
	local msg = display.newText( mainGroup, "Multitouch events not supported on this platform", display.contentCenterX, shade.y, appFont, 13 )
	msg:setFillColor( 1, 0, 0.2 )
else
	-- Create switch/label to enable/disable multitouch
	local enableMultitouchCheckbox = widget.newSwitch(
	{
		x = display.contentCenterX - 68,
		y = display.contentHeight-display.screenOriginY-40,
		style = "checkbox",
		initialSwitchState = true,
		onPress = onSwitchPress
	})
	mainGroup:insert( enableMultitouchCheckbox )
	local checkboxLabel = display.newText( mainGroup, "Enable Multitouch", display.contentCenterX+18, enableMultitouchCheckbox.y, appFont, 16 )

	-- Activate multitouch
	system.activate( "multitouch" )
	isMultitouchEnabled = true
end

-- Touch handling function
local function onTouch( event )

	local obj = event.target
	local phase = event.phase

	if ( "began" == phase ) then

		-- Make target and its label the top-most objects
		obj:toFront()
		obj.label:toFront()

		-- Set focus on the object based on the unique touch ID, and if multitouch is enabled
		if ( isMultitouchEnabled == true ) then
			display.currentStage:setFocus( obj, event.id )
		else
			display.currentStage:setFocus( obj )
		end
		-- Spurious events can be sent to the target, for example the user presses
		-- elsewhere on the screen and then moves the finger over the target;
		-- to prevent this, we add this flag and only move the target when it's true
		obj.isFocus = true

		-- Store initial position
		obj.x0 = event.x - obj.x
		obj.y0 = event.y - obj.y

	elseif obj.isFocus then

		if ( "moved" == phase ) then

			-- Make object move; we subtract "obj.x0" and "obj.y0" so that moves are relative
			-- to the initial touch point rather than the object snapping to that point
			obj.x = event.x - obj.x0
			obj.y = event.y - obj.y0

			-- Update/move object label
			obj.label.text = string.format("%0.0f",obj.x)..", "..string.format("%0.0f",obj.y)
			obj.label.x = obj.x
			obj.label.y = obj.y-(obj.height/2)-14

			-- Gradually show the shape's stroke depending on how much pressure is applied
			if ( event.pressure ) then
				obj:setStrokeColor( 1, 1, 1, event.pressure )
			end

		elseif ( "ended" == phase or "cancelled" == phase ) then

			-- Release focus on the object
			if ( isMultitouchEnabled == true ) then
				display.currentStage:setFocus( obj, nil )
			else
				display.currentStage:setFocus( nil )
			end
			obj.isFocus = false

			obj:setStrokeColor( 1, 1, 1, 0 )
		end
	end
	return true
end

-- Data table for position, radius, and color of objects
local objectData =
{
	{ x=160, y=100, radius=24, r=1, g=0, b=0.1 },
	{ x=65, y=175, radius=32, r=0.95, g=0.1, b=0.3 },
	{ x=200, y=225, radius=48, r=0.9, g=0.2, b=0.5 }
}

-- Loop through table and create objects
for i = 1,#objectData do

	-- Create object
	local obj = display.newCircle( mainGroup, objectData[i].x, objectData[i].y, objectData[i].radius )
	obj:setFillColor( objectData[i].r, objectData[i].g, objectData[i].b )
	obj.isDragObject = true

	-- Set stroke color/width (used for indicating pressure touch)
	obj:setStrokeColor( 1, 1, 1, 0 )
	obj.strokeWidth = 4

	-- Create label to show x/y of object
	obj.label = display.newText( mainGroup, string.format("%0.0f",obj.x)..", "..string.format("%0.0f",obj.y), obj.x, objectData[i].y-(obj.height/2)-14, appFont, 12 )
	obj.label:setFillColor( 0.8 )

	-- Add touch sensitivity to object
	obj:addEventListener( "touch", onTouch )
end
