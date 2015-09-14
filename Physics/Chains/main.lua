-- 
-- Abstract: Chains sample project
-- Demonstrates how to use a sequence of joints to construct chains
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local physics = require("physics")
physics.start()

physics.setScale( 60 )

display.setStatusBar( display.HiddenStatusBar )

-- The final "true" parameter overrides Corona's auto-scaling of large images
local background = display.newImage( "grille_bkg.png", centerX, centerY, true )

local ground = display.newImage( "ground.png", centerX, 450, true )
physics.addBody( ground, "static", { friction=0.5 } )

local beam1 = display.newImage( "beam.png" )
beam1.x = 20; beam1.y = 350; beam1.rotation = -40
physics.addBody( beam1, "static", { friction=0.5 } )

local beam2 = display.newImage( "beam.png" )
beam2.x = 410; beam2.y = 340; beam2.rotation = 20
physics.addBody( beam2, "static", { friction=0.5 } )

local beam3 = display.newImage( "beam_long.png" )
beam3.x = 280; beam3.y = 50
physics.addBody( beam3, "static", { friction=0.5 } )

local myJoints = {}

for i = 1,5 do
	local link = {}
	for j = 1,17 do
		link[j] = display.newImage( "link.png" )
		link[j].x = 121 + (i*34)
		link[j].y = 55 + (j*17)
		physics.addBody( link[j], { density=2.0, friction=0, bounce=0 } )
		
		-- Create joints between links
		if (j > 1) then
			prevLink = link[j-1] -- each link is joined with the one above it
		else
			prevLink = beam3 -- top link is joined to overhanging beam
		end
		myJoints[#myJoints + 1] = physics.newJoint( "pivot", prevLink, link[j], 121 + (i*34), 46 + (j*17) )

	end
end

local randomBall = function()
	ball = display.newImage( "super_ball.png" )
	ball.x = 10 + math.random( 60 ); ball.y = -20
	physics.addBody( ball, { density=2.9, friction=0.5, bounce=0.7, radius=24 } )
end

-- Call the above function 12 times
timer.performWithDelay( 1500, randomBall, 12 )