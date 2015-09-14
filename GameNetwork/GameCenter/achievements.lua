
local composer = require( "composer" )
local gameNetwork = require( "gameNetwork" )
local widget = require( "widget" )

local scene = composer.newScene()

local achievementGroup = display.newGroup()
local achievementsSet = { 0,0 }


-- Slider handler function
local function handleSlider( event )

	event.target.percentageLabel.text = event.value .. "%"

	if ( event.phase == "ended" ) then
		local ad = composer.getVariable( "achievementData" )
		for i = 1,#ad do
			if ( ad[i].identifier == event.target.achievementID ) then
				ad[i].percentComplete = event.value
			end
		end
	end
end


-- Visually align all sliders before scene shows
local function alignSliders( action )
	for i = 1,achievementGroup.numChildren do
		if ( achievementGroup[i]._isWidget == true ) then
			local slider = achievementGroup[i]

			if ( action == "reset" ) then
				slider:setValue( 0 )
				slider.percentageLabel.text = "0%"
			end

			slider.anchorX = 0.5 ; slider.x = 130
			if ( slider.contentWidth > slider.setWidth ) then
				if ( slider.value < 50 ) then
					slider.anchorX = 1 ; slider.x = ( 130 + slider.setWidth/2 )
				else
					slider.anchorX = 0 ; slider.x = ( 130 - slider.setWidth/2 )
				end
			end
		end
	end
end


-- Game Center request listener function
local function requestCallback( event )

	-- Event type of "resetAchievements"
	if ( event.type == "resetAchievements" ) then
		local ad = composer.getVariable( "achievementData" )
		for i = 1,#ad do
			if ( ad[i].isHidden == false ) then
				ad[i].percentComplete = 0
			end
		end
		alignSliders( "reset" )
		native.showAlert( "Result", "All achievements reset.", { "OK" } )
		
	-- Event type of "unlockAchievement"
	elseif ( event.type == "unlockAchievement" ) then
	
		achievementsSet[1] = achievementsSet[1]+1
		if ( achievementsSet[1] == achievementsSet[2] ) then
			native.showAlert( "Result", "Progress values set.", { "OK" } )
		end
	end

	local printTable = composer.getVariable( "printTable" )
	printTable( event )
end


-- Button handler function
local function handleButton( event )

	local target = event.target

	-- Show achievements panel
	if ( target.id == "showAchievements" ) then
		gameNetwork.show( "achievements" )

	-- Submit progress
	-- Note that a progress percentage which does not exceed any previously-submitted percentage will be ignored by Game Center
	elseif ( target.id == "setProgress" ) then
		achievementsSet[1] = 0
		local ad = composer.getVariable( "achievementData" )
		for i = 1,#ad do
			if ( ad[i].isHidden == false ) then
				gameNetwork.request( "unlockAchievement",
					{
						achievement = {
							identifier = ad[i].identifier,
							percentComplete = ad[i].percentComplete,
							showsCompletionBanner = false
						},
						listener = requestCallback
					}
				)
			end
		end

	-- Reset achievements
	elseif ( target.id == "resetAll" ) then
		gameNetwork.request( "resetAchievements", { listener=requestCallback } )
	end
	return true
end


function scene:create( event )

	local sceneGroup = self.view
	sceneGroup:insert( achievementGroup )

	local submitProgressButton = widget.newButton{
		id = "setProgress",
		label = "Set Progress",
		onRelease = handleButton,
		emboss = false,
		fontSize = 17,
		shape = "rectangle",
		width = 146,
		height = 40,
		fillColor = { default={ 28/255, 120/255, 200/255, 1 }, over={ 28/255, 120/255, 200/255, 0.8 } },
		labelColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 0.7 } }
	}
	submitProgressButton.x = display.contentCenterX - 51
	submitProgressButton.y = 352
	sceneGroup:insert( submitProgressButton )

	local resetButton = widget.newButton{
		id = "resetAll",
		label = "Reset",
		onRelease = handleButton,
		emboss = false,
		fontSize = 17,
		shape = "rectangle",
		width = 94,
		height = 40,
		fillColor = { default={ 15/255, 80/255, 140/255, 1 }, over={ 15/255, 80/255, 140/255, 0.8 } },
		labelColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 0.7 } }
	}
	resetButton.x = display.contentCenterX + 77
	resetButton.y = 352
	sceneGroup:insert( resetButton )
	
	local achievementsButton = widget.newButton{
		id = "showAchievements",
		label = "Show Achievements",
		onRelease = handleButton,
		emboss = false,
		fontSize = 17,
		shape = "rectangle",
		width = 248,
		height = 40,
		fillColor = { default={ 80/255, 90/255, 170/255, 1 }, over={ 80/255, 90/255, 170/255, 0.8 } },
		labelColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 0.7 } }
	}
	achievementsButton.x = display.contentCenterX
	achievementsButton.y = 408
	sceneGroup:insert( achievementsButton )
	
	local ad = composer.getVariable( "achievementData" )
	local achievementCount = 0

	for i = 1,#ad do
		if ( ad[i].isHidden == false ) then
			achievementCount = achievementCount + 1
			achievementsSet[2] = achievementCount
			local achievementLabel = display.newText( achievementGroup, ad[i].title, 0, 70+(achievementCount*66), "HelveticaNeue-Light", 18 )
			achievementLabel.anchorX = 0
			achievementLabel.x = display.contentCenterX - 115

			local slider = widget.newSlider{
				top = achievementLabel.y + 7,
				id = achievementCount,
				width = 170,
				listener = handleSlider
			}
			print(slider.value)
			achievementGroup:insert( slider )
			slider.setWidth = slider.contentWidth

			slider:setValue( ad[i].percentComplete )

			local sliderPercentage = display.newText( achievementGroup, slider.value.."%", 0, slider.y, "HelveticaNeue-Light", 16 )
			sliderPercentage:setFillColor( 1, 1, 1, 0.7 )
			sliderPercentage.anchorX = 1
			sliderPercentage.x = display.contentCenterX + 115
					
			slider.achievementID = ad[i].identifier
			slider.percentageLabel = sliderPercentage
		end
	end
end


function scene:show( event )

	if ( event.phase == "will" ) then
		alignSliders()
	end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

return scene
