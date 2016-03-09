
local composer = require( "composer" )
local gameNetwork = require( "gameNetwork" )
local widget = require( "widget" )

local scene = composer.newScene()

local achievementGroup = display.newGroup()
local achievementsSet = { 0,0 }

local appFont = composer.getVariable( "appFont" )


-- Slider handler function
local function handleSlider( event )

	event.target.percentageLabel.text = event.value

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
				slider.percentageLabel.text = "0"
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
		shape = "rectangle",
		width = 146,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.11,0.47,0.78,1 }, over={ 0.121,0.517,0.858,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = handleButton
	}
	submitProgressButton.x = display.contentCenterX - 51
	submitProgressButton.y = 362
	sceneGroup:insert( submitProgressButton )

	local resetButton = widget.newButton{
		id = "resetAll",
		label = "Reset",
		shape = "rectangle",
		width = 94,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.06,0.31,0.55,1 }, over={ 0.0672,0.347,0.616,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = handleButton
	}
	resetButton.x = display.contentCenterX + 77
	resetButton.y = 362
	sceneGroup:insert( resetButton )
	
	local achievementsButton = widget.newButton{
		id = "showAchievements",
		label = "Show Achievements",
		shape = "rectangle",
		width = 248,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.31,0.35,0.67,1 }, over={ 0.341,0.385,0.737,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = handleButton
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
			local achievementLabel = display.newText( achievementGroup, ad[i].title, 0, 70+(achievementCount*66), appFont, 16 )
			achievementLabel.anchorX = 0
			achievementLabel.x = display.contentCenterX - 115

			local slider = widget.newSlider{
				top = achievementLabel.y + 7,
				id = achievementCount,
				width = 170,
				listener = handleSlider
			}
			achievementGroup:insert( slider )
			slider.setWidth = slider.contentWidth

			slider:setValue( ad[i].percentComplete )

			local sliderPercentage = display.newText( achievementGroup, slider.value, 0, slider.y, appFont, 16 )
			sliderPercentage:setFillColor( 0.7 )
			sliderPercentage.anchorX = 1
			sliderPercentage.x = display.contentCenterX + 105
			
			local percentageSign = display.newText( achievementGroup, "%", 0, slider.y, appFont, 16 )
			percentageSign:setFillColor( 0.7 )
			percentageSign.anchorX = 0
			percentageSign.x = sliderPercentage.x + 1
			
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
