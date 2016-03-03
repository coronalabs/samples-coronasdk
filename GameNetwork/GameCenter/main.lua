
-- Abstract: Apple Game Center
-- Version: 1.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Apple Game Center", showBuildNum=true } )

-- The following property represents the bottom Y position of the sample title bar
local titleBarBottom = sampleUI.titleBarBottom

------------------------------
-- CONFIGURE STAGE
------------------------------

local composer = require( "composer" )
display.getCurrentStage():insert( sampleUI.backGroup )
display.getCurrentStage():insert( composer.stage )
display.getCurrentStage():insert( sampleUI.frontGroup )
composer.recycleOnSceneChange = false
local aliasGroup = display.newGroup()

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Require libraries/plugins
local widget = require( "widget" )
local gameNetwork = require( "gameNetwork" )

-- Set app font
composer.setVariable( "appFont", sampleUI.appFont )

-- Set common variables
composer.setVariable( "initializedGC", false )
composer.setVariable( "leaderboardsData", {} )
composer.setVariable( "achievementData", {} )
composer.setVariable( "debugOutput", false )  -- Set true to enable console print output


-- Table printing function for Game Center debugging
local function printTable( t )
	if ( composer.getVariable( "debugOutput" ) == false ) then return end
	print("--------------------------------")
	local printTable_cache = {}
	local function sub_printTable( t, indent )
		if ( printTable_cache[tostring(t)] ) then
			print( indent .. "*" .. tostring( t ) )
		else
			printTable_cache[tostring(t)] = true
			if ( type( t ) == "table" ) then
				for pos,val in pairs(t) do
					if ( type(val) == "table" ) then
						print( indent .. "[" .. pos .. "] => " .. tostring(t).. " {" )
						sub_printTable( val, indent .. string.rep( " ", string.len(pos)+8 ) )
						print( indent .. string.rep( " ", string.len(pos)+6 ) .. "}" )
					elseif ( type(val) == "string" ) then
						print( indent .. "[" .. pos .. '] => "' .. val .. '"' )
					else
						print( indent .. "[" .. pos .. "] => " .. tostring(val) )
					end
				end
			else
				print( indent..tostring(t) )
			end
		end
	end
	if ( type(t) == "table" ) then
		print( tostring(t) .. " {" )
		sub_printTable( t, "  " )
		print( "}" )
	else
		sub_printTable( t, "  " )
	end
end

-- Reference "printTable" function as a Composer variable for usage in all scenes
composer.setVariable( "printTable", printTable )


-- Game Center request listener function
local function requestCallback( event )

	if ( event.data ) then

		-- Event type of "loadLocalPlayer"
		if ( event.type == "loadLocalPlayer" ) then
	
			if ( aliasGroup.numChildren == 0 ) then
				-- Save player data to variable
				composer.setVariable( "localPlayerData", event.data )
				-- Display local player alias
				local textGroup = display.newGroup()
				aliasGroup:insert( textGroup )
				composer.stage:insert( aliasGroup )
				textGroup.anchorChildren = true
				local back = display.newRect( aliasGroup, 0, 0, display.actualContentWidth, 34 )
				back:setFillColor( 0.5,0.5,0.5,0.15 )
				local alias = display.newText( textGroup, "Game Center Alias: ", 0, back.y, sampleUI.appFont, 14 )
				alias:setFillColor( 0.5 )
				alias.anchorX = 1
				local name = display.newText( textGroup, event.data.alias, alias.x, back.y, sampleUI.appFont, 14 )
				name:setFillColor( 0.7 )
				name.anchorX = 0
				aliasGroup.x = display.contentCenterX
				aliasGroup.y = titleBarBottom + 36 - (aliasGroup.height*0.5)
				transition.to( aliasGroup, { time=800, y=aliasGroup.y+aliasGroup.height, transition=easing.outQuad } )
			end
	
		-- Event type of "loadLeaderboardCategories"
		elseif ( event.type == "loadLeaderboardCategories" ) then
	
			if ( #event.data > 0 ) then
				-- Store leaderboard categories in table
				local ld = composer.getVariable( "leaderboardsData" )
				for i = 1,#event.data do
					ld[#ld+1] = { category=event.data[i].category, title=event.data[i].title }
				end
				-- Show leaderboards scene
				composer.gotoScene( "leaderboards", { effect="slideUp", time=800 } )
			else
				native.showAlert( "Error", "Error in requesting app leaderboards.", { "OK" } )
			end
	
		-- Event type of "loadAchievementDescriptions" (loads all achievements for the app)
		elseif ( event.type == "loadAchievementDescriptions" ) then

			if ( #event.data > 0 ) then
				-- Store achievement descriptions
				local ad = composer.getVariable( "achievementData" )
				for i = 1,#event.data do
					ad[#ad+1] = { identifier=event.data[i].identifier, title=event.data[i].title, isHidden=event.data[i].isHidden, maximumPoints=event.data[i].maximumPoints, percentComplete=0 }
				end
			else
				native.showAlert( "Error", "Error in requesting app achievements.", { "OK" } )
			end
	
		-- Event type of "loadAchievements" (loads achievement percentages for current player)
		elseif ( event.type == "loadAchievements" ) then
	
			if ( #event.data > 0 ) then
				-- Update achievement percentages
				local ad = composer.getVariable( "achievementData" )
				for i = 1,#ad do
					for j = 1,#event.data do
						if ( ad[i].identifier == event.data[j].identifier ) then
							ad[i].percentComplete = event.data[j].percentComplete
						end
					end
				end
			else
				native.showAlert( "Error", "Error in requesting achievements for current player.", { "OK" } )
			end
		end
	end

	local printTable = composer.getVariable( "printTable" )
	printTable( event )
end


-- Scene buttons handler function
local function handleSceneButton( event )
	local target = event.target
	local leaderboardsButton = composer.getVariable( "leaderboardsButton" )
	local achievementsButton = composer.getVariable( "achievementsButton" )
	
	if ( target.id == "leaderboards" and composer.getSceneName( "current" ) == "achievements" ) then
		composer.gotoScene( "leaderboards", { effect="slideRight", time=600 } )
	elseif ( target.id == "achievements" and composer.getSceneName( "current" ) == "leaderboards" ) then
		composer.gotoScene( "achievements", { effect="slideLeft", time=600 } )
	end
end


-- Game Center initialization listener function
local function initCallback( event )

	if ( composer.getVariable( "initializedGC" ) == false ) then

		if ( event.data ) then

			-- Create "Leaderboards" scene button
			local leaderboardsButton = widget.newButton(
				{
					id = "leaderboards",
					label = "Leaderboards",
					shape = "rectangle",
					width = display.actualContentWidth/2,
					height = 36,
					font = sampleUI.appFont,
					fontSize = 16,
					fillColor = { default={ 0.13,0.34,0.48,1 }, over={ 0.13,0.34,0.48,1 } },
					labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
					onRelease = handleSceneButton
				})
			leaderboardsButton.anchorX = 1
			leaderboardsButton.anchorY = 0
			leaderboardsButton.x = display.contentCenterX
			leaderboardsButton.y = titleBarBottom
			composer.stage:insert( leaderboardsButton )
			composer.setVariable( "leaderboardsButton", leaderboardsButton )

			-- Create "Achievements" scene button
			local achievementsButton = widget.newButton(
				{
					id = "achievements",
					label = "Achievements",
					shape = "rectangle",
					width = display.actualContentWidth/2,
					height = 36,
					font = sampleUI.appFont,
					fontSize = 16,
					fillColor = { default={ 0.13,0.39,0.44,1 }, over={ 0.13,0.39,0.44,1 } },
					labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
					onRelease = handleSceneButton
				})
			achievementsButton.anchorX = 0
			achievementsButton.anchorY = 0
			achievementsButton.x = display.contentCenterX
			achievementsButton.y = titleBarBottom
			composer.stage:insert( achievementsButton )
			composer.setVariable( "achievementsButton", achievementsButton )

			-- Set initialized flag as true
			composer.setVariable( "initializedGC", true )

			-- Request local player information
			gameNetwork.request( "loadLocalPlayer", { listener=requestCallback } )

			-- Load leaderboard categories
			gameNetwork.request( "loadLeaderboardCategories", { listener=requestCallback } )

			-- Load achievement descriptions
			gameNetwork.request( "loadAchievementDescriptions", { listener=requestCallback } )
			
			-- Load player achievements
			gameNetwork.request( "loadAchievements", { listener=requestCallback } )
		else
			-- Display alert that Game Center cannot be initialized
			native.showAlert( "Error", "Cannot initialize Game Center. Confirm that you are signed in to the native Game Center app.", { "OK" } )
		end

		local printTable = composer.getVariable( "printTable" )
		printTable( event )
	end
end


-- Initialize Game Center if platform is an iOS device
if ( system.getInfo( "platformName" ) == "iPhone OS" ) then
	gameNetwork.init( "gamecenter", initCallback )
else
	native.showAlert( "Not Supported", "Apple Game Center is not supported on this platform. Please build and deploy to an iOS device.", { "OK" } )
end
