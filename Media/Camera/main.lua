-- 
-- Abstract: Camera sample app
-- 
-- Version: 1.3
-- 
-- Updated: February 1, 2016
--
-- Update History:
-- 	v1.1	Fixed logic problem where it said "session was cancelled".
--	v1.2	Added Android support.
--	v1.3	Added support for runtime permission model.
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.]
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local json = require('json')

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

-- Camera not supported on simulator.                    
local isXcodeSimulator = "iPhone Simulator" == system.getInfo("model")
if (isXcodeSimulator) then
	 local alert = native.showAlert( "Information", "Camera API not available on iOS Simulator.", { "OK" } )    
end

--
local bkgd = display.newRect( centerX, centerY, _W, _H )
bkgd:setFillColor( 0.5, 0, 0 )

local text = display.newText( "Tap anywhere to launch Camera", centerX, centerY, nil, 16 )

local function printTable( t, label, level )
	if label then print( label ) end
	level = level or 1

	if t then
		for k,v in pairs( t ) do
			local prefix = ""
			for i=1,level do
				prefix = prefix .. "\t"
			end

			print( prefix .. "[" .. tostring(k) .. "] = " .. tostring(v) )
			if type( v ) == "table" then
				print( prefix .. "{" )
				printTable( v, nil, level + 1 )
				print( prefix .. "}" )
			end
		end
	end
end

local sessionComplete = function(event)	
	local image = event.target

	print( "Camera ", ( image and "returned an image" ) or "session was cancelled" )
	print( "event name: " .. event.name )
	if image then
		print( "target: ", image._properties)
	else
		print( "event.target was nil" )
	end

	if image then
		-- center image on screen
		image.x = centerX
		image.y = centerY
		local w = image.width
		local h = image.height
		print( "w,h = ".. w .."," .. h )
	end
end

local tryToAccessCamera = nil
local justRequestedPermissions = false

local function permissionsListener( event )
	print( "In permissionsListener" )
	print( "Granted App Permissions: " )
	printTable(event.grantedAppPermissions)
	print( "Denied App Permissions: " )
	printTable(event.deniedAppPermissions)

	justRequestedPermissions = true
	tryToAccessCamera()
end

tryToAccessCamera = function()
	-- Get access to the Camera!
	local hasAccessToCamera, hasCamera = media.hasSource( media.Camera )
	if hasAccessToCamera then
		print( "Calling media.capturePhoto() from tap listener!" )
		media.capturePhoto( { listener = sessionComplete } )
	elseif hasCamera and native.canShowPopup( "requestAppPermission" ) and not justRequestedPermissions then
		-- On Android, we also need Storage permission to use media.capturePhoto().
		local permissionsToRequest = nil
		local rationaleTitleMessage = "media.capturePhoto() needs permissions!"
		local rationaleMessage = nil
		if system.getInfo( "platformName" ) == "Android" then
			permissionsToRequest = { "Camera", "Storage" }
			rationaleMessage = "Camera sample needs Camera and Storage permission to use media.capturePhoto()!"
		else
			permissionsToRequest = { "Camera" }
			rationaleMessage = "Camera sample needs the Camera permission to access the camera!"
		end

		native.showPopup("requestAppPermission", {
				appPermission = permissionsToRequest,
				urgency = "Normal",
				rationaleTitle = rationaleTitleMessage,
				rationaleDescription = rationaleMessage,
				listener = permissionsListener,
			})
	elseif justRequestedPermissions then
		justRequestedPermissions = false
	else
		native.showAlert( "Corona", "Camera not found." )
	end
end


local tapListener = function( event )

	-- See the current status of app permissions.
	print( "Granted app permissions:" )
	local grantedAppPermissions = system.getInfo( "grantedAppPermissions" )
	printTable(grantedAppPermissions)
	print( "Denied app permissions: ")
	local deniedAppPermissions = system.getInfo( "deniedAppPermissions" )
	printTable(deniedAppPermissions)

	tryToAccessCamera()

	return true
end
bkgd:addEventListener( "tap", tapListener )
