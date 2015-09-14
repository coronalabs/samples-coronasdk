--
-- Abstract: Shape sample app
--
-- Date: September 10, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: graphics, shapes, objects
--
-- File dependencies: none
--
-- Target devices: Simulator and devices
--
-- Limitations:
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local easing = require "easing"

local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5
local angle = 45

-- RoundedRect + color
---------------------------------------------------------------------------------------
local bkgd = display.newRect( 200, 250, halfW, halfW )
bkgd:setFillColor( 1, 0, 0 )

-- Tween fill's color
transition.to( bkgd.fill, { r=0, g=0.3, b=1, time=2000 } )


-- RoundedRect + Gradient
---------------------------------------------------------------------------------------
local dir = "up"
local bkgd = display.newRoundedRect( 100, 350, halfW, halfW, 20 )
bkgd.fill = { type="gradient", color1={ 1, 0, 0 }, color2={0, 0, 1}, direction=dir }

-- Fade out color2 of gradient
transition.to( bkgd.fill, { a2 = 0 } )


-- RoundedRect + Image
---------------------------------------------------------------------------------------
local bkgd = display.newRoundedRect( 100, 150, halfW, halfW, 20 )
bkgd.fill = { type="image", filename="aquariumbackgroundIPhone.jpg" }
bkgd.fill.scaleX = 2
bkgd.fill.scaleY = 2

-- Tween radius of rect
transition.to( bkgd.path, { radius=60, time=2000 } )--bkgd.fill.rotation = 45

-- Tween rotation of image *inside* rect
transition.to( bkgd.fill, { rotation=90, time=2000 })

-- Circle + Textured stroke
---------------------------------------------------------------------------------------

local bkgd = display.newCircle( halfW/2, halfH/2, 50 )
bkgd.fill = nil
bkgd.stroke = { type="image", filename="brush.png"}
bkgd:setStrokeColor( 0, 1, 1 )
bkgd.strokeWidth = 30

-- Tween position
transition.to( bkgd, { x=halfW+50, y= halfH+100, time=5000 } )

-- Tween radius
transition.to( bkgd.path, {radius=150, time=5000})



