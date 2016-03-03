
local composer = require( "composer" )
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios7" )

local scene = composer.newScene()

local text, progressBar


-- Set progress and update text
local function setProgress( progress, message )

    if progressBar then
		progress = math.min( 1, math.max( 0, progress ) )
		progressBar:setProgress( progress )
    end

	if text then
		text.text = message
    end
end


-- Create texture objects with "graphics.newTexture()", one by one
local function preloadTextures()

	local fileList = composer.getVariable( "fileList" )
	local textures = {}

    -- this function load a single texture, than schedules to load a next texture on next frame
    local function preloadTexture( f )

		-- Load the texture
        local texture = graphics.newTexture(
			{
				type = "image",
				filename = fileList[f]["file"],
				baseDir = system.CachesDirectory
			})
        if texture then
			texture:preload()
			local fileName = fileList[f]["file"]
			textures[fileName] = texture
        end

        -- Set progress
        setProgress( f/#fileList, 'Pre-Loading "' .. fileList[f]["file"] .. '"' )

        -- Schedule loading of next texture on next frame
		timer.performWithDelay( 1, function()
            -- If all textures are pre-loaded, return to demo scene
            if ( f == #fileList ) then
                composer.setVariable( "textures", textures )
				setProgress( 1, "Complete!" )
				timer.performWithDelay( 800, function() composer.gotoScene( "demo", { time=800, effect="slideDown" } ); end )
			-- Else, pre-load next texture
            else
                preloadTexture( f+1 )
            end
        end )
    end

    -- Pre-load first texture
    preloadTexture( 1 )
end


function scene:create( event )

	local sceneGroup = self.view

	progressBar = widget.newProgressView
	{
		x = display.contentCenterX,
		y = display.contentCenterY-40,
		width = 400,
		isAnimated = false
	}
	sceneGroup:insert( progressBar )

	text = display.newText( sceneGroup, "", display.contentCenterX, display.contentCenterY-20, composer.getVariable( "appFont" ), 16 )
	text.anchorX = 0
	text.x = progressBar.contentBounds.xMin
end


function scene:show( event )

	if ( event.phase == "will" ) then
		setProgress( 0, "" )
	elseif ( event.phase == "did" ) then
		preloadTextures()
	end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

return scene
