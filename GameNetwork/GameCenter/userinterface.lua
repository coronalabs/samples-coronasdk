-- Abstract: Userinterface
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
------------------------------------------------------------

local ui = {}
ui.boldFont = "HelveticaNeue-Bold"

local composer = require "composer"

function ui.createLabel( parentGroup, labelText, x, y, anchorY, anchorX, isYellow )
	local text = display.newEmbossedText( parentGroup, labelText, 0, 0, ui.boldFont, 18 )
	text.anchorX = anchorX
	text.anchorY = anchorY
	-- text:setReferencePoint( referencePoint )
	if isYellow then text:setFillColor( 1, 1, 0 ); else text:setFillColor( 1 ); end
	text.x, text.y = x, y
	return text
end

function ui.updateLabel( textObj, labelText, x, y, anchorY, anchorX )
	textObj.anchorX = anchorX
	textObj.anchorY = anchorY
	textObj:setText( labelText )
	-- textObj:setReferencePoint( referencePoint )
	textObj.x, textObj.y = x, y
end

function ui.createTabs( widget )
	-- create buttons table for the tab bar
	local tabButtons = 
	{
		{
			width = 32, 
			height = 32,
			defaultFile = "assets/tabIcon.png",
			overFile = "assets/tabIcon-down.png",
			label = "Score",
			onPress = function() composer.gotoScene( "scoreScene" ); end,
			selected = true
		},
		{
			width = 32,
			height = 32,
			defaultFile = "assets/tabIcon.png",
			overFile = "assets/tabIcon-down.png",
			label = "Boards",
			onPress = function() composer.gotoScene( "boardScene" ); end,
		},
	}
	
	-- create a tab-bar and place it at the bottom of the screen
	local tabs = widget.newTabBar
	{
		top = display.contentHeight - 50,
		width = display.contentWidth,
		backgroundFile = "assets/woodbg.png",
		tabSelectedLeftFile = "assets/tabBar_tabSelectedLeft.png",
		tabSelectedMiddleFile = "assets/tabBar_tabSelectedMiddle.png",
		tabSelectedRightFile = "assets/tabBar_tabSelectedRight.png",
		tabSelectedFrameWidth = 20,
		tabSelectedFrameHeight = 52,
		buttons = tabButtons
	}
end

return ui