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

local total_frames = 12
local image_name = "first_12_letters_of_the_alphabet.png"

local options =
{
	width = 64,
	height = 64,
	numFrames = total_frames
}

local sheet = graphics.newImageSheet( image_name, options )

local outlines = {}

for frameIndex = 1, total_frames do
	table.insert( outlines, graphics.newOutline( 2, sheet, frameIndex ) )
end

--------------------------------------------------------------------------------

local image_group = display.newGroup()

local function create_body( event )

	if image_group.numChildren >= 100 then

		-- Limit the number of bodies simultaneously on screen.
		image_group[ 1 ]:removeSelf()

	end

	local frameIndex = math.random( total_frames )

	local image_letter = display.newImage( sheet, frameIndex )

	image_group:insert( image_letter )

	image_letter.x = math.random( display.contentWidth )
	image_letter.y = 0

	image_letter.rotation = math.random( 360 )

	physics.addBody( image_letter, "dynamic", { density = 3.0,
												friction = 0.6,
												bounce = 0.4,
												outline = outlines[ frameIndex ] } )

end

timer.performWithDelay( 400, create_body, 1000 )
