
-------------------------------------------------------------------------------------------------------
-- Artwork used within this project is licensed under Public Domain Dedication
-- See the following site for further information: https://creativecommons.org/publicdomain/zero/1.0/
-------------------------------------------------------------------------------------------------------

local function generateCharacter(displayName, name, offset)

	local group = display.newGroup( )

	local selOffset = (( (offset or math.random(4)) + 1 ) % 4) * 4

	-- Create our player sprite sheet
	local sheetOptions = {
		width = 50,
		height = 50,
		numFrames = 64,
		sheetContentWidth = 800,
		sheetContentHeight = 200
	}

	local sheet_character = graphics.newImageSheet( "sprites.png", sheetOptions )

	local sequences_character = {
		{
			name = "down",
			frames = { 1+selOffset, 2+selOffset, 3+selOffset, 1+selOffset, 2+selOffset, 4+selOffset },
			time = 600,
			loopCount = 0,
			loopDirection = "forward"
		},
		{
			name = "left",
			frames = { 17+selOffset, 18+selOffset, 19+selOffset, 17+selOffset, 18+selOffset, 20+selOffset },
			time = 600,
			loopCount = 0,
			loopDirection = "forward"
		},
		{
			name = "right",
			frames = { 33+selOffset, 34+selOffset, 35+selOffset, 33+selOffset, 34+selOffset, 36+selOffset },
			time = 600,
			loopCount = 0,
			loopDirection = "forward"
		},
		{
			name = "up",
			frames = { 49+selOffset, 50+selOffset, 51+selOffset, 49+selOffset, 50+selOffset, 52+selOffset },
			time = 600,
			loopCount = 0,
			loopDirection = "forward"
		},
	}

	-- And, create the player that it belongs to
	local character = display.newSprite( sheet_character, sequences_character )
	character:setSequence( "down" )
	character:setFrame( 2 )

	group:insert( character, true )

	local hpBg = display.newRect( group, 0, -4-character.height*0.5, 40, 8 )
	hpBg:setFillColor( 0,0,0 )

	local hpFg = display.newRect( group, 0, -4-character.height*0.5, 38, 6 )
	hpFg:setFillColor( 0, 1, 0 )


	if name then
		local playerName = display.newText( {parent=group, text=name, x=0, y=-16-character.height*0.5, fontSize=12} )
		playerName.anchorY = 1
	end

	if displayName then
		local playerName = display.newText( {parent=group, text=displayName, x=0, y=-8-character.height*0.5, fontSize=8} )
		playerName.anchorY = 1
	end

	local function setHp(hp)
		hpFg.width = 38*hp/100
		hpFg:setFillColor( 100/hp, hp/100, 0 )
	end

	return {group=group, hp=setHp, anim=character}
end

return generateCharacter
