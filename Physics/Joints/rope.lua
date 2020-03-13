
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

	local jointTitle = display.newText( sceneGroup, "Rope Joint", display.contentCenterX, 115, composer.getVariable( "appFont" ), 20 )

	physics.pause()
	
	bodiesGroup.alpha = 0
	transition.to( bodiesGroup, { time=600, alpha=1, transition=easing.outQuad } )

	-- Create physical objects
	local shape1 = display.newCircle( bodiesGroup, 0, 0, 25 )
	shape1:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( shape1, "dynamic", { bounce=1, radius=25 } )
	shape1.x, shape1.y = display.contentCenterX-50, 200
	bodies[#bodies+1] = shape1

	local shape2 = display.newCircle( bodiesGroup, 0, 0, 25 )
	shape2:setFillColor( 0.6, 0.1, 0.7 )
	physics.addBody( shape2, "dynamic", { bounce=1, radius=25 } )
	shape2.x, shape2.y = display.contentCenterX+50, 180
	shape2.gravityScale = 0.2
	bodies[#bodies+1] = shape2

	local staticBox = display.newRect( bodiesGroup, 0, 0, display.contentWidth-40, 50 )
	staticBox:setFillColor( 0.2, 0.2, 1 )
	physics.addBody( staticBox, "static", { bounce=1 } )
	staticBox.x, staticBox.y = display.contentCenterX, 420
	bodies[#bodies+1] = staticBox

	shape1:toBack()
	shape2:toBack()
	staticBox:toBack()
		
	-- Create joint
	joint = physics.newJoint( "rope", shape1, shape2, 0, -20, 0, 20 )
		
	-- Possible properties/methods for the joint
	joint.maxLength = 200
end


function scene:show( event )

	if ( event.phase == "did" ) then

		-- Debugging data
		if ( joint and composer.getVariable( "consoleDebug" ) == true ) then
			print( "---------------------" )
			print( "INTERNALS: ROPE JOINT" )
			print( "---------------------" )
			print( "LOCAL ANCHOR A", joint:getLocalAnchorA() )
			print( "LOCAL ANCHOR B", joint:getLocalAnchorB() )
			print( "ANCHOR A", joint:getAnchorA() )
			print( "ANCHOR B", joint:getAnchorB() )
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
