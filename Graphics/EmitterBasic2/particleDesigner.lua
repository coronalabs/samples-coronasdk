local particleDesigner = {}

particleDesigner.endswith = function( str, ending )

	return ending=='' or string.sub(str,-string.len(ending))==ending

end

particleDesigner.loadFileContent = function( filename, baseDir )

	local path = system.pathForFile( filename, baseDir )

	local f = io.open( path, 'r' )

	local data = f:read( "*a" )
	f:close()

	return data

end

particleDesigner.findFirst = function( node, name_to_find )

	for _,n in ipairs( node.kids ) do

		if( ( n.type == "element" ) and
			( n.name == name_to_find ) ) then

			return n.attr

		end

	end

	return nil
end

particleDesigner.findBoolean = function( elements, element_name, attribute_name )

	local found = particleDesigner.findFirst( elements, element_name )
	if found then
		return ( found[ attribute_name ] == "1" )
	else
		return false
	end

end

particleDesigner.findNumber = function( elements, element_name, attribute_name )

	local found = particleDesigner.findFirst( elements, element_name )
	if found then
		return tonumber( found[ attribute_name ] )
	else
		return 0
	end

end

particleDesigner.findString = function( elements, element_name, attribute_name )

	local found = particleDesigner.findFirst( elements, element_name )
	if found then
		return found[ attribute_name ]
	else
		return ""
	end

end

particleDesigner.getBoolean = function( element, attribute_name )

	if element then
		return ( element[ attribute_name ] == "1" )
	else
		return false
	end

end

particleDesigner.getNumber = function( element, attribute_name )

	if element then
		return tonumber( element[ attribute_name ] )
	else
		return 0
	end

end

particleDesigner.getString = function( element, attribute_name )

	if element then
		return element[ attribute_name ]
	else
		return ""
	end

end

particleDesigner.loadPexParams = function( filename, baseDir )

	-- load file
	local data = particleDesigner.loadFileContent( filename, baseDir )

	local SLAXML = require "slaxdom"
	local params = {}

	local elements = SLAXML:dom( data ).root

	params.absolutePosition = particleDesigner.findBoolean( elements, "absolutePosition", "value" )

	local gravity_node = particleDesigner.findFirst( elements, "gravity" )
	params.gravityx = particleDesigner.getNumber( gravity_node, "x" )
	params.gravityy = particleDesigner.getNumber( gravity_node, "y" )

	local startColor_node = particleDesigner.findFirst( elements, "startColor" )
	params.startColorRed = particleDesigner.getNumber( startColor_node, "red" )
	params.startColorGreen = particleDesigner.getNumber( startColor_node, "green" )
	params.startColorBlue = particleDesigner.getNumber( startColor_node, "blue" )
	params.startColorAlpha = particleDesigner.getNumber( startColor_node, "alpha" )

	local startColorVariance_node = particleDesigner.findFirst( elements, "startColorVariance" )
	params.startColorVarianceRed = particleDesigner.getNumber( startColorVariance_node, "red" )
	params.startColorVarianceGreen = particleDesigner.getNumber( startColorVariance_node, "green" )
	params.startColorVarianceBlue = particleDesigner.getNumber( startColorVariance_node, "blue" )
	params.startColorVarianceAlpha = particleDesigner.getNumber( startColorVariance_node, "alpha" )

	local finishColor_node = particleDesigner.findFirst( elements, "finishColor" )
	params.finishColorRed = particleDesigner.getNumber( finishColor_node, "red" )
	params.finishColorGreen = particleDesigner.getNumber( finishColor_node, "green" )
	params.finishColorBlue = particleDesigner.getNumber( finishColor_node, "blue" )
	params.finishColorAlpha = particleDesigner.getNumber( finishColor_node, "alpha" )

	local finishColorVariance_node = particleDesigner.findFirst( elements, "finishColorVariance" )
	params.finishColorVarianceRed = particleDesigner.getNumber( finishColorVariance_node, "red" )
	params.finishColorVarianceGreen = particleDesigner.getNumber( finishColorVariance_node, "green" )
	params.finishColorVarianceBlue = particleDesigner.getNumber( finishColorVariance_node, "blue" )
	params.finishColorVarianceAlpha = particleDesigner.getNumber( finishColorVariance_node, "alpha" )

	params.startParticleSize = particleDesigner.findNumber( elements, "startParticleSize", "value" )
	params.startParticleSizeVariance = particleDesigner.findNumber( elements, "startParticleSizeVariance", "value" )
	params.finishParticleSize = particleDesigner.findNumber( elements, "finishParticleSize", "value" )
	params.finishParticleSizeVariance = particleDesigner.findNumber( elements, "finishParticleSizeVariance", "value" )

	params.maxRadius = particleDesigner.findNumber( elements, "maxRadius", "value" )
	params.maxRadiusVariance = particleDesigner.findNumber( elements, "maxRadiusVariance", "value" )
	params.minRadius = particleDesigner.findNumber( elements, "minRadius", "value" )
	params.minRadiusVariance = particleDesigner.findNumber( elements, "minRadiusVariance", "value" )
	params.rotatePerSecond = particleDesigner.findNumber( elements, "rotatePerSecond", "value" )
	params.rotatePerSecondVariance = particleDesigner.findNumber( elements, "rotatePerSecondVariance", "value" )
	params.rotationStart = particleDesigner.findNumber( elements, "rotationStart", "value" )
	params.rotationStartVariance = particleDesigner.findNumber( elements, "rotationStartVariance", "value" )
	params.rotationEndVariance = particleDesigner.findNumber( elements, "rotationEndVariance", "value" )
	params.rotationEnd = particleDesigner.findNumber( elements, "rotationEnd", "value" )
	params.emitterType = particleDesigner.findNumber( elements, "emitterType", "value" )

	local sourcePositionVariance_node = particleDesigner.findFirst( elements, "sourcePositionVariance" )
	params.sourcePositionVariancex = particleDesigner.getNumber( sourcePositionVariance_node, "x" )
	params.sourcePositionVariancey = particleDesigner.getNumber( sourcePositionVariance_node, "y" )

	params.speed = particleDesigner.findNumber( elements, "speed", "value" )
	params.speedVariance = particleDesigner.findNumber( elements, "speedVariance", "value" )

	-- Yes, from "particleLifeSpan" (uppercase "S"), to "particleLifespan" (lowercase "s").
	params.particleLifespan = particleDesigner.findNumber( elements, "particleLifeSpan", "value" )
	params.particleLifespanVariance = particleDesigner.findNumber( elements, "particleLifespanVariance", "value" )
	params.angle = particleDesigner.findNumber( elements, "angle", "value" )
	params.angleVariance = particleDesigner.findNumber( elements, "angleVariance", "value" )

	params.radialAcceleration = particleDesigner.findNumber( elements, "radialAcceleration", "value" )
	params.radialAccelVariance = particleDesigner.findNumber( elements, "radialAccelVariance", "value" )
	params.tangentialAcceleration = particleDesigner.findNumber( elements, "tangentialAcceleration", "value" )
	params.tangentialAccelVariance = particleDesigner.findNumber( elements, "tangentialAccelVariance", "value" )

	params.maxParticles = particleDesigner.findNumber( elements, "maxParticles", "value" )
	params.duration = particleDesigner.findNumber( elements, "duration", "value" )

	params.blendFuncSource = particleDesigner.findNumber( elements, "blendFuncSource", "value" )
	params.blendFuncDestination = particleDesigner.findNumber( elements, "blendFuncDestination", "value" )

	params.textureFileName = particleDesigner.findString( elements, "texture", "name" )

	return params
end

particleDesigner.loadJsonParams = function( filename, baseDir )

	-- load file
	local data = particleDesigner.loadFileContent( filename, baseDir )

	-- convert json to Lua table
	local json = require "json"
	local params = json.decode( data )

	return params

end

particleDesigner.loadParams = function( filename, baseDir )

	local lower_case_filename = string.lower( filename )

	if particleDesigner.endswith( lower_case_filename, ".json" ) then

		return particleDesigner.loadJsonParams( filename, baseDir )

	elseif particleDesigner.endswith( lower_case_filename, ".pex" ) then

		return particleDesigner.loadPexParams( filename, baseDir )

	else

		print( "Unrecognized particle file type for filename: " .. tostring( filename ) )
		return nil

	end

end

particleDesigner.newEmitter = function( filename, baseDir )

	local emitterParams = particleDesigner.loadParams( filename, baseDir )

	local emitter = display.newEmitter( emitterParams )

	return emitter
end

return particleDesigner
