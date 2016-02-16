
local widget = require( "widget" )

local M = {}

local infoShowing = false

function M:newUI( options )

	local backGroup = display.newGroup()
	local frontGroup = display.newGroup()
	local textGroupContainer = display.newContainer( 288, 240 ) ; frontGroup:insert( textGroupContainer )
	local barContainer = display.newContainer( 624, 36 ) ; frontGroup:insert( barContainer ) ; barContainer.anchorY = 0

	local scrollBounds
	local infoBoxState = "canOpen"
	local transComplete
	local defaultOrientation
	local themeName = options.theme or "whiteorange"
	local sampleCodeTitle = options.title or "Sample"
	local buildNum
	local offsetX = (display.actualContentWidth-display.contentWidth)/2
	local offsetY = (display.actualContentHeight-display.contentHeight)/2

	-- Read from the ReadMe.txt file
	local readMeText = ""
	local readMeFilePath = system.pathForFile( "ReadMe.txt", system.ResourceDirectory )
	if readMeFilePath then
		local readMeFile = io.open( readMeFilePath )
		local rt = readMeFile:read( "*a" )
		local function trimString( s )
			return string.match( s, "^()%s*$" ) and "" or string.match( s, "^%s*(.*%S)" )
		end
		rt = trimString( rt )
		if string.len( rt ) > 0 then readMeText = rt end
		io.close( readMeFile ) ; readMeFile = nil ; rt = nil
	end

	-- Create background image by theme value
	local background = display.newImageRect( backGroup, "sampleUI/back-"..themeName..".png", 360, 640 )
	background.x, background.y = display.contentCenterX, display.contentCenterY

	local topBarBack = display.newRect( frontGroup, 0, 0, 624, 37 )
	topBarBack:setFillColor( 0,0,0,0.2 ) ; topBarBack.anchorY = 0 ; topBarBack:toBack()
	local topBarOver = display.newRect( barContainer, 0, 0, 624, 36 )
	topBarOver:setFillColor( { type="gradient", color1={ 0.144 }, color2={ 0.158 } } )
	textGroupContainer:toBack()

	-- Check system for font selection
	local useFont
	if "Win" == system.getInfo( "platformName" ) then useFont = native.systemFont
	elseif "Android" == system.getInfo( "platformName" ) then useFont = native.systemFont
	else useFont = "HelveticaNeue-Light"
	end
	self.appFont = useFont

	-- Place Corona title
	local siteLink = display.newText( frontGroup, "Corona SDK", 0, 0, useFont, 14 ) ; siteLink.anchorX = 0
	siteLink:setFillColor( 0.961, 0.494, 0.125 )
	siteLink:addEventListener( "touch",
		function( event )
			if event.phase == "began" then
				system.openURL( "http://www.coronalabs.com" )
			end
			return true
		end )

	-- Place sample app title
	local title = display.newText( frontGroup, sampleCodeTitle, 0, 0, useFont, 14 ) ; title.anchorX = 1

	if options.showBuildNum == true then
		buildNum = display.newText( frontGroup, "Build "..tonumber( system.getInfo( "build" ):sub(-4) ), 0, 0, useFont, 10 )
		buildNum.anchorX = 1 ; buildNum.anchorY = 1
		if ( themeName == "darkgrey" or themeName == "mediumgrey" ) then buildNum:setFillColor( 0.8 ) else buildNum:setFillColor( 0.2 ) end
	end

	-- Create shade rectangle
	local screenShade = display.newRect( frontGroup, 0, 0, display.contentWidth+400, display.contentHeight+400 )
	screenShade:setFillColor( 0,0,0 ) ; screenShade.alpha = 0
	screenShade.x, screenShade.y = display.contentCenterX, display.contentCenterY
	screenShade.isHitTestable = false ; screenShade:toBack()

	-- Create info button (initially invisible)
	local infoButton = display.newImageRect( frontGroup, "sampleUI/infobutton.png", 25, 25 ) ; infoButton.anchorX = 1
	infoButton.isVisible = false
	infoButton.id = "infoButton"

	-- Create table for initial object positions
	local objPos = { infoBoxOffY=0, infoBoxDestY=0 }

	if ( system.orientation == "landscapeLeft" or system.orientation == "landscapeRight" ) then
		defaultOrientation = "landscape"
		background.x, background.y, background.rotation = display.contentCenterX, display.contentCenterY, 90
	elseif ( system.orientation == "portrait" or system.orientation == "portraitUpsideDown" ) then
		defaultOrientation = "portrait"
		background.x, background.y, background.rotation = display.contentCenterX, display.contentCenterY, 0
	end

	-- Position core objects
	objPos["infoBoxOffY"] = -130-offsetY
	objPos["infoBoxDestY"] = 158-offsetY
	barContainer.x, barContainer.y = display.contentCenterX, -offsetY-8
	topBarBack.x, topBarBack.y = display.contentCenterX, -offsetY-7
	siteLink.x, siteLink.y = 8-offsetX, (barContainer.height/2)-offsetY-4
	title.x, title.y = display.contentWidth-28+offsetX, (barContainer.height/2)-offsetY-4
	if buildNum then buildNum.x, buildNum.y = display.contentWidth+offsetX-7, display.contentHeight+offsetY-8 end
	textGroupContainer.x = display.contentCenterX
	infoButton.x, infoButton.y = display.contentWidth+offsetX-3, (barContainer.height/2)-offsetY-4

	-- Resize change handler
	local function onResize( event )

		local ox, oy = offsetX, offsetY
		local orientation = "landscape"
		if display.contentHeight > display.contentWidth then orientation = "portrait" end
		if orientation ~= defaultOrientation then ox, oy = offsetY, offsetX end

		if orientation == "portrait" then
			background.x, background.y, background.rotation = display.contentCenterX, display.contentCenterY, 0
		else
			background.x, background.y, background.rotation = display.contentCenterX, display.contentCenterY, 90
		end

		objPos["infoBoxOffY"] = -130-oy
		objPos["infoBoxDestY"] = 158-oy
		barContainer.x, barContainer.y = display.contentCenterX, -oy-8
		topBarBack.x, topBarBack.y = display.contentCenterX, -oy-7
		siteLink.x, siteLink.y = 8-ox, (barContainer.height/2)-oy-4
		title.x, title.y = display.contentWidth-28+ox, (barContainer.height/2)-oy-4
		if buildNum then buildNum.x, buildNum.y = display.contentWidth+ox-7, display.contentHeight+oy-8 end
		textGroupContainer.x = display.contentCenterX
		infoButton.x, infoButton.y = display.contentWidth+ox-3, (barContainer.height/2)-oy-4

		-- If info box is opening or already open, snap it entirely on screen
		if ( infoBoxState == "opening" or infoBoxState == "canClose" ) then
			transition.cancel( "infoBox" )
			textGroupContainer.xScale, textGroupContainer.yScale = 1,1
			textGroupContainer.y = objPos["infoBoxDestY"]
			scrollBounds.x, scrollBounds.y = display.contentCenterX, objPos["infoBoxDestY"]
			transComplete()
		-- If info box is closing or already closed, snap it entirely off screen
		elseif ( infoBoxState == "closing" or infoBoxState == "canOpen" ) then
			transition.cancel( "infoBox" )
			textGroupContainer.y = objPos["infoBoxOffY"]
			scrollBounds.x, scrollBounds.y = display.contentCenterX, objPos["infoBoxOffY"]
			transComplete()
		end
	end
	Runtime:addEventListener( "resize", onResize )

	-- If there is ReadMe.txt content, create needed elements
	if readMeText ~= "" then

		-- Create the info box scrollview
		scrollBounds = widget.newScrollView
		{
			x = 160,
			y = objPos["infoBoxDestY"],
			width = 288,
			height = 240,
			horizontalScrollDisabled = true,
			hideBackground = true,
			topPadding = 0,
			bottomPadding = 0
		}
		scrollBounds:setIsLocked( true )
		scrollBounds.x, scrollBounds.y = display.contentCenterX, objPos["infoBoxOffY"]
		frontGroup:insert( scrollBounds )

		local infoBoxBack = display.newRect( 0, 0, 288, 240 )
		if themeName == "whiteorange" then infoBoxBack:setFillColor( 0.88 )
		elseif themeName == "lightgrey" then infoBoxBack:setFillColor( 0.98 )
		else infoBoxBack:setFillColor( 0.78 ) end
		textGroupContainer:insert( infoBoxBack )

		-- Create the info text group
		local infoTextGroup = display.newGroup()
		textGroupContainer:insert( infoTextGroup )

		-- Create the info text and anchoring box
		local infoText = display.newText( infoTextGroup, "", 0, 0, 260, 0, useFont, 12 )
		infoText:setFillColor( 0 )
		infoText.text = "\n"..readMeText.."\n\n"
		infoText.anchorY = 0

		local textHeight = 240
		if infoText.height < 240 then textHeight = infoText.height end

		local infoTextAnchorBox = display.newRect( infoTextGroup, 0, 0, 288, textHeight )
		infoTextAnchorBox.anchorY = 0
		infoTextAnchorBox.isVisible = false

		-- Set anchor point on info text group
		local anc = infoTextGroup.height/120
		infoTextGroup.anchorChildren = true
		infoTextGroup.anchorY = 1/anc

		-- Initially set info objects to invisible
		infoTextGroup.isVisible = false
		textGroupContainer.isVisible = false

		transComplete = function()

			if infoBoxState == "opening" then
				scrollBounds:insert( infoTextGroup )
				infoTextGroup.x = 144 ; infoTextGroup.y = 120
				scrollBounds:setIsLocked( false )
				scrollBounds.x, scrollBounds.y = display.contentCenterX, objPos["infoBoxDestY"]
				infoBoxState = "canClose"
				infoShowing = true
				if self.onInfoEvent then
					self.onInfoEvent( { action="show", phase="did" } )
				end
			elseif infoBoxState == "closing" then
				infoTextGroup.isVisible = false
				textGroupContainer.isVisible = false
				scrollBounds.x, scrollBounds.y = display.contentCenterX, objPos["infoBoxOffY"]
				screenShade.isHitTestable = false
				infoBoxState = "canOpen"
				infoShowing = false
				if self.onInfoEvent then
					self.onInfoEvent( { action="hide", phase="did" } )
				end
			end
		end

		local function controlInfoBox( event )
			if event.phase == "began" then
				if infoBoxState == "canOpen" then
					infoBoxState = "opening"
					infoShowing = true
					if self.onInfoEvent then
						self.onInfoEvent( { action="show", phase="will" } )
					end
					textGroupContainer.x = display.contentCenterX
					textGroupContainer.y = objPos["infoBoxOffY"]
					textGroupContainer:insert( infoTextGroup )
					infoTextGroup.isVisible = true
					textGroupContainer.isVisible = true
					textGroupContainer.xScale = 0.96 ; textGroupContainer.yScale = 0.96
					screenShade.isHitTestable = true
					transition.cancel( "infoBox" )
					transition.to( screenShade, { time=400, tag="infoBox", alpha=0.75, transition=easing.outQuad } )
					transition.to( textGroupContainer, { time=900, tag="infoBox", y=objPos["infoBoxDestY"], transition=easing.outCubic } )
					transition.to( textGroupContainer, { time=400, tag="infoBox", delay=750, xScale=1, yScale=1, transition=easing.outQuad, onComplete=transComplete } )

				elseif infoBoxState == "canClose" then
					infoBoxState = "closing"
					infoShowing = false
					if self.onInfoEvent then
						self.onInfoEvent( { action="hide", phase="will" } )
					end
					textGroupContainer:insert( infoTextGroup )
					local scrollX, scrollY = scrollBounds:getContentPosition()
					infoTextGroup.x = 0 ; infoTextGroup.y = scrollY
					scrollBounds:setIsLocked( true )
					transition.cancel( "infoBox" )
					transition.to( screenShade, { time=400, tag="infoBox", alpha=0, transition=easing.outQuad } )
					transition.to( textGroupContainer, { time=400, tag="infoBox", xScale=0.96, yScale=0.96, transition=easing.outQuad } )
					transition.to( textGroupContainer, { time=700, tag="infoBox", delay=200, y=objPos["infoBoxOffY"], transition=easing.inCubic, onComplete=transComplete } )
				end
			end
			return true
		end

		-- Set info button tap listener
		infoButton.isVisible = true
		infoButton:addEventListener( "touch", controlInfoBox )
		infoButton.listener = controlInfoBox
		screenShade:addEventListener( "touch", controlInfoBox )
	end

	self.infoButton = infoButton
	self.titleBarBottom = barContainer.contentBounds.yMax
	backGroup:toBack() ; self.backGroup = backGroup
	frontGroup:toFront() ; self.frontGroup = frontGroup
end

function M:isInfoShowing()
	return infoShowing
end

return M
