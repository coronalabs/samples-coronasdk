-- 
-- Abstract: Camera sample app
-- 
-- Version: 1.3.1
-- 
-- Updated: February 11, 2016
--
-- Update History:
-- 	v1.1	Fixed logic problem where it said "session was canceled".
--	v1.2	Added Android support.
--	v1.3	Added support for runtime permission model.
--	v1.3.1	Maintenance.
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.]
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local json = require('json')

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

-- Set up UI elements.
local background = display.newRect( centerX, centerY, _W, _H )
background:setFillColor( 0.5, 0, 0 )
local displayText = display.newText( "Tap anywhere to launch Camera", centerX, _H - 24, nil, 16 )

-- Helper function that determines if a value is inside of a given table.
local function isValueInTable( haystack, needle )
	assert( type(haystack) == "table", "isValueInTable() : First parameter must be a table." )
	assert( needle ~= nil, "isValueInTable() : Second parameter must be not be nil." )

	for key, value in pairs( haystack ) do
		if ( value == needle ) then
			return true
		end
	end

	return false
end

-- Helper function that lets us know that we can use media.capturePhoto().
local function canUseMediaCapturePhoto()
	-- Ensure that can use the camera.
	local hasAccessToCamera, hasCamera = media.hasSource( media.Camera )
	if ( not hasCamera ) then
		print( "Device does not have a camera!" )
		return false
	elseif ( not hasAccessToCamera ) then
		print( "Lacking camera permission!" )
		return false
	end

	-- Ensure that we have permission to use external storage. We do not need
	-- to check for camera permission explicitly, because media.hasSource does that
	-- for us (see `hasAccessToCamera` above).
	local grantedPermissions = system.getInfo("grantedAppPermissions")
	if ( grantedPermissions ) then
		if ( not isValueInTable( grantedPermissions, "Storage" ) ) then
			print( "Lacking storage permission!" )
			return false
		end
	end

	return true 
end

-- Called when media.capturePhoto() finishes. If we get a photo back, display it.
local displayedPhoto = nil
local sessionComplete = function(event)	
	local image = event.target

	-- If we got an image back, display some information about it, and fit it
	-- to the screen.
	if ( image ) then
		print( "media.capturePhoto() returned an image!" )
		print( "event.target: ", image._properties)
		print( "Image resolution: ".. image.width .. "x" .. image.height )

		-- Delete previous photo if we've displayed one.
		if ( displayedPhoto ) then
			displayedPhoto:removeSelf()
		end
		displayedPhoto = image

		-- Center the image on the screen.
		image.x = centerX
		image.y = centerY

		-- Resize the image to fit the screen.
		local diffX, diffY = image.width - _W, image.height - _H
		local scaleFactor = 1
		if ( diffX > diffY ) then
			scaleFactor = _W / image.width
		else
			scaleFactor = _H / image.height
		end
		image:scale( scaleFactor, scaleFactor )

		-- Bring instruction text to the foreground.
		if ( displayText ) then
			displayText:toFront()
		end
	else
		print( "media.capturePhoto() was canceled." )
	end
end

-- Called when the user has granted or denied the requested permissions.
local function permissionsListener( event )
	-- Print out granted/denied permissions.
	print( "permissionsListener( " .. json.prettify( event or {} ) .. " )" )

	-- Check again for camera (and storage) access.
	-- Note that we use our helper function, canUseMediaCapturePhoto(), as the
	-- permissions listed in the event are ONLY for what has been just denied
	-- or granted.
	if ( canUseMediaCapturePhoto() ) then
		print( "Calling media.capturePhoto() from permissions listener!" )
		media.capturePhoto( { listener = sessionComplete } )
	else
		-- The user hasn't given us the required permissions.
		native.showAlert( "Corona", "Required permissions not granted.", { "OK" } )
	end
end

-- Attempt to access the camera.
-- We can't assume that the user has given us permission to use the camera.
local function tryToCapturePhoto( event )
	-- Get access to the Camera!
	local hasAccessToCamera, hasCamera = media.hasSource( media.Camera )
	if ( canUseMediaCapturePhoto() ) then
		-- If we have access to the camera, capture a photo.
		print( "Calling media.capturePhoto() from tap listener!" )
		media.capturePhoto( { listener = sessionComplete } )
	elseif ( hasCamera ) then
		-- If we don't have access to the camera, and a camera is actually available,
		-- request permission to use it, if we can.
		if ( native.canShowPopup( "requestAppPermission" ) ) then
			local permissionsToRequest = nil
			local rationaleTitleMessage = "media.capturePhoto() needs permissions!"
			local rationaleMessage = nil
			if system.getInfo( "platformName" ) == "Android" then
				-- On Android, we also need the Storage permission to use media.capturePhoto().
				permissionsToRequest = { "Camera", "Storage" }
				rationaleMessage = "Camera sample needs Camera and Storage permission to use media.capturePhoto()!"
			else
				permissionsToRequest = { "Camera" }
				rationaleMessage = "Camera sample needs the Camera permission to access the camera!"
			end

			-- Make the actual request from the user.
			native.showPopup( "requestAppPermission", {
					appPermission = permissionsToRequest,
					urgency = "Normal",
					rationaleTitle = rationaleTitleMessage,
					rationaleDescription = rationaleMessage,
					listener = permissionsListener,
				} )
		else
			-- The device has a Camera, but we can't ask for permission to use it.
			-- Tell the user to enable it in Settings.
			native.showAlert( "Corona", "A camera was found on this device, but permission to use it cannot " 
				.. "be requested. Please go to Settings and grant this app access to the Camera.", { "OK" } )
		end
	else
		-- The sample requires that we actually have a camera.
		native.showAlert( "Corona", "Camera not found.", { "OK" } )
	end

	return true
end

-- Display a warning message if the camera is not available.
do
	local hasAccessToCamera, hasCamera = media.hasSource( media.Camera )
	if ( not hasCamera ) then
		displayText.text = "Camera required for this sample"
	end
end

background:addEventListener( "tap", tryToCapturePhoto )
