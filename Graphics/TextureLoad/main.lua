
display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Texture Loading", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
local composer = require( "composer" )
display.getCurrentStage():insert( sampleUI.backGroup )
display.getCurrentStage():insert( composer.stage )
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set up download link for textures
composer.setVariable( "downloadURL", "https://raw.githubusercontent.com/coronalabs/sample-textureLoad/master/images/" )

-- Set app font
composer.setVariable( "appFont", sampleUI.appFont )

-- Include callback function for showing/hiding info box
-- In this sample, the photo timer and spinner are paused/resumed when appropriate
sampleUI.onInfoEvent = function( event )

	local photoTimers = composer.getVariable( "photoTimers" )
	local spinner = composer.getVariable( "spinner" )

	if ( event.action == "show" and event.phase == "will" ) then
		if photoTimers then
			if photoTimers[1] then
				timer.pause( photoTimers[1] )
			end
		end
		if spinner then
			spinner:stop()
		end

	elseif ( event.action == "hide" and event.phase == "did" ) then
		if photoTimers then
			if photoTimers[1] then
				timer.resume( photoTimers[1] )
			end
		end
		if spinner then
			spinner:start()
		end
	end
end

-- File list for sample
composer.setVariable( "fileList",
	{
		{ file="photo1.png", exists=false, fileSize=6932297 },  -- File sizes specified in bytes
		{ file="photo2.png", exists=false, fileSize=5840900 },
 		{ file="photo3.png", exists=false, fileSize=6465756 }
	})

-- Loop through file list and check which files already exist
local fileList = composer.getVariable( "fileList" )
local filesMissing = false

for f = 1,#fileList do
	local filePath = system.pathForFile( fileList[f]["file"], system.CachesDirectory )
	
	if ( filePath ) then
		local file, errorString = io.open( filePath, "r" )

		if not file then
			filesMissing = true
		else
			fileList[f]["exists"] = true
			file:close()
		end
		filePath = nil
		file = nil
	end
end

-- If all files exist, proceed to demo scene
if ( filesMissing == false ) then
	composer.gotoScene( "demo" )
-- Else, go to file download scene
else
	composer.gotoScene( "download", { time=800, effect="slideUp" } )
end
