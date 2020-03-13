
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
local joints = {}


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
	
	local jointTitle = display.newText( sceneGroup, "Friction Joint", display.contentCenterX, 115, composer.getVariable( "appFont" ), 20 )
	
	physics.pause()

	bodiesGroup.alpha = 0
	transition.to( bodiesGroup, { time=600, alpha=1, transition=easing.outQuad } )

	-- Collision handler function
	local function handleCollision( self, event )

		if ( event.phase == "began" ) then

			-- Depending on the object collided with, set force and torque limits
			local forceLimit = 0
			local torqueLimit = 0
			if ( event.other.type == "dirt" ) then
				forceLimit = 0.22
				torqueLimit = 0.022
			else
				forceLimit = 0.28
				torqueLimit = 0.028
			end

			-- Create joint 10 milliseconds after collision
			timer.performWithDelay( 10,
				function()
					-- Create joint
					joints[#joints+1] = physics.newJoint( "friction", event.other, self, self.x, self.y )

					-- Possible properties/methods for the joint
					joints[#joints].maxForce = forceLimit
					joints[#joints].maxTorque = torqueLimit

					-- Debugging data
					if ( composer.getVariable( "consoleDebug" ) == true ) then
						print( "-------------------------" )
						print( "INTERNALS: FRICTION JOINT" )
						print( "-------------------------" )
						print( "COLLIDED WITH", event.other.type )
						print( "LOCAL ANCHOR A", joints[#joints]:getLocalAnchorA() )
						print( "LOCAL ANCHOR B", joints[#joints]:getLocalAnchorB() )
						print( "ANCHOR A", joints[#joints]:getAnchorA() )
						print( "ANCHOR B", joints[#joints]:getAnchorB() )
					end
				end
			)
		end
	end

	-- Create physical objects
	local shape1 = display.newRect( bodiesGroup, 0, 0, 40, 40 )
	shape1:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( shape1, "dynamic" )
	shape1.x, shape1.y, shape1.rotation = display.contentCenterX-60, 170, 0
	shape1.angularVelocity = 200
	shape1.collision = handleCollision
	shape1:addEventListener( "collision", shape1 )
	bodies[#bodies+1] = shape1

	local shape2 = display.newRect( bodiesGroup, 0, 0, 40, 40 )
	shape2:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( shape2, "dynamic" )
	shape2.x, shape2.y, shape2.rotation = display.contentCenterX+60, 170, 0
	shape2.angularVelocity = 200
	shape2.collision = handleCollision
	shape2:addEventListener( "collision", shape2 )
	bodies[#bodies+1] = shape2

	local dirtField = display.newRect( bodiesGroup, 0, 0, 120, 190 )
	dirtField.type = "dirt"
	dirtField:setFillColor( 0.4, 0.25, 0.2 )
	physics.addBody( dirtField, "static", { isSensor=true } )
	dirtField.x, dirtField.y = display.contentCenterX-60, 335
	bodies[#bodies+1] = dirtField

	local grassField = display.newRect( bodiesGroup, 0, 0, 120, 190 )
	grassField.type = "grass"
	grassField:setFillColor( 0.1, 0.4, 0.3 )
	physics.addBody( grassField, "static", { isSensor=true } )
	grassField.x, grassField.y = display.contentCenterX+60, 335
	bodies[#bodies+1] = grassField

	shape1:toBack()
	shape2:toBack()
	dirtField:toBack()
	grassField:toBack()
end


function scene:show( event )

	if ( event.phase == "did" ) then

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
	for j = #joints,1,-1 do
		local joint = joints[j]
		joint:removeSelf()
		joint = nil
	end ; joints = nil
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
