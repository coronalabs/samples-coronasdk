
local composer = require( "composer" )
local widget = require( "widget" )
local presetControls = require( "presetControls" )

local scene = composer.newScene()

local sndClickHandle, sndBackgroundHandle, sndBackground
local controllersTableView
local buttonGroup
local focusIndex

local platformName = system.getInfo( "platformName" )

-- Change audio format based on the target platform
local audioFileFormat = "ogg"
if ( platformName == "iPhone OS" or platformName == "tvOS" ) then
	audioFileFormat = "aac"
end

-- Scene button handler function
local function handleSceneButton( nextScene )
	if nextScene == "game" and next( composer.getVariable("controls") ) == nil then
		print( "You must have at least one player connected!" )
	elseif nextScene == "exit" then
		native.requestExit()
	else
		audio.play( sndClickHandle )
		composer.gotoScene( nextScene, { effect="slideDown", time=600 } )
	end
	return true
end


local function widgetHandleSceneButton( event )
	return handleSceneButton(event.target.id)
end


local function updateMenuSelection()
	local activefillColor = { (55/255)+(0.3), (68/255)+(0.3), (77/255)+(0.3), 1 }
	local inactivefillColor = { (55/255)+(0.15), (68/255)+(0.15), (77/255)+(0.15), 1 }

	for i=1,buttonGroup.numChildren do
		local child = buttonGroup[i]
		if i == focusIndex then
			child:setFillColor( unpack( activefillColor ) )
		else
			child:setFillColor( unpack( inactivefillColor ) )
		end
	end 
end


local function onRowRender( event )
	
	local controls = composer.getVariable("controls")

    local row = event.row
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
    local color = event.row.params.color
    local deviceText
    if not event.row.isCategory then
	    if controls[event.row.params.id] then
	    	deviceText = event.row.params.id  .. ' / ' .. controls[event.row.params.id].name
	    else
	    	deviceText = event.row.params.deviceName .. " (not configured)"
	    	color = color*0.6
	    end
	else
		deviceText = event.row.params.label
	end

    local rowTitle = display.newText( row, deviceText, 0, 0, composer.getVariable("appFont"), 15 )
    rowTitle:setFillColor( color )
    rowTitle.x = rowWidth/2
    rowTitle.y = rowHeight * 0.5
end


local function updateControlsTable( device, status, deviceName )

	local controls = composer.getVariable("controls")

	-- If a specific controller is connected or disconnected, update controls table
	if device and status then

		-- Handle connect
		if status == "connected" then
			local lastRow = controllersTableView:getRowAtIndex( controllersTableView:getNumRows() )
			controllersTableView:insertRow(
			{
				isCategory = false,
				rowHeight = 28,
				rowColor = { default={ 1, 1, 1, 0.05 } },
				params = { id=device, color=0.9, deviceName=deviceName }
			})
		-- Handle disconnect
		elseif status == "disconnected" then
			for i=1,controllersTableView:getNumRows() do
				local row = controllersTableView:getRowAtIndex( i )
				if row ~= nil and row.params.id == device then
					controllersTableView:deleteRows( { i }, { slideLeftTransitionTime=0, slideUpTransitionTime=320 } )
				end
			end
		end

	-- Else, populate controls table with all current controllers
	else
		controllersTableView:deleteAllRows()
		controllersTableView:insertRow(
		{
			isCategory = true,
			rowHeight = 28,
			rowColor = { default={ 0.42, 0.42, 0.42, 0.9 } },
			params = { label="current controllers", color=0.75 }
		})


		for i,v in pairs( controls ) do
			controllersTableView:insertRow(
			{
				isCategory = false,
				rowHeight = 28,
				rowColor = { default={ 1, 1, 1, 0.05 } },
				params = { id=i, color=0.9, deviceName=v.name }
			})
		end

		local getEventDevice = composer.getVariable("getEventDevice")
 		local getNiceDeviceName = composer.getVariable("getNiceDeviceName")
		local inputDevices = system.getInputDevices()
		for i = 1,#inputDevices do
			local device = inputDevices[i]
			local deviceId = getEventDevice({device=device})
			if controls[deviceId] == nil then
				controllersTableView:insertRow(
				{
					isCategory = false,
					rowHeight = 28,
					rowColor = { default={ 1, 1, 1, 0.05 } },
					params = { id=deviceId, color=0.9, deviceName=getNiceDeviceName{device=device} }
				})				
			end
		end


	end
end


local function onInputDeviceStatusChanged( event )

	local controls = composer.getVariable("controls")
	local getEventDevice = composer.getVariable("getEventDevice")
	local getNiceDeviceName = composer.getVariable("getNiceDeviceName")

	if event.connectionStateChanged and event.device then
		if controls[getEventDevice(event)] == nil then
			controls[getEventDevice(event)] = presetControls.presetForDevice( event.device )
		end
		if event.device.isConnected == true then
			updateControlsTable( getEventDevice(event), "connected", getNiceDeviceName(event) )
		elseif event.device.isConnected == false then
			updateControlsTable( getEventDevice(event), "disconnected", getNiceDeviceName(event) )
		end
	end
end


function scene:create( event )

	local sceneGroup = self.view
	buttonGroup = display.newGroup()

	-- Play button
	local playButton = widget.newButton{
		x = display.contentCenterX,
		y = 0,
		id = "game",
		label = "Play",
		onPress = widgetHandleSceneButton,
		emboss = false,
		font = composer.getVariable("appFont"),
		fontSize = 17,
		shape = "rectangle",
		width = 250,
		height = 32,
		fillColor = {
			default={ (55/255)+(0.3), (68/255)+(0.3), (77/255)+(0.3), 1 },
			over={ (55/255)+(0.3), (68/255)+(0.3), (77/255)+(0.3), 0.8 }
		},
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } }
	}
	buttonGroup:insert( playButton )

	-- Configure controllers buttons
	local configureButton = widget.newButton{
		x = display.contentCenterX,
		y = 42,
		id = "select-player-device",
		label = "Configure a controller",
		onPress = widgetHandleSceneButton,
		emboss = false,
		font = composer.getVariable("appFont"),
		fontSize = 17,
		shape = "rectangle",
		width = 250,
		height = 32,
		fillColor = {
			default={ (55/255)+(0.15), (68/255)+(0.15), (77/255)+(0.15), 1 },
			over={ (55/255)+(0.1), (68/255)+(0.1), (77/255)+(0.1), 0.8 }
		},
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } }
	}
	buttonGroup:insert( configureButton )
	buttonGroup.y =  0 - composer.getVariable("letterboxHeight") + buttonGroup.contentHeight/2 + 45
	sceneGroup:insert( buttonGroup )
	
	-- Exit button. Do not show on iOS or tvOS, as per Apple's guidelines
	if ( platformName ~= "iPhone OS" and platformName ~= "tvOS" ) then
		local exitButton = widget.newButton{
			x = display.contentCenterX,
			y = 84,
			id = "exit",
			label = "Exit",
			onPress = widgetHandleSceneButton,
			emboss = false,
			font = composer.getVariable("appFont"),
			fontSize = 17,
			shape = "rectangle",
			width = 250,
			height = 32,
			fillColor = {
				default={ (55/255)+(0.15), (68/255)+(0.15), (77/255)+(0.15), 1 },
				over={ (55/255)+(0.1), (68/255)+(0.1), (77/255)+(0.1), 0.8 }
			},
			labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } }
		}
		buttonGroup:insert( exitButton )
	end

	buttonGroup.y =  0 - composer.getVariable("letterboxHeight") + 64
	sceneGroup:insert( buttonGroup )

	-- Create tableView showing controllers
	controllersTableView = widget.newTableView{
		x = display.contentCenterX,
		y = 320 + composer.getVariable("letterboxHeight") - 70,
		height = 140,
		width = display.contentWidth +(composer.getVariable("letterboxWidth")*2),
		noLines = true,
		backgroundColor = { 0.8, 0.8, 0.8, 0.3 },
		hideScrollBar = true,
		onRowRender = onRowRender
	}
	sceneGroup:insert( controllersTableView )

	-- Load sounds
	sndClickHandle = audio.loadSound( "click." .. audioFileFormat )
	sndBackgroundHandle = audio.loadSound( "background_menu." .. audioFileFormat )

	timer.performWithDelay( 1, function (  )
		focusIndex = 1
		updateMenuSelection()
	end )
end


function math.clamp(n, low, high) return math.min(math.max(n, low), high) end


local function onKeyEvent( event )

	if event.phase ~= "down" then
		return false
	end

	-- Let Android/tvOS exit here rather than closing the app mid-handling.
	if event.keyName == "back" or event.keyName == "mediaPause" then
		return false
	end

	local getEventDevice = composer.getVariable( "getEventDevice" )
	local getNiceDeviceName = composer.getVariable( "getNiceDeviceName" )
	local controls = composer.getVariable("controls")

	local device = getEventDevice( event )

	if controls[device] then
		if controls[device]["fire"] == event.keyName then
			if focusIndex>0 then
				timer.performWithDelay( 1, function ()
					audio.play( sndClickHandle )
					handleSceneButton( buttonGroup[focusIndex].id )
				end)
			end
		elseif controls[device]["up"] == event.keyName then
			focusIndex = math.clamp( focusIndex - 1, 1, buttonGroup.numChildren )
		elseif controls[device]["down"] == event.keyName then
			focusIndex = math.clamp( focusIndex + 1, 1, buttonGroup.numChildren )
		end
		updateMenuSelection()
	elseif controls[device] == nil then
		-- not configured device --
		composer.setVariable( "userDevice", device )
		if controls[device] == nil then
			controls[device] = {name=getNiceDeviceName( event )}
		end
		timer.performWithDelay( 1, function ()
			composer.gotoScene( "setup-player", { effect="slideDown", time=600 } )
		end)
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

	local accuracy = 0.6
	
	if math.abs(event.normalizedValue) > 0.6 then
		if controls[device] then
			if controls[device]["fire"] == axisName then
				if focusIndex>0 then
					timer.performWithDelay( 1, function ()
						audio.play( sndClickHandle )
						handleSceneButton( buttonGroup[focusIndex].id )
					end)
				end
			elseif controls[device]["up"] == axisName then
				focusIndex = math.clamp( focusIndex - 1, 1, buttonGroup.numChildren )
				Runtime:removeEventListener( "axis", onAxisEvent )
				timer.performWithDelay( 300, function()
					Runtime:addEventListener( "axis", onAxisEvent )
				end )
			elseif controls[device]["down"] == axisName then
				focusIndex = math.clamp( focusIndex + 1, 1, buttonGroup.numChildren )
				Runtime:removeEventListener( "axis", onAxisEvent )
				timer.performWithDelay( 300, function()
					Runtime:addEventListener( "axis", onAxisEvent )
				end )
			end
			updateMenuSelection()
		elseif controls[device] == nil then
			-- not configured device --
			local getNiceDeviceName = composer.getVariable("getNiceDeviceName")
			composer.setVariable( "userDevice", device )
			if controls[device] == nil then
				controls[device] = {name=getNiceDeviceName( event )}
			end
			timer.performWithDelay( 1, function ()
				composer.gotoScene( "setup-player", { effect="slideDown", time=600 } )
			end)
		end 
	end
end


function scene:show( event )

	if event.phase == "will" then

		focusIndex = 0
		updateMenuSelection()
		updateControlsTable()
	elseif event.phase == "did" then
		Runtime:addEventListener( "key", onKeyEvent )
		Runtime:addEventListener( "axis", onAxisEvent )
		Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )

		audio.rewind( sndBackgroundHandle )
		sndBackground = audio.play( sndBackgroundHandle, { loops=-1 } )

		system.activate("controllerUserInteraction")
	end
end


function scene:hide( event )

	if event.phase == "will" then
		audio.stop( sndBackground )
		Runtime:removeEventListener( "key", onKeyEvent )
		Runtime:removeEventListener( "axis", onAxisEvent )
		Runtime:removeEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
	elseif event.phase == "did" then
		system.deactivate("controllerUserInteraction")
	end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
