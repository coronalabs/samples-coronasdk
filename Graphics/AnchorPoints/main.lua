-- 
-- Abstract: Anchor Points sample app, demonstrating to use anchor points.
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

display.setDefault( "background", 80/255 )
local secondHand = display.newImageRect("images/clock-hands-hi.png", 412, 64)

secondHand.anchorX = 0.2257
secondHand.anchorY = 0.5

secondHand.x = display.contentCenterX 
secondHand.y = display.contentCenterY



timer.performWithDelay(1000, function() secondHand.rotation = secondHand.rotation + 6; end, 0)

