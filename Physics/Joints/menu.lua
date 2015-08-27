
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()


local function onButtonRelease( event )
	composer.gotoScene( event.target.id, { effect="slideLeft", time=800 } )
end


function scene:create( event )

	local sceneGroup = self.view

	-- Table of data for menu buttons
	local menuButtons = {
		{ label="pivot", fillDefault={0.216,0.267,0.302,1}, fillOver={0.216,0.267,0.302,0.8}  },
		{ label="distance", fillDefault={0.236,0.297,0.332,1}, fillOver={0.236,0.297,0.332,0.8} },
		{ label="piston", fillDefault={0.266,0.327,0.362,1}, fillOver={0.266,0.327,0.362,0.8} },
		{ label="friction", fillDefault={0.296,0.357,0.392,1}, fillOver={0.296,0.357,0.392,0.8} },
		{ label="weld", fillDefault={0.326,0.387,0.422,1}, fillOver={0.326,0.387,0.422,0.8} },
		{ label="wheel", fillDefault={0.216,0.267,0.302,1}, fillOver={0.216,0.267,0.302,0.8} },
		{ label="pulley", fillDefault={0.236,0.297,0.332,1}, fillOver={0.236,0.297,0.332,0.8} },
		{ label="touch", fillDefault={0.266,0.327,0.362,1}, fillOver={0.266,0.327,0.362,0.8} },
		{ label="rope", fillDefault={0.296,0.357,0.392,1}, fillOver={0.296,0.357,0.392,0.8} },
		{ label="gear", fillDefault={0.326,0.387,0.422,1}, fillOver={0.326,0.387,0.422,0.8} }
	}

	-- Loop through table to display buttons
	local rowNum = 0
	for i=1,#menuButtons do

		rowNum = rowNum+1
		local button = widget.newButton
		{
			label = menuButtons[i].label,
			id = menuButtons[i].label,
			shape = "rectangle",
			width = 130,
			height = 70,
			font = composer.getVariable( "appFont" ),
			fontSize = 17,
			alphaFade = false,
			fillColor = { default = menuButtons[i].fillDefault, over = menuButtons[i].fillOver },
			labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
			onRelease = onButtonRelease
		}
		if ( i <= 5 ) then
			button.x = display.contentCenterX - 70
		else
			if ( rowNum == 6 ) then rowNum = 1 end
			button.x = display.contentCenterX + 70
		end
		button.y = 85 + ((rowNum-1)*80)
		sceneGroup:insert( button )
	end
end


scene:addEventListener( "create", scene )

return scene
