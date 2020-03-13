
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

	local jointTitle = display.newText( sceneGroup, "Gear Joint", display.contentCenterX, 115, composer.getVariable( "appFont" ), 20 )

	physics.pause()

	bodiesGroup.alpha = 0
	transition.to( bodiesGroup, { time=600, alpha=1, transition=easing.outQuad } )

	-- Create physical objects
	local staticBox = display.newRect( bodiesGroup, 0, 0, 160, 40 )
	staticBox:setFillColor( 0.2, 0.2, 1 )
	physics.addBody( staticBox, "static", { isSensor=true } )
	staticBox.x, staticBox.y = display.contentCenterX-30, 300
	bodies[#bodies+1] = staticBox

	local gearL = display.newCircle( bodiesGroup, 0, 0, 40 )
	gearL:setFillColor( 1, 0.2, 0.4 )
	physics.addBody( gearL, "dynamic", { bounce=0, friction=0, radius=40 } )
	gearL.x, gearL.y = staticBox.x-55, 300
	gearL.radius = 40
	bodies[#bodies+1] = gearL

	local gearR = display.newCircle( bodiesGroup, 0, 0, 70 )
	gearR:setFillColor( 0.6, 0.1, 0.7 )
	physics.addBody( gearR, "dynamic", { bounce=0, friction=0, radius=70 } )
	gearR.x, gearR.y = staticBox.x+55, 300
	gearR.radius = 70
	bodies[#bodies+1] = gearR

	local bar = display.newRect( bodiesGroup, 0, 0, 30, (math.pi*50)+40 )
	bar:setFillColor( 0.6, 0.6, 0.7 )
	physics.addBody( bar, "dynamic", { bounce=0, friction=0 } )
	bar.x, bar.y = staticBox.x+140, gearR.y+(bar.height/2)-20
	bodies[#bodies+1] = bar

	gearL:toBack()
	gearR:toBack()
	bar:toBack()
	staticBox:toBack()

	-- Create joints
		
	-- Pivot joints for each gear
	joints[#joints+1] = physics.newJoint( "pivot", staticBox, gearL, gearL.x, gearL.y )
	joints[#joints+1] = physics.newJoint( "pivot", staticBox, gearR, gearR.x, gearR.y )
		
	-- Piston joint between "staticBox" and "bar" with vertical motion axis
	joints[#joints+1] = physics.newJoint( "piston", staticBox, bar, bar.x, bar.y, 0, 1 )
		
	-- Gear joint between "gearL" and "gearR"
	joints[#joints+1] = physics.newJoint( "gear", gearL, gearR, joints[1], joints[2], 1.0 )
	--joints[#joints].ratio = 1.0
		
	-- Gear joint between "gearR" and "bar"
	joints[#joints+1] = physics.newJoint( "gear", gearR, bar, joints[2], joints[3], -1*(gearL.radius/gearR.radius) )
	--joints[#joints].ratio = (gearL.radius/gearR.radius)

	-- Turn "gearL" with motor; this in turn drives "gearR" which in turn moves "bar" up
	joints[1].isMotorEnabled = true
	joints[1].motorSpeed = 15
	joints[1].maxMotorTorque = 1000
	joints[1].isLimitEnabled = true
	joints[1]:setRotationLimits( -90, 180 )
end


function scene:show( event )

	if ( event.phase == "did" ) then

		-- Debugging data
		if ( #joints == 5 and composer.getVariable( "consoleDebug" ) == true ) then
			print( "---------------------" )
			print( "INTERNALS: GEAR JOINT" )
			print( "---------------------" )
			print( "GEAR(L) + GEAR(R): RATIO", joints[4].ratio )
			print( "GEAR(L) + GEAR(R): JOINT 1", joints[4].joint1 )
			print( "GEAR(L) + GEAR(R): JOINT 2", joints[4].joint2 )
			print( "GEAR(R) + BAR:     RATIO", joints[5].ratio )
			print( "GEAR(R) + BAR:     JOINT 1", joints[5].joint1 )
			print( "GEAR(R) + BAR:     JOINT 2", joints[5].joint2 )
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
