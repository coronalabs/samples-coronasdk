-- Particle Designer helper file
--
-- Modified to support baseDir and textureSubDir
-- Updated 2016.03.08

local particleDesigner = {}

local json = require "json"

particleDesigner.loadParams = function( filename, baseDir, textureSubDir )

	baseDir = baseDir or system.ResourceDirectory

	-- load file
	local path = system.pathForFile( filename, baseDir )

	local f = io.open( path, 'r' )

	local data = f:read( "*a" )
	f:close()

	-- convert json to Lua table
	local params = json.decode( data )

	if textureSubDir then
		-- Append the subdirectory to the texture file name if supplied
		params.textureFileName = textureSubDir .. params.textureFileName
	end

	return params
end

----------------------------------------------------------------------
-- New Emitter
--
-- Returns a new emitter objects
--   filename = particle data file name (with subdirectory appended)
--   baseDir = base directory for both particle data file and texture file (optional but must be nil if textureSubDir used)
--   textureSubDir = subdirectory for texture file (optional)
--
particleDesigner.newEmitter = function( filename, baseDir, textureSubDir )

	local emitterParams = particleDesigner.loadParams( filename, baseDir, textureSubDir )

	local emitter = display.newEmitter( emitterParams, baseDir )	-- for new version of "newEmitter" API

	return emitter
end

return particleDesigner
