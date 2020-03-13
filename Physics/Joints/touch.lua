
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
local touchPoint


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

	local jointTitle = display.newText( sceneGroup, "Touch Joint", display.contentCenterX, 115, composer.getVariable( "appFont" ), 20 )

	physics.pause()

	bodiesGroup.alpha = 0
	transition.to( bodiesGroup, { time=600, alpha=1, transition=easing.outQuad } )

	-- Create physical objects
	local shape = display.newRect( bodiesGroup, 0, 0, 60, 60 )
	shape:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( shape, "dynamic", { bounce=0 } )
	shape.x, shape.y = display.contentCenterX, 300
	bodies[#bodies+1] = shape

	touchPoint = display.newImageRect( bodiesGroup, "dot.png", 32, 32 )
	touchPoint.blendMode = "add"
	touchPoint.alpha = 0

	shape:toBack()
	touchPoint:toBack()

	-- Create joint
	joint = physics.newJoint( "touch", shape, shape.x, shape.y+20 )

	-- Possible properties/methods for the joint
	joint.maxForce = 1000
	joint.frequency = 0.8
	joint.dampingRatio = 0.2
end


function scene:show( event )

	if ( event.phase == "did" ) then

		-- Move touch point (target) function
		local function moveTarget( event )

			if not ( joint ) then return end
			local newTargetX, newTargetY = math.random( 4,28 ), math.random( 18,44 )
			joint:setTarget( newTargetX*10, newTargetY*10 )

			touchPoint.x, touchPoint.y = newTargetX*10, newTargetY*10
			touchPoint.alpha = 1
			transition.to( touchPoint, { time=600, alpha=0, delay=80, tag="touchPoint", transition=easing.outQuad } )

			if ( joint and composer.getVariable( "consoleDebug" ) == true ) then
				print( "TARGET "..event.count, joint:getTarget() )
			end
		end
		timer.performWithDelay( 2000, moveTarget, 0 )

		-- Debugging data
		if ( joint and composer.getVariable( "consoleDebug" ) == true ) then
			print( "----------------------" )
			print( "INTERNALS: TOUCH JOINT" )
			print( "----------------------" )
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

	-- Cancel "touchPoint" transition if still underway
	transition.cancel( "touchPoint" )
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
