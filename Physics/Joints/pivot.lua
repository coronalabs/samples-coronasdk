
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 9.8 )
physics.setDrawMode( "normal" )

local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- Variables/references for this joint demo
local bodies = {}
local bodiesGroup
local joint


function scene:create( event )

	local sceneGroup = self.view

	bodiesGroup = display.newGroup()
	sceneGroup:insert( bodiesGroup )
	
	local buttonExit = widget.newButton
	{
		label = "Exit",
		shape = "rectangle",
		width = 128,
		height = 32,
		font = composer.getVariable( "appFont" ),
		fontSize = 15,
		alphaFade = false,
		fillColor = { default={ 0.12,0.32,0.52,1 }, over={ 0.132,0.352,0.572,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = function() composer.gotoScene( "menu", { effect="slideRight", time=800 } ); end
	}
	sceneGroup:insert( buttonExit )
	buttonExit.x = display.contentCenterX ; buttonExit.y = 68
	
	local jointTitle = display.newText( sceneGroup, "Pivot Joint", display.contentCenterX, 115, composer.getVariable( "appFont" ), 20 )
	
	physics.pause()
	
	bodiesGroup.alpha = 0
	transition.to( bodiesGroup, { time=600, alpha=1, transition=easing.outQuad } )

	-- Create physical objects
	local staticBox = display.newRect( bodiesGroup, 0, 0, 60, 60 )
	staticBox:setFillColor( 0.2, 0.2, 1 )
	physics.addBody( staticBox, "static", { isSensor=true } )
	staticBox.x, staticBox.y = display.contentCenterX, 280
	bodies[#bodies+1] = staticBox
		
	local shape = display.newRect( bodiesGroup, 0, 0, 40, 100 )
	shape:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( shape, "dynamic" )
	shape.x, shape.y, shape.rotation = display.contentCenterX, staticBox.y-40, 0
	bodies[#bodies+1] = shape

	shape:toBack()
	staticBox:toBack()

	-- Create joint
	joint = physics.newJoint( "pivot", staticBox, shape, staticBox.x, staticBox.y )

	-- Possible properties/methods for the joint
	joint.isMotorEnabled = true
	joint.motorSpeed = 40
	joint.maxMotorTorque = 1000
	--joint.isLimitEnabled = true
	--joint:setRotationLimits( -60, 125 )
end


function scene:show( event )

	if ( event.phase == "did" ) then

		-- Debugging data
		if ( joint and composer.getVariable( "consoleDebug" ) == true ) then
			print( "----------------------" )
			print( "INTERNALS: PIVOT JOINT" )
			print( "----------------------" )
			print( "LOCAL ANCHOR A", joint:getLocalAnchorA() )
			print( "LOCAL ANCHOR B", joint:getLocalAnchorB() )
			print( "ANCHOR A", joint:getAnchorA() )
			print( "ANCHOR B", joint:getAnchorB() )
			print( "ROTATION LIMITS", joint:getRotationLimits() )
			print( "JOINT ANGLE", joint.jointAngle )
			print( "JOINT SPEED", joint.jointSpeed )
			print( "MOTOR TORQUE", joint.motorTorque )
			print( "REFERENCE ANGLE", joint.referenceAngle )
		end

		local sampleUI = composer.getVariable( "sampleUI" )
		if ( sampleUI:isInfoShowing() == false ) then
			physics.setDrawMode( "hybrid" )
		end

		physics.start()
	end
end


function scene:hide( event )

	if ( event.phase == "will" ) then

		physics.setDrawMode( "normal" )
		transition.to( bodiesGroup, { time=600, alpha=0, delay=80, transition=easing.outQuad } )
	end
end


function scene:destroy( event )

	-- Explicitly remove joint(s) to prevent risk of orphaned body pointers
	joint:removeSelf() ; joint = nil
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
