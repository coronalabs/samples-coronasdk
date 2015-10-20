
local json = require( "json" )

local platformName = system.getInfo( "platformName" )

local presetControls = {}

local configFile
if platformName == "Android" then
	configFile = system.pathForFile( "control_presets_android.json" )
elseif platformName == "Win" then
	configFile = system.pathForFile( "control_presets_windows.json" )
elseif platformName == "Mac OS X" then
	configFile = system.pathForFile( "control_presets_osx.json" )
end


if ( configFile ) then
	local configFileHandle = io.open( configFile )
	if ( configFileHandle ) then
		local contents = configFileHandle:read("*a")
		presetControls = json.decode( contents )
		io.close(configFileHandle)

		-- Copy aliases; some devices like Xbox controllers have multiple names but the same control scheme
		for deviceName, deviceControls in pairs( presetControls ) do
			if ( deviceControls and deviceControls.aliases ) then
				for i = 1,#deviceControls.aliases do
					presetControls[deviceControls.aliases[i]] = deviceControls
				end
			end
		end
	end
end


-- Default keyboard controls when we're on the simulator or OSX
local presetControlsModule = {}

function presetControlsModule.presetForKeyboard()
	if ( presetControls.Keyboard ) then
		local ret = presetControls.Keyboard
		ret.name = "Keyboard"
		return ret
	end
end


-- Initialize controllers from presets
function presetControlsModule.presetForDevice( device )
	local productName = device.productName

	-- Find variously named Xbox controllers
	if ( not presetControls[productName] and string.find( productName, "360" ) and string.find( productName, "Microsoft" ) ) then
		productName = "Xbox Controller"
	end

	if ( presetControls[productName] ) then
		local ret = presetControls[productName]
		ret.name = device.displayName
		return ret
	end
end

return presetControlsModule
