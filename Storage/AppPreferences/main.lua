-- Abstract: AppPreferences
-- Version: 1.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )


------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------

local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="App Preferences", showBuildNum=true } )


------------------------------
-- CONFIGURE STAGE
------------------------------

display.getCurrentStage():insert( sampleUI.backGroup )
local sceneGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )


------------------------------
-- BEGIN SAMPLE CODE
------------------------------

-- Load libraries/plugins
local widget = require( "widget" )

if system.getInfo( "platform" ) == "android" then
	widget.setTheme( "widget_theme_android_holo_dark" )
end


-- Increments the number of time this app has been launched by 1 and saves to storage
local function incrementAppLaunchCount()
	-- First, read the last stored count from the app's preferences
	-- Will return nil if the preference does not exist, which happens on first launch
	local launchCount = system.getPreference( "app", "appLaunchCount", "number" )
	if ( launchCount == nil ) or ( launchCount < 0 ) then
		launchCount = 0
	end

	-- Increment the launch count and save it to storage
	launchCount = launchCount + 1
	system.setPreferences( "app", { appLaunchCount = launchCount } )
end
incrementAppLaunchCount()


-- Display the app launch count header text
local launchCountHeader = display.newText( sceneGroup, "App Launch Count:", 20, 40, sampleUI.appFont, 20 )
launchCountHeader:setFillColor( 1, 0.7, 0.35 )
launchCountHeader.anchorX = 0
launchCountHeader.anchorY = 0

-- Display the app launch count value text
-- This text object will be updated by the loadPreferences() function below
local launchCountValueText = display.newText( sceneGroup, "", 260, 40, sampleUI.appFont, 20 )
launchCountValueText.anchorX = 0
launchCountValueText.anchorY = 0


-- "Boolean" On/Off Switch Fields
-- Set up the on/off switch's header text
local onOffHeader = display.newText( sceneGroup, "Boolean:", 20, 90, sampleUI.appFont, 20 )
onOffHeader:setFillColor( 1, 0.7, 0.35 )
onOffHeader.anchorX = 0
onOffHeader.anchorY = 0

-- Set up the on/off switch's value text used to display the switch's current state
local onOffValueText = display.newText( sceneGroup, "", 260, 90, sampleUI.appFont, 20 )
onOffValueText.anchorX = 0
onOffValueText.anchorY = 0

-- Set up the on/off switch
local onOffSwitch = widget.newSwitch(
{
	left = 110,
	top = 90,
	style = "onOff",
	onRelease = function( event )
		-- Update this switch's value text when changed
		onOffValueText.text = tostring( event.target.isOn )
	end,
} )
sceneGroup:insert( onOffSwitch )


-- "Number" Stepper Fields
-- Set up the stepper's header text
local stepperHeader = display.newText( sceneGroup, "Number:", 20, 140, sampleUI.appFont, 20 )
stepperHeader:setFillColor( 1, 0.7, 0.35 )
stepperHeader.anchorX = 0
stepperHeader.anchorY = 0

-- Set up the stepper's value text used to display the stepper's current value
local stepperValueText = display.newText( sceneGroup, "", 260, 140, sampleUI.appFont, 20 )
stepperValueText.anchorX = 0
stepperValueText.anchorY = 0

-- Set up the numeric stepper widget
local stepper = widget.newStepper(
{
	left = 110,
	top = 138,
	minimumValue = -10,
	maximumValue = 10,
	onPress = function( event )
		-- Update this stepper's value text when changed
		stepperValueText.text = tostring( event.value )
	end,
} )
sceneGroup:insert( stepper )


-- "String" Segmented Control Fields
-- Set up the segmented control's header text
local segmentedHeader = display.newText( sceneGroup, "String:", 20, 190, sampleUI.appFont, 20 )
segmentedHeader:setFillColor( 1, 0.7, 0.35 )
segmentedHeader.anchorX = 0
segmentedHeader.anchorY = 0

-- Set up the segmented control
local segmentLabels = { "A", "B", "C" }
local segmentedControl = widget.newSegmentedControl(
{
	left = 110,
	top = 190,
	segments = segmentLabels,
	defaultSegment = 1,
	segmentWidth = 46,
} )
sceneGroup:insert( segmentedControl )

-- Function used to select a segment from the above control by name/label
-- Returns true if given name was found and was successfully selected
-- Returns false if give name was not found or if given an invalid argument
local function selectSegementByName( name )
	if type( name ) == "string" then
		for index = 1 , #segmentLabels do
			if segmentLabels[ index ] == name then
				segmentedControl:setActiveSegment( index )
				return true
			end
		end
	end
	return false
end


-- App preferences functions

-- Fetches preferences from storage and updates the screen's UI
local function loadPreferences()
	local value

	-- Fetch the "appLaunchCount" preference from storage and display it on-screen
	-- Note: Will return nil if preference was not found which happens on 1st app launch
	value = system.getPreference( "app", "appLaunchCount", "number" )
	if ( value == nil ) or ( value < 0 ) then
		value = 0
	end
	if value <= 999 then
		launchCountValueText.text = tostring( value )
	else
		launchCountValueText.text = "999+"
	end

	-- Fetch the last on/off switch state saved to storage and update its associated fields
	-- Note: Will return nil if preference was not found, which happens on 1st app launch
	value = system.getPreference( "app", "switchState", "boolean" )
	if value == nil then
		value = false
	end
	onOffSwitch:setState( { isOn=value } )
	onOffValueText.text = tostring( onOffSwitch.isOn )

	-- Fetch the last stepper value saved to storage and update its associated fields
	-- Note: Will return nil if preference was not found, which happens on 1st app launch
	value = system.getPreference( "app", "stepperValue", "number" )
	if value == nil then
		value = 0
	elseif value < -10 then
		value = -10
	elseif value > 10 then
		value = 10
	end
	stepper:setValue( value )
	stepperValueText.text = tostring( stepper:getValue() )

	-- Fetch the last selected segment name saved to storage and update its associated fields
	-- Note: Will return nil if preference was not found, which happens on 1st app launch
	value = system.getPreference( "app", "segmentName", "string" )
	local wasSuccessful = selectSegementByName( value )
	if not wasSuccessful then
		selectSegementByName( segmentLabels[1] )
	end

	-- Log that we've updated this app's UI with the loaded preferences
	print( "Preferences were loaded." )
end
loadPreferences()

-- Writes the current state of all widgets to storage
local function savePreferences()
	-- Fetch current widget states and save them to storage
	local preferences =
	{
		switchState = onOffSwitch.isOn,
		stepperValue = stepper:getValue(),
		segmentName = segmentedControl.segmentLabel,
	}
	local wasSuccessful = system.setPreferences( "app", preferences )

	-- Log whether or not the save was successful
	if wasSuccessful then
		print( "Preferences were saved successfully." )
	else
		print( "ERROR: Failed to save preferences." )
	end
end

-- Deletes this app's preferences from storage and resets the UI back to its defaults
local function deletePreferences()
	-- Delete this app's preferences from storage
	local preferenceNames =
	{
		"appLaunchCount",
		"switchState",
		"stepperValue",
		"segmentName",
	}
	local wasSuccessful = system.deletePreferences( "app", preferenceNames )

	-- Log whether or not deletion was successful
	if wasSuccessful then
		print( "Preferences were deleted successfully." )
	else
		print( "ERROR: Failed to delete preferences." )
	end

	-- Update the screen's widgets back to their default values
	loadPreferences()
end


-- Save, Restore, and Reset Buttons
local saveButton = widget.newButton(
{
	left = 20,
	top = 270,
	width = 88,
	height = 32,
	label = "Save",
	shape = "rect",
	fontSize = 16,
	font = sampleUI.appFont,
	fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = savePreferences,
} )
sceneGroup:insert( saveButton )

local restoreButton = widget.newButton(
{
	left = 116,
	top = 270,
	width = 88,
	height = 32,
	label = "Restore",
	shape = "rect",
	fontSize = 16,
	font = sampleUI.appFont,
	fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = loadPreferences,
} )
sceneGroup:insert( restoreButton )

local resetButton = widget.newButton(
{
	left = 212,
	top = 270,
	width = 88,
	height = 32,
	label = "Reset",
	shape = "rect",
	fontSize = 16,
	font = sampleUI.appFont,
	fillColor = { default={ 0.55,0.125,0.125,1 }, over={ 0.66,0.15,0.15,1 } },
	labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
	onRelease = deletePreferences,
} )
sceneGroup:insert( resetButton )
