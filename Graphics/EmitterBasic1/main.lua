--
-- Abstract: Particle Emitter Sample App
--
-- Version: 1.0
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2014 Corona Labs Inc. All Rights Reserved.
------------------------------------------------------------

local particleDesigner = require( "particleDesigner" )

local emitter = particleDesigner.newEmitter( "fire.json" )
emitter.x = display.contentWidth / 2
emitter.y = display.contentHeight / 2
