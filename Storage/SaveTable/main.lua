
-- Abstract: SaveTable
-- Version: 1.1
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Save Table", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------

display.getCurrentStage():insert( sampleUI.backGroup )
local sceneGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Declare initial variables
local dataTableNew = {}

-- Test data
local dataTable = {
	var1 = "Hello",
	var2 = "World",
	numValue = 25,
	randomValue = math.random( 100 )
}

-- Set default anchor points
display.setDefault( "anchorX", 0.0 )
display.setDefault( "anchorY", 0.0 )

-- Seed the random number generator
math.randomseed( os.time() )

-- Load external libraries
local str = require( "str" )

-- Set location for saved data
local filePath = system.pathForFile( "data.txt", system.DocumentsDirectory )


local function loadData()

	local file = io.open( filePath, "r" )

	if file then

		-- Read file contents into a string
		local dataStr = file:read( "*a" )

		-- Break string into separate variables and construct new table from resulting data
		local datavars = str.split( dataStr, "," )

		for i = 1,#datavars do
			-- Split each name/value pair
			local oneValue = str.split( datavars[i], "=" )
			dataTableNew[oneValue[1]] = oneValue[2]
		end

		io.close( file )

		-- Note that all values arrive as strings; change to numbers where numbers are expected
		dataTableNew["numValue"] = tonumber(dataTableNew["numValue"])
		dataTableNew["randomValue"] = tonumber(dataTableNew["randomValue"])
	else
		print ( "No file found!" )
	end
end


local function saveData()

	local file = io.open( filePath, "w" )

	for k,v in pairs( dataTable ) do
		file:write( k .. "=" .. v .. "," )
	end

	io.close( file )
end


local function processData()

	-- Show initial data
	local yPos = 60
	local textHeader1 = display.newText( sceneGroup, "Data before saving", 25, yPos-12, sampleUI.appFont, 20 )
	textHeader1:setFillColor( 1, 0.7, 0.35 )
	for k,v in pairs( dataTable ) do
		yPos = yPos + 25
		local textLine = display.newText( sceneGroup, k .. " = " .. v, 35, yPos, sampleUI.appFont, 18 )
	end

	-- Save data
	saveData()

	-- Load data
	loadData()

	-- Show retrieved data
	yPos = yPos + 65
	local textHeader2 = display.newText( sceneGroup, "Data after reloading", 25, yPos-12, sampleUI.appFont, 20 )
	textHeader2:setFillColor( 1, 0.5, 0.25 )
	for k,v in pairs( dataTableNew ) do
		yPos = yPos + 25
		local textLine = display.newText( sceneGroup, k .. " = " .. v, 35, yPos, sampleUI.appFont, 18 )
	end
end


-- Start program execution
processData()
