-- 
-- Abstract: SimplePoolPlus sample project 
-- A basic game of billiards using the physics engine
-- (This is easiest to play on iPad or other large devices, but should work on all iOS and Android devices)
-- 
-- Version: 1.3
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2011 Corona Labs Inc. All Rights Reserved.
--
-- History
--	1.3		Changed ball file names from 1.png to ball_1.png (for 1.png through 15.png)
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local physics = require("physics")

physics.start()

--physics.setDrawMode("hybrid") --Set physics Draw mode
physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector
display.setStatusBar( display.HiddenStatusBar )

--Constants
local spriteTime = 100 -- sprite itteration time 
local feltColorIndex = 1 
local animationStop = 2.8 -- Sprite Animation Stops Below this velocity
local screenW, screenH = _W, _H
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight --Screen Size properties
local ballBody = { density=0.8, friction=1.0, bounce=.7, radius=15 }
local onePlayer = 1
local twoPlayer = 2
local options = 3
--Foward Declarations
local gameOver 
local mode
--Load Audio
local buzzAudio = audio.loadSound("buzz.mp3")
local collisionAudio = audio.loadSound("ballsCollide.mp3") 

--Setup Splash Screen

function splash()
	
	display.setDefault( "anchorX", 0.0 )	-- default to TopLeft anchor point for new objects
	display.setDefault( "anchorY", 0.0 )

	splashGroup = display.newGroup()
	
	local splashBG = display.newImage("splashBG.png", true, 20, 1, true)
	splashGroup:insert(splashBG)

	local onePlayerButton = display.newImage( "onePlayerButton.png", 200, 550, true)
	onePlayerButton.id = onePlayer
	splashGroup:insert(onePlayerButton)

	local twoPlayerButton = display.newImage( "twoPlayerButton.png", 200, 700, true)
	twoPlayerButton.id = twoPlayer
	splashGroup:insert(twoPlayerButton)

	local optionsButton = display.newImage( "optionsButton.png", 200, 850, true)
	optionsButton.id = options
	splashGroup:insert(optionsButton)

	display.setDefault( "anchorX", 0.5 )	-- restore anchor points for new objects to center anchor point
	display.setDefault( "anchorY", 0.5 )

	local fillBot = display.newImage( "fill_bkg.png", true )
	fillBot.rotation=180; fillBot.x = 384; fillBot.y = 1117
	splashGroup:insert(fillBot)
	
	onePlayerButton:addEventListener("touch", init)
	twoPlayerButton:addEventListener("touch", init)
	optionsButton:addEventListener("touch", init)


	--Buzzing Splashing screen animation
	function buzzLogo()
		local buzzGroup = display.newGroup()
		local randBuzz = math.random(1,6)
		local animationOne = 1
		local animationTwo = 2
	
		if randBuzz == animationOne then 
			local buzzOn = display.newImage( "neonOn.png", centerX, 75, true)
			buzzGroup:insert(buzzOn)
			audio.play(buzzAudio)
			timer.performWithDelay(1000, function() buzzOn:removeSelf(); end, 1)
		
		elseif randBuzz >= animationTwo then
			local buzzOff = display.newImage( "neonOff.png", centerX, 75, true)
			buzzGroup:insert(buzzOff)
			timer.performWithDelay(1000, function() buzzOff:removeSelf() end, 1)
		end
	end
		
	buzzTimer =  timer.performWithDelay(400, buzzLogo, -1) --Loops buzz animation  

end
				
--Setup Gameplay Stage
function gameStage()
	
	stageGroup = display.newGroup()
	
	
	local table = display.newImage( "table_bkg.png", true) -- "true" overrides Corona's downsizing of large images on smaller devices
	stageGroup:insert(table)
	table.x = 384
	table.y = 512
	
	
	local tableTopColor = display.newImage( "table"..feltColorIndex..".png", true) -- "true" overrides Corona's downsizing of large images on smaller devices
	stageGroup:insert(tableTopColor)
	tableTopColor.x = 384
	tableTopColor.y = 512
	
	local fillTop = display.newImage( "fill_bkg.png", true )
	stageGroup:insert(fillTop)
	fillTop.x = 384; fillTop.y = -93
	
	local fillBot = display.newImage( "fill_bkg.png", true )
	stageGroup:insert(fillBot)
	fillBot.rotation=180; fillBot.x = 384; fillBot.y = 1117

	local endBumperShape = { -212,-18, 212,-18, 190,2, -190,2 }
	local sideBumperShape = { -18,-207, 2,-185, 2,185, -18,207 }
	local bumperBody = { friction=0.5, bounce=0.5, shape=endBumperShape }

	local bumper1 = display.newImage( "bumperEnd"..feltColorIndex..".png" )
	stageGroup:insert(bumper1)
	physics.addBody( bumper1, "static", bumperBody )
	bumper1.x = 384; bumper1.y = 58

	local bumper2 = display.newImage( "bumperEnd"..feltColorIndex..".png" )
	stageGroup:insert(bumper2)
	physics.addBody( bumper2, "static", bumperBody )
	bumper2.x = 384; bumper2.y = 966; bumper2.rotation = 180

	-- Override the shape declaration above, but reuse the other body properties
	bumperBody.shape = sideBumperShape

	local bumper3 = display.newImage( "bumperSide"..feltColorIndex..".png" )
	stageGroup:insert(bumper3)
	physics.addBody( bumper3, "static", bumperBody )
	bumper3.x = 157; bumper3.y = 279

	local bumper4 = display.newImage( "bumperSide"..feltColorIndex..".png" )
	stageGroup:insert(bumper4)
	bumper4.x = 611; bumper4.y = 279; bumper4.rotation = 180
		physics.addBody( bumper4, "static", bumperBody)

	local bumper5 = display.newImage( "bumperSide"..feltColorIndex..".png" )
	stageGroup:insert(bumper5)
	physics.addBody( bumper5, "static", bumperBody )
	bumper5.x = 157; bumper5.y = 745

	local bumper6 = display.newImage( "bumperSide"..feltColorIndex..".png" )
	stageGroup:insert(bumper6)
	physics.addBody( bumper6, "static", bumperBody )
	bumper6.x = 611; bumper6.y = 745; bumper6.rotation = 180
	
	pauseBtn = display.newImage("pause.png",720,0 )
	pauseBtn:addEventListener("touch", 
		function() 
			local gameState = "paused"
			restartMenu(gameState)
		end
	)
	
	
	
	if mode == onePlayer then

		--Setup Up Player Score Board for only one player
		local solidScoreBoard = display.newImage("solidScore.png")
		stageGroup:insert(solidScoreBoard)
		solidScoreBoard.y = 500; solidScoreBoard.x = 53;

		solidTotal = 0
		solidScoreText = display.newText(solidTotal, 0, 0, native.systemFontBold, 30 )
		solidScoreText:setFillColor( 0, 0, 0, 1 )
		solidScoreText.x = 50; solidScoreText.y = 400; solidScoreText.rotation = 270
			
		timer.performWithDelay(500,
			function()
				local player1 = display.newImage("player1.png")
				stageGroup:insert(player1)
				player1.y = display.contentHeight/2; player1.x = centerX; player1.alpha = 0;
				local player1 = transition.to( player1, { alpha= 1, time=400, x=53, y=540 } )
			end
		,1)

	elseif mode == twoPlayer then

		--Setup Up Player Score Board for two players
		local solidScoreBoard = display.newImage("solidScore.png")
		stageGroup:insert(solidScoreBoard)
		solidScoreBoard.y = 500; solidScoreBoard.x = 53;
		

		local stripeScoreBoard = display.newImage("stripeScore.png")
		stageGroup:insert(stripeScoreBoard)
		stripeScoreBoard.y = 500; stripeScoreBoard.x = 715; stripeScoreBoard.rotation = 180 

		solidTotal = 0
		solidScoreText = display.newText(solidTotal, 0, 0, native.systemFontBold, 30 )
		solidScoreText:setFillColor( 0, 0, 0, 1 )
		solidScoreText.x = 50; solidScoreText.y = 400; solidScoreText.rotation = 270

		stripeTotal = 0
		stripeScoreText = display.newText(stripeTotal, 0, 0, native.systemFontBold, 30 )
		stripeScoreText:setFillColor( 0, 0, 0, 1)
		stripeScoreText.x = 718; stripeScoreText.y = 602; stripeScoreText.rotation = 90
		
		--Player one animations
		timer.performWithDelay(250,
			function()
				local playerOneAnimation = display.newImage("player1.png")
				stageGroup:insert(playerOneAnimation)
				playerOneAnimation.y = display.contentHeight/2 ; playerOneAnimation.x = centerX; playerOneAnimation.alpha = 0;
				local playerOneAnimation = transition.to( playerOneAnimation, { alpha= 1, xScale= 1, yScale=1.0, time=400, x=53, y=540 } )
			end
		,1)
		
		-- Player two animations
		timer.performWithDelay(1000,
			function()
				local playerTwoAnimation = display.newImage("player2.png")
				stageGroup:insert(playerTwoAnimation)
				playerTwoAnimation.y = display.contentHeight/2; playerTwoAnimation.x = centerX; playerTwoAnimation.alpha = 0; playerTwoAnimation.rotation = 180;
				local playerTwoAnimation = transition.to( playerTwoAnimation, { alpha= 1, xScale= 1, yScale=1.0, time=400, x=715, y=460 } )
			end
		,1)

	end
	
 	ballProperties()
end

--Sets up all pool ball functions
function ballProperties()
	
	gameBallGroup = display.newGroup() --Create ball group	
	
	local v = 0
	local reqForce = .18
	local maxBallSounds = 4
	
	--OnCollision Audio 
 	function ballCollisionAudio( self, event )
		local force = event.force
		local objId = event.other.id
		local reqId = "spriteBall"
		
		if force >= reqForce and reqId == objId and v <= maxBallSounds then -- Audio Play back is determined by the amount of force
				audio.play(collisionAudio)
				v = v + 1
				timer.performWithDelay(1000, function() v = v - 1 end, 1)
		end
	end
	
	--Create cueball
	cueball = display.newImage( "ball_white.png" )
	gameBallGroup:insert(cueball)
	cueball.x = centerX; cueball.y = 780
	physics.addBody( cueball, ballBody )
	cueball.linearDamping = 0.3
	cueball.angularDamping = 0.8
	cueball.isBullet = true -- force continuous collision detection, to stop really fast shots from passing through other balls
	cueball.type = "cueBall"
	cueball.collision = onCollision
	cueball:addEventListener("collision", cueball) -- Sprite balls start animation on Collision with cueball
	cueball.postCollision = ballCollisionAudio --Sets Event Listener for Audio on Collision
	cueball:addEventListener( "postCollision", cueball )
	
	--Creat Rotating target
	target = display.newImage( "target.png" )
	target.x = cueball.x; target.y = cueball.y; target.alpha = 0;

	--Ball Properties Table

	local ballTable = {
						{type = "solid"}, 
					  	{type = "solid"}, 
						{type = "solid"}, 
						{type = "solid"}, 
						{type = "solid"}, 
						{type = "solid"}, 
						{type = "solid"}, 
						{type = "eightBall"},
						{type = "stripe"}, 
						{type = "stripe"}, 
						{type = "stripe"}, 
						{type = "stripe"}, 
						{type = "stripe"}, 
						{type = "stripe"}, 
						{type = "stripe"}
						}
					

	local spriteInstance = {}
	local n = 1
	for i = 1, 5 do
			for j = 1, (6-i) do 
				spriteInstance[n] = display.newImage("ball_" .. n .. ".png")
				gameBallGroup:insert(spriteInstance[n])
				physics.addBody(spriteInstance[n], ballBody)
				spriteInstance[n].x = 279 + (j*34) + (i*15) 
				spriteInstance[n].y = 185 + (i*27)
				spriteInstance[n].linearDamping = 0.3 -- simulates friction of felt
				spriteInstance[n].angularDamping = 2 -- stops balls from spinning forever
				spriteInstance[n].isBullet = true -- If true physics body always awake
				spriteInstance[n].active = true -- Ball is set to active
				spriteInstance[n].bullet = false -- force continuous collision detection, to stop really fast shots from passing through other balls
				spriteInstance[n].id = "spriteBall"
				spriteInstance[n].type = ballTable[n].type
				spriteInstance[n].postCollision = ballCollisionAudio
				spriteInstance[n]:addEventListener( "postCollision", spriteInstance[n] )
				n = n + 1
			end
	end
		cueball:addEventListener( "touch", cueShot ) -- Sets event listener to cueball
		setPockets()
	
end

--Reset cueball
function resetCueball()
	cueball.alpha = 0
	cueball.x = 384
	cueball.y = 780
	cueball.xScale = 2.0; cueball.yScale = 2.0
	local dropBall = transition.to( cueball, { alpha=1.0, xScale=1.0, yScale=1.0, time=400 } )
end


--Sets up pockets
function inPocket( self, event )

	local fallDown = transition.to( event.other, { alpha=0, xScale=0.3, yScale=0.3, time=200 } )
	local object = event.other
	
	event.other:setLinearVelocity( 0, 0 )
		
	if event.other.type == "cueBall" then
		timer.performWithDelay( 50, resetCueball )
		
	elseif event.other.type == "solid" and event.other.active == true then
		event.other.active = false
		--Update Solid Score
		solidTotal = solidTotal + 1
		solidScoreText.text = solidTotal
	elseif event.other.type == "stripe" and event.other.active == true and mode == 2 then
		event.other.active = false -- Prevents balls from 
		--Update Stripe Score
		stripeTotal = stripeTotal + 1
		stripeScoreText.text = stripeTotal
	elseif event.other.type == "eightBall" then				
		gameOver()
	end

end

-- Create pockets
function setPockets()
	local pocket = {}
	for i = 1, 3 do
		for j = 1, 2 do
			local index = j + ((i-1) * 2) -- a counter from 1 to 6

			-- Add objects to use as collision sensors in the pockets
			local sensorRadius = 20
			pocket[index] = display.newCircle( -389 + (515*j), -436 + (474*i), sensorRadius )
			stageGroup:insert(pocket[index])
			
			-- (Change this value to "true" to make the pocket sensors visible)
			pocket[index].isVisible = false
			physics.addBody( pocket[index], { radius=sensorRadius, isSensor=true } )
			pocket[index].id = "pocket"
			pocket[index].bullet = false
			pocket[index].collision = inPocket
			pocket[index]:addEventListener( "collision", pocket[index] ) -- add table listener to each pocket sensor

		end
	end
end



-- Shoot the cue ball, using a visible force vector
function cueShot( event )

	local t = event.target
	local phase = event.phase
	
		
	if "began" == phase then
		display.getCurrentStage():setFocus( t )
		t.isFocus = true
		
		-- Stop current cueball motion, if any
		t:setLinearVelocity( 0, 0 )
		t.angularVelocity = 0

		target.x = t.x
		target.y = t.y

		startRotation = function()
			target.rotation = target.rotation + 4
		end
		
		Runtime:addEventListener( "enterFrame", startRotation )
		
		local showTarget = transition.to( target, { alpha=0.4, xScale=0.4, yScale=0.4, time=200 } )
		myLine = nil

	elseif t.isFocus then
		
		if "moved" == phase then
			
			if ( myLine ) then
				myLine.parent:remove( myLine ) -- erase previous line, if any
			end
			myLine = display.newLine( t.x,t.y, event.x,event.y )
			myLine:setStrokeColor( 1, 1, 1, 50/255 )
			myLine.strokeWidth = 15

		elseif "ended" == phase or "cancelled" == phase then
		
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			
			local stopRotation = function()
				Runtime:removeEventListener( "enterFrame", startRotation )
			end
			
			local hideTarget = transition.to( target, { alpha=0, xScale=1.0, yScale=1.0, time=200, onComplete=stopRotation } )
			
			if ( myLine ) then
				myLine.parent:remove( myLine )
			end
			
			-- Strike the ball!
				local cueShot = audio.loadSound("cueShot.mp3")
				audio.play(cueShot)
				t:applyForce( (t.x - event.x), (t.y - event.y), t.x, t.y )	
		end
	end

	return true	-- Stop further propagation of touch event
end

--Displays game over screeen
function gameOver()
		
	gameOverGroup = display.newGroup()
	
	local overSplash = display.newImage( "game_over.png", centerX, centerY, true )
	gameOverGroup:insert(overSplash)
	overSplash.alpha = 0
	overSplash.xScale = 1.5; overSplash.yScale = 1.5
	
	local showGameOver = transition.to( overSplash, { alpha=1.0, xScale=1.0, yScale=1.0, time=500 } )
	cueball:removeEventListener( "touch", cueShot )
	
	local gameState = "gameOver"
	restartMenu(gameState) 
	
end

--In game restart menu
function restartMenu(gameState)
	pauseBtn:removeSelf()
	menuGroup = display.newGroup()
		
	if gameState == "paused" then
		local backDrop = display.newRect(0, 0, screenW, screenH )
		backDrop.anchorX = 0
		backDrop.anchorY = 0
		menuGroup:insert(backDrop)
		backDrop:setFillColor(0, 0, 0,100/255)
	end
	
	local restartGameImage = display.newImage("newGameButton.png",centerX,centerY,true )
	menuGroup:insert(restartGameImage)
	restartGameImage.state = gameState
	restartGameImage:addEventListener('touch', restartGame)
	
end


--Restart Game
function restartGame( event )
	local gameState = event.target.state
	if event.phase == "ended"  then
		if gameState == "gameOver" then
			gameOverGroup:removeSelf()
		end
			stageGroup:removeSelf() -- Removes All Stage Objects
			gameBallGroup:removeSelf() --Removes Ball Objects
			menuGroup:removeSelf() --Removes Menu Group Objects
			timer.performWithDelay(1000, splash, 1) -- Calls splash screen
	end
end

--Displays options menu
function optionMenu()
	
	local stroke = 5
	local optionsGroup = display.newGroup() --Create options menu group
	
	local function changeFelt(event)
		local feltObject = event.target
		local feltColor = event.target.id
		if event.phase == "ended" then
			feltColorIndex = feltColor
			feltObject.selected = true
			optionsGroup:removeSelf() 
			feltObject:setStrokeColor(16/255, 1, 4/255)
			timer.performWithDelay(200, 
				function() 
					
					transition.to( splashGroup, { alpha= 1, xScale= 1, yScale=1.0, time=1000} )
				end
			,1)

		end
		
	end
	
	display.setDefault( "anchorX", 0.0 )	-- default to TopLeft anchor point for new objects
	display.setDefault( "anchorY", 0.0 )

	local optionsBG = display.newImage("optionsBG.png",-5,540,true)
	optionsGroup:insert(optionsBG)

	local greenFelt = display.newImage( "sample1.png", 49, 701, true )
	optionsGroup:insert(greenFelt)
	greenFelt:setStrokeColor(1)
	greenFelt.strokeWidth = stroke
	greenFelt.id = "1"
	greenFelt:addEventListener('touch', changeFelt)
	
	local purpleFelt = display.newImage( "sample2.png", 219, 701, true ) 
	optionsGroup:insert(purpleFelt)
	purpleFelt:setStrokeColor(1)
	purpleFelt.strokeWidth = stroke
	purpleFelt.id = "2"
	purpleFelt:addEventListener('touch', changeFelt)
	local redFelt = display.newImage( "sample3.png", 392, 701, true )
	optionsGroup:insert(redFelt)
	redFelt:setStrokeColor(1) 
	redFelt.strokeWidth = stroke
	redFelt.id = "3"
	redFelt:addEventListener('touch', changeFelt)
		
	local tealFelt = display.newImage( "sample4.png", 565, 701, true )
	optionsGroup:insert(tealFelt)
	tealFelt:setStrokeColor(1)
	tealFelt.strokeWidth = stroke
	tealFelt.id = "4"
	tealFelt:addEventListener('touch', changeFelt)
	
	local selectFeltText = display.newText("Select a table color!", 150, 625, systemFontBold, 50 )
	optionsGroup:insert(selectFeltText)
	selectFeltText:setFillColor(1,1,1)
	
	display.setDefault( "anchorX", 0.5 )	-- restore anchor points for new objects to center anchor point
	display.setDefault( "anchorY", 0.5 )

end



function init( event )
	 
	mode = event.target.id

	if mode == onePlayer or mode == twoPlayer then
		
		timer.cancel(buzzTimer)-- Remoes buzzing animation
		
		splashGroup:removeSelf()-- Removes splash screen objects
		
	timer.performWithDelay(800, gameStage, 1)
		
	elseif mode == options then
		local splashButtonAnimation = transition.to( splashGroup, { alpha= 0, xScale= 1, yScale=1.0, time=400} ) -- Transitions splash Menu to options Menu
		optionMenu()
	end
	
		
end

-- Set Up Splashh Screen
splash()

--Sets game splash button listeners





