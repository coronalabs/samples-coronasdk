--
-- Abstract: Particle Emitter Sample App
--
-- Version: 1.0
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2014 Corona Labs Inc. All Rights Reserved.
------------------------------------------------------------

local particleDesigner = require( "particleDesigner" )

local filename
filename = "fire.pex"

local emitterParams = particleDesigner.loadParams( filename )
local emitter = display.newEmitter( emitterParams )

emitter.x = display.contentWidth / 2
emitter.y = display.contentHeight / 2

emitter.alpha = 0
emitter.rotation = -90

local anim

anim = function( obj )
	transition.to( emitter, { time=750, alpha=1 } )
	transition.to( emitter, { time=2000, rotation=90 } )
	transition.to( emitter, { delay=2000, time=2000, rotation=-90 } )
	transition.to( emitter, { delay=4000, time=750, alpha=0, onComplete=anim } )
end

anim()
