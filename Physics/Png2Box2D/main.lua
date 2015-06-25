display.setStatusBar( display.HiddenStatusBar )

local physics = require( "physics" )
physics.start()
physics.setDrawMode( "hybrid" )

--------------------------------------------------------------------------------

local left_side_piece = display.newImage( "ground.png" )
left_side_piece.x = 0
left_side_piece.y = ( display.contentHeight - 200 )
physics.addBody( left_side_piece, "static", { friction=0.5, bounce=0.3 } )

left_side_piece.rotation = 45

--------------------------------------------------------------------------------

local center_piece = display.newImage( "ground.png" )
center_piece.x = display.contentCenterX
center_piece.y = ( display.contentHeight - 64 )
physics.addBody( center_piece, "static", { friction=0.5, bounce=0.3 } )

--------------------------------------------------------------------------------

local right_side_piece = display.newImage( "ground.png" )
right_side_piece.x = display.contentWidth
right_side_piece.y = ( display.contentHeight - 200 )
physics.addBody( right_side_piece, "static", { friction=0.5, bounce=0.3 } )

right_side_piece.rotation = -45

--------------------------------------------------------------------------------

local image_name = "star.png"

local image_outline = graphics.newOutline( 2, image_name )

local image_group = display.newGroup()

local function create_body( event )

	if image_group.numChildren >= 100 then

		-- Limit the number of bodies simultaneously on screen.
		image_group[ 1 ]:removeSelf()

	end

	local image_star = display.newImageRect( image_name,
												64,
												64 )

	image_group:insert( image_star )

	image_star.x = math.random( display.contentWidth )
	image_star.y = 0

	image_star.rotation = math.random( 360 )

	physics.addBody( image_star, "dynamic", { density = 3.0,
												friction = 0.6,
												bounce = 0.4,
												outline = image_outline } )

end

timer.performWithDelay( 400, create_body, 1000 )

--------------------------------------------------------------------------------
