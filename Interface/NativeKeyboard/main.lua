
-- Abstract: NativeKeyboard
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local darkMode = system.getInfo("darkMode")
local theme = "darkgrey"
if darkMode then
	theme = "mediumgrey"
end
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme = theme, title = "Native Keyboard", showBuildNum = false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Require libraries/plugins
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios7" )

-- Set app font
local appFont = sampleUI.appFont

-- Local variables and forward references
local letterboxWidth = math.abs(display.safeScreenOriginX)
local field

-- Label/value for the phase of the keyboard input
local phaseLabel = display.newText( mainGroup, "Input Phase:", 30-letterboxWidth, sampleUI.titleBarBottom+382 + display.safeScreenOriginY, appFont, 17 )
phaseLabel.anchorX = 0
phaseLabel:setFillColor( 1, 0.4, 0.25 )
local phaseValue = display.newText( mainGroup, "—", phaseLabel.contentBounds.xMax+5, phaseLabel.y, appFont, 17 )
phaseValue.anchorX = 0
phaseValue:setFillColor( 0.8 )

-- Input handler
local function inputListener( event )

	-- Update displayed phase value
	phaseValue.text = event.phase

	if ( event.phase == "began" ) then
		-- User begins selection/editing of field

	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		-- Output resulting text from field
        print( "FINAL INPUT: " .. event.target.text )

	elseif ( event.phase == "editing" ) then
		-- Output new characters and current field input
		print( "NEW CHARACTERS: " .. event.newCharacters )
		print( "CURRENT INPUT: " .. event.text )
	end
end

local function createField( fieldType )

	native.setKeyboardFocus( nil )

	-- Destroy existing input field/box
	if ( field ) then
		display.remove( field ) ; field = nil
	end

	-- Create new basic input field or box
	if ( fieldType == "Multi-Line" ) then
		field = native.newTextBox( display.contentCenterX, sampleUI.titleBarBottom+195 - display.safeScreenOriginY, 260+(letterboxWidth*2), 60 )
		field.font = native.newFont( appFont, 17 )
		field.isEditable = true
	else
		field = native.newTextField( display.contentCenterX, sampleUI.titleBarBottom+195 - display.safeScreenOriginY, 260+(letterboxWidth*2), 30 )
		field.font = native.newFont( appFont )
		field:resizeFontToFitHeight()
	end
	field:addEventListener( "userInput", inputListener )

	-- Set additional properties based on type
	if ( fieldType == "Numeric" ) then
		field.inputType = "number"
	elseif ( fieldType == "Decimal" ) then
		field.inputType = "decimal"
	elseif ( fieldType == "Phone" ) then
		field.inputType = "phone"
	elseif ( fieldType == "URL" ) then
		field.inputType = "url"
	elseif ( fieldType == "Email" ) then
		field.inputType = "email"
	elseif ( fieldType == "No Emoji" ) then
		field.inputType = "no-emoji"
	elseif ( fieldType == "Password" ) then
		field.isSecure = true
	end
end

-- Create default input field initially
createField( "Default" )

-- Label reference for picker wheel
local inputTypeLabels = { "Default", "Multi-Line", "Numeric", "Decimal", "Phone", "URL", "Email", "No Emoji", "Password" }

-- Create picker wheel for input types
local columnData = {
	{
		align = "center",
		width = display.actualContentWidth,
		startIndex = 1,
		labels = inputTypeLabels
	}
}

local pickerWheel = widget.newPickerWheel(
{
	left = 0-letterboxWidth,
	top = sampleUI.titleBarBottom - display.safeScreenOriginY,
	columns = columnData,
	style = "resizable",
	width = display.actualContentWidth,
	rowHeight = 30,
	font = appFont,
	fontSize = 15,
	onValueSelected = function( event ) phaseValue.text = "—"; createField( inputTypeLabels[event.row] ); end
})
mainGroup:insert( pickerWheel )

-- Create invisible background element for hiding the keyboard
local backRect = display.newRect( mainGroup, display.contentCenterX, display.contentCenterY, 1000, 1000 )
backRect.isVisible = false
backRect.isHitTestable = true
backRect:toBack()
backRect:addEventListener( "touch",
	function( event )
		if ( sampleUI:isInfoShowing() == true ) then return end
		if ( event.phase == "began" ) then
			native.setKeyboardFocus( nil )
		end
		return true
	end
)

-- Callback function for showing/hiding info box
sampleUI.onInfoEvent = function( event )

	if ( event.action == "show" and event.phase == "will" ) then
		native.setKeyboardFocus( nil )
		if ( field ) then field.isVisible = false end
		phaseLabel.isVisible = false
		phaseValue.isVisible = false
	elseif ( event.action == "hide" and event.phase == "did" ) then
		if ( field ) then field.isVisible = true end
		phaseLabel.isVisible = true
		phaseValue.isVisible = true
	end
end
