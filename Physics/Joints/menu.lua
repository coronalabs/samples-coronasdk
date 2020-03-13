
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()


local function onButtonRelease( event )
	composer.gotoScene( event.target.id:lower(), { effect="slideLeft", time=800 } )
end


function scene:create( event )

	local sceneGroup = self.view

	local sceneTitle = display.newText( sceneGroup, "Select Joint", display.contentCenterX, 115, composer.getVariable( "appFont" ), 20 )

	-- Table of data for menu buttons
	local menuButtons = { "Pivot", "Distance", "Piston", "Friction", "Weld", "Wheel", "Pulley", "Touch", "Rope", "Gear" }

	-- Loop through table to display buttons
	local rowNum = 0
	for i = 1,#menuButtons do

		rowNum = rowNum+1
		local button = widget.newButton(
			{
				label = menuButtons[i],
				id = menuButtons[i],
				shape = "rectangle",
				width = 110,
				height = 32,
				font = composer.getVariable( "appFont" ),
				fontSize = 15,
				fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
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
