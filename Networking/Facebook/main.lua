
-- Abstract: Facebook
-- Version: 2.0
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

-- Facebook Commands
local fbCommand			-- forward reference
local LOGIN = 0
local LOGOUT = 1
local SHOW_REQUEST_DIALOG = 2
local SHARE_LINK_DIALOG = 3
local POST_MSG = 4
local POST_PHOTO = 5
local GET_USER_INFO = 6
local PUBLISH_INSTALL = 7


-- Check for an item inside the provided table
-- Based on implementation at: https://www.omnimaga.org/other-computer-languages-help/(lua)-check-if-array-contains-given-value/
local function inTable( t, item )
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

	-- This displays a Facebook Dialog to requests friends to play with you
	if fbCommand == SHOW_REQUEST_DIALOG then

		response = facebook.showDialog( "requests", { 
					title = "Choose Friends to Play With",
                    message = "You should download this game!",
                })

	-- This displays a Facebook Dialog for posting a link with a photo to your Facebook Wall
	elseif fbCommand == SHARE_LINK_DIALOG then

		-- Determine what link to share
		local linkToShare = nil
		if system.getInfo( "platformName" ) == "Android" then
			linkToShare = "https://coronalabs.com/blog/2015/07/24/facebook-v4-plugin-android-beta/"
		else
			linkToShare = "https://coronalabs.com/blog/2015/09/01/facebook-v4-plugin-ios-beta-improvements-and-new-features/"
		end

		-- Create table with link data to share
		local linkData = {
			name = "Facebook v4 Corona plugin on " .. system.getInfo( "platformName" ) .. "!",
			link = linkToShare,
			description = "More Facebook awesomeness for Corona!",
			picture = "https://coronalabs.com/wp-content/uploads/2014/11/Corona-Icon.png",
		}

		response = facebook.showDialog( "link", linkData )
		

	-- Request the current logged in user's info
	elseif fbCommand == GET_USER_INFO then
		response = facebook.request( "me" )
		-- facebook.request( "me/friends" )		-- Alternate request

	-- This code posts a photo image to your Facebook Wall
	elseif fbCommand == POST_PHOTO then
		local attachment = {
			name = "Developing a Facebook app using the Corona SDK!",
			link = "http://www.coronalabs.com/links/forum",
			caption = "Link caption",
			description = "Corona SDK for developing iOS and Android apps with the same code base.",
			picture = "http://www.coronalabs.com/links/demo/Corona90x90.png",
			actions = json.encode( { { name = "Learn More", link = "http://coronalabs.com" } } )
		}
	
		response = facebook.request( "me/feed", "POST", attachment )		-- posting the photo
	
	-- This code posts a message to your Facebook Wall
	elseif fbCommand == POST_MSG then
		local time = os.date("*t")
		local postMsg = {
			message = "Posting from Corona SDK! " ..
				os.date("%A, %B %e")  .. ", " .. time.hour .. ":"
				.. time.min .. "." .. time.sec
		}
	
		response = facebook.request( "me/feed", "POST", postMsg )		-- posting the message
	end

	printTable( response )
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

			print( "Facebook Command: " .. fbCommand )

	        if ( fbCommand == GET_USER_INFO ) then
				statusMessage.text = response.name
				printTable( response )
			elseif ( fbCommand == POST_PHOTO ) then
				statusMessage.text = "Photo posted"
				printTable( response )
			elseif ( fbCommand == POST_MSG ) then
				statusMessage.text = "Message posted"
				printTable( response )
			else
				statusMessage.text = "(unknown)"
			end
        else
			statusMessage.text = "Post failed"
			printTable( event.response )
		end

	elseif ( "dialog" == event.type ) then
		statusMessage.text = event.response
    end
end


local function enforceFacebookLogin( )
	if facebook.isActive then
		local accessToken = facebook.getCurrentAccessToken()
		if accessToken == nil then

			print( "Need to log in" )
			facebook.login()

		-- Get publish_actions permission only if we're not getting user info or issuing a game request.
		elseif not inTable( accessToken.grantedPermissions, "publish_actions" ) 
			and fbCommand ~= GET_USER_INFO
			and fbCommand ~= SHOW_REQUEST_DIALOG then

			print( "Logged in, but need permissions" )
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

-- Set the FB Connect listener to use throughout the app.
facebook.setFBConnectListener( listener )

local function buttonOnRelease( event )
	local id = event.target.id

	print("buttonOnRelease: ", id)

	printTable( event )

	if id == "login" then
		fbCommand = LOGIN
		enforceFacebookLogin()
	elseif id == "postPhoto" then
		fbCommand = POST_PHOTO
		enforceFacebookLogin()
	elseif id == "postMessage" then
		fbCommand = POST_MSG
		enforceFacebookLogin()
	elseif id == "showRequestDialog" then
		fbCommand = SHOW_REQUEST_DIALOG
		enforceFacebookLogin()
	elseif id == "shareLinkDialog" then
		fbCommand = SHARE_LINK_DIALOG
		enforceFacebookLogin()
	elseif id == "getUser" then
		fbCommand = GET_USER_INFO
		enforceFacebookLogin()
	elseif id == "publishInstall" then
		fbCommand = PUBLISH_INSTALL
		facebook.publishInstall()
		statusMessage.text = "App install status posted"
	else -- Logout
		fbCommand = LOGOUT
		facebook.logout()
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
		y = 130,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.08,0.28,0.48,1 }, over={ 0.08,0.28,0.48,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease,
	})
mainGroup:insert( loginButton )

-- "Post Photo" button
local postPhotoButton = widget.newButton(
	{
		label = "Post photo",
		id = "postPhoto",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 170,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.1,0.3,0.5,1 }, over={ 0.1,0.3,0.5,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease,
	})
mainGroup:insert( postPhotoButton )

-- "Post Message" button
local postMessageButton = widget.newButton(
	{
		label = "Post message",
		id = "postMessage",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 210,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.12,0.32,0.52,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( postMessageButton )

-- "Show Request Dialog" button
local showRequestDialogButton = widget.newButton(
	{
		label = "Show request dialog",
		id = "showRequestDialog",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 250,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.14,0.34,0.54,1 }, over={ 0.14,0.34,0.54,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( showRequestDialogButton )

-- "Share Link" button
local shareLinkDialogButton = widget.newButton(
	{
		label = "Share link dialog",
		id = "shareLinkDialog",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 290,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.16,0.36,0.56,1 }, over={ 0.16,0.36,0.56,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( shareLinkDialogButton )

-- "Get User Info" button
local getInfoButton = widget.newButton(
	{
		label = "Get user",
		id = "getUser",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 330,
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
		y = 370,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.2,0.4,0.6,1 }, over={ 0.2,0.4,0.6,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( publishInstallButton )

-- "Logout" button
local logoutButton = widget.newButton(
	{
		label = "Log out",
		id = "logout",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 410,
		width = 192,
		height = 32,
		font = appFont,
		fontSize = 16,
		fillColor = { default={ 0.296,0.357,0.392,1 }, over={ 0.296,0.357,0.392,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonOnRelease
	})
mainGroup:insert( logoutButton )
