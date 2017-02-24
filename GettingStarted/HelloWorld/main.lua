-- 
-- Abstract: Hello World sample app, using native system font 
--
-- Version: 1.3
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright © 2017 Corona Labs Inc. All Rights Reserved.
--
------------------------------------------------------------

local background = display.newImageRect( "world.jpg", display.contentWidth, display.contentHeight )
background.x = display.contentCenterX
background.y = display.contentCenterY

local myText = display.newText( "Hello, World!", display.contentCenterX, display.contentHeight / 2, native.systemFontBold, 40 )
myText:setFillColor( 0.95, 0.49, 0.13 )
