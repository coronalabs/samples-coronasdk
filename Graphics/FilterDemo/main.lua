--
-- Abstract: Filter Demo sample app
--
-- Date: September 10, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: graphics, shaders, filters
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

local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5

local group = display.newGroup()
local w,h = 106,160
local x,y = w/2, h/2

local effects = {
	{
		name = "filter.blur"
	},
	{
		name = "filter.pixelate", 
		params = {
			numPixels = 20,
		},
	},
	{
		name = "filter.emboss", 
		params = {
			intensity = 1,
		},
	},
	{
		name = "filter.brightness",
		params = {
			intensity = 0.5,
		},		 
	},
	{
		name = "filter.radialWipe", 
		params = {
			progress = 1,
		},
	},
	{
		name = "filter.wobble", 
		params = {
			amplitude = 10,
		},
	},
	{
		name = "filter.monotone", 
		params = {
			r = 0,
			g = 0,
			b = 1,
			a = 1,
		},
	},
	{
		name = "filter.vignette", 
		params = {
			radius = 1,
		},
	},
	{
		name = "filter.swirl", 
		params = {
			intensity = 1,
		},
	},
}

local function setEffect( effect, filter, t )
	local params = filter.params
	if effect and params then
		for k,v in pairs( filter.params ) do
			effect[k] = v * t
		end
	end
end

-- Some effects are time based (e.g. random),
-- so force Corona to re-blit them.
display.setDrawMode( "forceRender" )

local numImages = 0
for j=1,3 do
	for i=1,3 do
		numImages = numImages + 1
		local image = display.newImageRect( "sample320x480.jpg", w, h )
		group:insert( image )
		image:translate( x + w*(i-1), y + h*(j-1) )

		local filter = effects[numImages]
		image.fill.effect = filter.name

		setEffect( image.fill.effect, filter, 1 )

	end
end

-- Animate effects
local time = 2000
local function animate( event )
	local t = math.sin( event.time / 1000 ) * 0.45 + 0.5 --( event.time % time ) / time
	for i=1,(numImages) do
		local image = group[i]
		setEffect( image.fill.effect, effects[i], t )
	end
end

Runtime:addEventListener( "enterFrame", animate )
