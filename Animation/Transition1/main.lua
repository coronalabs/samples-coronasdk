-- 
-- Abstract: Transition sample app
-- 
-- Version: 1.1
--
-- Copyright (C) 2009 Corona Labs Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
-- Supports Graphics 2.0

-- Demonstrates how to fade out a rectangle

-- Create rectangle
r = display.newRect( display.contentCenterX, display.contentCenterY, 150, 150 )
r:setFillColor( 1, 1, 1 )
countTxt = display.newText( "Start", display.contentCenterX, display.contentCenterY, system.nativeFont, 50 )
countTxt:setFillColor( 1, 0, 0 )
count = 0

local function repeatFade (event)
	r.alpha = 1
	transition.to( r, { alpha=0, time=1000 } )
	count = count + 1
	countTxt.text = count
end

-- Fade out rectangle every second 20x using transition.to()       
timer.performWithDelay(1000, repeatFade, 10 )
