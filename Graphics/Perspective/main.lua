--
-- Abstract: 2.5 distortion sample app, demonstrating how to use quadrilateral distortion with transitions
--
-- Date: October, 2013
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: graphics, 2.5D, filters, transitions
--
-- File dependencies: none
--
-- Target devices: Simulator and devices
--
-- Limitations:
--
-- Comments: 
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local logo = display.newImage( "corona-logo.png" )
logo.x = display.contentCenterX ; logo.y = display.contentCenterY
logo.fill.effect = "filter.monotone"
logo.fill.effect.r = 0 ; logo.fill.effect.g = 0 ; logo.fill.effect.b = 0 ; logo.fill.effect.a = 0
--logo.fill.effect.r = 1 ; logo.fill.effect.g = 0.3 ; logo.fill.effect.a = 0.4

local logo90 = display.newImage( "corona-logo90.png" )
logo90.x = display.contentCenterX ; logo90.y = display.contentCenterY
logo90.fill.effect = "filter.monotone"
logo90.fill.effect.r = 1 ; logo90.fill.effect.g = 0.3 ; logo90.fill.effect.b = 0 ; logo90.fill.effect.a = 0.6
logo90.path.x1=150 ; logo90.path.y1=150 ; logo90.path.x2=0 ; logo90.path.y2=0 ; logo90.path.x3=-150 ; logo90.path.y3=-150 ; logo90.path.x4=0 ; logo90.path.y4=0
logo90.isVisible = false

local logoBack = display.newImage( "corona-logo-back.png" )
logoBack.x = display.contentCenterX ; logoBack.y = display.contentCenterY
logoBack.alpha = 0.7 ; logoBack.path.x2 = 150 ; logoBack.path.y2 = -150
logoBack.fill.effect = "filter.monotone"
logoBack.fill.effect.r = 0 ; logoBack.fill.effect.g = 0 ; logoBack.fill.effect.b = 0 ; logoBack.fill.effect.a = 0
logoBack.isVisible = false

local topRightFoldMask = display.newImage( "fold-mask.png" )
topRightFoldMask.anchorX = 1 ; topRightFoldMask.anchorY = 0
topRightFoldMask.x = logo.x+150 ; topRightFoldMask.y = logo.y-150
topRightFoldMask.isVisible = false

local lowerLeftFoldMask = display.newImage( "fold2-mask.png" )
lowerLeftFoldMask.x = logo.x ; lowerLeftFoldMask.y = logo.y
lowerLeftFoldMask.isVisible = false

local topRightFoldMaskL = display.newImage( "fold2-mask.png" )
topRightFoldMaskL.rotation = 180
topRightFoldMaskL.x = logo.x ; topRightFoldMaskL.y = logo.y
topRightFoldMaskL.isVisible = false

local topRightFold = display.newImage( "fold.png" )
topRightFold.anchorX = 1 ; topRightFold.anchorY = 0
topRightFold.x = logo.x+150 ; topRightFold.y = logo.y-150
topRightFold.isVisible = false

local lowerLeftFold = display.newImage( "fold2.png" )
lowerLeftFold.x = logo.x ; lowerLeftFold.y = logo.y
lowerLeftFold.isVisible = false

local lowerLeftFoldFlipped = display.newImage( "fold2b.png" )
lowerLeftFoldFlipped.x = logo.x ; lowerLeftFoldFlipped.y = logo.y
lowerLeftFoldFlipped.path.x4=-148 ; lowerLeftFoldFlipped.path.y4=148
--lowerLeftFoldFlipped.fill.effect = "filter.desaturate" ; lowerLeftFoldFlipped.fill.effect.intensity = 1
lowerLeftFoldFlipped.isVisible = false

-- Create counter for which transition in series
local nextTransition = 0


local transitionParams = {

	--1
	{	trans = { logo.path, logo.fill.effect },
		params = { { time=1200, delay=400, x1=10, y1=10, x2=20, y2=-20, x3=-10, y3=-10, x4=-40, y4=40, transition=easing.inOutSine },
					  { time=1200, delay=400, r=0.2, g=0, b=0.7, a=0.1, transition=easing.inOutSine } }
	},
	--2
	{	trans = { logo.path, logo.fill.effect },
		params = { { time=1200, delay=400, x2=110, y2=-110, x4=-110, y4=110, transition=easing.inOutSine },
					  { time=1200, delay=400, r=0.2, g=0, b=0.7, a=0.2, transition=easing.inOutSine } }
	},
	--3
	{	trans = { logo.path, logo.fill.effect },
		params = { { time=1200, x2=20, y2=-20, x4=-40, y4=40, transition=easing.inOutSine },
					  { time=1200, r=0.2, g=0, b=0.7, a=0.1, transition=easing.inOutSine } }
	},
	--4
	{	trans = { logo.path, logo.fill.effect },
		params = { { time=1600, delay=400, x1=40, y1=40, x2=10, y2=-10, x3=-20, y3=-20, x4=-10, y4=10, transition=easing.inOutSine },
					  { time=1600, delay=400, r=1, g=0.3, b=0, a=0.35, transition=easing.inOutSine }
					}
	},
	--5
	{	trans = { logo.path, logo.fill.effect },
		params = { { time=1600, delay=400, x1=60, y1=60, x2=-10, y2=-30, x3=-40, y3=-40, x4=-10, y4=30, transition=easing.inOutSine },
					  { time=1600, delay=400, r=1, g=0.3, b=0, a=0.6, transition=easing.inOutSine } }
	},
	--6
	{	trans = { logo.path, logo, logo.fill.effect },
		params = { { time=1800, delay=400, x1=0, y1=0, x2=0, y2=0, x3=0, y3=0, x4=0, y4=0, transition=easing.inOutCubic },
					  { time=1800, delay=400, rotation=180, transition=easing.inOutCubic },
					  { time=1800, delay=400, r=0, g=0, b=0, a=0, transition=easing.inOutCubic } }
	},
	--7
	{	unhide = { topRightFoldMask, topRightFold },
		trans = { topRightFold.path, topRightFold },
		params = { { time=1400, delay=500, x4=-50, y4=50, transition=easing.inOutSine },
					  { time=1400, delay=500, alpha=0.7, transition=easing.inOutSine } }
	},
	--8
	{	trans = { topRightFold.path, topRightFold },
		params = { { time=1400, x4=0, y4=0, transition=easing.inOutSine },
					  { time=1400, alpha=1, transition=easing.inOutSine } }
	},
	--9
	{	hide = { topRightFoldMask, topRightFold },
		trans = { logo, logo.path, logo.path, logo.fill.effect, logo.fill.effect },
		params = { { time=2800, rotation=0, transition=easing.inOutSine },
					  { time=1400, x1=10, y1=10, x2=20, y2=-20, x3=-10, y3=-10, x4=-10, y4=10, transition=easing.inOutSine },
					  { time=1400, delay=1400, x1=0, y1=0, x2=0, y2=0, x3=0, y3=0, x4=0, y4=0, transition=easing.inOutSine },
					  { time=1400, r=1, g=0.3, b=0, a=0.35, transition=easing.inOutSine },
					  { time=1400, delay=1400, r=0, g=0, b=0, a=0, transition=easing.inOutSine } }
	},
	--10
	{	unhide = { lowerLeftFold, lowerLeftFoldMask },
		trans = { lowerLeftFold.path },
		params = { { time=400, delay=400, x2=149, y2=-149, transition=easing.inQuad } }
	},
	--11
	{	hide = { lowerLeftFold },
		unhide = { lowerLeftFoldFlipped },
		trans = { lowerLeftFoldFlipped.path },
		params = { { time=400, x4=-50, y4=50, transition=easing.outQuad } }
	},
	--12
	{	trans = { logo.path, logo, logo.fill.effect },
		params = { { time=800, delay=400, x4=-150, y4=150, transition=easing.inQuad },
					  { time=400, delay=400, alpha=0.7, transition=easing.inQuad },
					  { time=300, delay=400, r=0.2, g=0, b=0.7, a=0.08, transition=easing.inQuad } }
	},
	--13
	{	hide = { lowerLeftFoldMask, logo },
		unhide = { logoBack, topRightFoldMaskL },
		trans = { logoBack.path, lowerLeftFoldFlipped.path, logoBack },
		params = { { time=600, x2=0, y2=0, transition=easing.outQuad },
					  { time=600, x4=0, y4=0, transition=easing.outQuad },
					  { time=600, alpha=1, transition=easing.outQuad } }
	},
	--14
	{	hide = { topRightFoldMaskL, lowerLeftFoldFlipped },
		trans = { logoBack.path, logoBack, logoBack.fill.effect },
		params = { { time=1000, delay=400, x1=149, y1=149, x3=-149, y3=-149, transition=easing.inCubic },
					  { time=1000, delay=400, alpha=0.7, transition=easing.inCubic },
					  { time=1000, delay=400, r=1, g=0.3, b=0, a=0.6, transition=easing.inCubic },
					  --{ time=200, x1=150, y1=150, x2=0, y2=0, x3=-150, y3=-150, x4=0, y4=0 },
					  --{ time=200, alpha=1 },
					  --{ time=200, r=1, g=0.3, b=0, a=0.6 }
					  }
	},
	--15
	{	hide = { logoBack },
		unhide = { logo90 },
		trans = { logo90.path, logo90.fill.effect },
		params = { { time=1000, x1=0, y1=0, x3=0, y3=0, transition=easing.outCubic },
					  { time=1000, r=0, g=0, b=0, a=0, transition=easing.outCubic } }
	}
}

-- This function handles the transitions of the object(s)
local function doTrans()

	-- Cancel all existing transitions before starting new transition(s)
	transition.cancel()

	-- Increment series counter
	nextTransition = nextTransition+1

	if ( #transitionParams < nextTransition ) then return end 

	if ( transitionParams[nextTransition].unhide ) then
		for u=1,#transitionParams[nextTransition].unhide do transitionParams[nextTransition].unhide[u].isVisible = true end
	end
	if ( transitionParams[nextTransition].hide ) then
		for h=1,#transitionParams[nextTransition].hide do transitionParams[nextTransition].hide[h].isVisible = false end
	end
	
	for i=1,#transitionParams[nextTransition].trans do
		local ref = transitionParams[nextTransition].trans[i]
		local prm = transitionParams[nextTransition].params[i]
		local params = {}
		for k,v in pairs(prm) do params[k]=v end
		if ( i==1 ) then params["onComplete"] = doTrans end
		transition.to( ref, params )
	end

end

doTrans()
