
-- Abstract: Filter Viewer
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Filter Viewer", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Require libraries/plugins
local filterData = require( "filters" )
local widget = require( "widget" )
if ( system.getInfo("platform") ~= "tvos" ) then
	widget.setTheme( "widget_theme_android_holo_light" )
end

-- Set app font
local appFont = sampleUI.appFont

-- Local variables and forward references
local deviceSupportsHPFS = system.getInfo( "gpuSupportsHighPrecisionFragmentShaders" )
local currentFilter = ""
local list

-- Create containers for images
local cont1 = display.newContainer( display.actualContentWidth/2, 150 )
cont1.x, cont1.y = display.contentCenterX-(cont1.width/2)-2, sampleUI.titleBarBottom + 75
mainGroup:insert( cont1 )
local cont2 = display.newContainer( display.actualContentWidth/2, 150 )
cont2.x, cont2.y = display.contentCenterX+(cont2.width/2)+2, sampleUI.titleBarBottom + 75
mainGroup:insert( cont2 )

-- Image before filter is applied
local before = display.newImageRect( cont1, "image.jpg", 200, 160 )
before.x, before.y = 1, 0

-- Image after filter is applied
local after = display.newImageRect( cont2, "image.jpg", 200, 160 )
after.x, after.y = -1, 0

-- Function to render table view rows
local function onRowRender( event )

	local row = event.row
	local y = row.contentHeight * 0.5
	local rowTitle = display.newText( row, row.id.name, 20, y-2, appFont, 16 )
	row.rowTitle = rowTitle
	if ( currentFilter == row.id.name ) then
		rowTitle:setFillColor( 1, 0.4, 0.25 )
	else
		rowTitle:setFillColor( 1 )
	end
	rowTitle.anchorX = 0

	local rowLine = display.newRect( row, 160, y+20, display.actualContentWidth, 2 )
	rowLine.anchorY = 1
	rowLine:setFillColor( 0 )

	if ( row.id.reqhp == true and deviceSupportsHPFS == false ) then
		rowTitle:setFillColor( 0.4 )
		row.canTest = false
	else
		row.canTest = true
	end
end

-- Handle row touch events
local function onRowTouch( event )

	if ( event.target.canTest == false ) then return end

	if ( event.phase == "press" ) then
		list.actionOnRelease = true
	elseif ( event.phase == "cancelled" ) then
		list.actionOnRelease = false
	end

	if ( "release" == event.phase and list.actionOnRelease == true ) then

		list.actionOnRelease = false
		currentFilter = event.target.id.name

		-- Apply filter to image
		after.fill.effect = event.target.id.name

		-- Step down through all filter data to apply filter properties
		local thisData = filterData[event.target.id.name]
		for K1,V1 in pairs( thisData ) do
			if ( type(V1) == "table" and #V1 == 0 ) then
				for K2,V2 in pairs(V1) do
					if ( type(V2) == "table" and #V2 == 0 ) then
						for K3,V3 in pairs(V2) do
							if not ( type(V3) == "table" and #V3 == 0 ) then
								after.fill.effect[K1][K2][K3] = V3
							end
						end
					else
						after.fill.effect[K1][K2] = V2
					end
				end
			else
				after.fill.effect[K1] = V1
			end
		end
		list:reloadData()
	end
end

local function scrollListener( event )
	if ( event.x and event.xStart and ( math.abs( event.x - event.xStart ) > 10 ) ) then
		list.actionOnRelease = false
	end
	return true
end

-- Create a table view
list = widget.newTableView(
{
	top = sampleUI.titleBarBottom + 154,
	left = display.screenOriginX,
	width = display.actualContentWidth,
	height = display.actualContentHeight - 180,
	hideBackground = true,
	rowTouchDelay = 0,
	noLines = true,
	hideScrollBar = true,
	onRowRender = onRowRender,
	onRowTouch = onRowTouch,
	listener = scrollListener
})
mainGroup:insert( list )

-- Read effects from module and sort alphabetically
local filterList = {}
for k,v in pairs(filterData) do
	filterList[#filterList+1] = { name=k, reqhp=v["reqhp"] }
end
table.sort( filterList, function( a,b ) return a.name < b.name; end )

-- Populate table view
for i = 1,#filterList do
	list:insertRow( { id=filterList[i], rowHeight=40, rowColor={ default={1,1,1,0}, over={1,1,1,0} } } )
end
