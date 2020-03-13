
local M = {}

-- Require libraries/plugins
local oAuth = require( "oAuth" )
local json = require( "json" )

-- These are set in "main.lua" and passed in via "twitter.init()"
local consumerKey
local consumerSecret
local webURL

-- The following are returned after a successful authentication and login by the user
local access_token
local access_token_secret
local user_id
local screen_name

-- Local variables used in the tweet
local postMessage
local delegate

-- Forward references
local doTweet


-- Debug output function (useful for displaying JSON information returned from Twitter API)
local function printTable( t )

	local printTable_cache = {}

	local function sub_printTable( t, indent )

		if ( printTable_cache[tostring(t)] ) then
			print( indent .. "*" .. tostring(t) )
		else
			printTable_cache[tostring(t)] = true
			if ( type( t ) == "table" ) then
				for pos,val in pairs( t ) do
					if ( type(val) == "table" ) then
						print( indent .. "[" .. pos .. "] => " .. tostring( t ).. " {" )
						sub_printTable( val, indent .. string.rep( " ", string.len(pos)+8 ) )
						print( indent .. string.rep( " ", string.len(pos)+6 ) .. "}" )
					elseif ( type(val) == "string" ) then
						print( indent .. "[" .. pos .. '] => "' .. val .. '"' )
					else
						print( indent .. "[" .. pos .. "] => " .. tostring(val) )
					end
				end
			else
				print( indent..tostring(t) )
			end
		end
	end

	if ( type(t) == "table" ) then
		print( tostring(t) .. " {" )
		sub_printTable( t, "  " )
		print( "}" )
	else
		sub_printTable( t, "  " )
	end
end


-- Response to table (strips the token from the web address returned)
local function responseToTable( str, delimeters )

	local obj = {}

	while str:find(delimeters[1]) ~= nil do

		if #delimeters > 1 then

			local key_index = 1
			local val_index = str:find(delimeters[1])
			local key = str:sub(key_index, val_index - 1)

			str = str:sub((val_index + delimeters[1]:len()))

			local end_index
			local value

			if str:find(delimeters[2]) == nil then
				end_index = str:len()
				value = str
			else
				end_index = str:find(delimeters[2])
				value = str:sub(1, (end_index - 1))
				str = str:sub((end_index + delimeters[2]:len()), str:len())
			end
			obj[key] = value

		else
			local val_index = str:find(delimeters[1])
			str = str:sub((val_index + delimeters[1]:len()))

			local end_index
			local value

			if str:find(delimeters[1]) == nil then
				end_index = str:len()
				value = str
			else
				end_index = str:find(delimeters[1])
				value = str:sub(1, (end_index - 1))
				str = str:sub(end_index, str:len())
			end
			obj[#obj+1] = value
		end
	end
	return obj
end


-- Sends the tweet/request or authorizes if no access token exists
local function doTweet()

	local values = postMessage

	-- Callback from request
	local function doTweetCallback( status, result )

		local response = json.decode( result )
		printTable( response )

		-- Return the following: type of request, screen name, response
		delegate.twitterSuccess( values[1], screen_name, response )
	end

	-- Build the parameter table for the Twitter request
	-- values[1] = Type of request ("tweet", "users", "friends", etc.)
	-- values[2] = Twitter URL suffix
	-- values[3] = Method ("GET" or "POST")
	-- values[4] = Parameter pairs
	local params = {}
	if #values > 3 then
		for i = 4,#values do
			print( values[i][1] .. " = " .. values[i][2]  )
			params[i-3] = { key = values[i][1], value = values[i][2] }
			if params[i-3].value == "SELF" then 
				params[i-3].value = screen_name
			end
		end
	end

	-- Make the request
	oAuth.makeRequest( "https://api.twitter.com/1.1/"..values[2], params, consumerKey, access_token, consumerSecret, access_token_secret,
		values[3], doTweetCallback )
end


local function webPopupListener( event )

	local remain_open = true
	local url = event.url

	-- The URL that we are looking for contains "oauth_token" and our own URL
	-- It also has the "oauth_token_secret" and "oauth_verifier" strings
	if ( url:find( "oauth_token" ) and url:find( webURL ) ) then

		-- Callback from access token conversion
		local function accessTokenCallback( status, access_response_value )

			local access_response = responseToTable( access_response_value, {"=", "&"} )
			access_token = access_response.oauth_token
			access_token_secret = access_response.oauth_token_secret
			user_id = access_response.user_id
			screen_name = access_response.screen_name

			if not access_token then return end

			-- Send the tweet
			doTweet()
		end

		-- Executes when web popup listener starts
		url = url:sub( url:find( "?" ) + 1, url:len() )

		-- Get request token and verifier
		local authorize_response = responseToTable( url, { "=", "&" } )
		remain_open = false

		-- Convert request token to access token
		oAuth.getAccessToken( authorize_response.oauth_token, authorize_response.oauth_verifier, twitter_request_token_secret, consumerKey, consumerSecret, "https://api.twitter.com/oauth/access_token", accessTokenCallback )

	elseif url:find( webURL ) then

		-- Login was cancelled by user
		remain_open = false
		delegate.twitterCancel()
	end
	return remain_open
end


function M.tweet( del, msg )

	-- Defined at the top of the module
	postMessage = msg
	delegate = del

	-- Check to see if user is authorized to tweet
	if not access_token then

		-- Callback function for request
		local function tweetAuthCallback( status, result )

			local twitter_request_token = result:match( "oauth_token=([^&]+)" )
			local twitter_request_token_secret = result:match( "oauth_token_secret=([^&]+)" )

			-- No valid token received (abort)
			if not twitter_request_token then
				delegate.twitterFailed()
				return
			end

			-- Request authorization by displaying a web popup to access the Twitter site
			native.showWebPopup( 0, 0, 320, 480, "https://api.twitter.com/oauth/authenticate?oauth_token="..twitter_request_token, { urlRequest=webPopupListener } )
		end

		-- Exit if no API keys set (avoids crashing app)
		if not consumerKey or not consumerSecret then
			delegate.twitterFailed()
			return
		end

		-- Get temporary token by calling the routine and waiting for a response callback
		local twitter_request = oAuth.getRequestToken( consumerKey, webURL, "https://api.twitter.com/oauth/request_token", consumerSecret, tweetAuthCallback )
	else
		-- Account is already authorized, just tweet
		doTweet()
	end
end


function M.init( key, secret, URL )
	consumerKey = key
	consumerSecret = secret
	webURL = URL
end

return M
