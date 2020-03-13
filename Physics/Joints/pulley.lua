
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
	
	local jointTitle = display.newText( sceneGroup, "Pulley Joint", display.contentCenterX, 115, composer.getVariable( "appFont" ), 20 )
	
	physics.pause()
	
	bodiesGroup.alpha = 0
	transition.to( bodiesGroup, { time=600, alpha=1, transition=easing.outQuad } )

	-- Create physical objects
	local bodyA = display.newCircle( bodiesGroup, 0, 0, 40 )
	bodyA:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( bodyA, "dynamic", { bounce=0.8, radius=40 } )
	bodyA.x, bodyA.y = display.contentCenterX-50, 260
	bodies[#bodies+1] = bodyA

	local bodyB = display.newCircle( bodiesGroup, 0, 0, 26 )
	bodyB:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( bodyB, "dynamic", { bounce=0.8, radius=26 } )
	bodyB.x, bodyB.y = display.contentCenterX+50, 300
	bodies[#bodies+1] = bodyB

	local staticBox = display.newRect( bodiesGroup, 0, 0, display.contentWidth-40, 50 )
	staticBox:setFillColor( 0.2, 0.2, 1 )
	physics.addBody( staticBox, "static", { bounce=0.8 } )
	staticBox.x, staticBox.y = display.contentCenterX, 420
	bodies[#bodies+1] = staticBox

	bodyA:toBack()
	bodyB:toBack()
	staticBox:toBack()

	-- Create joint
	joint = physics.newJoint( "pulley", bodyA, bodyB, bodyA.x, bodyA.y-100, bodyB.x, bodyB.y-140, bodyA.x, bodyA.y, bodyB.x, bodyB.y, 1.0 )
end


function scene:show( event )

	if ( event.phase == "did" ) then

		-- Debugging data
		if ( joint and composer.getVariable( "consoleDebug" ) == true ) then
			print( "-----------------------" )
			print( "INTERNALS: PULLEY JOINT" )
			print( "-----------------------" )
			print( "ANCHOR A", joint:getAnchorA() )
			print( "ANCHOR B", joint:getAnchorB() )
			print( "GROUND ANCHOR A", joint:getGroundAnchorA() )
			print( "GROUND ANCHOR B", joint:getGroundAnchorB() )
			print( "JOINT LENGTH 1", joint.length1 )
			print( "JOINT LENGTH 2", joint.length2 )
			print( "JOINT RATIO", joint.ratio )
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
