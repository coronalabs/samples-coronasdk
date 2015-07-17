
display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Pew pew pew!", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
local composer = require( "composer" )
local scene = composer.newScene()
display.getCurrentStage():insert( sampleUI.backGroup )
display.getCurrentStage():insert( composer.stage )
display.getCurrentStage():insert( sampleUI.frontGroup )


local composer = require( "composer" )
local widget = require( "widget" )
local presetControls = require('presetControls')


local sndClick, sndBackground
local sndBackgroundHandler

-- Scene button handler function
local function handleSceneButton( event )
	local nextScene = event.target.id
	if ( nextScene == 'game' and next( composer.getVariable( 'controls' ) ) == nil ) then
		print "You must have at least one player connected first."
	else
		-- If we are entering the same, stop the background menu music.
		if ( sndBackgroundHandler ~= nil and nextScene == "game" ) then
			audio.stop(sndBackgroundHandler)
			sndBackgroundHandler = nil
		end

		audio.play( sndClick )
		composer.gotoScene( nextScene, { effect="crossFade", time=200 } )
	end
	return true
end

local configuredControllers

function scene:create( event )

	local sceneGroup = self.view
	local buttonGroup = display.newGroup()

	-- Play button
	local playButton = widget.newButton{
		x = display.contentCenterX,
		y = 0,
		id = "game",
		label = "Play",
		onPress = handleSceneButton,
		emboss = false,
		fontSize = 17,
		shape = "rectangle",
		width = 270,
		height = 36,
		fillColor = {
			default={ (55/255)+(0.3), (68/255)+(0.3), (77/255)+(0.3), 1 },
			over={ (55/255)+(0.3), (68/255)+(0.3), (77/255)+(0.3), 0.8 }
		},
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } }
	}
	buttonGroup:insert( playButton )

	-- Settings button
	local settingsButton = widget.newButton{
		x = display.contentCenterX,
		y = 46,
		id = "select-player-device",
		label = "Configure Controller",
		onPress = handleSceneButton,
		emboss = false,
		fontSize = 17,
		shape = "rectangle",
		width = 270,
		height = 36,
		fillColor = {
			default={ (55/255)+(0.1), (68/255)+(0.1), (77/255)+(0.1), 1 },
			over={ (55/255)+(0.1), (68/255)+(0.1), (77/255)+(0.1), 0.8 }
		},
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } }
	}
	buttonGroup:insert( settingsButton )
	
	buttonGroup.y = display.contentCenterY - buttonGroup.contentHeight/2
	sceneGroup:insert( buttonGroup )

	configuredControllers = display.newText{
		parent = sceneGroup,
		text = "No controllers configured!",
		x = display.contentCenterX,
		y = display.contentHeight*0.75,
		width = 270,
		aligh = "center",
		fontSize = 16
	}

	-- Load menu sound effects.
	sndClick = audio.loadSound( "click.ogg" )
	sndBackground = audio.loadSound( "background_menu.ogg" )
end

function updateControlsText(  )
	local controls = composer.getVariable( "controls" )
	if next(controls) ~= nil then
		local txt = "Configured controls:"
		for i, v in pairs(controls) do
			txt = txt .. '\n* ' .. v.name
		end
		configuredControllers.text = txt
	end

end

local function onInputDeviceStatusChanged( event )
	local controls = composer.getVariable( "controls" )
	if event.connectionStateChanged and event.device and event.device.isConnected then
		if controls[getEventDevice(event)] == nil then
			controls[getEventDevice(event)] = presetControls.presetForDevice(event.device)
			updateControlsText()
		end
	end
end


function scene:show( event )
	local sceneGroup = self.view
	
	updateControlsText()

	if ( sndBackgroundHandler == nil ) then
		sndBackgroundHandler = audio.play( sndBackground, { loops = -1 } )
	end

	Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )

end

function scene:hide( event )
	Runtime:removeEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
end


function scene:destroy( event )
	audio.dispose( sndClick )
	sndClick = nil

	audio.dispose( sndBackground )
	sndBackground = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )
scene:addEventListener( "hide", scene )


return scene
