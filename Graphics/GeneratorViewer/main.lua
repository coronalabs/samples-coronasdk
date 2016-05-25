-- 
-- Abstract: GeneratorViewer sample app
--  
-- Version: 2.0
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar ) 
-- display.setDefault( "background", 1 )

-- Some effects are time based (e.g. random),
-- so force Corona to re-blit them.
display.setDrawMode( "forceRender" )

local titleString = "Generator Effects"

-- Modules
-------------------------------------------------------------------------------

local widget = require( "widget" )
local json = require "json"

-- Constants
-------------------------------------------------------------------------------

-- create a constant for the left spacing of the row content
local LEFT_PADDING = 10
local halfW = display.contentCenterX
local halfH = display.contentCenterY
local width = display.actualContentWidth

local supportHPS = system.getInfo( "gpuSupportsHighPrecisionFragmentShaders" )

-- Forward declares
-------------------------------------------------------------------------------
local list
local previewShowing = false

-- Views
-------------------------------------------------------------------------------

--Create a group to hold our widgets & images
local view = display.newGroup()

-- Create toolbar to go at the top of the screen
local titleBar = display.newRect( view, halfW, 0, width, 32 )
titleBar.fill = { type = 'gradient', color1 = { .74, .8, .86, 1 }, color2 = { .35, .45, .6, 1 } }
titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5

-- create embossed text to go on toolbar
local titleText = display.newEmbossedText( view, titleString , halfW, titleBar.y, native.systemFontBold, 20 )

-- Preview group
-------------------------------------------------------------------------------
local preview = display.newGroup()
preview:translate( halfW + width, halfH )

local after = display.newRect( preview, 0, 0, 160, 160 )

local onBackRelease = function()
	--Transition in the list, transition out the item selected text and the back button
	--The table x origin refers to the center of the table in Graphics 2.0, so we translate with half the object's contentWidth
	transition.to( list, { x = width * 0.5 + display.screenOriginX, time = 400, transition = easing.outExpo } )
	transition.to( preview, { x = width + preview.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
	titleText.text = titleString
	previewShowing = false
end

-- Back button
local backButton = widget.newButton
{
	x = 0,
	y = after.contentHeight,
	width = 298,
	height = 56,
	label = "Back", 
	labelYOffset = - 1,
	onRelease = onBackRelease
}
preview:insert( backButton )

-- Precision information.
local precisionText = display.newText
{
	x = 0,
	y = - after.contentHeight,
	fontSize = 14,
	text="This effect is not supported by this device's GPU",
}
precisionText:setFillColor( 1, 0, 0 )
preview:insert( precisionText )

-- preview is child of main view
view:insert( preview )


-- UI
-------------------------------------------------------------------------------

-- Handle row rendering
local function onRowRender( event )
	local phase = event.phase
	local row = event.row
	
	-- Precalculate y position. NOTE: row's height will change as we add children
	local y = row.contentHeight * 0.5

	local rowTitle = display.newText( row, row.id.name, 0, 0, native.systemFontBold, 16 )
	local rowArrow = display.newImage( row, "rowArrow.png", false )

	-- Left-align title
	rowTitle.anchorX = 0
	rowTitle.x = LEFT_PADDING
	rowTitle.y = y
	rowTitle:setFillColor( 0 )
	
	-- Right-align the arrow
	rowArrow.anchorX = 1
	rowArrow.x = row.contentWidth - LEFT_PADDING
	rowArrow.y = y
end

-- Hande row touch events
local function onRowTouch( event )
	local phase = event.phase
	local row = event.target
	
	if "press" == phase then
		-- print( "Pressed row: " .. row.index )
	elseif "release" == phase then
		-- Set preview effect
		after.fill.effect = row.id.name

		-- Alert the user if this device does not support high precision fragment shaders.
		if row.id.reqhp and not supportHPS then
			precisionText.isVisible = true
		else
			precisionText.isVisible = false
		end

		
		--Transition out the list, transition in the item selected text and the back button
		-- The table x origin refers to the center of the table in Graphics 2.0, so we translate with half the object's contentWidth
		transition.to( list, { x = - width * 0.5 + display.screenOriginX, time = 400, transition = easing.outExpo } )
		transition.to( preview, { x = display.contentCenterX, time = 400, transition = easing.outExpo } )
		titleText.text = row.id.name:sub( 11 )
		previewShowing = true
		-- print( "Tapped and/or Released row: " .. row.index )
	end
end

-- Create a tableView
list = widget.newTableView
{
	top = titleBar.contentHeight + display.screenOriginY,
	left = display.screenOriginX,
	width = width, 
	height = display.actualContentHeight - titleBar.contentHeight,
	onRowRender = onRowRender,
	onRowTouch = onRowTouch,
}

-- list is child of main view
view:insert( list )


-- Load effect list
-------------------------------------------------------------------------------

-- Read effects from json
local f = io.open( system.pathForFile( "generators.json" ) )
local data = f:read( "*a" )
local effects = json.decode( data )

for i = 1, #effects do
	list:insertRow{
		id = effects[i], -- use name of effect as id
		height = 72,
		category = "foo"
	}
end

-- handle key events
local function onKeyEvent( event )

    local phase = event.phase
    local keyName = event.keyName

    if ( "back" == keyName and "up" == phase ) then
        if previewShowing then
            onBackRelease()
        else
            native.requestExit()
        end
        -- we handled the key event, return true
        return true
    end
    -- we did not handle the key event, let the system know it has to deal with it
    return false
end
Runtime:addEventListener( "key", onKeyEvent )
