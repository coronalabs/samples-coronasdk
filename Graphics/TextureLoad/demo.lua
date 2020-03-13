
local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

local fileList = composer.getVariable( "fileList" )
local preloadButton, releaseButton, statusText, spinner
local appFont = composer.getVariable( "appFont" )
local photo, photoGroup
local photoTimers = {}
local removePhoto
local textures


local function createPhoto( fileIndex )

	-- Get the photo to display
	if ( fileIndex > #fileList ) then fileIndex = 1 end
	local photoFile = fileList[fileIndex]["file"]

	-- Check if it has been pre-loaded or not
	local texture = textures[photoFile]
	if texture then
		-- Pre-loaded texture exists
		photo = display.newImageRect( photoGroup, texture.filename, texture.baseDir, 144, 144 )
    else
		-- Texture not pre-loaded; fall back to normal loading
		photo = display.newImageRect( photoGroup, photoFile, system.CachesDirectory, 144, 144 )
	end

	if photo then
		photo.x, photo.y = display.contentCenterX, display.contentCenterY+20
		photo.fileIndex = fileIndex
		photoTimers[1] = timer.performWithDelay( 800, removePhoto )
	end
end


local function releaseTextures()

    -- Release textures one by one
    if textures then
		for textureName, textureResource in pairs( textures ) do
			textureResource:releaseSelf()
			textures[textureName] = nil
		end
    end
	-- Alternatively, release all textures by texture type
	-- graphics.releaseTextures( "image" )

	-- Update UI
	preloadButton.isVisible = true
	releaseButton.isVisible = false
	statusText.text = "Textures not Pre-Loaded"
	statusText:setFillColor( 0.5 )

	-- Remove existing photo
	removePhoto( photo )
end


removePhoto = function( event )

	-- If there is an existing timer, cancel it
	if photoTimers[1] then
		timer.cancel( photoTimers[1] )
		photoTimers[1] = nil
	end

	-- Remove the photo and create another
	if photo then
		display.remove( photo )
		createPhoto( photo.fileIndex+1 )
	end
end


function scene:create( event )

    local sceneGroup = self.view

	preloadButton = widget.newButton
	{
		label = "Pre-Load Textures",
		id = "preload",
		shape = "rectangle",
		width = 220,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.296,0.357,0.392,1 }, over={ 0.326,0.393,0.431,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = function() composer.gotoScene( "preload" , { time=800, effect="slideUp" } ); end
	}
	sceneGroup:insert( preloadButton )
	preloadButton.x, preloadButton.y = display.contentCenterX, 65

	releaseButton = widget.newButton
	{
		label = "Un-Load Textures",
		id = "release",
		shape = "rectangle",
		width = 220,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.55,0.125,0.125,1 }, over={ 0.66,0.15,0.15,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = function() releaseTextures(); end
	}
	sceneGroup:insert( releaseButton )
	releaseButton.x, releaseButton.y = display.contentCenterX, 65

	local backRect = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY+20, 152, 152 )
	backRect:setFillColor( 0.2, 0.2, 0.2, 0.5 )

	statusText = display.newText( sceneGroup, "", 140, 283, appFont, 20 )
	statusText.anchorX = 0
	statusText:setFillColor( 0.5 )

	photoGroup = display.newGroup()
	sceneGroup:insert( photoGroup )

	composer.setVariable( "photoTimers", photoTimers )
	
	if system.getInfo( "platform" ) ~= "tvos" then
		widget.setTheme( "widget_theme_android_holo_light" )
	end
	spinner = widget.newSpinner( { x=114, y=283, deltaAngle=10, incrementEvery=10 } )
	sceneGroup:insert( spinner )
	composer.setVariable( "spinner", spinner )
end


function scene:show( event )

	local sceneGroup = self.view

	if ( event.phase == "will" ) then

		textures = composer.getVariable( "textures" )

        if not textures then
            textures = {}
			preloadButton.isVisible = true
			releaseButton.isVisible = false
			statusText.text = "Textures not Pre-Loaded"
			statusText:setFillColor( 0.5 )
		else
			preloadButton.isVisible = false
			releaseButton.isVisible = true
			statusText.text = "Using Pre-Loaded Textures"
			statusText:setFillColor( 1 )
        end

    elseif ( event.phase == "did" ) then

		spinner:start()
		createPhoto( 1 )
    end
end


function scene:hide( event )

    if ( event.phase == "will" ) then

		-- If there is an existing timer, cancel it
		if ( photoTimers[1] ) then
			timer.cancel( photoTimers[1] )
			photoTimers[1] = nil
		end
		spinner:stop()

	elseif ( event.phase == "did" ) then

		-- Remove the photo
		display.remove( photo )
    end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
