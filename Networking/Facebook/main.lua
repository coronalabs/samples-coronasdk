
-- Abstract: Facebook
-- Version: 2.1
-- 
-- Update History:
--  v1.1		Layout adapted for Android/iPad/iPhone4
--  v1.2		Modified for new Facebook Connect API (from build #243)
--  v1.3		Added buttons to: Post Message, Post Photo, Show Dialog, Logout
--  v1.4		Added  ...{"publish_stream"} .. permissions setting to facebook.login() calls.
--  v1.5		Added single sign-on support in build.settings (must replace XXXXXXXXX with valid facebook appId)
--  v1.6		Modified the build.settings file to get the plugin for iOS.
--  v1.7		Added more buttons to test features. Upgraded sample to use Facebook v4 plugin.
--  v1.8		Uses new login model introduced in Facebook v4 plugin.
--  v2.0		Code cleanup and improvement. New interface
--  v2.1		Added more buttons to test new Facebook APIs introduced in stable release of Facebook v4, bugfixes, and code cleanup.
--
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Facebook", showBuildNum=true } )

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
local facebook = require( "plugin.facebook.v4" )

-- Set app font
local appFont = sampleUI.appFont

local debugOutput = true  -- Set true to enable console print output

-- Create status text objects
local statusHeader = display.newText( mainGroup, "Status", display.contentCenterX, 45, appFont, 20 )
local statusMessage = display.newText( mainGroup, "Not connected", display.contentCenterX, 70, appFont, 18 )
statusMessage:setFillColor( 0.7 )

-- State variables for facebook commands we're executing
local requestedFBCommand
local commandProcessedByFB

-- Facebook Commands
local LOGIN = 0
local POST_MSG = 1
local POST_LINK = 2
local POST_PHOTO = 3
local SHOW_REQUEST_DIALOG = 4
local SHARE_LINK_DIALOG = 5
local SHARE_PHOTO_DIALOG = 6
local GET_USER_INFO = 7
local PUBLISH_INSTALL = 8
local IS_FACEBOOK_APP_ENABLED = 9
local LOGOUT = 10


-- Check for an item inside the provided table
-- Based on implementation at: https://www.omnimaga.org/other-computer-languages-help/(lua)-check-if-array-contains-given-value/
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


-- Runs the desired facebook command
local function processFBCommand( )

	local response = {}

	-- This code posts a message to your Facebook Wall
	if requestedFBCommand == POST_MSG then
		local time = os.date("*t")
		local postMsg = {
			message = "Posting from Corona SDK! " ..
				os.date("%A, %B %e")  .. ", " .. time.hour .. ":"
				.. time.min .. "." .. time.sec
		}
	
		response = facebook.request( "me/feed", "POST", postMsg )		-- posting the message

	-- This code posts a link to your Facebook Wall with a message about it
	elseif requestedFBCommand == POST_LINK then
		local attachment = {
			name = "Developing a Facebook app using the Corona SDK!",
			link = "http://www.coronalabs.com/links/forum",
			caption = "Link caption",
			description = "Corona SDK for developing iOS and Android apps with the same code base.",
			picture = "http://www.coronalabs.com/links/demo/Corona90x90.png",
			message = "Corona is awesome! Check it out!",
		}
	
		response = facebook.request( "me/feed", "POST", attachment )		-- posting the photo

	-- This code posts a photo from the Internet to your Facebook Wall
	elseif requestedFBCommand == POST_PHOTO then
		local attachment = {
			caption = "Photo Caption",
			url = "http://www.coronalabs.com/links/demo/Corona90x90.png",
		}
	
		response = facebook.request( "me/photos", "POST", attachment )		-- posting the photo

	-- This displays a Facebook Dialog to requests friends to play with you
	elseif requestedFBCommand == SHOW_REQUEST_DIALOG then

		response = facebook.showDialog( "requests", { 
					title = "Choose Friends to Play With",
                    message = "You should download this game!",
                })

	-- This displays a Facebook Dialog for posting a link with a photo to your Facebook Wall
	elseif requestedFBCommand == SHARE_LINK_DIALOG then

		-- Create table with link data to share
		local linkData = {
			name = "Facebook Corona plugin on " .. system.getInfo( "platformName" ) .. "!",
			link = "https://coronalabs.com/blog/2016/10/28/facebook-plugin-update-we-are-out-of-beta/",
			description = "More Facebook awesomeness for Corona!",
			picture = "https://coronalabs.com/wp-content/uploads/2014/11/Corona-Icon.png",
		}

		response = facebook.showDialog( "link", linkData )

	-- This displays a Facebook Dialog for posting photos to your photo album.
	elseif requestedFBCommand == SHARE_PHOTO_DIALOG then

		-- Create table with photo data to share
		local photoData = {
			photos = {
				{ url = "https://coronalabs.com/wp-content/uploads/2014/11/Corona-Icon.png", },
				{ url = "https://www.coronalabs.com/links/demo/Corona90x90.png", },
			},
		}

		response = facebook.showDialog( "photo", photoData )		

	-- Request the current logged in user's info
	elseif requestedFBCommand == GET_USER_INFO then
		response = facebook.request( "me" )
		-- facebook.request( "me/friends" )		-- Alternate request
	end

	printTable( response )
end


local function needPublishActionsPermission( )
	return requestedFBCommand ~= LOGIN
		and requestedFBCommand ~= SHOW_REQUEST_DIALOG
		and requestedFBCommand ~= GET_USER_INFO
		and requestedFBCommand ~= PUBLISH_INSTALL
		and requestedFBCommand ~= IS_FACEBOOK_APP_ENABLED
		and requestedFBCommand ~= LOGOUT
end


local function enforceFacebookLoginAndPermissions( )
	if facebook.isActive then
		local accessToken = facebook.getCurrentAccessToken()
		if accessToken == nil then

			print( "Need to log in" )
			facebook.login()

		-- Get publish_actions permission only if we're not getting user info or issuing a game request.
		elseif needPublishActionsPermission() and not valueInTable( accessToken.grantedPermissions, "publish_actions" ) then

			print( "Logged in, but need publish_actions permission" )
			printTable( accessToken )
			facebook.login( { "publish_actions" } )

		else

			print( "Already logged in with needed permissions" )
			printTable( accessToken )
			statusMessage.text = "Already logged in"
			processFBCommand()

		end
	else
		print( "Please wait for facebook to finish initializing before checking the current access token" );
	end
end


-- New Facebook Connection listener
local function listener( event )

	-- Debug Event parameters printout --------------------------------------------------
	-- Prints Events received up to 20 characters. Prints "..." and total count if longer
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
	-- End of debug Event routine -------------------------------------------------------

    print( "event.name", event.name ) -- "fbconnect"
    print( "event.type:", event.type ) -- type is either "session" or "request" or "dialog"
	print( "isError: " .. tostring( event.isError ) )
	print( "didComplete: " .. tostring( event.didComplete ) )
	print( "response: " .. tostring( event.response ) )
	
	-----------------------------------------------------------------------------------------
	-- Process the response to the FB command
	-- Note: If the app is already logged in, we will still get a "login" phase
	-----------------------------------------------------------------------------------------
    if ( "session" == event.type ) then

		statusMessage.text = event.phase  -- "login", "loginFailed", "loginCancelled", or "logout"

		print( "Session Status: " .. event.phase )
		
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

			-- Advance the facebook command state as this command has been processed by Facebook.
			commandProcessedByFB = requestedFBCommand

			print( "Facebook Command: " .. commandProcessedByFB )

			if ( commandProcessedByFB == POST_MSG ) then
				statusMessage.text = "Message posted"
				printTable( response )
			elseif ( commandProcessedByFB == POST_LINK ) then
				statusMessage.text = "Link posted"
				printTable( response )
			elseif ( commandProcessedByFB == POST_PHOTO ) then
				statusMessage.text = "Photo posted"
				printTable( response )
			elseif ( commandProcessedByFB == GET_USER_INFO ) then
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
		-- Advance the facebook command state as this command has been processed by Facebook.
		commandProcessedByFB = requestedFBCommand

		statusMessage.text = event.response
    end
end


-- Set the FB Connect listener to use throughout the app.
facebook.setFBConnectListener( listener )


local function buttonOnRelease( event )
	local id = event.target.id

	print("buttonOnRelease: ", id)

	printTable( event )

	if id == "login" then
		requestedFBCommand = LOGIN
		enforceFacebookLoginAndPermissions()
	elseif id == "postMessage" then
		requestedFBCommand = POST_MSG
		enforceFacebookLoginAndPermissions()
	elseif id == "postLink" then
		requestedFBCommand = POST_LINK
		enforceFacebookLoginAndPermissions()
	elseif id == "postPhoto" then
		requestedFBCommand = POST_PHOTO
		enforceFacebookLoginAndPermissions()
	elseif id == "showRequestDialog" then
		requestedFBCommand = SHOW_REQUEST_DIALOG
		enforceFacebookLoginAndPermissions()
	elseif id == "shareLinkDialog" then
		requestedFBCommand = SHARE_LINK_DIALOG
		enforceFacebookLoginAndPermissions()
	elseif id == "sharePhotoDialog" then
		requestedFBCommand = SHARE_PHOTO_DIALOG
		-- This can only be done if the Facebook app in installed, so verify that first.
		if not facebook.isFacebookAppEnabled() then
			statusMessage.text = "Need Facebook app to share photos."
			commandProcessedByFB = requestedFBCommand
		else
			-- Now enforce the state of our connection with Facebook to run this command.
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
		statusMessage.text = "Is Facebook App Enabled? " .. tostring(facebook.isFacebookAppEnabled())
		commandProcessedByFB = requestedFBCommand
	else -- Logout
		requestedFBCommand = LOGOUT
		facebook.logout()
		commandProcessedByFB = requestedFBCommand
	end
	return true
end


-- "Login" button
local loginButton = widget.newButton(
	{
		label = "Login",
		id = "login",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 115,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.08,0.28,0.48,1 }, over={ 0.08,0.28,0.48,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease,
	})
mainGroup:insert( loginButton )

-- "Post Message" button
local postMessageButton = widget.newButton(
	{
		label = "Post message",
		id = "postMessage",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 155,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.1,0.3,0.5,1 }, over={ 0.1,0.3,0.5,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease,
	})
mainGroup:insert( postMessageButton )

-- "Post Link" button
local postLinkButton = widget.newButton(
	{
		label = "Post link",
		id = "postLink",
		shape = "rectangle",
		x = display.contentCenterX / 2,
		y = 195,
		width = 144,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.12,0.32,0.52,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( postLinkButton )

-- "Share Link dialog" button
local shareLinkDialogButton = widget.newButton(
	{
		label = "Share link dialog",
		id = "shareLinkDialog",
		shape = "rectangle",
		x = display.contentWidth - (display.contentCenterX / 2),
		y = 195,
		width = 144,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.12,0.32,0.52,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( shareLinkDialogButton )

-- "Post Photo" button
local postPhotoButton = widget.newButton(
	{
		label = "Post photo",
		id = "postPhoto",
		shape = "rectangle",
		x = display.contentCenterX / 2,
		y = 235,
		width = 144,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.14,0.34,0.54,1 }, over={ 0.14,0.34,0.54,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( postPhotoButton )

-- "Share Photo dialog" button
local sharePhotoDialogButton = widget.newButton(
	{
		label = "Share photo dialog",
		id = "sharePhotoDialog",
		shape = "rectangle",
		x = display.contentWidth - (display.contentCenterX / 2),
		y = 235,
		width = 144,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.14,0.34,0.54,1 }, over={ 0.14,0.34,0.54,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( sharePhotoDialogButton )

-- "Show Request Dialog" button
local shareRequestDialogButton = widget.newButton(
	{
		label = "Show request dialog",
		id = "showRequestDialog",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 275,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.16,0.36,0.56,1 }, over={ 0.16,0.36,0.56,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( shareRequestDialogButton )

-- "Get User Info" button
local getInfoButton = widget.newButton(
	{
		label = "Get user",
		id = "getUser",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 315,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.18,0.38,0.58,1 }, over={ 0.18,0.38,0.58,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( getInfoButton )

-- "Publish Install" button
local publishInstallButton = widget.newButton(
	{
		label = "Publish install",
		id = "publishInstall",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 355,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.2,0.4,0.6,1 }, over={ 0.2,0.4,0.6,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( publishInstallButton )

-- "Is Facebook App Enabled" button
local isFacebookAppEnabledButton = widget.newButton(
	{
		label = "Facebook App Enabled?",
		id = "isFacebookAppEnabled",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 395,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.22,0.42,0.62,1 }, over={ 0.22,0.42,0.62,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( isFacebookAppEnabledButton )

-- "Logout" button
local logoutButton = widget.newButton(
	{
		label = "Log out",
		id = "logout",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 435,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.296,0.357,0.392,1 }, over={ 0.296,0.357,0.392,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( logoutButton )
