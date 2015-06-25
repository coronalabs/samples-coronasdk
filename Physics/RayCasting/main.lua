-- 
-- Abstract: Ray casting sample project
-- Demonstrates ray casting
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local physics = require( "physics" )
physics.start()

display.setStatusBar( display.HiddenStatusBar )

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- We need this to make the object draggable.
local gameUI = require("gameUI")

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--local instructionLabel = display.newText( "drag any object into the ray", 0, 0, native.systemFontBold, 20 )
display.newText( "drag any object into the ray", centerX, 20, native.systemFontBold, 20 )

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Add all the physics objects.

local ground = display.newImage( "ground.png", 160, 445 )
ground.myName = "ground"
physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )

local crate1 = display.newImage( "crate.png", 120, 392 )
crate1.myName = "crate1"
physics.addBody( crate1 )
crate1:addEventListener( "touch", gameUI.dragBody ) -- Make the object draggable.

local crate2 = display.newImage( "crate.png", 200, 424 )
crate2.myName = "crate2"
physics.addBody( crate2 )
crate2:addEventListener( "touch", gameUI.dragBody ) -- Make the object draggable.

local crate3 = display.newImage( "crate.png", 160, 312 )
crate3.myName = "crate3"
physics.addBody( crate3 )
crate3:addEventListener( "touch", gameUI.dragBody ) -- Make the object draggable.

local crate4 = display.newImage( "crate.png", 160, 262 )
crate4.myName = "crate4"
physics.addBody( crate4 )
crate4:addEventListener( "touch", gameUI.dragBody ) -- Make the object draggable.

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local ray

local ray_from_x = 64
local ray_from_y = 320
local ray_to_x = 256
local ray_to_y = 384

local unbroken_ray = display.newLine( ray_from_x, ray_from_y, ray_to_x, ray_to_y )
unbroken_ray.strokeWidth = 2
unbroken_ray:setStrokeColor( 1, 0, 0 )

local reflected_ray

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local order_label = {}

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local cleanup_at_start_of_gameloop = function()

	-- Update their positions by removing their old instances
	-- and creating a new one.
	display.remove( ray )
	ray = nil

	display.remove( reflected_ray )
	reflected_ray = nil

	for i in pairs(order_label)
	do
		display.remove( order_label[i] )
	end

	order_label = {}

end

local debug_output_object_hit = function( hits )

	-- There's at least one hit.
	print( "Hit count: ", #hits )

	-- Output all the results.
	for i,v in ipairs(hits)
	do
		print( "Hit: ", i, v.object.myName, " Position: ", v.position.x, v.position.y, " Surface normal: ", v.normal.x, v.normal.y, " Fraction: ", v.fraction )
	end

end

local label_all_hits = function( hits )

	for i,v in ipairs(hits)
	do
		order_label[i] = display.newText( tostring( i ), v.position.x, v.position.y, native.systemFontBold, 15 )
	end

end

local draw_line_to_hit = function( hit )

	-- Draw a line to the hit.
	ray = display.newLine( ray_from_x, ray_from_y, hit.position.x, hit.position.y )

end

local draw_reflection_of_hit = function( hit )

	-- Draw the reflection of the hit.
	local reflected_ray_direction_x, reflected_ray_direction_y = physics.reflectRay( ray_from_x, ray_from_y, hit )

	--print( "Reflected direction: ", reflected_ray_direction_x, " ", reflected_ray_direction_y )

	local reflected_ray_length = 64

	reflected_ray = display.newLine( hit.position.x,
										hit.position.y,
										( hit.position.x + ( reflected_ray_direction_x * reflected_ray_length ) ),
										( hit.position.y + ( reflected_ray_direction_y * reflected_ray_length ) ) )
	reflected_ray.strokeWidth = 2
	reflected_ray:setStrokeColor( 0, 1, 0 )

end

local gameloop = function(event) 

	cleanup_at_start_of_gameloop()

	-- "closest" is the default behavior, when none are specified.
	local hits = physics.rayCast( ray_from_x, ray_from_y, ray_to_x, ray_to_y )
	--local hits = physics.rayCast( ray_from_x, ray_from_y, ray_to_x, ray_to_y, "closest" )
	--local hits = physics.rayCast( ray_from_x, ray_from_y, ray_to_x, ray_to_y, "any" )
	--local hits = physics.rayCast( ray_from_x, ray_from_y, ray_to_x, ray_to_y, "sorted" )
	--local hits = physics.rayCast( ray_from_x, ray_from_y, ray_to_x, ray_to_y, "unsorted" )

	if hits then

		--debug_output_object_hit( hits )

		label_all_hits( hits )

		-- The first hit.
		local hit = hits[ 1 ]
		-- The last hit.
		--local hit = hits[ #hits ]

		draw_line_to_hit( hit )

		draw_reflection_of_hit( hit )

	else

		-- There's no hit.
		ray = display.newLine( ray_from_x, ray_from_y, ray_to_x, ray_to_y )

	end

	ray.strokeWidth = 2

end

Runtime:addEventListener("enterFrame", gameloop)
