--*********************************************************************************************
-- ====================================================================
-- Corona SDK "GameCenter Tapper" Sample Code
-- ====================================================================
--
-- File: main.lua
--
-- Version 1.0
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2013 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
--*********************************************************************************************

display.setStatusBar( display.DarkStatusBar )

-- Define reference points locations anchor ponts
local TOP_REF = 0
local BOTTOM_REF = 1
local LEFT_REF = 0
local RIGHT_REF = 1
local CENTER_REF = 0.5

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

-- create app background
local bg = display.newImageRect( "assets/gcbg.jpg", 320, 480 )
bg.x, bg.y = display.contentWidth*0.5, display.contentHeight*0.5

local widget = require( "widget" )
local composer = require "composer"
local ui = require "userinterface"	-- handles various user-interface related tasks
local gameNetwork = require "gameNetwork"

-- create toolbar to go at the top of the screen
local titleBar = display.newImage( "assets/woodbg.png", centerX, 40 )

-- create embossed text to go on toolbar
local titleText = display.newEmbossedText( "Corona GCTapper", centerX, centerY, ui.boldFont, 20 )
titleText:setFillColor( 1 )
titleText.x, titleText.y = 160, titleBar.y

-- create a shadow underneath the titlebar
local shadow = display.newImage( "assets/shadow.png" )

shadow.anchorX = 0
shadow.anchorY = 0
shadow.x, shadow.y = 0, 64
shadow.xScale = 320 / shadow.contentWidth; shadow.yScale = 0.35

-- setup composer scenes (non-external module scenes)
local scoreScene = composer.newScene( "scoreScene" )
local boardScene = composer.newScene( "boardScene" )

-- variables (and forward declarations)
local requestCallback, userScoreText, currentBoardText, userBestText, bestLabel, bestText
local leaderBoards, achievements = {}, {}
	leaderBoards.Easy = "com.appledts.EasyTapList"
	leaderBoards.Hard = "com.appledts.HardTapList"
	leaderBoards.Awesome = "com.appledts.AwesomeTapList"
	achievements.OneTap = "com.appletest.one_tap"
	achievements.TwentyTaps = "com.appledts.twenty_taps"
	achievements.OneHundredTaps = "com.appledts.one_hundred_taps"
local currentBoard = "Easy"
local userScore, userBest, bestTextValue, topScorer = 0, "0 Taps", "0 Taps", "???"

-- private functions --------------------------------------------------------------------

local function setUserScore( value )
	userScore = value
	if userScoreText then
		local scoreTapString = tostring( userScore ) .. " Taps"; if userScore == 1 then scoreTapString = "1 Tap"; end
		ui.updateLabel( userScoreText, scoreTapString, display.contentWidth-25, 270, TOP_REF, RIGHT_REF )
	end
end

local function offlineAlert() 
	native.showAlert( "GameCenter Offline", "Please check your internet connection.", { "OK" } )
end

-- button event handlers ----------------------------------------------------------------

local function onIncrementScore( event )
	setUserScore( userScore+1 )
	
	-- unlock achievements when specific tap requirement is met
	if loggedIntoGC then
		local message
		
		if userScore == 1 then
			gameNetwork.request( "unlockAchievement", {
				achievement = {
					identifier=achievements["OneTap"],
					percentComplete=100,
					showsCompletionBanner=true,
				}
			}); message = "You completed the \"Just One Tap\" achievement!"
		
		elseif userScore == 10 then
			gameNetwork.request( "unlockAchievement", {
				achievement = {
					identifier=achievements["TwentyTaps"],
					percentComplete=50,
					showsCompletionBanner=true,
				}
			}); message = "You achieved 50% of the \"Work the taps\" achievement!"
		
		elseif userScore == 20 then
			gameNetwork.request( "unlockAchievement", {
				achievement = {
					identifier=achievements["TwentyTaps"],
					percentComplete=100,
					showsCompletionBanner=true,
				}
			}); message = "You completed the \"Work the taps\" achievement!"
		
		elseif userScore == 50 then
			gameNetwork.request( "unlockAchievement", {
				achievement = {
					identifier=achievements["OneHundredTaps"],
					percentComplete=50,
					showsCompletionBanner=true,
				}
			}); message = "You completed 50% of the \"One Hundred Taps\" achievement!"
		
		elseif userScore == 75 then
			gameNetwork.request( "unlockAchievement", {
				achievement = {
					identifier=achievements["OneHundredTaps"],
					percentComplete=75,
					showsCompletionBanner=true,
				}
			}); message = "You completed 75% of the \"One Hundred Taps\" achievement!"
		
		elseif userScore == 100 then
			gameNetwork.request( "unlockAchievement", {
				achievement = {
					identifier=achievements["OneHundredTaps"],
					percentComplete=100,
					showsCompletionBanner=true,
				}
			}); message = "You completed the \"One Hundred Taps\" achievement!"
		end
		if message then native.showAlert( "Achievement Unlocked", message, { "OK" } ); end
	end
end

local function onSubmitScore( event )
	if loggedIntoGC then gameNetwork.request( "setHighScore", { localPlayerScore={ category=leaderBoards[currentBoard], value=userScore }, listener=requestCallback } ); else offlineAlert(); end
end

local function onChangeBoard( event )
	local function alertCompletion( event )
		if event.action == "clicked" and event.index ~= 4 then		
			if 		event.index == 1 then currentBoard = "Awesome";
			elseif 	event.index == 2 then currentBoard = "Easy";
			elseif 	event.index == 3 then currentBoard = "Hard"; end
			
			-- reset current score and update current score and board labels
			userScore = 0
			ui.updateLabel( userScoreText, "0 Taps", display.contentWidth-25, 270, TOP_REF, RIGHT_REF )
			ui.updateLabel( currentBoardText, currentBoard, display.contentWidth-25, 142, TOP_REF, RIGHT_REF )
			
			-- reload best score
			if loggedIntoGC then gameNetwork.request( "loadScores", { leaderboard={ category=leaderBoards[currentBoard], playerScope="Global", timeScope="AllTime", range={1,3} }, listener=requestCallback } ); else offlineAlert(); end
		end
	end
	native.showAlert( "Choose Leaderboard:", "", { "Awesome", "Easy", "Hard", "Cancel" }, alertCompletion )
end

local function onShowBoards( event )
	if loggedIntoGC then gameNetwork.show( "leaderboards", { leaderboard={ category=leaderBoards[currentBoard], timeScope="Week" } } ); else offlineAlert(); end
end

local function onShowAchievements( event )
	if loggedIntoGC then gameNetwork.show( "achievements" ); else offlineAlert(); end
end

local function onResetAchievements( event )
	userScore = 0; userScoreText:setText( "0 Taps" )
	userScoreText.anchorX = 1
	userScoreText.anchorX = 0
	userScoreText.x = display.contentWidth-25; userScoreText.y = 270
	
	if loggedIntoGC then gameNetwork.request( "resetAchievements" ); else offlineAlert(); end
end

-- scoreScene (first tab) ---------------------------------------------------------------

function scoreScene:create( event )
	local sceneGroup = self.view
	local logo = display.newImageRect( sceneGroup, "assets/corona_gc_logos.png", 264, 182 )
	logo.x, logo.y = display.contentWidth * 0.5, 175
	
	local currentScoreLabel = ui.createLabel( sceneGroup, "Current Score:", 25, 270, TOP_REF, LEFT_REF, true )
	
	display.remove( userScoreText )
	userScoreText = ui.createLabel( sceneGroup, "0 Taps", display.contentWidth-25, 270, TOP_REF, RIGHT_REF )
	
	local incrementScoreBtn = widget.newButton
	{ 
		left = 21,
		top = 305,
		width = 298,
		height = 56,
		label = "Increment Score",
		onRelease = onIncrementScore 
	}
	sceneGroup:insert( incrementScoreBtn )
	
	local submitScoreBtn = widget.newButton
	{ 
		left = 21,
		top = 360,
		width = 298,
		height = 56,
		label = "Submit High Score",
		onRelease=onSubmitScore 
	}
	sceneGroup:insert( submitScoreBtn )
end
scoreScene:addEventListener( "create", scoreScene )

-- boardScene (second tab) --------------------------------------------------------------

function boardScene:create( event )
	local sceneGroup = self.view
	local changeBoardBtn = widget.newButton
	{ 
		left = 21,
		top = 80,
		width = 298,
		height = 56,
		label = "Change Leaderboard",
		onRelease = onChangeBoard 
	}
	sceneGroup:insert( changeBoardBtn )
	
	local boardLabel = ui.createLabel( sceneGroup, "Leaderboard:", 25, 142, TOP_REF, LEFT_REF , true )
	
	display.remove( currentBoardText )
	currentBoardText = ui.createLabel( sceneGroup, currentBoard, display.contentWidth-25, 142, TOP_REF, RIGHT_REF )
	
	local yourLabel = ui.createLabel( sceneGroup, "Your Best", 25, 177, TOP_REF, LEFT_REF, true )
	
	display.remove( userBestText )
	userBestText = ui.createLabel( sceneGroup, userBest, display.contentWidth-25, 177, TOP_REF, RIGHT_REF  )
	
	display.remove( bestLabel )
	bestLabel = ui.createLabel( sceneGroup, topScorer .. " got:", 25, 212, TOP_REF, LEFT_REF, true )
	
	display.remove( bestText )
	bestText = ui.createLabel( sceneGroup, bestTextValue, display.contentWidth-25, 212, TOP_REF, RIGHT_REF  )
	
	local showBoardsBtn = widget.newButton
	{ 
		left = 21,
		top = 255,
		width = 298,
		height = 56,
		label = "Show Leaderboards",
		onRelease = onShowBoards 
		}
	sceneGroup:insert( showBoardsBtn )
	
	local showAchBtn = widget.newButton
	{ 
		left = 21,
		top = 310,
		width = 298,
		height = 56,
		label = "Show Achievements",
		onRelease = onShowAchievements 
	}
	sceneGroup:insert( showAchBtn )
	
	local resetBtn = widget.newButton
	{ 
		left = 21,
		top = 365,
		width = 298,
		height = 56,
		label = "Reset Score & Achievements", 
		onRelease = onResetAchievements 
	}
	sceneGroup:insert( resetBtn )
end
boardScene:addEventListener( "create", boardScene )

-- gamenetwork callback listeners -------------------------------------------------------

function requestCallback( event )
	if event.type == "setHighScore" then
		local function alertCompletion() gameNetwork.request( "loadScores", { leaderboard={ category=leaderBoards[currentBoard], playerScope="Global", timeScope="AllTime", range={1,3} }, listener=requestCallback } ); end
		native.showAlert( "High Score Reported!", "", { "OK" }, alertCompletion )
	
	elseif event.type == "loadScores" then
		if event.data then
			local topRankID = event.data[1].playerID
			local topRankScore = event.data[1].formattedValue
			bestTextValue = string.sub( topRankScore, 1, 12 ) .. "..."
			
			if topRankID then gameNetwork.request( "loadPlayers", { playerIDs={ topRankID }, listener=requestCallback} ); end
		end
		
		if event.localPlayerScore then
			userBest = event.localPlayerScore.formattedValue
		else
			userBest = "Not ranked"
		end
		
		if userBestText then ui.updateLabel( userBestText, userBest, display.contentWidth-25, 177, TOP_REF, RIGHT_REF ); end
	
	elseif event.type == "loadPlayers" then
		if event.data then
			local topRankAlias = event.data[1].alias
			
			if topRankAlias then
				topScorer = topRankAlias
				if bestLabel and bestText then
					ui.updateLabel( bestLabel, topScorer .. " got:", 25, 212, TOP_REF, LEFT_REF )
					ui.updateLabel( bestText, bestTextValue, display.contentWidth-25, 212, TOP_REF, RIGHT_REF )
				end
			end
		end
	end
end

local function initCallback( event )
	-- "showSignIn" is only available on iOS 6+
	if event.type == "showSignIn" then
		-- This is an opportunity to pause your game or do other things you might need to do while the Game Center Sign-In controller is up.
		-- For the iOS 6.0 landscape orientation bug, this is an opportunity to remove native objects so they won't rotate.
	-- This is type "init" for all versions of Game Center.
	elseif event.data then
		loggedIntoGC = true
		gameNetwork.request( "loadScores", { leaderboard={ category=leaderBoards[currentBoard], playerScope="Global", timeScope="AllTime", range={1,3} }, listener=requestCallback } )
	end

end

-- system event handler -----------------------------------------------------------------

local function onSystemEvent( event ) 
	if "applicationStart" == event.type then
		loggedIntoGC = false
		gameNetwork.init( "gamecenter", { listener=initCallback } )
		return true
	end
end
Runtime:addEventListener( "system", onSystemEvent )
ui.createTabs( widget )
composer.gotoScene( "scoreScene" )
