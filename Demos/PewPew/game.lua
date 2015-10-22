
local composer = require( "composer" )
local widget = require( "widget" )

local generateCharacter = require( "character" )
local particleDesigner = require( "particleDesigner" )

local scene = composer.newScene()

local runFrameSpeed = 1.5
local runtime = 0
local spinner
local startText
local controlButtons = { ["left"]={x=-1,y=0}, ["right"]={x=1,y=0}, ["up"]={x=0,y=-1}, ["down"]={x=0,y=1} }
local players = {}
local numPlayers = 0
local pewPews = {}
local pewCounter = nil
local sndPewHandle, sndPew2Handle, sndDamageHandle, sndDeathHandle, sndBackgroundMusic, sndBackgroundMusicHandle, sndClickHandle

local exitButtonBackground, exitButton
local exitOnStartUp = false

-- Change audio format based on the target platform
local audioFileFormat = "ogg"
if ( system.getInfo( "platformName" ) == "iPhone OS" ) then
	audioFormat = "aac"
end

local function onInputDeviceStatusChanged( event )

	if event.connectionStateChanged then
		local getEventDevice = composer.getVariable( "getEventDevice" )
		local device = getEventDevice( event )
		local player = players[device]
		if player ~= nil then
			if event.device.isConnected then
				player.sprite.group.alpha = player.hp > 0 and 1 or 0.45
			else
				player.sprite.group.alpha = 0.25
				player.v.x = 0
				player.v.y = 0
				player.sprite.anim:setFrame( 2 )
			end
		end
	end
end


local function createPlayer( device, displayName, inputDevice )

	local sprite = generateCharacter( displayName, device, numPlayers, composer.getVariable("appFont") )
	numPlayers = numPlayers + 1
	sprite.group.x = math.random( 50, display.contentWidth - 50 )
	sprite.group.y = math.random( 50, display.contentHeight - 50 )
	players[device] = {
		sprite = sprite,
		v = { x=0, y=0 },
		anim = "idle",
		canFire = true,
		cooldown = 300,
		name = displayName,
		score = 0,
		lastDir = controlButtons["down"],
		hp = 100,
		inputDevice = inputDevice,
		exitProgress = -1
	}
	scene.view:insert( sprite.group )
end


local function createPew( player )

	local len = math.sqrt(player.lastDir.x*player.lastDir.x + player.lastDir.y*player.lastDir.y)
	if len > 0 then
		player.canFire = false
		timer.performWithDelay( player.cooldown, function()
			player.canFire = player.hp > 0
		end )

		local isCorona = math.random() <= 0.95
		local pew = {
			sprite = display.newImageRect( scene.view, isCorona and "pew.png" or "pew2.png", 25, 25 ),
			dmg = isCorona and 5 or 2,
			v = { x=0, y=0 },
			lifetime = 1.2,
			player = player
		}
		audio.play( isCorona and sndPewHandle or sndPew2Handle )
		pew.sprite.x = player.sprite.group.x
		pew.sprite.y = player.sprite.group.y
		player.sprite.group:toFront()
		transition.to( pew.sprite, { rotation=360*pew.lifetime*2, time=pew.lifetime*1000 } )
		transition.to( pew.sprite, { alpha=0, time=pew.lifetime*0.2*1000, delay=pew.lifetime*0.8*1000 } )
		pew.v.x = 3*player.lastDir.x/len + player.v.x
		pew.v.y = 3*player.lastDir.y/len + player.v.y
		pewPews[#pewPews+1] = pew
	end
end


local function onKeyEvent( event )

	local getEventDevice = composer.getVariable( "getEventDevice" )
	local device = getEventDevice( event )
	local controls = composer.getVariable( "controls" )

	local player = players[device]
	if player ~= nil then

		local controlDevice = controls[device]
		for c, mod in pairs(controlButtons) do
			if controlDevice[c] == event.keyName then
				local val
				if event.phase == "down" then
					val = 1
				else
					val = 0
				end
				player.v.x = player.v.x*(1-math.abs(mod.x)) + math.abs(mod.x)*mod.x*val
				player.v.y = player.v.y*(1-math.abs(mod.y)) + math.abs(mod.y)*mod.y*val
			end
		end
		if player.canFire and controlDevice["fire"] == event.keyName then
			createPew( player )
		end
		if controls[device]["start"] == event.keyName then
			if event.phase == "down" then
				if player.exitProgress<0 then
					player.exitProgress = system.getTimer()
				end
			else
				player.exitProgress = -1
				if exitOnStartUp then
					audio.play( sndClickHandle )
					composer.gotoScene( "main-menu", { effect="slideUp", time=600 } )
					return true
				end
			end
		end
	else
		if controls[device] and controls[device]["start"] == event.keyName then
			transition.to( startText, { time=280, alpha=0, transition=easing.outQuad } )
			transition.to( spinner, { time=280, alpha=0, transition=easing.outQuad } )
			createPlayer( device, controls[device].name, event.device )
		end
	end
end


local function onAxisEvent( event )

	local getEventDevice = composer.getVariable( "getEventDevice" )
	local device = getEventDevice( event )
	local controls = composer.getVariable( "controls" )

	local axisName = ""
	if event.normalizedValue > 0 then
		axisName = event.axis.type .. "+"
	else
		axisName = event.axis.type .. "-"
	end

	local accuracy = 0.3
	
	local player = players[device]
	if player ~= nil then
		local controlDevice = controls[device]
		for c, mod in pairs(controlButtons) do
			if controlDevice[c] == axisName then
				local val = math.abs(event.normalizedValue)
				if val < accuracy then
					val = 0
				end
				player.v.x = player.v.x*(1-math.abs(mod.x)) + math.abs(mod.x)*mod.x*val
				player.v.y = player.v.y*(1-math.abs(mod.y)) + math.abs(mod.y)*mod.y*val
			end
		end
		if player.v.x*player.v.x + player.v.y*player.v.y > 1 then
			local len = math.sqrt(player.v.x*player.v.x + player.v.y*player.v.y)
			player.v.x = player.v.x/len
			player.v.y = player.v.y/len
		end
		if player.canFire and controlDevice['fire'] == axisName and event.normalizedValue > accuracy then
			createPew(player)
		end
		if controls[device]["start"] == axisName then
			if math.abs(event.normalizedValue) > accuracy then
				if player.exitProgress<0 then
					player.exitProgress = system.getTimer()
				end
			else
				player.exitProgress = -1
				if exitOnStartUp then
					audio.play( sndClickHandle )
					composer.gotoScene( "main-menu", { effect="slideUp", time=600 } )
					return true
				end
			end
		end
	else
		if controls[device] and controls[device]["start"] == axisName and event.normalizedValue > accuracy then
			transition.to( startText, { time=280, alpha=0, transition=easing.outQuad } )
			transition.to( spinner, { time=280, alpha=0, transition=easing.outQuad } )
			createPlayer(device, controls[device].name, event.device)
		end
	end
end


local function getDeltaTime()
   local temp = system.getTimer()  -- Get current game time in ms
   local dt = (temp-runtime) / (1000/60)  -- 60fps or 30fps as base
   runtime = temp  -- Store game time
   return dt, temp
end


local function clampToScreen( x, min, max )
	if x < min then
		return min
	elseif x > max then
		return max
	else
		return x
	end
end


local function onFrameEnter()

	if exitOnStartUp then 
		return
	end

	if not pewCounter then
		-- pewCounter = display.newText( scene.view, "0", 10, 10)
	end

	local dt, time = getDeltaTime()
	local frameVelocity = dt*runFrameSpeed*1 -- instead of 1 should be frame time.
	local maxExitProgress = -1
	--tickPlayers
	for device, player in pairs(players) do
		player.sprite.group.x = clampToScreen(player.sprite.group.x + player.v.x*frameVelocity, 15, display.contentWidth-15)
		player.sprite.group.y = clampToScreen(player.sprite.group.y + player.v.y*frameVelocity, 25, display.contentHeight-25)

		local anim = "idle"
		if player.v.x*player.v.x + player.v.y*player.v.y >= 0.1 then
			if math.abs( player.v.x ) >= math.abs( player.v.y ) then
				if 0 < player.v.x then
					anim = "right"
				else
					anim = "left"
				end
			else
				if 0 < player.v.y then
					anim = "down"
				else
					anim = "up"
				end
			end
			player.lastDir = controlButtons[anim]
		end

		if player.anim ~= anim then
			if anim == "idle" then
				player.sprite.anim:pause()
				player.sprite.anim:setFrame(2)
			else
				player.sprite.anim:setSequence(anim)
				player.sprite.anim:play()
			end
			player.anim = anim
		end
		if player.exitProgress>0 then
			if maxExitProgress < 0 then
				maxExitProgress = player.exitProgress
			else
				maxExitProgress = math.min( player.exitProgress, maxExitProgress )
			end
		end
	end

	if maxExitProgress < 0 then
		exitButtonBackground.alpha = 0
	else
		local exitProgress = math.min(1, (time - maxExitProgress)/2000)
		exitButtonBackground.alpha = 0.3
		exitButtonBackground.width = exitButton.width * exitProgress
		exitButtonBackground.x = exitButton.x - exitButton.width*0.5 + exitButtonBackground.width*0.5
		if exitProgress >= 1 then
			exitButtonBackground.alpha = 0.6
			exitOnStartUp = true
			return
		end
	end

	-- Tick pew pews
	if #pewPews > 0 then
		for i=1,#pewPews do
			local pew = pewPews[i]
			if pew and not pew.dead and pew.sprite then
				if pew.sprite then
					pew.sprite.x = pew.sprite.x + frameVelocity*pew.v.x
					pew.sprite.y = pew.sprite.y + frameVelocity*pew.v.y
				end
				pew.lifetime = pew.lifetime - dt/60
				if pew.lifetime < 0 then
					if pew.sprite and pew.sprite then
						pew.sprite:removeSelf()
					end
					pew.dead = true
					pew.sprite = nil
				else
					for k, player in pairs(players) do
						if player ~= pew.player and player.hp > 0 and pew.sprite and math.abs(player.sprite.group.x - pew.sprite.x) < 20 and math.abs(player.sprite.group.y - pew.sprite.y) < 20 then

							if player.inputDevice then
								player.inputDevice:vibrate()
							end

							player.hp = player.hp - pew.dmg
							if player.hp <= 0 then
								player.hp = 0
								player.canFire = false
								player.sprite.group.alpha = 0.45
								player.sprite.anim.fill.effect = "filter.grayscale"
								audio.play( sndDeathHandle )
							else
								audio.play( sndDamageHandle )
								emitter = particleDesigner.newEmitter( "damage.json" )
								emitter.x = pew.sprite.x
								emitter.y = pew.sprite.y
								timer.performWithDelay( 500, function()
									emitter = nil
								end )
							end
							player.sprite.hp(player.hp)

							local sprite = pew.sprite
							pew.sprite = nil
							transition.cancel( sprite )
							transition.to( sprite, {xScale=3, yScale=3, time=250, rotation=sprite.rotation+90, alpha=0, onComplete = function(  )
								sprite:removeSelf( )
							end})
							pew.lifetime = -1
						end
					end
				end
			end
		end
		oldPews = pewPews
		pewPews = {}
		for i=1,#oldPews do
			if not oldPews[i].dead then
				pewPews[#pewPews+1] = oldPews[i]
			end
		end
	end
	if pewCounter then
		pewCounter.text = tostring( #pewPews )
	end
end


function scene:create( event )

	local sceneGroup = self.view

	display.setDefault( "textureWrapX", "repeat" )
	display.setDefault( "textureWrapY", "repeat" )

	-- Create a background image
	local background = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
	background.fill = { type="image", filename="grass.png" }
	background.fill.scaleX = 0.5
	background.fill.scaleY = 0.5

	-- Restore defaults
	local textureWrapDefault = "clampToEdge"
	display.setDefault( "textureWrapX", textureWrapDefault )
	display.setDefault( "textureWrapY", textureWrapDefault )

	-- Add back button
	exitButton = widget.newButton{
		label = "exit",
		onPress = function()
			audio.play( sndClickHandle )
			composer.gotoScene( "main-menu", { effect="slideUp", time=600 } )
		end,
		fontSize = 13,
		shape = "rectangle",
		width = 70,
		height = 20,
		fillColor = {
			default={ 0, 0, 0, 0.6 },
			over={ 0, 0, 0, 0.6 }
		},
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } }
	}
	sceneGroup:insert( exitButton )
	exitButton.x = exitButton.width*0.5 - composer.getVariable( "letterboxWidth" )
	exitButton.y = display.contentHeight - exitButton.height*0.5 + composer.getVariable( "letterboxHeight" )
	
	exitButtonBackground = display.newRect( sceneGroup, exitButton.x, exitButton.y, exitButton.width, exitButton.height )
	exitButtonBackground.alpha = 0

	startText = display.newText{
		parent = sceneGroup,
		x = display.contentCenterX,
		y = display.contentCenterY-60,
		text = 'press "start game" button on any device to play',
		font = composer.getVariable("appFont"),
		fontSize = 17
	}

	-- Load sounds
	sndClickHandle = audio.loadSound( "click." .. audioFileFormat )
	sndBackgroundMusicHandle = audio.loadStream( "background_fight." .. audioFileFormat )
	sndDamageHandle = audio.loadSound( "damage." .. audioFileFormat )
	sndDeathHandle = audio.loadSound( "death." .. audioFileFormat )
	sndPewHandle = audio.loadSound( "pew." .. audioFileFormat )
	sndPew2Handle = audio.loadSound( "pew2." .. audioFileFormat )

	-- Create spinner
	spinner = widget.newSpinner{
		x = display.contentCenterX,
		y = display.contentCenterY
	}
	sceneGroup:insert( spinner )
end


function scene:show( event )

	if event.phase == "will" then
		-- Re-show and start spinner
		startText.alpha = 1
		spinner.alpha = 1
		spinner:start()
		exitButtonBackground.alpha = 0
		exitOnStartUp = false

	elseif event.phase == "did" then
		-- Add listeners
		Runtime:addEventListener( "axis", onAxisEvent )
		Runtime:addEventListener( "key", onKeyEvent )
		Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
		Runtime:addEventListener( "enterFrame", onFrameEnter )

		audio.rewind( sndBackgroundMusicHandle )
		sndBackgroundMusic = audio.play( sndBackgroundMusicHandle, { loops=-1 } )
	end
end


function scene:hide( event )

	if event.phase == "will" then

		-- Remove listeners
		Runtime:removeEventListener( "axis", onAxisEvent )
		Runtime:removeEventListener( "key", onKeyEvent )
		Runtime:removeEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
		Runtime:removeEventListener( "enterFrame", onFrameEnter )

		-- Stop all audio
		audio.stop()

	elseif event.phase == "did" then

		-- Cleanup
		if #pewPews > 0 then
			for i=1,#pewPews do
				local pew = pewPews[i]
				pew.player = nil
				if pew.sprite then
					transition.cancel( pew.sprite )
					pew.sprite:removeSelf()
					pew.sprite = nil
				end
			end
		end
		pewPews = {}

		for k,player in pairs(players) do
			if player.sprite.group then
				player.sprite.group:removeSelf()
				player.sprite.group = nil
			end
		end
		players = {}
		numPlayers = 0

		-- Stop spinner
		spinner:stop()
	end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
