--
-- For more information on emitter properties, see the EmitterObject documentation at:
-- https://docs.coronalabs.com/api/type/EmitterObject/index.html
--

local emitterParams = {

	-- General emitter properties
	textureFileName = "particle.png",
	maxParticles = 100,
	angle = -90,
	angleVariance = 0,
	emitterType = 0,  -- Change to 1 for radial emitter type (see below)
	duration = -1,

	-- Point/line/field emitter properties
	speed = 320,
	speedVariance = 0,
	sourcePositionVariancex = 0,
	sourcePositionVariancey = 0,
	gravityx = 0,
	gravityy = 0,
	radialAcceleration = 0,
	radialAccelVariance = 0,
	tangentialAcceleration = 0,
	tangentialAccelVariance = 0,

	-- Radial emitter properties
	maxRadius = 0,
	maxRadiusVariance = 72.00,
	minRadius = 0,
	minRadiusVariance = 0,
	rotatePerSecond = 0,
	rotatePerSecondVariance = 152.90,

	-- General particle properties
	particleLifespan = 0.8,
	particleLifespanVariance = 0,
	startParticleSize = 100,
	startParticleSizeVariance = 50,
	finishParticleSize = 20,
	finishParticleSizeVariance = 40,
	rotationStart = 0,
	rotationStartVariance = 0,
	rotationEnd = 0,
	rotationEndVariance = 0,
	
	-- Color/alpha particle properties
	startColorRed = 0.8,
	startColorGreen = 0.2,
	startColorBlue = 0.1,
	startColorAlpha = 0.8,
	startColorVarianceRed = 0,
	startColorVarianceGreen = 0,
	startColorVarianceBlue = 0,
	startColorVarianceAlpha = 0,
	finishColorRed = 0.8,
	finishColorGreen = 0.2,
	finishColorBlue = 0.1,
	finishColorAlpha = 0,
	finishColorVarianceRed = 0,
	finishColorVarianceGreen = 0,
	finishColorVarianceBlue = 0,
	finishColorVarianceAlpha = 0,
	
	-- Blend mode properties
	blendFuncSource = 770,
	blendFuncDestination = 1
}

return emitterParams
