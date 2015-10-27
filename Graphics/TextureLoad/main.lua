
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

-- Set app font based on platform
if ( "Win" == system.getInfo( "platformName" ) or "Android" == system.getInfo( "platformName" ) ) then
	composer.setVariable( "appFont", native.systemFont )
else
	composer.setVariable( "appFont", "HelveticaNeue-Light" )
end

-- Set reference to "sampleUI" module for function calls in other modules
composer.setVariable( "sampleUI", sampleUI )

-- File list for sample
composer.setVariable( "fileList",
	{
		{ file="photo1.png", exists=false, fileSize=6932297 },  -- File sizes specified in bytes
		{ file="photo2.png", exists=false, fileSize=5840900 },
		{ file="photo3.png", exists=false, fileSize=6465756 },
		{ file="photo4.png", exists=false, fileSize=6304622 },
		{ file="photo5.png", exists=false, fileSize=5983230 },
		{ file="photo6.png", exists=false, fileSize=5437731 }
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
