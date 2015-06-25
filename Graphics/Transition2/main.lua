-- 
-- Abstract: Transition2 sample app
-- 
-- Version: 1.0
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


-- Demonstrates a sequence of transitions

display.setDefault( "background", 80/255 )
local square = display.newRect(  0, 0, 100, 100 )
square.anchorChildren = true
square:setFillColor( 255/255,255/255,255/255 )

local w,h = display.contentWidth, display.contentHeight

-- move square to bottom right corner; subtract half side-length b/c 
-- the local origin is at the square’s center; fade out square
transition.to( square, { time=1500, alpha=0, x=(w-50), y=(h-50) } )

-- fade square back in after 2.5 seconds
transition.to( square, { time=500, delay=2500, alpha=1.0 } )