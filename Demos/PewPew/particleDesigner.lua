local particleDesigner = {}

local json = require "json"

particleDesigner.loadParams = function( filename, baseDir )

	-- load file
	local path = system.pathForFile( filename, baseDir )

	local f = io.open( path, 'r' )

	local data = f:read( "*a" )
	f:close()

	-- convert json to Lua table
	local params = json.decode( data )

	return params
end

particleDesigner.newEmitter = function( filename, baseDir )

	local emitterParams = particleDesigner.loadParams( filename, baseDir )

	local emitter = display.newEmitter( emitterParams )

	return emitter
end

return particleDesigner
