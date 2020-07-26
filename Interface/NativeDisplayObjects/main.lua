
-- Abstract: NativeDisplayObjects
-- Version: 2.0
-- Sample code is MIT licensed; see https://solar2d.com/LICENSE.txt
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
native.setProperty( "preferredScreenEdgesDeferringSystemGestures", true ) 
------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local darkMode = system.getInfo("darkMode")
local theme = "darkgrey"
if darkMode then
	theme = "mediumgrey"
end

local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme = theme, title = "Native Display Objects", showBuildNum = false } )

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

-- Set app font
local appFont = sampleUI.appFont

-- Local variables and forward references
local labelGroup = display.newGroup() ; mainGroup:insert( labelGroup )
local mapLocationAttempts = 0
local currentObject = ""
local textField
local textBox
local mapView
local webView

-- Create invisible background element for hiding the keyboard (when applicable)
local backRect = display.newRect( mainGroup, display.contentCenterX, display.contentCenterY, 1000, 1000 )
backRect.isVisible = false
backRect.isHitTestable = true

local objectLabel = display.newText( mainGroup, "", display.contentCenterX, display.screenOriginY+54, appFont, 17 )
objectLabel:setFillColor( 1, 0.4, 0.25 )

-- Cleanup function
local function cleanUp( event )

	-- Remove existing labels
	for i = labelGroup.numChildren,1,-1 do
		display.remove( labelGroup[i] )
		labelGroup[i] = nil
	end
	objectLabel.text = ""
	currentObject = ""

	-- Remove existing native objects
	if ( textField ) then
		display.remove( textField )
		textField = nil
	elseif ( textBox ) then
		display.remove( textBox )
		textBox = nil
	elseif ( mapView ) then
		display.remove( mapView )
		mapView = nil
	elseif ( webView ) then
		display.remove( webView )
		webView = nil
	end
end

local function closeKeyboard()
	if ( sampleUI:isInfoShowing() == true ) then return end
	backRect:removeEventListener( "touch", closeKeyboard )
	native.setKeyboardFocus( nil )
	if ( textBox and textBox.tip ) then
		transition.to( textBox.tip, { time=250, alpha=0, transition=easing.outQuad } )
	end
	return true
end

local function closeMap( event )
	if ( sampleUI:isInfoShowing() == true ) then return end
	if ( mapView and event.y > mapView.y-(mapView.height/2) ) then return end
	if ( event.phase == "began" ) then
		backRect:removeEventListener( "touch", closeMap )
		cleanUp()
	end
	return true
end

local function closeWebView( event )
	if ( sampleUI:isInfoShowing() == true ) then return end
	if ( webView and event.y > webView.y-(webView.height/2) ) then return end
	if ( event.phase == "began" ) then
		backRect:removeEventListener( "touch", closeWebView )
		cleanUp()
	end
	return true
end

-- Input handler for text field/box
local function inputListener( event )

	if ( event.phase == "began" ) then
		if ( textBox and textBox.tip and system.getInfo("environment") ~= "simulator" ) then
			transition.to( textBox.tip, { time=250, alpha=1, transition=easing.outQuad } )
		end
		backRect:addEventListener( "touch", closeKeyboard )
	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
		closeKeyboard()
	end
end

-- Location handler for map view
local function locationHandler( event )

	if ( mapView == nil ) then return end
	local currentLocation = mapView:getUserLocation()

	if ( currentLocation.errorCode or ( currentLocation.latitude == 0 and currentLocation.longitude == 0 ) ) then
		-- Location may not be returned on first attempt, so continue querying every 500 milliseconds
		mapLocationAttempts = mapLocationAttempts + 1
		if ( mapLocationAttempts > 10 ) then
			native.showAlert( "Location Error", currentLocation.errorMessage, { "OK" } )
		else
			timer.performWithDelay( 500, locationHandler )
		end
	else
		-- Center map at current latitude and longitude
		mapView:setCenter( currentLocation.latitude, currentLocation.longitude )
	end
end

-- Button handler function
local function onButtonRelease( event )

	local buttonID = event.target.id

	if ( event.target.id == currentObject or mapView ~= nil ) then return end
	-- Remove existing objects before creating new ones
	cleanUp()

	if ( buttonID == "Text Field" ) then
		-- Create native text field
		textField = native.newTextField( display.contentCenterX, objectLabel.y+40, 260, 30 )
		textField.font = native.newFont( appFont )
		textField:resizeFontToFitHeight()
		textField:setReturnKey( "done" )
		textField.placeholder = "Enter text"
		textField:addEventListener( "userInput", inputListener )
		native.setKeyboardFocus( textField )
		objectLabel.text = "Text Field"

	elseif ( buttonID == "Text Box" ) then
		-- Create native text box
		textBox = native.newTextBox( display.contentCenterX, objectLabel.y+65, 260, 80 )
		textBox.font = native.newFont( appFont, 17 )
		textBox.isEditable = true
		textBox.placeholder = "Enter your text"
		textBox:addEventListener( "userInput", inputListener )
		objectLabel.text = "Text Box"
		textBox.tip = display.newText( labelGroup, "(touch outside box to close keyboard)", display.contentCenterX, textBox.y+60, appFont, 14 )
		textBox.tip:setFillColor( 0.6 )
		textBox.tip.alpha = 0

	elseif ( buttonID == "Alert" ) then
		-- Create native alert
		local alertBox = native.showAlert( "Custom Alert", "This is a native alert with customizable title, text, and buttons which can perform various actions upon being clicked.", { "OK", "solar2d.com" },
			function( event )
				if ( event.action == "clicked" ) then
					if ( event.index == 2 ) then
						system.openURL( "https://www.solar2d.com" )
					end
					cleanUp()
				end
			end
		)
		objectLabel.text = ""

	elseif ( buttonID == "Activity" ) then
		-- Show native activity indicator
		native.setActivityIndicator( true )
		-- Hide it after 2 seconds
		timer.performWithDelay( 2000,
			function()
				native.setActivityIndicator( false )
				cleanUp()
			end
		)
		objectLabel.text = ""

	elseif ( buttonID == "Map View" ) then
		-- Create native map view
		local mapHeight = display.actualContentHeight - ( objectLabel.y - display.screenOriginY + 50 )
		mapView = native.newMapView( display.contentCenterX, objectLabel.y+(mapHeight/2)+50, display.actualContentWidth, mapHeight )
		mapView.mapType = "standard"
		objectLabel.text = "Map View"
		mapView.tip = display.newText( labelGroup, "(touch outside map to close)", display.contentCenterX, objectLabel.y+25, appFont, 14 )
		mapView.tip:setFillColor( 0.6 )
		backRect:addEventListener( "touch", closeMap )
		mapLocationAttempts = 0
		locationHandler()
	
	elseif ( buttonID == "Web View" ) then
		-- Create native web view
		local viewHeight = display.contentHeight - ( objectLabel.y - display.screenOriginY + 50 )
		webView = native.newWebView( display.contentCenterX, objectLabel.y+(viewHeight/2)+50, display.actualContentWidth, viewHeight )
		webView:request( "https://www.solar2d.com" )
		objectLabel.text = "Web View"
		webView.tip = display.newText( labelGroup, "(touch outside web view to close)", display.contentCenterX, objectLabel.y+25, appFont, 14 )
		webView.tip:setFillColor( 0.6 )
		backRect:addEventListener( "touch", closeWebView )
	end

	currentObject = event.target.id
	return true
end

-- Callback function for showing/hiding info box
sampleUI.onInfoEvent = function( event )

	if ( event.action == "show" and event.phase == "will" ) then
		native.setKeyboardFocus( nil )
		if ( textField ) then textField.isVisible = false end
		if ( textBox ) then textBox.isVisible = false end
		if ( mapView ) then mapView.isVisible = false end
		if ( webView ) then webView.isVisible = false end
	elseif ( event.action == "hide" and event.phase == "did" ) then
		if ( textField ) then textField.isVisible = true end
		if ( textBox ) then textBox.isVisible = true end
		if ( mapView ) then mapView.isVisible = true end
		if ( webView ) then webView.isVisible = true end
	end
end

-- Table of labels for buttons
local menuButtons = { "Text Field", "Text Box", "Alert", "Activity", "Map View", "Web View" }

-- Loop through table to display buttons
local rowNum = 0
local buttonGroup = display.newGroup()
for i = 1,#menuButtons do
	rowNum = rowNum+1
	local button = widget.newButton(
	{
		label = menuButtons[i],
		id = menuButtons[i],
		shape = "rectangle",
		width = 130,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = onButtonRelease
	})
	if ( i <= 3 ) then
		button.x = display.contentCenterX - 74
	else
		if ( rowNum == 4 ) then rowNum = 1 end
		button.x = display.contentCenterX + 74
	end
	button.y = 165 + ((rowNum-1)*50)
	buttonGroup:insert( button )
	
	if ( menuButtons[i] == "Map View" and ( system.getInfo("environment") == "simulator" or system.getInfo("platform") == "macos" or system.getInfo("platform") == "win32" ) ) then
		button:setEnabled( false )
		button.alpha = 0.3
	end
end
mainGroup:insert( buttonGroup )
buttonGroup.anchorChildren = true
buttonGroup.x = display.contentCenterX
buttonGroup.y = display.contentHeight - (buttonGroup.contentHeight/2) - display.safeScreenOriginY - 18
