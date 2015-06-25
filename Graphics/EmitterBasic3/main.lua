--
-- Abstract: Particle Emitter Sample App
--
-- Version: 1.0
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2014 Corona Labs Inc. All Rights Reserved.
------------------------------------------------------------

local particleDesigner = require( "particleDesigner" )

local emitter = particleDesigner.newEmitter( "fire.json" )
emitter.x = display.contentWidth / 2
emitter.y = display.contentHeight / 2

--------------------------------------------------------------------------------

local function stop_particles( event )
	emitter:stop()
end

local function start_particles( event )
	emitter:start()
end

local function pause_particles( event )
	emitter:pause()
end

--------------------------------------------------------------------------------

local function blue_color( event )
	emitter.startColorRed = 0
	emitter.startColorGreen = 0
	emitter.startColorBlue = 1
	emitter.startColorAlpha = 1
end

local function green_color( event )
	emitter.startColorRed = 0
	emitter.startColorGreen = 1
	emitter.startColorBlue = 0
	emitter.startColorAlpha = 1
end

local original_red = emitter.startColorRed
local original_green = emitter.startColorGreen
local original_blue = emitter.startColorBlue
local original_alpha = emitter.startColorAlpha

local function original_color( event )
	emitter.startColorRed = original_red
	emitter.startColorGreen = original_green
	emitter.startColorBlue = original_blue
	emitter.startColorAlpha = original_alpha
end

--------------------------------------------------------------------------------

local original_rate = emitter.emissionRateInParticlesPerSeconds

local function set_original_rate( event )
	emitter.emissionRateInParticlesPerSeconds = original_rate
end

local function set_lower_rate( event )
	emitter.emissionRateInParticlesPerSeconds = original_rate / 8
end

--------------------------------------------------------------------------------

local sequence

sequence = function( obj )
	timer.performWithDelay( 1000, blue_color )
	timer.performWithDelay( 3000, green_color )
	timer.performWithDelay( 4000, stop_particles )
	timer.performWithDelay( 5000, start_particles )
	timer.performWithDelay( 6000, original_color )
	timer.performWithDelay( 8000, pause_particles )
	timer.performWithDelay( 10000, start_particles )
	timer.performWithDelay( 11000, set_lower_rate )
	timer.performWithDelay( 14000, set_original_rate )
	timer.performWithDelay( 14000, sequence )
end

sequence()
