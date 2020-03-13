
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
	
	local jointTitle = display.newText( sceneGroup, "Wheel Joint", display.contentCenterX, 115, composer.getVariable( "appFont" ), 20 )
	
	physics.pause()
	
	bodiesGroup.alpha = 0
	transition.to( bodiesGroup, { time=600, alpha=1, transition=easing.outQuad } )
		
	-- Create physical objects
	local vehicleBody = display.newRect( bodiesGroup, 0, 0, 110, 20 )
	vehicleBody:setFillColor( 0.6, 0.1, 0.7 )
	physics.addBody( vehicleBody, "dynamic" )
	vehicleBody.x, vehicleBody.y = display.contentCenterX-50, 330
	vehicleBody.isFixedRotation = true
	bodies[#bodies+1] = vehicleBody

	local wheelA = display.newCircle( bodiesGroup, 0, 0, 15 )
	wheelA:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( wheelA, "dynamic", { bounce=0.5, friction=0.8, radius=15 } )
	wheelA.x, wheelA.y = vehicleBody.x-35, vehicleBody.y+30
	bodies[#bodies+1] = wheelA
		
	local wheelB = display.newCircle( bodiesGroup, 0, 0, 15 )
	wheelB:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( wheelB, "dynamic", { bounce=0.5, friction=0.8, radius=15 } )
	wheelB.x, wheelB.y = vehicleBody.x, vehicleBody.y+30
	bodies[#bodies+1] = wheelB
		
	local wheelC = display.newCircle( bodiesGroup, 0, 0, 15 )
	wheelC:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( wheelC, "dynamic", { bounce=0.5, friction=0.8, radius=15 } )
	wheelC.x, wheelC.y = vehicleBody.x+35, vehicleBody.y+30
	bodies[#bodies+1] = wheelC
		
	local staticBox = display.newRect( bodiesGroup, 0, 0, display.contentWidth-40, 50 )
	staticBox:setFillColor( 0.2, 0.2, 1 )
	physics.addBody( staticBox, "static", { bounce=0, friction=1 } )
	staticBox.x, staticBox.y = display.contentCenterX, 420
	bodies[#bodies+1] = staticBox

	local bumperA = display.newRect( bodiesGroup, 0, 0, 30, 20 )
	bumperA:setFillColor( 0.2, 0.2, 1 )
	physics.addBody( bumperA, "static", { bounce=1, friction=0 } )
	bumperA.x, bumperA.y = staticBox.x-staticBox.width/2+15, 385
	bodies[#bodies+1] = bumperA

	local bumperB = display.newRect( bodiesGroup, 0, 0, 30, 20 )
	bumperB:setFillColor( 0.2, 0.2, 1 )
	physics.addBody( bumperB, "static", { bounce=1, friction=0 } )
	bumperB.x, bumperB.y = staticBox.x+staticBox.width/2-15, 385
	bodies[#bodies+1] = bumperB

	vehicleBody:toBack()
	wheelA:toBack()
	wheelB:toBack()
	wheelC:toBack()
	staticBox:toBack()
	bumperA:toBack()
	bumperB:toBack()

	-- Possible properties/methods for the joints
	local springFrequency = 30
	local springDampingRatio = 1.0

	-- Create joints
	joints[#joints+1] = physics.newJoint( "wheel", vehicleBody, wheelA, wheelA.x, wheelA.y, 1, 1 )
	joints[#joints].springFrequency = springFrequency
	joints[#joints].springDampingRatio = springDampingRatio

	joints[#joints+1] = physics.newJoint( "wheel", vehicleBody, wheelB, wheelB.x, wheelB.y, 1, 1 )
	joints[#joints].springFrequency = springFrequency
	joints[#joints].springDampingRatio = springDampingRatio
		
	joints[#joints+1] = physics.newJoint( "wheel", vehicleBody, wheelC, wheelC.x, wheelC.y, 1, 1 )
	joints[#joints].springFrequency = springFrequency
	joints[#joints].springDampingRatio = springDampingRatio

	-- Apply torque to wheels to make vehicle move
	wheelA:applyTorque( 2 )
	wheelB:applyTorque( 2 )
	wheelC:applyTorque( 2 )
end


function scene:show( event )

	if ( event.phase == "did" ) then

		-- Debugging data
		if ( #joints == 3 and composer.getVariable( "consoleDebug" ) == true ) then
			print( "----------------------" )
			print( "INTERNALS: WHEEL JOINT" )
			print( "----------------------" )
			print( " " )
			print( "LEFT WHEEL" )
			print( "----------" )
			print( "LOCAL ANCHOR A", joints[1]:getLocalAnchorA() )
			print( "LOCAL ANCHOR B", joints[1]:getLocalAnchorB() )
			print( "ANCHOR A", joints[1]:getAnchorA() )
			print( "ANCHOR B", joints[1]:getAnchorB() )
			print( "LOCAL AXIS A", joints[1]:getLocalAxisA() )
			print( "JOINT TRANSLATION", joints[1].jointTranslation )
			print( "JOINT SPEED", joints[1].jointSpeed )
			print( " " )
			print( "MIDDLE WHEEL" )
			print( "------------" )
			print( "LOCAL ANCHOR A", joints[2]:getLocalAnchorA() )
			print( "LOCAL ANCHOR B", joints[2]:getLocalAnchorB() )
			print( "ANCHOR A", joints[2]:getAnchorA() )
			print( "ANCHOR B", joints[2]:getAnchorB() )
			print( "LOCAL AXIS A", joints[2]:getLocalAxisA() )
			print( "JOINT TRANSLATION", joints[2].jointTranslation )
			print( "JOINT SPEED", joints[2].jointSpeed )
			print( " " )
			print( "RIGHT WHEEL" )
			print( "-----------" )
			print( "LOCAL ANCHOR A", joints[3]:getLocalAnchorA() )
			print( "LOCAL ANCHOR B", joints[3]:getLocalAnchorB() )
			print( "ANCHOR A", joints[3]:getAnchorA() )
			print( "ANCHOR B", joints[3]:getAnchorB() )
			print( "LOCAL AXIS A", joints[3]:getLocalAxisA() )
			print( "JOINT TRANSLATION", joints[3].jointTranslation )
			print( "JOINT SPEED", joints[3].jointSpeed )
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
