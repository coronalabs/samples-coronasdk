
local json = require("json")

local presetControls = {}
local configFile = system.pathForFile( "control_presets.json" )
if ( configFile ) then
	local configFileHandle = io.open( configFile )
	if ( configFileHandle ) then
		local contents = configFileHandle:read("*a")
		presetControls = json.decode(contents)
		io.close(configFileHandle)

		-- Copy aliases. Some devices, like xbox controllers, have multiple names but the same control scheme.
		for deviceName, deviceControls in pairs( presetControls ) do
			if ( deviceControls and deviceControls.aliases ) then
				for i = 1, #deviceControls.aliases do
					presetControls[deviceControls.aliases[i]] = deviceControls
				end
			end
		end
	end
end

-- Default keyboard controls when we're on the simulator or OSX.
local presetControlsModule = {}

function presetControlsModule.presetForKeyboard( )
	if ( presetControls.Keyboard ) then
		local ret = presetControls.Keyboard
		ret.name = "Keyboard"
		return ret
	end
end

-- Initialize controllers from presets.
function presetControlsModule.presetForDevice( device )
	print( device.displayName )
	if ( "joystick" == device.type ) then
		local name = device.displayName

		-- Find variously named xbox controllers.
		if ( not presetControls[name] and string.find( name, "360" ) and string.find( name, "Microsoft" ) ) then
			name = "Xbox Controller"
		end

		if ( presetControls[name] ) then
			local ret = presetControls[name]
			ret.name = device.displayName
			return ret
		end
	end
end


return presetControlsModule
