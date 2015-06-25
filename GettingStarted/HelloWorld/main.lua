-- 
-- Abstract: Hello World sample app, using native iOS font 
-- To build for Android, choose an available font, or use native.systemFont
--
-- Version: 1.2
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
------------------------------------------------------------

local background = display.newImage( "world.jpg", display.contentCenterX, display.contentCenterY )

local myText = display.newText( "Hello, World!", display.contentCenterX, display.contentWidth / 4, native.systemFont, 40 )
myText:setFillColor( 1, 110/255, 110/255 )
