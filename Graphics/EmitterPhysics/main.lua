--
-- Abstract: Particle Emitter Sample App
--
-- Version: 1.0
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2014 Corona Labs Inc. All Rights Reserved.
------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 9.8 )

local particleDesigner = require( "particleDesigner" )

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local left_side_piece = display.newRect( 0, 0, 750, 10 )
left_side_piece.x = 0
left_side_piece.y = ( display.contentHeight - 100 )
physics.addBody( left_side_piece, "static", { friction=0.25, bounce=0.95 } )
left_side_piece.rotation = 45
left_side_piece:setFillColor( 0.5, 0, 1, 1 )

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local center_piece = display.newRect( 0, 0, 750, 10 )
center_piece.x = display.contentCenterX
center_piece.y = ( display.contentHeight - 0 )
physics.addBody( center_piece, "static", { friction=0.25, bounce=0.95 } )
center_piece:setFillColor( 0.5, 0, 1, 1 )

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local right_side_piece = display.newRect( -10, 0, 750, 10 )
right_side_piece.x = display.contentWidth
right_side_piece.y = ( display.contentHeight - 100 )
physics.addBody( right_side_piece, "static", { friction=0.25, bounce=0.95 } )
right_side_piece.rotation = -45
right_side_piece:setFillColor( 0.5, 0, 1, 1 )

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local body_radius = 5

local g = display.newGroup()
g.x = display.contentWidth / 6
g.y = 0

local c = display.newCircle( 0, 0, body_radius )
g:insert( c )

local emitter = particleDesigner.newEmitter( "fire.json" )
g:insert( emitter )

physics.addBody( g, "dynamic", { density = 1.0, friction = 0.25, bounce = 0.95, radius = body_radius } )
g.isFixedRotation = true

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
