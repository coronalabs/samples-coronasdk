
local composer = require( "composer" )
local widget = require( "widget" )
local dlmod = require( "dlmod" )
widget.setTheme( "widget_theme_ios7" )

local scene = composer.newScene()

local text, progressBar
local totalBytes = 0
local bytesRemaining = 0


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


-- Callback function to track download progress
local function downloadListener( event )

	if ( event.progress and event.message ) then
		setProgress( event.progress, event.message )
	end

	-- Event property "done" means texture files are done downloading
	if ( event.done ) then

		progressBar:setProgress( 1 )

		-- When done loading textures, proceed to next scene
		timer.performWithDelay( 800, function() composer.gotoScene( "demo", { time=800, effect="slideDown" } ); end )
	end
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

	text = display.newText( sceneGroup, "(waiting)", display.contentCenterX, display.contentCenterY-20, composer.getVariable( "appFont" ), 16 )
	text.anchorX = 0
	text.x = progressBar.contentBounds.xMin

	-- Loop through file list and calculate total bytes + bytes remaining
	local fileList = composer.getVariable( "fileList" )
	for f = 1,#fileList do
		totalBytes = totalBytes + fileList[f]["fileSize"]
		if ( fileList[f]["exists"] == false ) then
			bytesRemaining = bytesRemaining + fileList[f]["fileSize"]
		end
	end

	-- Set progress bar level
	progressBar:setProgress( 1-(bytesRemaining/totalBytes) )
end


function scene:show( event )

	if ( event.phase == "did" ) then
		-- Start downloading textures; progress will be reported to "downloadListener"
		dlmod.download( composer.getVariable( "downloadURL" ), composer.getVariable( "fileList" ), downloadListener )
	end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

return scene
