
-- Abstract: Facebook
-- Version: 2.1
-- Sample code is MIT licensed; see https://solar2d.com/LICENSE.txt
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Facebook", showBuildNum=false } )

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
local json = require( "json" )
local widget = require( "widget" )
local facebook = require( "plugin.facebook.v4a" )

-- Set app font
local appFont = sampleUI.appFont

local debugOutput = true  -- Set true to enable console print output

-- Create status text objects
local statusHeader = display.newText( mainGroup, "Status", display.contentCenterX, 50, appFont, 20 )
local statusMessage = display.newText( mainGroup, "(not connected)", display.contentCenterX, 75, appFont, 16 )
statusMessage:setFillColor( 0.7 )

-- State variables for Facebook commands we're executing
local requestedFBCommand
local commandProcessedByFB

-- Facebook commands
local LOGIN = 0
local SHOW_REQUEST_DIALOG = 1
local SHARE_LINK_DIALOG = 2
local SHARE_PHOTO_DIALOG = 3
local GET_USER_INFO = 4
local PUBLISH_INSTALL = 5
local IS_FACEBOOK_APP_ENABLED = 6
local LOGOUT = 7


-- Check for an item inside the provided table
local function valueInTable( t, item )
	for k,v in pairs( t ) do
		if v == item then
			return true
		end
	end
	return false
end


-- Table printing function for Facebook debugging
local function printTable( t )
	print("Printing table", debugOutput )
	if type( t ) ~= "table" then
		print("WARNING: attempt to print a non-table. Table expected, got " .. type( t ) )
		return
	end
	if ( debugOutput == false ) then 
		return 
	end
	print("--------------------------------")
	print( json.prettify( t ) )
end


-- Runs the desired Facebook command
local function processFBCommand()

	local response = {}

	-- This displays a Facebook dialog to requests friends to play with you
	if requestedFBCommand == SHOW_REQUEST_DIALOG then
		response = facebook.showDialog( "requests", { 
			title = "Choose Friends to Play With",
			message = "You should download this game!",
		})

	-- This displays a Facebook dialog for posting a link with a photo
	elseif requestedFBCommand == SHARE_LINK_DIALOG then
		-- Create table with link data to share
		local linkData = {
			name = "Facebook plugin for Solar2D",
			link = "https://docs.coronalabs.com/guide/social/usingFacebook/index.html",
			description = "More Facebook awesomeness for Solar2D!",
			picture = "https://solar2d.com/images/logo.png",
		}
		response = facebook.showDialog( "link", linkData )

	-- This displays a Facebook dialog for posting photos to your photo album
	elseif requestedFBCommand == SHARE_PHOTO_DIALOG then
		-- Create table with photo data to share
		local photoData = {
			photos = {
				{ url = "https://solar2d.com/images/logo.png", },
			},
		}
		response = facebook.showDialog( "photo", photoData )		

	-- Request the current logged in user's info
	elseif requestedFBCommand == GET_USER_INFO then
		response = facebook.request( "me" )
		-- facebook.request( "me/friends" )  -- Alternate request
	end

	printTable( response )
end

local function enforceFacebookLoginAndPermissions()
	if facebook.isActive then
		local accessToken = facebook.getCurrentAccessToken()
		if accessToken == nil then
			print( "Need to log in!" )
			facebook.login()
		else
			print( "Already logged in with necessary permissions" )
			printTable( accessToken )
			statusMessage.text = "Logged in"
			processFBCommand()
		end
	else
		print( "Please wait for facebook to finish initializing before checking the current access token" );
	end
end


-- New Facebook Connection listener
local function listener( event )

	-- Debug event parameters output
	-- Prints events received up to 20 characters. Prints "..." and total count if longer
	print( "Facebook Listener events:" )
	
	local maxStr = 20		-- set maximum string length
	local endStr
	
	for k,v in pairs( event ) do
		local valueString = tostring(v)
		if string.len(valueString) > maxStr then
			endStr = " ... #" .. tostring(string.len(valueString)) .. ")"
		else
			endStr = ")"
		end
		print( "   " .. tostring( k ) .. "(" .. tostring( string.sub(valueString, 1, maxStr ) ) .. endStr )
	end
	-- End of debug event routine

	print( "event.name", event.name )  -- "fbconnect"
	print( "event.type:", event.type )  -- Type is either "session", "request", or "dialog"
	print( "isError: " .. tostring( event.isError ) )
	print( "didComplete: " .. tostring( event.didComplete ) )
	print( "response: " .. tostring( event.response ) )
	
	-- Process the response to the Facebook command
	-- Note that if the app is already logged in, we will still get a "login" phase
    if ( "session" == event.type ) then

		statusMessage.text = event.phase  -- "login", "loginFailed", "loginCancelled", or "logout"
		print( "Session status: " .. event.phase )

		if ( event.phase ~= "login" ) then
			-- Exit if login error
			return
		else
			-- Run the desired command
			processFBCommand()
		end

    elseif ( "request" == event.type ) then

        local response = event.response  -- This is a JSON object from the Facebook server

		if ( not event.isError ) then
	        response = json.decode( event.response )

			-- Advance the Facebook command state as this command has been processed by Facebook
			commandProcessedByFB = requestedFBCommand

			print( "Facebook Command: " .. commandProcessedByFB )

			if ( commandProcessedByFB == GET_USER_INFO ) then
				statusMessage.text = response.name
				printTable( response )
			else
				statusMessage.text = "(unknown)"
			end
        elseif tostring( event.response ) == "Duplicate status message" then
        	statusMessage.text = "Caught duplicate status message!"
			printTable( event.response )
        else
			statusMessage.text = "Post failed"
			printTable( event.response )
		end

	elseif ( "dialog" == event.type ) then
		-- Advance the Facebook command state as this command has been processed by Facebook
		commandProcessedByFB = requestedFBCommand

		statusMessage.text = event.response
    end
end

facebook.init(listener)

local function buttonOnRelease( event )

	local id = event.target.id
	printTable( event )

	if id == "login" then
		requestedFBCommand = LOGIN
		enforceFacebookLoginAndPermissions()
	elseif id == "showRequestDialog" then
		requestedFBCommand = SHOW_REQUEST_DIALOG
		enforceFacebookLoginAndPermissions()
	elseif id == "shareLinkDialog" then
		requestedFBCommand = SHARE_LINK_DIALOG
		enforceFacebookLoginAndPermissions()
	elseif id == "sharePhotoDialog" then
		requestedFBCommand = SHARE_PHOTO_DIALOG
		-- This can only be done if the Facebook app in installed, so verify that first
		if not facebook.isFacebookAppEnabled() then
			statusMessage.text = "Facebook app needed to share photos"
			commandProcessedByFB = requestedFBCommand
		else
			-- Now enforce the state of our connection with Facebook to run this command
			enforceFacebookLoginAndPermissions()
		end
	elseif id == "getUser" then
		requestedFBCommand = GET_USER_INFO
		enforceFacebookLoginAndPermissions()
	elseif id == "publishInstall" then
		requestedFBCommand = PUBLISH_INSTALL
		facebook.publishInstall()
		statusMessage.text = "App install status posted"
		commandProcessedByFB = requestedFBCommand
	elseif id == "isFacebookAppEnabled" then
		requestedFBCommand = IS_FACEBOOK_APP_ENABLED
		statusMessage.text = "Facebook app enabled: " .. tostring(facebook.isFacebookAppEnabled())
		commandProcessedByFB = requestedFBCommand
	else  -- Logout
		requestedFBCommand = LOGOUT
		facebook.logout()
		commandProcessedByFB = requestedFBCommand
	end
	return true
end

-- Login button
local loginButton = widget.newButton(
	{
		label = "Login",
		id = "login",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 115,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.08,0.28,0.48,1 }, over={ 0.08,0.28,0.48,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease,
	})
mainGroup:insert( loginButton )


-- Share link dialog button
local shareLinkDialogButton = widget.newButton(
	{
		label = "Share link dialog",
		id = "shareLinkDialog",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 155,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.12,0.32,0.52,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( shareLinkDialogButton )

-- Share photo dialog button
local sharePhotoDialogButton = widget.newButton(
	{
		label = "Share photo dialog",
		id = "sharePhotoDialog",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 195,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.14,0.34,0.54,1 }, over={ 0.14,0.34,0.54,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( sharePhotoDialogButton )

-- Show request dialog button
local shareRequestDialogButton = widget.newButton(
	{
		label = "Show request dialog",
		id = "showRequestDialog",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 235,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.16,0.36,0.56,1 }, over={ 0.16,0.36,0.56,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( shareRequestDialogButton )

-- Get user info button
local getInfoButton = widget.newButton(
	{
		label = "Get user",
		id = "getUser",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 275,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.18,0.38,0.58,1 }, over={ 0.18,0.38,0.58,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( getInfoButton )

-- Publish install button
local publishInstallButton = widget.newButton(
	{
		label = "Publish install",
		id = "publishInstall",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 315,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.2,0.4,0.6,1 }, over={ 0.2,0.4,0.6,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( publishInstallButton )

-- Facebook app enabled button
local isFacebookAppEnabledButton = widget.newButton(
	{
		label = "Facebook app enabled?",
		id = "isFacebookAppEnabled",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 355,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.22,0.42,0.62,1 }, over={ 0.22,0.42,0.62,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( isFacebookAppEnabledButton )

-- Log out button
local logoutButton = widget.newButton(
	{
		label = "Log out",
		id = "logout",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 395,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.296,0.357,0.392,1 }, over={ 0.296,0.357,0.392,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( logoutButton )
