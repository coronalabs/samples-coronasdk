
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()


local function onButtonRelease( event )
	composer.gotoScene( event.target.id, { effect="slideLeft", time=800 } )
end


function scene:create( event )

	local sceneGroup = self.view

	local sceneTitle = display.newText( sceneGroup, "select joint", display.contentCenterX, 115, composer.getVariable( "appFont" ), 20 )

	-- Table of data for menu buttons
	local menuButtons = {
		{ label="pivot", fillDefault={ 0.12,0.32,0.52,1 }, fillOver={ 0.12,0.32,0.52,0.8 } },
		{ label="distance", fillDefault={ 0.14,0.34,0.54,1 }, fillOver={ 0.14,0.34,0.54,0.8 } },
		{ label="piston", fillDefault={ 0.16,0.36,0.56,1 }, fillOver={ 0.16,0.36,0.56,0.8 } },
		{ label="friction", fillDefault={ 0.18,0.38,0.58,1 }, fillOver={ 0.18,0.38,0.58,0.8 } },
		{ label="weld", fillDefault={ 0.2,0.4,0.6,1 }, fillOver={ 0.2,0.4,0.6,0.8 } },
		{ label="wheel", fillDefault={ 0.12,0.32,0.52,1 }, fillOver={ 0.12,0.32,0.52,0.8 } },
		{ label="pulley", fillDefault={ 0.14,0.34,0.54,1 }, fillOver={ 0.14,0.34,0.54,0.8 } },
		{ label="touch", fillDefault={ 0.16,0.36,0.56,1 }, fillOver={ 0.16,0.36,0.56,0.8 } },
		{ label="rope", fillDefault={ 0.18,0.38,0.58,1 }, fillOver={ 0.18,0.38,0.58,0.8 } },
		{ label="gear", fillDefault={ 0.2,0.4,0.6,1 }, fillOver={ 0.2,0.4,0.6,0.8 } }
	}

	-- Loop through table to display buttons
	local rowNum = 0
	for i = 1,#menuButtons do

		rowNum = rowNum+1
		local button = widget.newButton(
			{
				label = menuButtons[i].label,
				id = menuButtons[i].label,
				shape = "rectangle",
				width = 110,
				height = 32,
				font = composer.getVariable( "appFont" ),
				fontSize = 16,
				fillColor = { default = menuButtons[i].fillDefault, over = menuButtons[i].fillOver },
				labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
				onRelease = onButtonRelease
			})
		if ( i <= 5 ) then
			button.x = display.contentCenterX - 64
		else
			if ( rowNum == 6 ) then rowNum = 1 end
			button.x = display.contentCenterX + 64
		end
		button.y = 165 + ((rowNum-1)*50)
		sceneGroup:insert( button )
	end
end


scene:addEventListener( "create", scene )

return scene
